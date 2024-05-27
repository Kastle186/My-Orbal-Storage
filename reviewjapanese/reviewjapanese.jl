#!/usr/bin/julia

using Random
using StatsBase # Needs to be installed via the Julia REPL with Pkg.add("StatsBase")

include("quiztools.jl")

"""
"""
function getparams()
    wordfile = ""
    numquestions = 0

    if length(ARGS) < 2
        print("\n")

        if length(ARGS) < 1
            print("Enter the file where the word list is: ")
            wordfile = readline(stdin)
        else
            wordfile = ARGS[1]
        end

        print("Enter the number of questions you want to review: ")
        numquestions = parse(Int, readline(stdin))

    else
        wordfile = ARGS[1]
        numquestions = parse(Int, ARGS[2])

    end

    return wordfile, numquestions
end

"""
"""
function main()
    wordfile, numquestions = getparams()
    wordpool = QuizTools.getwords(wordfile)

    QuizTools.runquiz(wordpool, numquestions)
    return 0
end

main()
