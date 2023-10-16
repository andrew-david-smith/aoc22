path = Path.join(["..", "inputs", "1.txt"])
{:ok, data} = File.read(path)
lines = String.split(data, "\n") |> Enum.chunk_by(&(&1 == ""))
filtered = Enum.map(lines, &(Enum.filter(&1, fn l -> l != "" end)))
ints = Enum.map(filtered, fn list -> Enum.map(list, &(String.to_integer(&1))) end)
totals = Enum.map(ints, &(Enum.sum(&1)))

totals |> Enum.max |> Integer.to_string |> IO.puts
totals |> Enum.sort(&(&1 >= &2)) |> Enum.take(3) |> Enum.sum |> Integer.to_string |> IO.puts
