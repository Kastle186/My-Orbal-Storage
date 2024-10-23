// File: Program.cs

using System;

public class Program
{
    static int Main(string[] args)
    {
        if (args.Length == 0 || string.IsNullOrWhiteSpace(args[0]))
        {
            Console.WriteLine("GitEnv: A command is required to run.");
            return -1;
        }

        string cmd = args[0];
        string[] cmdArgs = args[1..];
        int exitCode = 999;

        switch (cmd)
        {
            case "branches":
                exitCode = GitCommands.GetBranches(cmdArgs);
                break;

            case "newbranch":
                exitCode = GitCommands.CreateNewBranch(cmdArgs);
                break;

            case "checkout":
                exitCode = GitCommands.Checkout(cmdArgs);
                break;

            case "checkin":
                exitCode = GitCommands.Checkin(cmdArgs);
                break;

            case "stage":
                exitCode = GitCommands.StageChanges(cmdArgs);
                break;

            case "unstage":
                exitCode = GitCommands.UnstageChanges(cmdArgs);
                break;

            case "update":
                exitCode = GitCommands.UpdateBranch(cmdArgs);
                break;

            default:
                Console.WriteLine($"Apologies, but the command '{cmd}' isn't available yet.");
                exitCode = 999;
                break;
        }

        return exitCode;
    }
}
