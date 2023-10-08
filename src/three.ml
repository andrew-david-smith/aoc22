let file = "../inputs/3.txt"
type bag = { left : char list; right : char list }

let read_file ic =
  let rec reader output =
    match input_line ic with
    | x -> reader (output @ [ x ])
    | exception End_of_file -> output
  in
  reader []

let to_char_list s = List.init (String.length s) (String.get s)
let diff l1 l2 = List.find (fun x -> List.mem x l2) l1
let diff' l1 l2 = List.filter (fun x -> List.mem x l2) l1

let split_in_half list =
  let rec split_at_helper v current output l =
    if List.length l == (v + 1) then
      split_at_helper v [] (output @ [current @ [List.hd l]]) (List.tl l)
    else match l with
    | h :: t -> split_at_helper v (current @ [h]) output t 
    | [] -> if List.is_empty current then output else output @ [current]
  in
  let length = List.length list / 2 in
  split_at_helper length [] [] list

let char_score c =
  if Char.lowercase_ascii c == c then Char.code c - 96
  else Char.code c - 65 + 27

let string_to_bag s =
  let list = to_char_list s in
  let parts = split_in_half list in
  let left = List.hd parts in
  let right = parts |> List.rev |> List.hd in
  { left; right}

let bag_to_score b =
  diff b.left b.right |> char_score

let in_batches_of n l =
  let rec batches_helper current output list =
    if List.length current == n - 1 then 
      batches_helper [] (output @ [current @ [List.hd list]]) (List.tl list)
    else match list with
    | h :: t -> batches_helper (current @ [h]) output t
    | [] -> output @ [current]
  in
  batches_helper [] [] l

let common_val l =
  List.fold_left diff' (List.hd l) (List.tl l) |> List.hd

let () =
  let data = open_in file |> read_file in
  let in_threes = data |> in_batches_of 3 in
  let in_threes_char = List.map (fun l -> List.map to_char_list l) in_threes in
  let filtered = List.filter (fun l -> not (List.is_empty l)) in_threes_char in
  let common_val = List.map common_val filtered in
  let bags = List.map string_to_bag data in
  let scores = List.map bag_to_score bags in
  let scores' = List.map char_score common_val in
  let total = List.fold_left (fun a b -> a + b) 0 scores in
  let total' = List.fold_left (fun a b -> a + b) 0 scores' in
  total |> string_of_int |> print_endline;
  total' |> string_of_int |> print_endline
