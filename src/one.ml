let file = "../inputs/1.txt"

let read_file ic =
  let rec reader current output =
    match input_line ic with
    | "" -> reader [] (current :: output)
    | x -> reader (int_of_string x :: current) output
    | exception End_of_file -> current :: output
  in
  reader [] []

let parta data =
  let summed = List.map (List.fold_left ( + ) 0) data in
  List.sort compare summed |> List.rev |> List.hd

let partb data =
  let summed = List.map (List.fold_left ( + ) 0) data in
  match List.sort compare summed |> List.rev with
  | a :: b :: c :: _ -> a + b + c
  | _ -> assert false

let () =
  let a = open_in file |> read_file |> parta |> string_of_int in
  let b = open_in file |> read_file |> partb |> string_of_int in
  print_endline a;
  print_endline b
