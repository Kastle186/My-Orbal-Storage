// File: Commands.cs

using System;
using System.IO;

public static class Commands
{
    private const int DIR_DEQUE_MAX_SIZE = 10;
    private const string DIR_DEQUE_SEPARATOR = ";;";

    /// <summary>
    /// Appends the new cwd/pwd to the DIR_DEQUE environment variable. The purpose
    /// of said variable is to store the directory history for the 'cdprev' command.
    /// </summary>
    /// <remarks>
    /// The history stores at most <c>DIR_DEQUE_MAX_SIZE (default: 10)</c> paths.
    /// When 'cd' is issued and the deque is full, the path at the end is discarded,
    /// as to make space for the new one. It also uses ';;' as separator. The reason
    /// for being unconventional here is as to not collide with potential pathnames
    /// with special characters (e.g. Windows' "C:\" or Samba's mounted paths with ":").
    /// </remarks>
    /// <seealso cref="CdPrev" />
    /// <returns>
    /// Prints the new value of the DIR_DEQUE environment variable for the shell
    /// to consume and set it. Returns 0 if everything went fine, -1 otherwise.
    /// </returns>
    internal static int Dir2Deque(string[] args)
    {
        // Path has already been validated by 'cd' at this point, so no need to
        // to make more overhead with repeating that.
        string newPath = args[0];

        string dirStackValue = Environment.GetEnvironmentVariable("DIR_DEQUE");
        string[] histPaths = dirStackValue.Split(DIR_DEQUE_SEPARATOR);

        if (histPaths.Length == DIR_DEQUE_MAX_SIZE)
        {
            // To dequeue from the end of the deque, we have to then push back
            // the remaining items, as to make space at the front.

            for (int i = 1; i < DIR_DEQUE_MAX_SIZE-1; i++)
            {
                histPaths[i-1] = histPaths[i];
            }

            histPaths[DIR_DEQUE_MAX_SIZE-1] = newPath;
            Console.WriteLine(string.Join(DIR_DEQUE_SEPARATOR, histPaths));
        }
        else
        {
            Console.WriteLine($"{dirStackValue}{DIR_DEQUE_SEPARATOR}{newPath}");
        }

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
