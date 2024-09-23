// File: Setup.cs

using System;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;

public static class DotnetDevSetup
{
    /// <summary>
    /// Checks which operating system the DotnetDev is currently running on.
    /// </summary>
    /// <returns>
    /// Outputs the operating system's name in lowercase, as recognized by the
    /// runtime repo, for the shell to consume and set, and returns 0.
    /// </returns>
    public static int GetOperatingSystem()
    {
        // As of now, I don't expect my Dotnet Dev to be used outside of the
        // mainstream operating systems. If required at some point, we can simply
        // add new clauses to support those other operating systems. However,
        // one can set a different OS by means of the 'setos' command.

        if (OperatingSystem.IsLinux())
            Console.WriteLine("linux");

        if (OperatingSystem.IsMacOS())
            Console.WriteLine("osx");

        if (OperatingSystem.IsWindows())
            Console.WriteLine("windows");

        return 0;
    }

    /// <summary>
    /// Checks what architecture is the system where the DotnetDev is currently
    /// running on.
    /// </summary>
    /// <returns>
    /// Outputs the hardware's architecture name in lowercase, as recognized by
    /// the runtime repo, for the shell to consume and set, and returns 0.
    /// </returns>
    public static int GetArchitecture()
    {
        Architecture systemArch = RuntimeInformation.OSArchitecture;
        Console.WriteLine(systemArch.ToString().ToLower());
        return 0;
    }

    /// <summary>
    /// Processes and validates the path of the runtime repo clone the user wants
    /// to work on.
    /// </summary>
    /// <returns>
    /// Outputs the full path to the given clone of the runtime repo for the shell
    /// to consume and set, and returns 0 if everything goes fine, and -1 otherwise.
    /// </returns>
    public static int SetRepo(string[] cmdArgs)
    {
        if (cmdArgs.Length < 1 || string.IsNullOrWhiteSpace(cmdArgs[0]))
        {
            Console.WriteLine("SetRepo: A path to the runtime repo is required.");
            return -1;
        }

        string repoPath = cmdArgs[0];

        if (!Directory.Exists(repoPath))
        {
            Console.WriteLine("SetRepo: The given path '{0}' was unfortunately not found.",
                              repoPath);
            return -1;
        }

        string repoAbsolutePath = Path.GetFullPath(repoPath);
        Console.WriteLine(Path.TrimEndingDirectorySeparator(repoAbsolutePath));
        return 0;
    }

    /// <summary>
    /// Processes and validates the new operating system value that the user wants
    /// to set to the DOTNET_DEV_OS environment variable.
    /// </summary>
    /// <returns>
    /// Outputs the new OS in lowercase for the shell to consume and set.
    /// Returns 0 if everything went fine, and -1 otherwise.
    /// </returns>
    public static int SetOS(string[] cmdArgs)
    {
        if (cmdArgs.Length < 1 || string.IsNullOrWhiteSpace(cmdArgs[0]))
        {
            Console.WriteLine("SetOS: An operating system name is required as argument.");
            return -1;
        }

        // TODO: Add the other OS's supported by the runtime repo to the
        //       "supportedOSs" array.

        string newOS = cmdArgs[0].ToLower();
        string[] supportedOSs = new[] { "linux", "osx", "windows" };

        if (!supportedOSs.Any(os => os == newOS))
        {
            Console.WriteLine("SetOS: The currently supported OS's are {0}.",
                              string.Join(", ", supportedOSs));
            return -1;
        }

        Console.WriteLine(newOS);
        return 0;
    }

    /// <summary>
    /// Processes and validates the new architecture value that the user wants
    /// to set to the DOTNET_DEV_ARCH environment variable.
    /// </summary>
    /// <returns>
    /// Outputs the new architecture in lowercase for the shell to consume and set.
    /// Returns 0 if everything went fine, and -1 otherwise.
    /// </returns>
    public static int SetArch(string[] cmdArgs)
    {
        if (cmdArgs.Length < 1 || string.IsNullOrWhiteSpace(cmdArgs[0]))
        {
            Console.WriteLine("SetArch: An architecture name is required as argument.");
            return -1;
        }

        string newArch = cmdArgs[0].ToLower();
        string[] supportedArchs = Enum.GetNames(typeof(Architecture));

        if (!supportedArchs.Any(a => a.ToLower() == newArch))
        {
            Console.WriteLine("SetArch: The currently supported architectures are {0}.",
                              string.Join(", ", supportedArchs));
            return -1;
        }

        Console.WriteLine(newArch);
        return 0;
    }

    /// <summary>
    /// Processes and validates the new configuration value that the user wants
    /// to set to the DOTNET_DEV_CONFIG environment variable.
    /// </summary>
    /// <returns>
    /// Outputs the new configuration in titlecase for the shell to consume and set.
    /// Returns 0 if everything went fine, and -1 otherwise.
    /// </returns>
    public static int SetConfig(string[] cmdArgs)
    {
        if (cmdArgs.Length < 1 || string.IsNullOrWhiteSpace(cmdArgs[0]))
        {
            Console.WriteLine("SetConfig: A configuration name is required as argument.");
            return -1;
        }

        string newConfig = cmdArgs[0].ToLower();

        switch (newConfig)
        {
            case "dbg":
            case "debug":
                Console.WriteLine("Debug");
                break;

            case "chk":
            case "checked":
                Console.WriteLine("Checked");
                break;

            case "rel":
            case "release":
                Console.WriteLine("Release");
                break;

            default:
                Console.WriteLine("SetConfig: You have to pick one of the following"
                                  + " three: Debug, Checked, Release.");
                return -1;
        }

        return 0;
    }
}
