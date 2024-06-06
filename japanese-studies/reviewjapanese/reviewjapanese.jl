#!/usr/bin/julia

using Random

include("commandline_parser.jl")
include("quiztools.jl")

params = CommandLineParser.parsecmdline(ARGS)

wordpool = QuizTools.get_wordpool(params["word-files"])
shuffle!(wordpool)

QuizTools.runquiz(wordpool, params)
