let file = "../inputs/5.txt"

let read_file ic =
  let rec reader output =
    match input_line ic with
    | x -> reader (output @ [ x ])
    | exception End_of_file -> output
  in
  reader []

let cols =
  [|
    [ 'B'; 'V'; 'W'; 'T'; 'Q'; 'N'; 'H'; 'D' ];
    [ 'D'; 'W'; 'B' ];
    [ 'T'; 'S'; 'Q'; 'W'; 'J'; 'C' ];
    [ 'F'; 'J'; 'R'; 'N'; 'Z'; 'T'; 'P' ];
    [ 'G'; 'P'; 'V'; 'J'; 'M'; 'S'; 'T' ];
    [ 'B'; 'W'; 'F'; 'T'; 'N' ];
    [ 'B'; 'L'; 'D'; 'Q'; 'F'; 'H'; 'V'; 'N' ];
    [ 'H'; 'P'; 'F'; 'R' ];
    [ 'Z'; 'S'; 'M'; 'B'; 'L'; 'N'; 'P'; 'H' ];
  |]

let cols' =
  [|
    [ 'B'; 'V'; 'W'; 'T'; 'Q'; 'N'; 'H'; 'D' ];
    [ 'D'; 'W'; 'B' ];
    [ 'T'; 'S'; 'Q'; 'W'; 'J'; 'C' ];
    [ 'F'; 'J'; 'R'; 'N'; 'Z'; 'T'; 'P' ];
    [ 'G'; 'P'; 'V'; 'J'; 'M'; 'S'; 'T' ];
    [ 'B'; 'W'; 'F'; 'T'; 'N' ];
    [ 'B'; 'L'; 'D'; 'Q'; 'F'; 'H'; 'V'; 'N' ];
    [ 'H'; 'P'; 'F'; 'R' ];
    [ 'Z'; 'S'; 'M'; 'B'; 'L'; 'N'; 'P'; 'H' ];
  |]

type action = { amount : int; f : int; t : int }

exception Foo of string

let action_from_string s =
  let pattern = "move \\([0-9]+\\) from \\([0-9]+\\) to \\([0-9]+\\)" in
  let r = Str.regexp pattern in
  if Str.string_match r s 0 then
    let amount = Str.matched_group 1 s |> int_of_string in
    let f = Str.matched_group 2 s |> int_of_string in
    let t = Str.matched_group 3 s |> int_of_string in
    { amount; f; t }
  else raise (Foo "Unable to parse action")

let split_list n lst =
  let rec take n acc = function
    | [] -> (List.rev acc, [])
    | hd :: tl as l ->
        if n > 0 then take (n - 1) (hd :: acc) tl else (List.rev acc, l)
  in
  if n <= 0 then ([], lst) else take n [] lst

let perform_action action stack =
  let f = stack.(action.f - 1) in
  let t = stack.(action.t - 1) in
  let vals, new_from = split_list action.amount (List.rev f) in
  let new_from = List.rev new_from in
  let new_to = t @ vals in
  stack.(action.f - 1) <- new_from;
  stack.(action.t - 1) <- new_to

let perform_action' action stack =
  let f = stack.(action.f - 1) in
  let t = stack.(action.t - 1) in
  let vals, new_from = split_list action.amount (List.rev f) in
  let new_from = List.rev new_from in
  let new_to = t @ List.rev vals in
  stack.(action.f - 1) <- new_from;
  stack.(action.t - 1) <- new_to

let () =
  let data = open_in file |> read_file in
  let actions = List.map action_from_string data in
  List.iter (fun a -> perform_action a cols) actions;
  List.iter (fun a -> perform_action' a cols') actions;
  let chars = Array.map (fun l -> l |> List.rev |> List.hd) cols in
  let chars' = Array.map (fun l -> l |> List.rev |> List.hd) cols' in
  String.init (Array.length chars) (fun i -> chars.(i)) |> print_endline;
  String.init (Array.length chars') (fun i -> chars'.(i)) |> print_endline
