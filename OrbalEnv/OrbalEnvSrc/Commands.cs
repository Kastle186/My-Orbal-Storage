// File: Commands.cs

using System;
using System.IO;

public static class Commands
{
    private const int DIR_STACK_MAX_SIZE = 10;
    private const string DIR_STACK_SEPARATOR = ";;";

    public static int Dir2Stack(string[] args)
    {
        return 0;
    }

    /// <summary>
    /// Move up 'n' directories up the directory tree, 'n' provided through the
    /// first element of the args array. If it's not an int, then an error code
    /// is returned, alongside a message to be printed by the shell function.
    /// </summary>
    /// <remarks>
    /// If it gets to the root directory before 'n' counts of 'cd ..', then the
    /// function ends the looping there, as there is nowhere else to move up to.
    /// </remarks>
    /// <returns>
    /// Prints the new working directory for the shell to consume and move to, and
    /// returns 0 if everything went fine. Returns -1 otherwise.
    /// </returns>
    public static int Ncd(string[] args)
    {
        if (!Int32.TryParse(args[0], out int level))
        {
            Console.WriteLine($"Ncd: An integer is required as argument.");
            return -1;
        }

        var cwd = new DirectoryInfo(Directory.GetCurrentDirectory());

        for (int i = 0; i < level; i++)
        {
            // If the parent of the current directory is denoted as null by C#,
            // then that means we're at the root directory, and therefore we
            // can't go up anymore. We've finished running this command.

            if (cwd.Parent is null)
                break;

            cwd = cwd.Parent;
        }

        Console.WriteLine(cwd.FullName);
        return 0;
    }

    public static int CdPrev(string[] args)
    {
        return 0;
    }
}
