// File: ReviewJapanese.cs

using System;

public class ReviewJapanese
{
    static int Main(string[] args)
    {
        // ARGS[0]: Comma-separated list of files containing the words for the
        //          word pool.
        // ARGS[1]: What will be prompted in the question: Kanji/Kana&English
        // ARGS[2]: What will be expected in the answer: Kanji/Kana/English
        // ARGS[3]: Number of questions in this game's quiz.

        if (args.Length == 0 || args[0] == "--help" || args[0] == "-h")
        {
            ShowHelp();
            return 0;
        }

        return 0;
    }

    private static void ShowHelp()
    {
        Console.WriteLine("\nHelp Under Construction!");
    }
}
