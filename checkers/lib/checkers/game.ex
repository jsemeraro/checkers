defmodule Checkers.Game do
  def new do
    %{
      board: new_game,
      score_one: 0,
      score_two: 0
    }
  end

  def client_view(game) do
    board = game.board
    score_one = game.score_one
    score_two = game.score_two
    %{
      board: board,
      score_one: score_one,
      score_two: score_two
    }
  end

  #To start off the first two rows and last two rows have checkers on every other row, this is a lot to look at so let's maybe find another way
  defp new_game do
    board = %{0 => %{0 => %{checker: false},
                     1 => %{checker: true, player_id: 1},
                     2 => %{checker: false},
                     3 => %{checker: true, player_id: 1},
                     4 => %{checker: false},
                     5 => %{checker: true, player_id: 1},
                     6 => %{checker: false},
                     7 => %{checker: true, player_id: 1}},
              1 => %{0 => %{checker: true, player_id: 1},
                     1 => %{checker: false},
                     2 => %{checker: true, player_id: 1},
                     3 => %{checker: false},
                     4 => %{checker: true, player_id: 1},
                     5 => %{checker: false},
                     6 => %{checker: true, player_id: 1},
                     7 => %{checker: false}},
              2 => %{0 => %{checker: false},
                     1 => %{checker: true, player_id: 1},
                     2 => %{checker: false},
                     3 => %{checker: true, player_id: 1},
                     4 => %{checker: false},
                     5 => %{checker: true, player_id: 1},
                     6 => %{checker: false},
                     7 => %{checker: true, player_id: 1}},
              3 => %{0 => %{checker: false},
                     1 => %{checker: false},
                     2 => %{checker: false},
                     3 => %{checker: false},
                     4 => %{checker: false},
                     5 => %{checker: false},
                     6 => %{checker: false},
                     7 => %{checker: false}},
              4 => %{0 => %{checker: false},
                     1 => %{checker: false},
                     2 => %{checker: false},
                     3 => %{checker: false},
                     4 => %{checker: false},
                     5 => %{checker: false},
                     6 => %{checker: false},
                     7 => %{checker: false}},
              5 => %{0 => %{checker: true, player_id: 2},
                     1 => %{checker: false},
                     2 => %{checker: true, player_id: 2},
                     3 => %{checker: false},
                     4 => %{checker: true, player_id: 2},
                     5 => %{checker: false},
                     6 => %{checker: true, player_id: 2},
                     7 => %{checker: false}},
              6 => %{0 => %{checker: false},
                     1 => %{checker: true, player_id: 2},
                     2 => %{checker: false},
                     3 => %{checker: true, player_id: 2},
                     4 => %{checker: false},
                     5 => %{checker: true, player_id: 2},
                     6 => %{checker: false},
                     7 => %{checker: true, player_id: 2}},
              7 => %{0 => %{checker: true, player_id: 2},
                     1 => %{checker: false},
                     2 => %{checker: true, player_id: 2},
                     3 => %{checker: false},
                     4 => %{checker: true, player_id: 2},
                     5 => %{checker: false},
                     6 => %{checker: true, player_id: 2},
                     7 => %{checker: false}}
            }
  end
end
