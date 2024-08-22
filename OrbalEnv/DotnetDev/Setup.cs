// File: Setup.cs

using System;
using System.Runtime.InteropServices;
using System.Linq;

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
    /// Processes and validates the new operating system value that the user wants
    /// to set to the DOTNET_DEV_OS environment variable.
    /// </summary>
    /// <returns>
    /// Outputs the new OS in lowercase for the shell to consume and set.
    /// Returns 0 if everything went fine, and -1 otherwise.
    /// </returns>
    public static int SetOS(string[] cmdArgs)
    {
        if (cmdArgs.Length < 1)
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
        if (cmdArgs.Length < 1)
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
        if (cmdArgs.Length < 1)
        {
            Console.WriteLine("SetConfig: A configuration name is required as argument.");
            return -1;
        }

        string newConfig = cmdArgs[0].ToLower();

        // NOTE: CoreCLR specifically has an additional supported configuration
        //       called "Checked". One can build using it by means of the command
        //       'buildclrchk', but for universally setting it, we are opting to
        //       not permit it, at least for the time being, because all the other
        //       components of the runtime repo only support debug and release.

        if (newConfig != "debug" && newConfig != "release")
        {
            Console.WriteLine("SetConfig: You have to pick either '{0}' or '{1}'.",
                              "debug", "release");
            return -1;
        }

        Console.WriteLine(newConfig == "release" ? "Release" : "Debug");
        return 0;
    }
}
