let file = "../inputs/4.txt"

type range = { start : int; fin : int }
type pair = { left : range; right : range }

let read_file ic =
  let rec reader output =
    match input_line ic with
    | x -> reader (output @ [ x ])
    | exception End_of_file -> output
  in
  reader []

let string_to_range s =
  let split = String.split_on_char '-' s in
  let start = split |> List.hd |> int_of_string in
  let fin = split |> List.rev |> List.hd |> int_of_string in
  { start; fin }

let string_to_pair s =
  let split = String.split_on_char ',' s in
  let left = split |> List.hd |> string_to_range in
  let right = split |> List.rev |> List.hd |> string_to_range in
  { left; right }

let range_contains r1 r2 = r1.start >= r2.start && r1.fin <= r2.fin

let pair_contains_full_contain p =
  range_contains p.left p.right || range_contains p.right p.left

let range_overlap r1 r2 =
  (r1.start >= r2.start && r1.start <= r2.fin)
  || (r1.fin >= r2.start && r1.fin <= r2.fin)

let pair_contains_any_overlap p =
  range_overlap p.left p.right || range_overlap p.right p.left

let () =
  let data = open_in file |> read_file in
  let pairs = List.map string_to_pair data in
  let filtered = List.filter pair_contains_full_contain pairs in
  let filtered' = List.filter pair_contains_any_overlap pairs in
  let total = filtered |> List.length |> string_of_int in
  let total' = filtered' |> List.length |> string_of_int in
  print_endline total;
  print_endline total'
