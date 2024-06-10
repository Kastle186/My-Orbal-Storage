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

# ---------- Get_Words_From_Files() ----------

def get_words_from_files(files: list[str]) -> list[JPWord]:
    word_pool = []
    return word_pool

# ---------- Main() ----------

def main(args: list[str]) -> int:
    params = parse_cmdline(args)
    return 0

main(sys.argv)
