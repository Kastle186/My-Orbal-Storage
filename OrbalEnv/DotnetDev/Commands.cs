// File: Commands.cs

using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class DotnetDevCommands
{
    // PLANS:
    // Parse the command line. We can defer faulty command-lines to be handled
    // by the runtime repo's build script, so here, we'll just assume they're
    // well-formed.

    static readonly string s_scriptExt = OperatingSystem.IsWindows() ? ".cmd" : ".sh";

    // The Dotnet Dev Environment allows the user to pass the arguments to the
    // build scripts either literally how they would when calling said scripts
    // directly, or in the form of 'param=value'. For this notation, there are
    // some keywords that map to the full name of the argument supported by the
    // runtime repo. The s_dotnetDevOptsMap is made for mapping those conversions.
    //
    // The interesting thing to note here, is that every parameter can be passed
    // as 'param=value', or just 'param' if they're flags, regardless of whether
    // they are included in this conversion table. The param name for those absent
    // here is the exact same as the build script flag. Therefore, adding them here
    // to the conversion table would be kind of pointless, since the mapping would
    // involve only adding the dash '-' at the beginning. Depending on how things
    // turn out, we might end up adding them, but for now, we can handle adding
    // the dash '-' as we go processing them.

    static readonly Dictionary<string, string> s_dotnetDevOptsMap = new()
    {
        { "binlog",   "binaryLog" },
        { "cc",       "cross" },
        { "conf",     "configuration" },
        { "hostconf", "hostConfiguration" },
        { "libsconf", "librariesConfiguration" },
        { "runconf",  "runtimeConfiguration" }
    };

    // NEXT STEPS:
    // * Comment the BuildRuntimeMain() function's code.
    // * Add method doc to the BuildRuntimeRepo() function.
    // * Add support for abbreviated configuration values.

    /// <summary>
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <returns>
    /// </returns>
    public static int BuildRuntimeRepo(string[] args)
    {
        if (args.Length < 1 || string.IsNullOrWhiteSpace(args[0]))
        {
            Console.WriteLine("BuildRuntimeRepo: A build type is required. The"
                              + " currently supported values are 'main' and 'tests'.");
            return -1;
        }

        string repoPath = Environment.GetEnvironmentVariable("DOTNET_DEV_REPO");

        if (string.IsNullOrEmpty(repoPath))
        {
            Console.WriteLine("BuildRuntimeRepo: The path to the repo to work on"
                              + " is needed to be set. Use the 'setrepo' command"
                              + " for this, and try again.");
            return -1;
        }

        string buildType = args[0].ToLower();
        int result = 999;

        // Using a switch case here instead of a usual if/else to leave the door
        // open to easily be able to add support for other scripts within the repo.

        switch (buildType)
        {
            case "main":
                result = BuildRuntimeMain(repoPath, args[1..]);
                break;

            case "tests":
                result = BuildRuntimeTests(repoPath, args[1..]);
                break;

            default:
                Console.WriteLine("BuildRuntimeRepo: The currently supported build"
                                  + " types are 'main' and 'tests'.");
                return -1;
        }

        return result;
    }

    private static int BuildRuntimeMain(string repoPath, string[] args)
    {
        bool dashedFlagsStarted = false;
        string scriptPath = Path.Join(repoPath, $"build{s_scriptExt}");
        StringBuilder buildOptsSb = new StringBuilder();

        foreach (string arg in args)
        {
            if (arg.Contains('='))
            {
                string[] paramKvp = arg.Split('=');

                if (paramKvp.Length == 1)
                {
                    Console.WriteLine($"BuildRuntimeMain: The flag '{paramKvp[0]}'"
                                      + " is missing its value.");
                    return -1;
                }

                string optName = s_dotnetDevOptsMap.ContainsKey(paramKvp[0])
                                 ? s_dotnetDevOptsMap[paramKvp[0]]
                                 : paramKvp[0];

                string optValue = paramKvp[1];
                buildOptsSb.Append($" -{optName} {optValue}");
            }
            else if (arg.StartsWith('-'))
            {
                if (!dashedFlagsStarted)
                    dashedFlagsStarted = true;

                buildOptsSb.Append($" {arg}");
            }
            else
            {
                string convertedArg = s_dotnetDevOptsMap.ContainsKey(arg)
                                      ? s_dotnetDevOptsMap[arg]
                                      : arg;
 
                buildOptsSb.Append(dashedFlagsStarted ? $" {convertedArg}"
                                                      : $" -{convertedArg}");
            }
        }

        Console.WriteLine($"{scriptPath} {buildOptsSb.ToString()}");
        return 0;
    }

    private static int BuildRuntimeTests(string repoPath, string[] args)
    {
        Console.WriteLine("Build Runtime Tests Under Construction!");
        return -1;
    }
}
