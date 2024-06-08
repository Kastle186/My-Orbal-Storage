# Tools for Japanese/English Little Quizzes

module QuizTools

using Match

export get_wordpool
export runquiz

"""
"""
struct JPWord
    english::String
    kana::String
    kanji::String
end

"""
"""
function addwords_fromfile!(wordpool::Vector{JPWord}, jporgfile::String)
    println("Reading the word list from '$jporgfile' into the word pool...")

    for line in eachline(jporgfile)
        if ! startswith(line, "-")
            continue
        end

        parts = split(line, " ")

        # Parts[1] = The dash denoting the list item
        # Parts[2] = Hiragana/Katakana writing
        # Parts[3] = Kanji writing
        # Parts[4..] = Definitions

        kanawriting = parts[2]
        kanjiwriting = strip(parts[3], ['(', ')', ':'])
        english = join(parts[4:length(parts)], " ")

        push!(wordpool, JPWord(english, kanawriting, kanjiwriting))
    end

    return wordpool
end

"""
"""
function ask(question::JPWord, from::String, to::String)
    from_prompt = ""
    to_prompt = ""

    @match from begin
        "kanji" => begin
            from_prompt = "the following kanji '$(question.kanji)'"
            if cmp(to, "english") == 0
                to_prompt = "the meaning"
            elseif cmp(to, "kana") == 0
                to_prompt = "the kana spelling"
            end
        end

        "kana&english" => begin
            from_prompt = "'$(question.kana)' when it means '$(question.english)'"
            to_prompt = "the kanji"
        end

        "kana" => begin
            from_prompt = "the following word '$(question.kana)'"
            to_prompt = "the meaning"
        end

        "english" => begin
            from_prompt = "the following english words/phrases"
            to_prompt = "the japanese meaning in kana"
        end
    end

    println("What is $to_prompt of $from_prompt?")
    answer = readline(stdin)
    return lowercase(answer)
end

"""
"""
function displayresults(
    actual::Int,
    expected::Int,
    misses::Vector{@NamedTuple{q::JPWord, a::String}},
    corrects::Vector{@NamedTuple{q::JPWord, a::String}}
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
            println("- English: $(miss.q.english)")
            println("- Kana:    $(miss.q.kana)")
            println("- Kanji:   $(miss.q.kanji)\n")
            println("You answered: '$(miss.a)'\n")
        end

        println("And here are the questions you got right:\n")
        for correct in corrects
            println("- English: $(correct.q.english)")
            println("- Kana:    $(correct.q.kana)")
            println("- Kanji:   $(correct.q.kanji)\n")
            println("You answered: '$(correct.a)'\n")
        end
    end
end

"""
"""
function get_wordpool(jpfiles::Vector{String})
    pool = Vector{JPWord}()
    print("\n")

    for file in jpfiles
        addwords_fromfile!(pool, file)
    end

    return pool
end

"""
"""
function runquiz(wordpool::Vector{JPWord}, params::Dict{String,Any})
    from = params["ask"]
    to = params["answer"]
    numqs = params["num-questions"]
    poolsize = length(wordpool)

    numcorrects = 0
    misses = Vector{@NamedTuple{q::JPWord, a::String}}()
    corrects = Vector{@NamedTuple{q::JPWord, a::String}}()
    qcounter = 1

    while qcounter <= numqs
        i = (rand(1:poolsize) * rand(1:poolsize) * rand(1:poolsize)) % poolsize
        question = wordpool[i]

        # Conditions that make the questions change at runtime:
        # * From is Kanji, but the word only has Kana writing.
        #   * From turns to Kana.
        #   * If To is Kana, then To would have to turn to English.
        # * To is Kanji, but the word only has Kana writing.
        #   * To turns to Kana.
        #   * From turns to English only.

        if cmp(from, "kanji") == 0 && isempty(question.kanji)
            answer = ask(question, "kana", "english")
        elseif cmp(to, "kanji") == 0 && isempty(question.kanji)
            answer = ask(question, "english", "kana")
        else
            answer = ask(question, from, to)
        end

        expected = lowercase(getproperty(question, Symbol(to)))

        if isempty(answer)
            answer = "(no answer)"
        end

        if occursin(answer, expected)
            numcorrects += 1
            push!(corrects, (q=question, a=answer))
        else
            push!(misses, (q=question, a=answer))
        end
        qcounter += 1
    end

    displayresults(numcorrects, numqs, misses, corrects)
end

end

