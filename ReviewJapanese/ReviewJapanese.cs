using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

using SplitOpts = System.StringSplitOptions;

public class ReviewJapanese
{
    internal record JPWord
    {
        public string Kana { get; init; }
        public string Kanji { get; init; }
        public string Definition { get; init; }
    };

    static int Main(string[] args)
    {
        if (args.Length < 1)
        {
            Console.WriteLine("Apologies, but the japanese dictionary file is"
                              + " needed to populate the question pool :(");
            return -1;
        }

        Console.OutputEncoding = Encoding.UTF8;
        List<string> wordsPool = GetWordsFromOrgDict(args[0]);
        return 0;
    }

    private static List<string> GetWordsFromOrgDict(string jpOrgFile)
    {
        List<string> words = new List<string>();

        foreach (string line in File.ReadLines(jpOrgFile, Encoding.UTF8))
        {
            if (!line.StartsWith('-')) continue;

            string[] parts = line.Split(' ', SplitOpts.RemoveEmptyEntries
                                             | SplitOpts.TrimEntries);

            // Parts[0] = The dash denoting the list item
            // Parts[1] = Hiragana/Katakana writing
            // Parts[2] = Kanji writing
            // Parts[3..] = Definitions

            string kanaWriting = parts[1];
            string kanjiWriting = parts[2].Trim('(', ')', ':');
            string definitions = string.Join(' ', parts[3..]);

            words.Add(new JPWord(kanaWriting, kanjiWriting, definitions));
        }

        return words;
    }
}
