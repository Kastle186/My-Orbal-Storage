// File: DotnetDev.cs

using System;

// POTENTIAL IDEAS:
//
// 1) Make a resources file with all the error messages.
// 2) Make an enum with the potential commands, instead of working with the
//    the strings directly.

public class DotnetDev
{
    static int Main(string[] args)
    {
        if (args.Length < 1)
        {
            throw new ArgumentException(
                "This case should never happen. Something's wrong with the"
                + " front-end script if we got here.");
        }

        if (!Enum.TryParse(args[0], true, out DevCommand command))
        {
            Console.WriteLine(
                $"Apologies, but the command '{args[0]}' has not been"
                + " implemented yet.");
            return -1;
        }

        int exitCode = 999;

        switch (command)
        {
            case DevCommand.GetArch:
                exitCode = CommandsModule.GetArch();
                break;

            case DevCommand.GetOS:
                exitCode = CommandsModule.GetOS();
                break;

            default:
                throw new ArgumentException(
                    "This case should never happen because any bad commands are"
                    + " filtered out by the Enum.TryParse() call at the start.");
        }

        return exitCode;
    }
}
