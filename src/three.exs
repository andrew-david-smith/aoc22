defmodule Three do
  def charcode(s) do
    s |> String.to_charlist |> hd
  end

  def score(s) do
    output = charcode(s)
    if s == String.upcase(s) do
      output - 38
    else
      output - 96
    end
  end
end

path = Path.join(["..", "inputs", "3.txt"])
{:ok, data} = File.read(path)
lines = String.split(data, "\n") |> Enum.filter(fn l -> l != "" end)
lists = Enum.map(lines, &(String.graphemes(&1)))
halved_tuples = Enum.map(lists, fn l -> Enum.split(l, div(length(l), 2)) end)
uniqs = Enum.map(halved_tuples, fn {a,b} -> a -- (a -- b) end)

scores = Enum.map(uniqs, &(Three.score(&1 |> hd)))
scores |> Enum.sum |> IO.puts

