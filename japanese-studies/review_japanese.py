#!/usr/bin/python

import sys
import argparse

# ********** JPWord Class **********

class JPWord:
    def __init__(self, english: str, kana: str, kanji: str) -> None:
        self.english = english
        self.kana = kana
        self.kanji = kanji

    def __str__(self) -> str:
        return "\n".join([f"English: {self.english}",
                          f"Kana: {self.kana}",
                          f"Kanji: {self.kanji}"])

# ---------- Parse_CmdLine() ----------

def parse_cmdline(args: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog='review_japanese.py',
        description='Little script to review and practice my japanese knowledge!')

    parser.add_argument('--words-files', metavar='FILE', nargs='+', type=str,
                        help='List of files containing the words to review,' \
                             ' separated by spaces.')

    parser.add_argument('--quiz-type', choices=['read','write'], metavar='TYPE',
                        type=str, help='Whether you want to practice reading or writing.')

    parser.add_argument('--num-questions', metavar='NUM', type=int,
                        help='Number of questions you want this game to include :)')

    return parser.parse_args()

# ---------- Get_Words_From_File() ----------

def get_words_from_file(pool: list[JPWord], filename: str) -> None:
    with open(filename) as fp:
        for line in fp:
            if not line.startswith("- "): continue

            # Parts[0] = Dash denoting the start of the list item.
            # Parts[1] = Hiragana Writing
            # Parts[2] = Kanji Writing
            # Parts[3..] = Meanings in English

            parts = line.strip().split(" ")
            kanawriting = parts[1]
            kanjiwriting = ''.join([c for c in parts[2] if not c in '():'])
            english = ' '.join(parts[3:])

            word = JPWord(english, kanawriting, kanjiwriting)
            pool.append(word)

# ---------- Generate_Word_Pool() ----------

def generate_word_pool(files: list[str]) -> list[JPWord]:
    word_pool = []

    for f in files:
        get_words_from_file(word_pool, f)

    return word_pool

# ---------- Main() ----------

def main(args: list[str]) -> int:
    params = parse_cmdline(args)
    return 0

main(sys.argv)
