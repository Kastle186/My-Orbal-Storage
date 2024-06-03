# Tools for Japanese/English Little Quizzes

module QuizTools

export getwords
export runquiz

"""
"""
struct JPWord
    kana::String
    kanji::String
    english::String
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
        english = join(parts[4:length(parts)], " ")

        push!(words, JPWord(kanawriting, kanjiwriting, english))
    end

    return words
end

"""
"""
function ask(question::JPWord, from::String, to::String)
    from_prompt = ""
    to_prompt = ""

    if cmp(from, "kanji") == 0
        from_prompt = "the following Kanji '$(question.kanji)'"

        if cmp(to, "english") == 0
            to_prompt = "meaning"
        elseif cmp(to, "kana") == 0
            to_prompt = "kana spelling"
        end

    else
        to_prompt = "Kanji"
        from_prompt = "$(question.kana) when it means $(question.english)"
    end

    println("\nWhat is the $to_prompt of $from_prompt?")
end

"""
"""
function displayresults(
    actual::Int,
    expected::Int,
    misses::Vector{@NamedTuple{q::JPWord, a::String}}
)
    print("\nYou had $actual/$expected correct answers")

    if actual == expected
        print("!\n")
        println("Way to go! You got all questions of this session right!")
    else
        print(".\n")
        println("You missed $(expected - actual) questions :(")
        println("\nHere are the missed questions, so you can review them:\n")

        for miss in misses
            println("- Kanji:    $(miss.q.kanji)")
            println("  Kana:     $(miss.q.kana)")
            println("  Meanings: $(miss.q.english)\n")
            println("You answered: '$(miss.a)'\n")
        end
    end
end

"""
"""
function runquiz(wordlist::Vector{JPWord}, numqs::Int, quiztype::String)
    numcorrects = 0
    misses = Vector{@NamedTuple{q::JPWord, a::String}}()
    qindices = rand(1:length(wordlist), numqs)

    qfrom, qto = map(s -> String(s), split(quiztype, '2'))

    for qi in qindices
        question = wordlist[qi]
        ask(question, qfrom, qto)
        answer = readline(stdin)

        expected = lowercase(getproperty(question, Symbol(qto)))

        if ! isempty(answer) && occursin(lowercase(answer), expected)
            numcorrects += 1
        else
            push!(misses, (q=question, a=answer))
        end
    end

    displayresults(numcorrects, numqs, misses)
end

end
