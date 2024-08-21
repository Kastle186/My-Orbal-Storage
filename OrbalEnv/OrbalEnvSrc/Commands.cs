// File: Commands.cs

using System;
using System.IO;

public static class Commands
{
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
    /// Outputs the new working directory for the shell to consume and move to,
    /// and returns 0 if everything went fine. Returns -1 otherwise.
    /// </returns>
    public static int Ncd(string[] args)
    {
        if (!Int32.TryParse(args[0], out int level))
        {
            Console.WriteLine("Ncd: An integer is required as argument.");
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

    /// <summary>
    /// Retrieves the number of directories, number of files, and the total residing
    /// in the given path. It arranges them in the following format:
    ///   <c>\<Total\> items: \<NumDirs\> directories, \<NumFiles\> files</c>
    /// </summary>
    /// <remarks>
    /// If no directory is passed as an argument, then this command runs on the
    /// current path.
    /// </remarks>
    /// <returns>
    /// Outputs the path's item count and returns 0 if everything went fine.
    /// Returns -1 otherwise.
    /// </returns>
    public static int ItemCount(string[] args)
    {
        string path = args.Length > 0 ? args[0] : Directory.GetCurrentDirectory();

        if (!Directory.Exists(path))
        {
            Console.WriteLine("ItemCount: The given path was not found.");
            return -1;
        }

        // IDEA: Might be cool to also allow counting certain patterns, rather than
        //       only all or nothing. Also, would be nice to be able to receive the
        //       files wildcard only, and assume it's on the current directory.

        int numDirs = Directory.GetDirectories(path).Length;
        int numFiles = Directory.GetFiles(path).Length;

        Console.WriteLine("{0} items: {1} directories, {2} files",
                          numDirs + numFiles,
                          numDirs,
                          numFiles);
        return 0;
    }
}
