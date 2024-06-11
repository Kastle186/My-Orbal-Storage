#!/usr/bin/python

import argparse
import random
import sys

from collections import namedtuple

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

# ********** Question/Answer Set Type **********

QA = namedtuple('QA', ['question', 'answer'])

# ---------- Parse_CmdLine() ----------

def parse_cmdline(args: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog='review_japanese.py',
        description='Little script to review and practice my japanese knowledge!')

    parser.add_argument('--words-files', metavar='FILE', nargs='+', type=str,
                        help='List of files containing the words to review,' \
                             ' separated by spaces.')

    parser.add_argument('--quiz-kind', choices=['read','write'], metavar='TYPE',
                        type=str, help='Whether you want to practice reading or writing.')

    parser.add_argument('--num-questions', metavar='NUM', type=int,
                        help='Number of questions you want this game to include :)')

    return parser.parse_args()

# ---------- Get_Words_From_File() ----------

def get_words_from_file(pool: list[JPWord], filename: str) -> None:
    with open(filename, encoding='utf8') as fp:
        for line in fp:
            if not line.startswith("- "): continue

            # Parts[0] = Dash denoting the start of the list item.
            # Parts[1] = Hiragana Writing
            # Parts[2] = Kanji Writing
            # Parts[3..] = Meanings in English

            parts = line.strip().split()
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

# ---------- Ask() ----------

def ask(question: JPWord, qkind: str) -> str:
    from_prompt = ''
    to_prompt = ''

    if qkind == 'read':
        from_prompt = 'of the following '
        to_prompt = 'the meaning'
        if not question.kanji:
            from_prompt += f"word '{question.kana}'"
        else:
            from_prompt += f"kanji '{question.kanji}'"

    elif qkind == 'write':
        if not question.kanji:
            from_prompt = f"for '{question.english}'"
            to_prompt = 'the japanese word'
        else:
            from_prompt = f"of '{question.kana}' when it means '{question.english}'"
            to_prompt = 'the kanji'

    answer = input(f"\nWhat is {to_prompt} {from_prompt}?\n")
    return answer.lower()

# ---------- Run_Quiz() ----------

def run_quiz(word_pool: list[JPWord], kind: str, num_questions: int) -> None:
    q_counter = 1
    corrects = []
    misses = []

    while q_counter <= num_questions:
        q_counter += 1
        question = random.choice(word_pool)

        if kind == 'read':
            expected_answer_type = 'english'
        elif kind == 'write':
            expected_answer_type = 'kanji' if question.kanji else 'kana'

        answer = ask(question, kind)
        expected = getattr(question, expected_answer_type).lower()

        if answer == expected:
            corrects.append(QA(question, answer))
        else:
            misses.append(QA(question, answer))

    display_results(corrects, misses, num_questions)

# ---------- Display_Results() ----------

def display_results(corrects: list[QA], misses: list[QA], num_questions: int) -> None:
    num_corrects = len(corrects)
    num_misses = len(misses)

    print(f"\nYou had {num_corrects}/{num_questions} correct answers",
          end="!\n" if num_corrects == num_questions else ".\n")

    if num_corrects == num_questions:
        print("\nWay to go! You got them all right this time!\n")
    else:
        print("\nHere are the ones you missed, so you can review them :)")
        for miss in misses:
            print(f"\n{str(miss.question)}")
            print(f"You answered: '{miss.answer}'")

    print("\nHere are the ones you got right:")
    for correct in corrects:
        print(f"\n{str(correct.question)}")
        print(f"You answered: '{correct.answer}'")

# ---------- Setup_And_Run_App() ----------

def setup_and_run_app(params: argparse.Namespace) -> None:
    # TODO: Add params validation.
    word_pool = generate_word_pool(params.words_files)
    random.shuffle(word_pool)
    run_quiz(word_pool, params.quiz_kind, params.num_questions)

# ---------- Main() ----------

def main(args: list[str]) -> int:
    params = parse_cmdline(args)
    setup_and_run_app(params)
    return 0

main(sys.argv)
