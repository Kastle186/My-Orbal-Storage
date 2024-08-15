// File: Program.cs

// GENERAL TODO: Add safeguards where needed.

using System;

public class Program
{
    static int Main(string[] args)
    {
        string cmd = args[0];
        string[] cmdArgs = args[1..];
        int exitCode = 0;

        switch (cmd)
        {
            case "dir2stack":
                Commands.Dir2Stack(cmdArgs);
                break;

            case "ncd":
                Commands.Ncd(cmdArgs);
                break;

            case "cdprev":
                Commands.CdPrev(cmdArgs);
                break;

            default:
                Console.WriteLine($"Apologies, but the command '{cmd}' isn't available yet.");
                exitCode = -1;
                break;
        }

        return exitCode;
    }
}
