// File: Commands.cs

using System;
using System.IO;
using System.Text;

public static class DotnetDevCommands
{
    // PLANS:
    // Parse the command line. We can defer faulty command-lines to be handled
    // by the runtime repo's build script, so here, we'll just assume they're
    // well-formed.

    const string ENV_REPO_ROOT = "DOTNET_DEV_REPO";
    const string ENV_ARCH = "DOTNET_DEV_ARCH";
    const string ENV_OS = "DOTNET_DEV_OS";
    const string ENV_CONFIG = "DOTNET_DEV_CONFIG";

    static readonly string s_scriptExt = OperatingSystem.IsWindows() ? ".cmd" : ".sh";

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
    public static int BuildRepo(string[] buildArgs)
    {
        string repoPath = Environment.GetEnvironmentVariable(ENV_REPO_ROOT);

        if (string.IsNullOrEmpty(repoPath))
        {
            Console.WriteLine("BuildRepo: First set the path to where the clone of"
                              + " the runtime repo is located with 'setrepo'.");
            return -1;
        }

        string argsStr = string.Join(' ', buildArgs);
        StringBuilder argsSb = new StringBuilder(argsStr);

        if (!argsStr.Contains("-a ") && !argsStr.Contains("-arch "))
        {
            argsSb.AppendFormat(" -arch {0}",
                                Environment.GetEnvironmentVariable(ENV_ARCH));
        }

        if (!argsStr.Contains("-os "))
        {
            argsSb.AppendFormat(" -os {0}",
                                Environment.GetEnvironmentVariable(ENV_OS));
        }

        // IDEA: Might be worth exploring the idea of it adding the `-configuration`
        //       flag when at least one subset has its own configuration flag
        //       specified AND at least one other subset doesn't have it there.

        if (!argsStr.Contains("-c ")
            && !argsStr.Contains("-configuration ")
            && !argsStr.Contains("-rc ")
            && !argsStr.Contains("-runtimeConfiguration ")
            && !argsStr.Contains("-lc ")
            && !argsStr.Contains("-librariesConfiguration "))
        {
            argsSb.AppendFormat(" -configuration {0}",
                                Environment.GetEnvironmentVariable(ENV_CONFIG));
        }

        Console.WriteLine("{0} {1}",
                          Path.Join(repoPath, $"build{s_scriptExt}"),
                          argsSb.ToString());
        return 0;
    }
}
