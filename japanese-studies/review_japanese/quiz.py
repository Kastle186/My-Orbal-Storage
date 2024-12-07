# File: quiz.py

import random

from argparse import Namespace
from collections import namedtuple
from enum import Enum
from typing import TextIO

# ********** JPWord Class **********

class JPWord:
    def __init__(self, english: str, kana: str, kanji: str) -> None:
        self.english = english
        self.kana = kana
        self.kanji = kanji

    def __str__(self) -> str:
        strrep = f"- English: {self.english}\n" \
                 f"  Kana: {self.kana}"
        if self.kanji:
            strrep += f"\n  Kanji: {self.kanji}"
        return strrep

    def orig_str(self) -> str:
        return f"- {self.kana} ({self.kanji}): {self.english}"

# ********** Question/Answer Set Type **********

QA = namedtuple('QA', ['question', 'answer'])

# ********** Answer States Enum **********

class AnswerState(Enum):
    CORRECT = 1
    MISSED  = 2
    PARTIAL = 3 # Currently Unused

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

def ask(question: JPWord, qkind: str, qnum: int) -> str:
    from_prompt = 'of the following'
    to_prompt = 'the meaning'

    if not question.kanji:
        from_prompt += f" word '{question.kana}'"
    else:
        from_prompt += f" kanji '{question.kanji}'"
        to_prompt += ' and kana writing' if qkind == 'read' else ''

    answer = input(f"\n{qnum}) What is {to_prompt} {from_prompt}?\n").strip()
    return answer if len(answer) > 0 else "<no response>"

# ---------- Check_Answer() ----------

def check_answer(question: JPWord, answer: str, kind: str) -> AnswerState:
    if kind == 'translate' or (kind == 'read' and not question.kanji):
        en = answer.lower()
        expected_en = question.english.lower()
        return AnswerState.CORRECT if en in expected_en else AnswerState.MISSED

    # FEATURE IDEA: Add partially correct answers, when either the english meaning
    #               or the kana writing are correct.

    try:
        en, jp = map(lambda x: x.strip(), answer.split(','))
    except ValueError:
        return AnswerState.MISSED
    else:
        en = en.lower()
        jp = jp.split('(')[0]
        expected_en = question.english.lower()
        expected_jp = list(map(lambda x: x.strip(),
                                   question.kana.split('(')[0].split('/')))

        if en in expected_en and jp in expected_jp:
            return AnswerState.CORRECT

    return AnswerState.MISSED

# ---------- Record_Misses() ----------

def record_misses(to_study: list[QA]) -> None:
    with open('to-study.org', 'a', encoding='utf8') as fp:
        fp.writelines([qa.question.orig_str() + '\n' for qa in to_study])

# ---------- Multi_IO_Print() ----------

def multi_io_print(text: str, file_stream: TextIO) -> None:
    print(text, end='')
    file_stream.write(text)

# ---------- Display_Results() ----------

def display_results(corrects: list[QA], misses: list[QA], num_questions: int) -> None:
    num_corrects = len(corrects)
    num_misses = len(misses)
    results_file = open('results.txt', 'wt', encoding='utf8')

    multi_io_print(f"\nYou had {num_corrects}/{num_questions} correct answers.\n",
                   results_file)

    if num_corrects == num_questions:
        multi_io_print("\nWay to go! You got them all right this time!\n",
                       results_file)
    else:
        multi_io_print("\nHere are the ones you missed, so you can review them :)\n",
                       results_file)

        for miss in misses:
            multi_io_print(f"\n{str(miss.question)}\n", results_file)
            multi_io_print(f"You answered: '{miss.answer}'\n", results_file)

        record_misses(misses)

    if num_corrects > 0:
        multi_io_print("\nHere are the ones you got right:\n", results_file)

        for correct in corrects:
            multi_io_print(f"\n{str(correct.question)}\n", results_file)
            multi_io_print(f"You answered: '{correct.answer}'\n", results_file)

    results_file.close()

# ---------- Run_Quiz() ----------

def run_quiz(word_pool: list[JPWord], kind: str, num_questions: int) -> None:
    q_counter = 0
    corrects = []
    misses = []
    partials = []

    while q_counter < num_questions:
        q_counter += 1
        question = word_pool[random.randint(0, len(word_pool)-1)]
        answer = ask(question, kind, q_counter)

        if check_answer(question, answer, kind) == AnswerState.CORRECT:
            corrects.append(QA(question, answer))
        else:
            misses.append(QA(question, answer))

    display_results(corrects, misses, num_questions)

# ---------- Setup_And_Run_App() ----------

def setup_and_run_app(params: Namespace) -> None:
    word_pool = generate_word_pool(params.words_files)
    # random.shuffle(word_pool)
    run_quiz(word_pool, params.quiz_kind, params.num_questions)
