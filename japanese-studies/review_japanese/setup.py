# File: setup.py

import argparse
import os

# ---------- Validate_Params() ----------

def validate_params(params: argparse.Namespace) -> bool:
    all_files_valid = True
    print("\nValidating received parameters...\n")

    for wf_path in params.words_files:
        if not os.path.isfile(wf_path):
            print(f"Apologies, but the given file '{wf_path}' was not found.")
            all_files_valid = False

    if not all_files_valid:
        return False

    while params.num_questions <= 0:
        print('Apologies, but the number of questions has to be a positive number.')
        params.num_questions = input('Enter the number of questions you want ' \
                                     'the quiz to have: ', end='')
    return True

# ---------- Parse_CmdLine() ----------

def parse_cmdline(args: list[str]) -> argparse.Namespace | None:
    parser = argparse.ArgumentParser(
        prog='review_japanese.py',
        description='Little script to review and practice my japanese knowledge!')

    parser.add_argument('--words-files', metavar='FILE', nargs='+', type=str,
                        help='List of files containing the words to review,' \
                             ' separated by spaces.')

    parser.add_argument('--quiz-kind', choices=['translate','read'], metavar='TYPE',
                        type=str, help='Whether you want to practice translating,' \
                                       ' or reading.')

    parser.add_argument('--num-questions', metavar='NUM', type=int,
                        help='Number of questions you want this game to include :)')

    result = parser.parse_args()
    return result if validate_params(result) else None
