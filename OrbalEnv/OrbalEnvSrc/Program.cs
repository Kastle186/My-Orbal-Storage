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
            case "ncd":
                exitCode = Commands.Ncd(cmdArgs);
                break;

            case "itemcount":
                exitCode = Commands.ItemCount(cmdArgs);
                break;

            default:
                Console.WriteLine($"Apologies, but the command '{cmd}' isn't available yet.");
                exitCode = -1;
                break;
        }

        return exitCode;
    }
}
