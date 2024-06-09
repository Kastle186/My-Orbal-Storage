// File: CommandLineParser.cs

using System;
using System.IO;

internal record struct QuizParams
{
    public readonly string[] WordsFiles;
    public readonly string Ask;
    public readonly string Answer;
    public readonly int NumQuestions;
}

internal static class CommandLineParser
{
    public static QuizParams Parse(string[] args)
    {
        string[] files = args[0].Split(',');
        string toask = args[1].ToLower();
        string toanswer = args[2].ToLower();
        bool allFilesFound = true;

        foreach (string f in files)
        {
            if (!File.Exists(f))
            {
                Console.WriteLine($"Apologies, but file '{f}' was not found.");
                allFilesFound = false;
            }
        }

        if (!allFilesFound) return null;

        if (!Int32.TryParse(args[3], out numQuestions) || numQuestions <= 0)
        {
        }
    }
}
