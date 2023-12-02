app "day2"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br" }
    imports [
        pf.Stdout,
        pf.Task,
        "input/day2.txt" as input : Str,
    ]
    provides [main] to pf

must = \x ->
    when x is
        Ok v -> v
        Err _ -> crash "never"

splitLines = \x -> (Str.split x "\n")

getGameResult = \game -> game |> Str.splitFirst ": " |> must |> .after
getCount = \raw -> 
    split = Str.splitFirst raw " " |> must
    count = split.before |> Str.toU32 |> must
    (split.after, count)

parseRound = \round ->
    rawCounts = Str.split round ", "
    countsDict = rawCounts |> List.map getCount |> Dict.fromList
    reds = Dict.get countsDict "red" |> Result.withDefault 0
    greens = Dict.get countsDict "green" |> Result.withDefault 0
    blues = Dict.get countsDict "blue" |> Result.withDefault 0
    { reds, greens, blues }

getRounds = \game ->
    game |> Str.split "; " |> List.map parseRound

roundIsPossible = \{reds, greens, blues} ->
    reds <= 12 && greens <= 13 && blues <= 14

gameIsPossible = \game ->
    game |> getRounds |> List.all roundIsPossible

findMins = \rounds ->
    allReds = List.map rounds .reds
    allGreens = List.map rounds .greens
    allBlues = List.map rounds .blues
    minReds = allReds |> List.max |> Result.withDefault 0
    minGreens = allGreens |> List.max |> Result.withDefault 0
    minBlues = allBlues |> List.max |> Result.withDefault 0
    {reds: minReds, greens: minGreens, blues: minBlues}

getPower = \{reds, greens, blues} -> 
    reds * greens * blues

part1 =
    games = splitLines input |> List.dropLast 1 |> List.map getGameResult
    gameSum = List.walkWithIndex games 0 \sum, game, idx -> if gameIsPossible game then sum + idx + 1 else sum
    Num.toStr gameSum

part2 = 
    games = splitLines input |> List.dropLast 1 |> List.map getGameResult
    powers = games |> List.map getRounds |> List.map findMins |> List.map getPower
    powerSum = List.sum powers
    Num.toStr powerSum

main = 
    _ <- Task.await (Stdout.line part1)
    Stdout.line part2
