let file = "../inputs/2.txt"

type play = Rock | Paper | Scissors
type outcome = Win | Loss | Draw
type game = { enemy : play; me : play }

let read_file ic =
  let rec reader output =
    match input_line ic with
    | x -> reader (output @ [ x ])
    | exception End_of_file -> output
  in
  reader []

exception Foo of string

let string_to_play s =
  match s with
  | "A" | "X" -> Rock
  | "B" | "Y" -> Paper
  | "C" | "Z" -> Scissors
  | _ -> raise (Foo "Unknown symbol")

let string_to_game s =
  let split = String.split_on_char ' ' s in
  let enemy = split |> List.hd |> string_to_play in
  let me = split |> List.rev |> List.hd |> string_to_play in
  { enemy; me }

let score_for_play p = match p with Rock -> 1 | Paper -> 2 | Scissors -> 3
let score_for_outcome o = match o with Win -> 6 | Draw -> 3 | Loss -> 0

let outcome_for_game g =
  if g.enemy == g.me then Draw
  else
    match g.enemy with
    | Rock -> if g.me == Paper then Win else Loss
    | Paper -> if g.me == Scissors then Win else Loss
    | Scissors -> if g.me == Rock then Win else Loss

let game_to_points g =
  let o = outcome_for_game g in
  let play_score = score_for_play g.me in
  let outcome_score = score_for_outcome o in
  play_score + outcome_score

type another = { enemy : play; outcome : outcome }

let string_to_outcome s =
  match s with
  | "X" -> Loss
  | "Y" -> Draw
  | "Z" -> Win
  | _ -> raise (Foo "Unknown symbol")

let string_to_game' s =
  let split = String.split_on_char ' ' s in
  let enemy = split |> List.hd |> string_to_play in
  let o = split |> List.rev |> List.hd |> string_to_outcome in
  { enemy; outcome = o }

let required_play g =
  if g.outcome == Draw then g.enemy
  else
    match g.enemy with
    | Rock -> if g.outcome == Win then Paper else Scissors
    | Paper -> if g.outcome == Win then Scissors else Rock
    | Scissors -> if g.outcome == Win then Rock else Paper

let game'_to_points g =
  let play_score = score_for_play (required_play g) in
  let outcome_score = score_for_outcome g.outcome in
  play_score + outcome_score

let () =
  let data = open_in file |> read_file in
  let games = List.map string_to_game data in
  let games' = List.map string_to_game' data in
  let scores = List.map game_to_points games in
  let scores' = List.map game'_to_points games' in
  let total = List.fold_left (fun a b -> a + b) 0 scores in
  let total' = List.fold_left (fun a b -> a + b) 0 scores' in
  total |> string_of_int |> print_endline;
  total' |> string_of_int |> print_endline
