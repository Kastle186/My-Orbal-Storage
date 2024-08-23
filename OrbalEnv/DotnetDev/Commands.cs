// File: Commands.cs

using System;
using System.Collections.Generic;
using System.Text;

public static class DotnetDevCommands
{
    // PLANS:
    // Parse the command line. We can defer faulty command-lines to be handled
    // by the runtime repo's build script, so here, we'll just assume they're
    // well-formed.

    static readonly string s_scriptExt = OperatingSystem.IsWindows() ? ".cmd" : ".sh";

    // Need to briefly explain this map and why it does not have all possible
    // flags the runtime repo build script supports.

    static readonly Dictionary<string, string> s_dotnetDevOptsMap = new()
    {
        { "binlog",   "-binaryLog" },
        { "cc",       "-cross" },
        { "conf",     "-configuration" },
        { "hostconf", "-hostConfiguration" }
        { "libsconf", "-librariesConfiguration" },
        { "runconf",  "-runtimeConfiguration" }
    };

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

        string buildType = args[0].ToLower();
        int result = 999;

        // Using a switch case here instead of a usual if/else to leave the door
        // open to easily be able to add support for other scripts within the repo.

        switch (buildType)
        {
            case "main":
                result = BuildRuntimeMain(args[1..]);
                break;

            case "tests":
                result = BuildRuntimeTests(args[1..]);
                break;

            default:
                Console.WriteLine("BuildRuntimeRepo: The currently supported build"
                                  + " types are 'main' and 'tests'.");
                return -1;
        }

        return result;
    }

    private static int BuildRuntimeMain(string[] args)
    {
        return 0;
    }

    private static int BuildRuntimeTests(string[] args)
    {
        return 0;
    }
}
