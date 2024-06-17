# File: quiz.py

import random

from argparse import Namespace
from collections import namedtuple

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

# ********** Question/Answer Set Type **********

QA = namedtuple('QA', ['question', 'answer'])

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

    if qkind == 'translate' or qkind == 'read':
        from_prompt = 'of the following'
        to_prompt = 'the meaning'

        if not question.kanji:
            from_prompt += f" word '{question.kana}'"
        else:
            from_prompt += f" kanji '{question.kanji}'"
            to_prompt += ' and kana writing' if qkind == 'read' else ''

    elif qkind == 'write':
        if not question.kanji:
            from_prompt = f"for '{question.english}'"
            to_prompt = 'the japanese word'
        else:
            from_prompt = f"of '{question.kana}' when it means '{question.english}'"
            to_prompt = 'the kanji'

    answer = input(f"\nWhat is {to_prompt} {from_prompt}?\n").strip()
    return answer if len(answer) > 0 else "<no response>"

# ---------- Check_Answer() ----------

def check_answer(question: JPWord, answer: str, kind: str) -> bool:
    if kind == 'translate' or (kind == 'read' and not question.kanji):
        return answer.lower() in question.english.lower()

    # FIXME: Some words have multiple kana writings, which are separated by
    #        forward slashes '/'. Only one is enough to get the question right,
    #        so handle this special case.

    # FEATURE: Add partially correct answers, when either the english meaning or
    #          the kana writing are correct.

    if kind == 'read' and question.kanji:
        try:
            en, jp = map(lambda x: x.strip(), answer.split(','))
        except ValueError:
            return False
        else:
            en = en.lower()
            jp = jp.rstrip('(')[0]
            expected_en = question.english.lower()
            expected_jp = question.kana.rstrip('(')[0]
            return en in expected_en and jp == expected_jp

    # TODO: Implement writing checks.
    if kind == 'write':
        return True

    return False

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

# ---------- Run_Quiz() ----------

def run_quiz(word_pool: list[JPWord], kind: str, num_questions: int) -> None:
    q_counter = 1
    corrects = []
    misses = []

    while q_counter <= num_questions:
        q_counter += 1
        question = random.choice(word_pool)
        answer = ask(question, kind)

        if check_answer(question, answer, kind):
            corrects.append(QA(question, answer))
        else:
            misses.append(QA(question, answer))

    display_results(corrects, misses, num_questions)

# ---------- Setup_And_Run_App() ----------

def setup_and_run_app(params: Namespace) -> None:
    word_pool = generate_word_pool(params.words_files)
    random.shuffle(word_pool)
    run_quiz(word_pool, params.quiz_kind, params.num_questions)
