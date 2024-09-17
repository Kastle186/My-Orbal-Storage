// File: Commands.cs

using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class DotnetDevCommands
{
    const string ENV_REPO_ROOT = "DOTNET_DEV_REPO";
    const string ENV_ARCH = "DOTNET_DEV_ARCH";
    const string ENV_OS = "DOTNET_DEV_OS";
    const string ENV_CONFIG = "DOTNET_DEV_CONFIG";

    static readonly string s_scriptExt = OperatingSystem.IsWindows() ? ".cmd" : ".sh";

    /// <summary>
    /// Validates the specified repo path exists and calls the appropriate helper
    /// function, depending on the type of build.
    /// </summary>
    /// <returns>
    /// Returns the value received from the helper function, or -1 if the repo path
    ///  was not found or if no build type, or an unrecognized one, was received.
    /// </returns>
    public static int BuildRepo(string[] buildArgs)
    {
        int result = 999;
        string repoPath = Environment.GetEnvironmentVariable(ENV_REPO_ROOT);

        if (string.IsNullOrEmpty(repoPath))
        {
            Console.WriteLine("BuildRepo: First set the path to where the clone of"
                              + " the runtime repo is located with 'setrepo'.");
            return -1;
        }

        if (buildArgs.Length < 1 || string.IsNullOrWhiteSpace(buildArgs[0]))
        {
            Console.WriteLine("BuildRepo: A build type is required. The currently"
                              + " supported values are 'main' and 'tests'");
            return -1;
        }

        string buildType = buildArgs[0];

        switch (buildType)
        {
            case "main":
                result = BuildMain(repoPath, buildArgs[1..]);
                break;

            case "tests":
                result = BuildTests(repoPath, buildArgs[1..]);
                break;

            default:
                Console.WriteLine($"The build type '{buildType}' was not recognized.");
                result = -1;
                break;
        }

        return result;
    }

    // TODO: Update this method's docs, and restore the functionality of automatically
    //       adding the architecture, operating system, and general configuration
    //       flags with the values from the environment variables, in the cases
    //       where they are not provided by the user.

    /// <summary>
    /// Validates the specified repo path exists and processes the command-line
    /// for building. If the architecture, operating system, and/or configuration
    /// are missing, it appends them to the received args with the values set to
    /// their respective environment variables.
    /// </summary>
    /// <returns>
    /// Outputs the full build command for the shell to process and run, and
    /// returns 0 if everything went fine. Returns -1 otherwise.
    /// </returns>
    private static int BuildMain(string repoPath, string[] buildArgs)
    {
        Dictionary<string, string> processedArgs = new();
        List<string> msbuildFlags = new();

        for (int i = 0; i < buildArgs.Length; i++)
        {
            string nextArg = buildArgs[i];

            if (nextArg.StartsWith("-p:") || nextArg.StartsWith("/p:"))
            {
                // If we entered this condition, then this means this argument is
                // meant to be passed as an MSBuild flag. We store these ones
                // separately, because we want to append them at the end of the
                // final command-line.
                msbuildFlags.Add(nextArg);
                continue;
            }

            string[] maybeKvp = nextArg.Split('=');
            string paramName = maybeKvp[0].TrimStart('-').ToLower();
            string argValue = string.Empty;

            if (maybeKvp.Length > 1)
                argValue = maybeKvp[1];
            else
            {
                // If this is the last token, or the next one is also a flag, then
                // that means the current token is a switch flag, and therefore its
                // would-be value is just the empty string.
                string seeAhead = (i + 1) == buildArgs.Length
                                  ? string.Empty
                                  : buildArgs[i + 1];

                if (!seeAhead.StartsWith('-') && !seeAhead.StartsWith('/'))
                {
                    argValue = seeAhead;
                    i++;
                }
            }

            bool isConfigParam = false;

            if (paramName == "s" || paramName == "set")
            {
                paramName = "subset";
            }
            else if (paramName == "a")
            {
                paramName = "arch";
            }
            else if (paramName == "c"
                     || paramName == "conf"
                     || paramName == "config"
                     || paramName == "configuration")
            {
                paramName = "configuration";
                isConfigParam = true;
            }
            else if (paramName == "lc"
                     || paramName == "libsconf"
                     || paramName == "libsconfig"
                     || paramName == "librariesconfiguration")
            {
                paramName = "librariesConfiguration";
                isConfigParam = true;
            }
            else if (paramName == "rc"
                     || paramName == "runconf"
                     || paramName == "runtimeconfig"
                     || paramName == "runtimeconfiguration"
                     || paramName == "clrconf"
                     || paramName == "clrconfig")
            {
                paramName = "runtimeConfiguration";
                isConfigParam = true;
            }

            BuildUtils.ProcessBuildArg(paramName, argValue, processedArgs, isConfigParam);
        }

        string buildScript = Path.Join(repoPath, $"build{s_scriptExt}");
        StringBuilder argsSb = new();

        foreach (KeyValuePair<string, string> argKvp in processedArgs)
        {
            argsSb.Append($" -{argKvp.Key}");

            if (!string.IsNullOrEmpty(argKvp.Value))
                argsSb.Append($" {argKvp.Value}");
        }

        // The reason we are conditioning printing the script args and MSBuild flags
        // is to avoid returning a command-line with trailing spaces in the cases
        // where one or both of those are empty. If anything, for cleanliness.

        Console.Write(buildScript);

        if (argsSb.Length > 0)
            Console.Write($"{argsSb.ToString()}");

        if (msbuildFlags.Count > 0)
            Console.Write($" {string.Join(' ', msbuildFlags)}");

        Console.Write("\n");
        return 0;
    }

    /// <summary>
    /// </summary>
    /// <returns>
    /// </returns>
    private static int BuildTests(string repoPath, string[] buildArgs)
    {
        Dictionary<string, string> kvpArgs = new();
        List<string> scriptFlags = new();
        List<string> msBuildFlags = new();

        for (int i = 0; i < buildArgs.Length; i++)
        {
            string nextArg = buildArgs[i];

            if (nextArg.StartsWith("-p:") || nextArg.StartsWith("/p:"))
            {
                // If we entered this condition, then this means this argument is
                // meant to be passed as an MSBuild flag. We store these ones
                // separately, because we want to append them at the end of the
                // final command-line.
                msBuildFlags.Add(nextArg);
                continue;
            }

            if (!nextArg.Contains('='))
            {
                // If we're here, that means we found an argument to pass directly
                // to the tests script command-line directly.
                scriptFlags.Add(nextArg);
                continue;
            }

            // If we're here, then our next argument is in the DotnetDev's Kvp Form.
            // MSBuild arguments also use a Kvp-like expression, but we already
            // processed them above, so we're sure it's a DotnetDev one here.

            string[] kvp = nextArg.Split('=');
            string paramName = kvp[0].ToLower();
            string argValue = kvp.Length > 1 ? kvp[1] : "";
            bool isConfigParam = false;

            if (paramName == "a" || paramName == "arch")
            {
                paramName = "arch";

                if (BuildUtils.IsTestArgDuplicated("arch", argValue, kvpArgs, scriptFlags))
                {
                    Console.WriteLine("BuildTests: Only one arch value should be"
                                      + " specified.");
                    return -1;
                }
            }
            else if (paramName == "c"
                     || paramName == "config"
                     || paramName == "configuration"
                     || paramName == "clr"
                     || paramName == "clrconf"
                     || paramName == "clrconfig"
                     || paramName == "rc"
                     || paramName == "runconf"
                     || paramName == "runtimeconfig"
                     || paramName == "runtimeconfiguration")
            {
                paramName = "clr";
                isConfigParam = true;

                if (BuildUtils.IsTestArgDuplicated("clr", argValue, kvpArgs, scriptFlags))
                {
                    Console.WriteLine("BuildTests: Only one CLR configuration value"
                                      + " should be specified.");
                    return -1;
                }
            }
            else if (paramName == "libs"
                     || paramName == "libsconf"
                     || paramName == "libsconfig"
                     || paramName == "lc"
                     || paramName == "librariesconfiguration")
            {
                paramName = "libs";
                isConfigParam = true;

                if (BuildUtils.IsTestArgDuplicated("libs", argValue, kvpArgs, scriptFlags)
                    || !string.IsNullOrEmpty(
                        msBuildFlags.Find(
                            x => x.Contains("LibrariesConfiguration"))))
                {
                    Console.WriteLine("BuildTests: Only one Libraries configuration"
                                      + " value should be specified.");
                    return -1;
                }
            }

            // NOTE: We might have to make a similar method for processing test
            //       build args if they start differing too much, as we start
            //       supporting more in our DotnetDev Kvp Notation.
            BuildUtils.ProcessBuildArg(paramName, argValue, kvpArgs, isConfigParam);
        }

        // Build the command-line here: Note that we need to handle the special
        // cases for the architecture and clr configuration, since those don't
        // use dashes '-'.

        string testsScript = Path.Join(repoPath, "src", "tests", $"build{s_scriptExt}");
        StringBuilder kvpArgsSb = new();
        bool isWindows = OperatingSystem.IsWindows();

        foreach (KeyValuePair<string, string> argKvp in kvpArgs)
        {
            if (argKvp.Key == "arch" || argKvp.Key == "clr")
            {
                kvpArgsSb.AppendFormat(" {0}", isWindows
                                               ? argKvp.Value
                                               : $"-{argKvp.Value}");
                continue;
            }
            else if (argKvp.Key == "libs")
            {
                msBuildFlags.Add($"/p:LibrariesConfiguration={argKvp.Value}");
                continue;
            }

            kvpArgsSb.Append($" -{argKvp.Key}");

            if (!string.IsNullOrEmpty(argKvp.Value))
            {
                kvpArgsSb.AppendFormat("{0}{1}",
                                       isWindows ? " " : ":",
                                       argKvp.Value);
            }
        }

        // The reason we are conditioning printing the script args and MSBuild flags
        // is to avoid returning a command-line with trailing spaces in the cases
        // where one or both of those are empty. If anything, for cleanliness.

        Console.Write(testsScript);

        if (kvpArgsSb.Length > 0)
            Console.Write($"{kvpArgsSb.ToString()}");

        if (scriptFlags.Count > 0)
            Console.Write($" {string.Join(' ', scriptFlags)}");

        if (msBuildFlags.Count > 0)
            Console.Write($" {string.Join(' ', msBuildFlags)}");

        Console.Write("\n");
        return 0;
    }
}
