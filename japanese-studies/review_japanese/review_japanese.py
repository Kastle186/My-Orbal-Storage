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

    setup_and_run_app(params)
    return 0

main(sys.argv)
