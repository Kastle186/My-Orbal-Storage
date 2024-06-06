# Command Line Parsing Little Tool

using ArgParse

"""
"""
module CommandLineParser

export parsecmdline

"""
"""
function parsecmdline_helper(args::Vector{String})
    s = ArgParseSettings(description = "Little quizzer app to practice Japanese!")

    @add_arg_table s begin
        "--word-files"
            help = "File(s) containing the words you wish to practice, separated by spaces."
            arg_type = Vector{String}
            required = true
            nargs = '+'

        "--ask"
            help = "What you wish to be asked: Kanji or Kana?"
            arg_type = String
            required = false

        "--answer"
            help = "What you wish to answer: Kana or English?"
            arg_type = String
            required = false

        "--num-questions"
            help = "How many questions do want the quiz to have?"
            arg_type = Int
            required = false
    end

    return parse_args(args, s)
end

"""
"""
function validate_args(parsed_args::Dict{String,Any})
    print("\nValidating the input arguments...\n")

    files = parsed_args["word-files"]
    allfilesvalid = true

    for f in files
        if ! isfile(f)
            println("Apologies, but file '$f' was not found :(")
            allfilesvalid = false
        end
    end

    if ! allfilesvalid return false end

    # Supported Combinations:
    # - Give me the Kanji, and I reply with the Kana.
    # - Give me the Kanji, and I reply with the meaning in English.
    # - Give me the Kana with the meaning in English, and I reply with the Kanji.
    # - TODO EXTRA: Give me a word in English, and I reply with the Japanese Kanji.
    # - TODO LONGER TERM: Grammar rules.

    toask = haskey(parsed_args, "ask") ? lowercase(parsed_args["ask"]) : ""
    askprompt = "Enter the question's prompt (kanji/kana&english): "

    while cmp(toask, "kanji") != 0 || cmp(toask, "kana&english") != 0
        if ! isempty(toask)
            print("Apologies, but '$toask' os not a supported type of question. ")
        end

        print("$askprompt: ")
        toask = lowercase(readline(stdin))
    end
    parsed_args["ask"] = toask

    validanswers = cmp(toask, "kanji") == 0 ? ["kana", "english"] : ["kanji"]
    toans = haskey(parsed_args, "answer") ? lowercase(parsed_args["answer"]) : ""
    ansprompt = "Enter the type of answer you want to give ($(join(validanswers, '/'))): "

    while ! toans in validanswers
        if ! isempty(toans)
            print("Apologies, but '$toans' is not a possible answer type in this case. ")
        end

        print("$ansprompt: ")
        toans = lowercase(readline(stdin))
    end
    parsed_args["answer"] = toans

    numqs = haskey(parsed_args, "num-questions") ? parsed_args["num-questions"] ? 0
    qsprompt = "Enter the number of questions you want the quiz to have: "

    while numqs <= 0
        if numqs < 0
            print("Apologies, but the number of questions must be greater than zero. ")
        end

        print("$qsprompt: ")

        try
            numqs = parse(Int, readline(stdin))
        catch
            println("Apologies, but '$numqs' has to be an integer number. Try again please.")
            numqs = 0
        end
    end

    parsed_args["num-questions"] = numqs
    return true
end

"""
"""
function parsecmdline(args::Vector{String})
    parsed_args = parsecmdline_helper(args)

    if validate_args(parsed_args) return parsed_args end

    println("\nApologies, but some issues were found :(\n")
    exit(-1)
end

end
