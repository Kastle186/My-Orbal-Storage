# Tools for Japanese/English Little Quizzes

module QuizTools

export getwords
export runquiz

"""
"""
struct JPWord
    kana::String
    kanji::String
    meanings::String
end

"""
"""
function getwords(jporgfile::String)
    words = Vector{JPWord}()
    println("\nReading the word pool from '$jporgfile'...")

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
function runquiz(wordlist::Vector{JPWord}, numqs::Int)
    numcorrects = 0
    misses = Vector{@NamedTuple{q::JPWord, a::String}}()
    qindices = rand(1:length(wordlist), numqs)

    for qi in qindices
        question = wordlist[qi]

        println("\nWhat does this Kanji $(question.kanji) mean?")
        answer = readline(stdin)

        if ! isempty(answer) && occursin(lowercase(answer), lowercase(question.meanings))
            numcorrects += 1
        else
            push!(misses, (q=question, a=answer))
        end
    end

    print("\nYou had $numcorrects/$numqs correct answers")

    if numcorrects == numqs
        print("!\n")
        println("Way to go! You got all questions of this session right!")
    else
        print(".\n")
        println("You missed $(numqs - numcorrects) questions :(")
        println("\nHere are the missed questions, so you can review them:\n")

        for miss in misses
            println("- Kanji:    $(miss.q.kanji)")
            println("  Kana:     $(miss.q.kana)")
            println("  Meanings: $(miss.q.meanings)\n")
            println("You answered: '$(miss.a)'\n")
        end
    end
end

end
