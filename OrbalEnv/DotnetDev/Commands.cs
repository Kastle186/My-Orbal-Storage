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
        int argIndex = 0;
        Dictionary<string, string> processedArgs = new();
        List<string> msbuildFlags = new();

        // DotnetDev expects all the flags in the 'key=value' format to be passed
        // before the dashed ones and the MSBuild ones. That's why we have to keep
        // track of the index even after we exit this loop.

        for (; argIndex < buildArgs.Length; argIndex++)
        {
            string nextArg = buildArgs[argIndex];

            // This means the next flag is meant to be passed directly to the build
            // command-line, so we are done processing the 'param=arg' notation args.
            if (nextArg.StartsWith('-') || nextArg.StartsWith('/'))
                break;

            string[] kvp = nextArg.Split('=');
            string paramName = kvp[0].ToLower();
            string argValue = kvp.Length > 1 ? kvp[1] : "";

            // For the 'param=arg' notation, one can pass the same name as the
            // runtime repo's build script flags, or use one of the shorthand aliases
            // we've defined here. If an alias is detected, we set the param name
            // to its long flag from the build script for clearer and universal
            // handling, as we later on also process the dashed arguments and there
            // may or may not be duplicates.

            if (paramName == "set")
            {
                paramName = "subset";
            }
            else if (paramName == "conf"
                     || paramName == "config"
                     || paramName == "configuration")
            {
                paramName = "configuration";
                BuildUtils.ProcessBuildConfigKvpArg(ref argValue);
            }
            else if (paramName == "lc"
                     || paramName == "libsconf"
                     || paramName == "libsconfig"
                     || paramName == "librariesconfiguration")
            {
                paramName = "librariesConfiguration";
                BuildUtils.ProcessBuildConfigKvpArg(ref argValue);
            }
            else if (paramName == "rc"
                     || paramName == "runconf"
                     || paramName == "runtimeconfig"
                     || paramName == "runtimeconfiguration"
                     || paramName == "clrconf"
                     || paramName == "clrconfig")
            {
                paramName = "runtimeConfiguration";
                BuildUtils.ProcessBuildConfigKvpArg(ref argValue);
            }

            if (!processedArgs.ContainsKey(paramName))
            {
                processedArgs.Add(paramName, argValue);
            }
            else if (!string.IsNullOrEmpty(processedArgs[paramName]))
            {
                if (paramName == "subset")
                    processedArgs[paramName] += $"+{argValue}";
                else
                    processedArgs[paramName] += $",{argValue}";
            }
        }

        // Once we're done processing the arguments in the 'param=arg' notation,
        // we might bump into dashed arguments meant to be passed as is to the
        // build script. However, here we also take into account the possibility
        // of duplicated arguments on the same command-line (e.g. arch=x64 -a x86).
        // In this case, we append both values accordingly, so as we don't end
        // up with an invalid command-line due to the repeated flags.
 
        for (; argIndex < buildArgs.Length; argIndex++)
        {
            string nextArg = buildArgs[argIndex];

            if (nextArg.StartsWith("-p:") || nextArg.StartsWith("/p:"))
            {
                // If we entered this condition, then this means this argument is
                // meant to be passed as an MSBuild flag. We store these ones
                // separately, because we want to append them at the end of the
                // final command-line.
                msbuildFlags.Add(nextArg);
                continue;
            }

            nextArg = nextArg.TrimStart('-').ToLower();

            if (nextArg == "s" || nextArg == "subset")
            {
                BuildUtils.ProcessDashedBuildArg("subset",
                                                 buildArgs[++argIndex],
                                                 processedArgs);
            }
            else if (nextArg == "a" || nextArg == "arch")
            {
                BuildUtils.ProcessDashedBuildArg("arch",
                                                 buildArgs[++argIndex],
                                                 processedArgs);
            }
            else if (nextArg == "os")
            {
                BuildUtils.ProcessDashedBuildArg("os",
                                                 buildArgs[++argIndex],
                                                 processedArgs);
            }
            else if (nextArg == "c" || nextArg == "configuration")
            {
                BuildUtils.ProcessDashedBuildArg("configuration",
                                                 buildArgs[++argIndex],
                                                 processedArgs);
            }
            else if (nextArg == "lc" || nextArg == "librariesconfiguration")
            {
                BuildUtils.ProcessDashedBuildArg("librariesConfiguration",
                                                 buildArgs[++argIndex],
                                                 processedArgs);
            }
            else if (nextArg == "rc" || nextArg == "runtimeconfiguration")
            {
                BuildUtils.ProcessDashedBuildArg("runtimeConfiguration",
                                                 buildArgs[++argIndex],
                                                 processedArgs);
            }
            else if (!processedArgs.ContainsKey(nextArg))
            {
                // If this is the last token, or the next one is also a flag, then
                // that means the current token is a switch flag, and therefore its
                // would-be value is just the empty string.
                string seeAhead = (argIndex + 1) == buildArgs.Length
                                  ? string.Empty
                                  : buildArgs[argIndex + 1];

                if (seeAhead.StartsWith('-') || seeAhead.StartsWith('/'))
                    seeAhead = string.Empty;

                processedArgs.Add(nextArg, seeAhead);
            }
            else
            {
                Console.WriteLine("Found an unexpected invalid argument: '{0}'.",
                                  nextArg);
                return -1;
            }
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
        int argIndex = 0;
        Dictionary<string, string> processedArgs = new();
        List<string> scriptFlags = new();
        List<string> msbuildFlags = new();

        // DotnetDev expects all the flags in the 'key=value' format to be passed
        // before the dashed ones and the MSBuild ones. That's why we have to keep
        // track of the index even after we exit this loop.

        for (; argIndex < buildArgs.Length; argIndex++)
        {
            string nextArg = buildArgs[argIndex];

            // This means the next flag is meant to be passed directly to the build
            // command-line, so we are done processing the 'param=arg' notation args.
            if (!nextArg.Contains('=')
                || nextArg.StartsWith("-p:")
                || nextArg.StartsWith("/p:"))
                break;

            string[] kvp = nextArg.Split('=');
            string paramName = kvp[0].ToLower();
            string argValue = kvp.Length > 1 ? kvp[1] : "";

            // For the 'param=arg' notation, one can pass the same name as the
            // tests build script flags, or use one of the shorthand aliases we've
            // defined here. If an alias is detected, we set the param name to its
            // flag from the tests build script for clearer and universal handling,
            // as we later on also process the dashed arguments and there may or
            // may not be duplicates.

            if (paramName == "clr"
                || paramName == "clrconf"
                || paramName == "clrconfig"
                || paramName == "rc"
                || paramName == "runconf"
                || paramName == "runtimeconfig"
                || paramName == "runtimeconfiguration")
            {
                paramName = "clr";
                BuildUtils.ProcessBuildConfigKvpArg(ref argValue);
            }
            else if (paramName == "libs"
                     || paramName == "libsconf"
                     || paramName == "libsconfig"
                     || paramName == "lc"
                     || paramName == "librariesconfiguration")
            {
                paramName = "libs";
                BuildUtils.ProcessBuildConfigKvpArg(ref argValue);

                // Since the libraries configuration is passed as an MSBuild flag
                // when building tests, we save it to the msbuildFlags list, rather
                // than our usual processedArgs dictionary.

                msbuildFlags.Add($"-p:LibrariesConfiguration={argValue}");
                continue;
            }

            if (!processedArgs.ContainsKey(paramName))
            {
                processedArgs.Add(paramName, argValue);
                continue;
            }

            if (paramName == "arch" || paramName == "clr")
            {
                Console.WriteLine("BuildTests: Only one {0} value may be specified.",
                                  paramName);
                return -1;
            }

            if (paramName == "test" || paramName == "dir" || paramName == "tree")
            {
                processedArgs[paramName] += $";{argValue}";
            }
        }

        for (; argIndex < buildArgs.Length; argIndex++)
        {
            string nextArg = buildArgs[argIndex];

            if (nextArg.StartsWith("-p:") || nextArg.StartsWith("/p:"))
            {
                // If we entered this condition, then this means this argument is
                // meant to be passed as an MSBuild flag. We store these ones
                // separately, because we want to append them at the end of the
                // final command-line.
                //
                // However, there is a specific flag we handle separately:
                //   "-p:LibrariesConfiguration"
                // This because we also support an alias for the kvp notation, so
                // we have to make sure there are no duplicated values.

                if (nextArg.Contains("LibrariesConfiguration")
                    && (!string.IsNullOrEmpty(
                            msbuildFlags.Find(
                                x => x.Contains("LibrariesConfiguration")))))
                {
                    Console.WriteLine("BuildTests: Only one libraries configuration"
                                      + " value may be specified.");
                    return -1;
                }

                msbuildFlags.Add(nextArg);
            }
            else
            {
                scriptFlags.Add(nextArg);
            }
        }

        string testsScript = Path.Join(repoPath, "src", "tests", $"build{s_scriptExt}");
        StringBuilder argsSb = new();

        // This right now only works on Linux and Mac.
        foreach (KeyValuePair<string, string> argKvp in processedArgs)
        {
            if (argKvp.Key == "arch" || argKvp.Key == "clr")
            {
                argsSb.Append($" -{argKvp.Value}");
                continue;
            }

            argsSb.Append($" -{argKvp.Key}");

            if (!string.IsNullOrEmpty(argKvp.Value))
                argsSb.Append($":{argKvp.Value}");
        }

        // The reason we are conditioning printing the script args and MSBuild flags
        // is to avoid returning a command-line with trailing spaces in the cases
        // where one or both of those are empty. If anything, for cleanliness.

        Console.Write(testsScript);

        if (argsSb.Length > 0)
            Console.Write($"{argsSb.ToString()}");

        if (scriptFlags.Count > 0)
            Console.Write($" {string.Join(' ', scriptFlags)}");

        if (msbuildFlags.Count > 0)
            Console.Write($" {string.Join(' ', msbuildFlags)}");

        Console.Write("\n");
        return 0;
    }
}
