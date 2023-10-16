defmodule Game do
  defstruct [:left, :right] 

  def from_string(str) do
    [l, r] = String.split(str, " ")
    %Game{left: l, right: r}
  end

  def move_from_string(str) do
    case str do
      "A" -> :rock
      "B" -> :paper
      "C" -> :scissors
      "X" -> :rock
      "Y" -> :paper
      "Z" -> :scissors
    end
  end

  def play_score(move) do
    case move do
      :rock -> 1
      :paper -> 2
      :scissors -> 3
    end
  end

  def outcome_score(oc) do
    case oc do
      :win -> 6
      :draw -> 3
      :loss -> 0
    end
  end

  def score(g) do
    ps = g.right |> move_from_string |> play_score
    os = g |> end_state |> outcome_score
    os + ps
  end

  def score_two(g) do
    os = g |> end_state_two |> outcome_score
    ps = g |> my_move_calc |> play_score
    os + ps
  end

  def my_move_calc(g) do
    es = end_state_two(g)
    case { g.left |> move_from_string, es } do
      {n, :draw} -> n
      {:rock, :win} -> :paper
      {:rock, :loss} -> :scissors
      {:paper, :win} -> :scissors
      {:paper, :loss} -> :rock
      {:scissors, :win} -> :rock
      {:scissors, :loss} -> :paper
    end
  end

  def end_state_two(g) do
    case g.right do
      "X" -> :loss
      "Y" -> :draw
      "Z" -> :win
    end
  end

  def end_state(g) do
    case { move_from_string(g.left), move_from_string(g.right) } do
      { n, n } -> :draw
      {:rock, :paper} -> :win
      {:rock, :scissors} -> :loss
      {:paper, :scissors} -> :win
      {:paper, :rock} -> :loss
      {:scissors, :rock} -> :win
      {:scissors, :paper} -> :loss
    end
  end
end

defmodule Main do
  def main do
    path = Path.join(["..", "inputs", "2.txt"])
    {:ok, data} = File.read(path)
    lines = String.split(data, "\n") |> Enum.filter(fn l -> l != "" end)
    games = Enum.map(lines, &(Game.from_string(&1)))
    scores = Enum.map(games, &(Game.score(&1)))
    scores_two = Enum.map(games, &(Game.score_two(&1)))

    scores |> Enum.sum |> IO.puts
    scores_two |> Enum.sum |> IO.puts
  end
end

Main.main
