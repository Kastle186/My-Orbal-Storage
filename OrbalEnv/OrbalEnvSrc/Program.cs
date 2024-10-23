// File: Program.cs

using System;

public class Program
{
    static int Main(string[] args)
    {
        if (args.Length == 0 || string.IsNullOrWhiteSpace(args[0]))
        {
            Console.WriteLine("OrbalEnv: A command is required to run.");
            return -1;
        }

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
                exitCode = 999;
                break;
        }

        return exitCode;
    }
}
