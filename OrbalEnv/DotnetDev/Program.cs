// File: Program.cs

// GENERAL TODO: Add safeguards where needed.

using System;

public class Program
{
    static int Main(string[] args)
    {
        string cmd = args[0];
        string[] cmdArgs = args[1..];
        int exitCode = 999;

        switch (cmd)
        {
            case "getos":
                exitCode = DotnetDevSetup.GetOperatingSystem();
                break;

            case "getarch":
                exitCode = DotnetDevSetup.GetArchitecture();
                break;

            // case "setrepo":
            //     break;

            case "setos":
                exitCode = DotnetDevSetup.SetOS(cmdArgs);
                break;

            case "setarch":
                exitCode = DotnetDevSetup.SetArch(cmdArgs);
                break;

            case "setconfig":
                exitCode = DotnetDevSetup.SetConfig(cmdArgs);
                break;

            default:
                Console.WriteLine($"Apologies, but the command '{cmd}' isn't available yet.");
                exitCode = -1;
                break;
        }

        return exitCode;
    }
}
