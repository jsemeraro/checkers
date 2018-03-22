defmodule Checkers.Game do
  def new do
    %{
      board: %{}, #TODO array of dictionary - each one has a color and a "true" for if it has a piece on it
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
end
