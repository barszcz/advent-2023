app "hello"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br" }
    imports [
        pf.Stdout,
        pf.Task,
        "input/day1.txt" as input : Str,
    ]
    provides [main] to pf

splitLines = \x -> (Str.split x "\n")

part1 = 
    lines = input |> splitLines
    digits = Set.fromList(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
    getFirstDigit = \line -> Str.graphemes line |> List.findFirst (\x -> Set.contains digits x) |> Result.withDefault ""
    getLastDigit = \line -> Str.graphemes line |> List.findLast (\x -> Set.contains digits x) |> Result.withDefault ""
    firstDigits = List.map lines getFirstDigit
    lastDigits = List.map lines getLastDigit
    List.map2 firstDigits lastDigits (\f, l -> Str.joinWith [f, l] "")
        |> List.map Str.toU32
        |> List.map \x -> Result.withDefault x 0
        |> List.sum
        |> Num.toStr


replacements = [
    ("one", "one1one"),
    ("two", "two2two"),
    ("three", "three3three"),
    ("four", "four4four"),
    ("five", "five5five"),
    ("six", "six6six"),
    ("seven", "seven7seven"),
    ("eight", "eight8eight"),
    ("nine", "nine9nine")
]

part2 = 
    lines = input |> splitLines
    digits = Set.fromList(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
    replace = \s -> List.walk replacements s \line, (substr, replacement) -> Str.replaceEach line substr replacement
    replacedLines = List.map lines replace
    getFirstDigit = \line -> Str.graphemes line |> List.findFirst (\x -> Set.contains digits x) |> Result.withDefault ""
    getLastDigit = \line -> Str.graphemes line |> List.findLast (\x -> Set.contains digits x) |> Result.withDefault ""
    firstDigits = List.map replacedLines getFirstDigit
    lastDigits = List.map replacedLines getLastDigit
    List.map2 firstDigits lastDigits (\f, l -> Str.joinWith [f, l] "")
        |> List.map Str.toU32
        |> List.map \x -> Result.withDefault x 0
        |> List.sum
        |> Num.toStr

main = 
    _ <- Task.await (Stdout.line part1)
    Stdout.line part2
