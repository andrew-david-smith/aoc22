let file = "../inputs/6.txt"

let read_file ic =
  let rec reader output =
    match input_line ic with
    | x -> reader (output @ [ x ])
    | exception End_of_file -> output
  in
  reader [] |> List.hd

let to_char_list s = List.init (String.length s) (String.get s)

let rec take n lst =
  if n <= 0 then []
  else match lst with [] -> [] | hd :: tl -> hd :: take (n - 1) tl

let find_first_uniq_chars n_uniqs s =
  let l = to_char_list s in
  let rec helper n list =
    let ss = take n_uniqs list in
    let sorted_uniq = List.sort_uniq compare ss in
    let sorted = List.sort compare ss in
    if List.equal ( == ) sorted sorted_uniq then n + n_uniqs
    else helper (n + 1) (List.tl list)
  in
  helper 0 l

let () =
  let s = open_in file |> read_file in
  let n = find_first_uniq_chars 4 s in
  let n' = find_first_uniq_chars 14 s in
  n |> string_of_int |> print_endline;
  n' |> string_of_int |> print_endline
