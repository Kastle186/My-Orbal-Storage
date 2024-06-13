#!/usr/bin/python

import sys

from quiz import setup_and_run_app
from setup import parse_cmdline

# ---------- Main() ----------

def main(args: list[str]) -> int:
    params = parse_cmdline(args)

    if params is None:
        print("Apologies, but errors were found and the quiz can't run :(")
        return -1

    if params.quiz_kind == 'write':
        print("Apologies, but the 'write' functionality is still under construction.")
        return -2

    setup_and_run_app(params)
    return 0

if sys.version_info < (3, 10):
    print('Apologies, but this little study script requires at least Python 3.10 to run.')
    exit(-1)

main(sys.argv)
