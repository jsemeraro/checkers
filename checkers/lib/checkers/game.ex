defmodule Checkers.Game do
  def new do
    %{
      board: new_game, #TODO array of dictionary - each one has a color and a "true" for if it has a piece on it
      score: 0
    }
  end

  def client_view(game) do
    board = game.board
    score = game.score
    %{
      board: board,
      score: score
    }
  end

  #To start off the first two rows and last two rows have checkers on every other row, this is a lot to look at so let's maybe find another way
  defp new_game do
    board = %{0 => %{0 => %{checker?: true},
                     1 => %{checker?: false},
                     2 => %{checker?: true},
                     3 => %{checker?: false},
                     4 => %{checker?: true},
                     5 => %{checker?: false},
                     6 => %{checker?: true},
                     7 => %{checker?: false}},
              1 => %{0 => %{checker?: false},
                     1 => %{checker?: true},
                     2 => %{checker?: false},
                     3 => %{checker?: true},
                     4 => %{checker?: false},
                     5 => %{checker?: true},
                     6 => %{checker?: false},
                     7 => %{checker?: true}},
              2 => %{0 => %{checker?: false},
                     1 => %{checker?: false},
                     2 => %{checker?: false},
                     3 => %{checker?: false},
                     4 => %{checker?: false},
                     5 => %{checker?: false},
                     6 => %{checker?: false},
                     7 => %{checker?: false}},
              3 => %{0 => %{checker?: false},
                     1 => %{checker?: false},
                     2 => %{checker?: false},
                     3 => %{checker?: false},
                     4 => %{checker?: false},
                     5 => %{checker?: false},
                     6 => %{checker?: false},
                     7 => %{checker?: false}},
              4 => %{0 => %{checker?: false},
                     1 => %{checker?: false},
                     2 => %{checker?: false},
                     3 => %{checker?: false},
                     4 => %{checker?: false},
                     5 => %{checker?: false},
                     6 => %{checker?: false},
                     7 => %{checker?: false}},
              5 => %{0 => %{checker?: false},
                     1 => %{checker?: false},
                     2 => %{checker?: false},
                     3 => %{checker?: false},
                     4 => %{checker?: false},
                     5 => %{checker?: false},
                     6 => %{checker?: false},
                     7 => %{checker?: false}},
              6 => %{0 => %{checker?: false},
                     1 => %{checker?: false},
                     2 => %{checker?: false},
                     3 => %{checker?: false},
                     4 => %{checker?: false},
                     5 => %{checker?: false},
                     6 => %{checker?: false},
                     7 => %{checker?: false}},
              7 => %{0 => %{checker?: false},
                     1 => %{checker?: false},
                     2 => %{checker?: false},
                     3 => %{checker?: false},
                     4 => %{checker?: false},
                     5 => %{checker?: false},
                     6 => %{checker?: false},
                     7 => %{checker?: false}}
            }
  end
end
