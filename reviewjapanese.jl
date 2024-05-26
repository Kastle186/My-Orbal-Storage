#!/usr/bin/julia

using Random
using StatsBase # Needs to be installed via the Julia REPL with Pkg.add("StatsBase")

"""
"""
struct JPWord
    kana::String
    kanji::String
    meanings::String
end

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
function getwords(jporgfile::String)
    words = Vector{JPWord}()

    for line in eachline(jporgfile)
        if ! startswith(line, "-") continue end

        parts = split(line, " ")

        # Parts[1] = The dash denoting the list item
        # Parts[2] = Hiragana/Katakana writing
        # Parts[3] = Kanji writing
        # Parts[4..] = Definitions

        kanawriting = parts[2]
        kanjiwriting = strip(parts[3], ['(', ')', ':'])
        meanings = join(parts[4:length(parts)], " ")

        push!(words, JPWord(kanawriting, kanjiwriting, meanings))
    end

    return words
end

"""
"""
function run_kanji2englishtest(wordlist::Vector{JPWord})
    numcorrects = 0
    misses = Vector{@NamedTuple{q::JPWord, a::String}}()
    total = length(wordlist)

    shuffle!(wordlist)

    for question in wordlist
        println("\nWhat does this Kanji $(question.kanji) mean?")
        answer = readline(stdin)

        if ! isempty(answer) && occursin(answer, lowercase(question.meanings))
            numcorrects += 1
        else
            push!(misses, (q=question, a=answer))
        end
    end

    print("\nYou had $numcorrects/$total correct answers")

    if numcorrects == total
        print("!\n")
        println("Way to go! You got all questions of this session right!")
    else
        print(".\n")
        println("You missed $(total - numcorrects) questions :(")
        println("\nHere are the missed questions, so you can review them:\n")

        for miss in misses
            println("- Kanji:    $(miss.q.kanji)")
            println("  Kana:     $(miss.q.kana)")
            println("  Meanings: $(miss.q.meanings)\n")
            println("You answered: '$(miss.a)'\n")
        end
    end
end

"""
"""
function main()
    wordfile, numquestions = getparams()

    wordpool = getwords(wordfile)
    questions = sample(wordpool, numquestions)
    run_kanji2englishtest(questions)

    return 0
end

main()
