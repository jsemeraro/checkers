defmodule Checkers.Game do
  use Agent

  def start_link(name) do
    b = new_game()
    Agent.start_link(fn ->
      %{name: name, board: b, player1: nil, player2: nil}
    end, name: reg(name))
  end

  def reg(name) do
    {:via, Registry, {Checkers.GameRegistry, name}}
  end

  def client_view(game) do
    state = Agent.get(game, fn state -> state end)
    %{
      board: Map.get(state, :board),
      player1: Map.get(state, :player1),
      player2: Map.get(state, :player2)
    }
  end

  # assign a user a color when they join
  def add_user(game) do
    player1 = Agent.get(game, fn(state) -> Map.get(state, :player1) end)
    player2 = Agent.get(game, fn(state) -> Map.get(state, :player2) end)

    cond do
      player1 == nil ->
        player1 = %{color: :red, score: 0}
        Agent.update(game, fn(state) -> Map.put(state, :player1, player1) end)
        :red
      player2 == nil ->
        player2 = %{color: :black, score: 0}
        Agent.update(game, fn(state) -> Map.put(state, :player2, player2) end)
        :black
      true ->
        :full
    end
  end

  defp get_tile_data(board, {row, col}) do
    Map.get(board, row) |> Map.get(col)
  end

  # TODO: write this function
  defp valid_move(agent, origin_data, dest_data) do
    # do validation
    # - check the origin data to be of correct color for player
    # - check the tile we are clicking is empty
    # - check the tile is one above
    # - check the tile is two above and there is a checker and it is a different color checker between

    # return statement: true, false, checker we are jumping over
    true
  end

  # from: (row, col)
  # to:   (row, col)
  def move_checker(agent, origin, dest) do
    # get checker at origin location
    board = Agent.get(agent, fn(state) -> Map.get(state, :board) end )
    origin_data = get_tile_data(board, origin)
    dest_data = get_tile_data(board, dest)

    valid = valid_move(agent, origin_data, dest_data)
    # if valid, move tile
    if valid do
      update_board(agent, origin, dest)
    end
  end

  # TODO: delete the checker we are possibly jumping over
  # update the board when we have a valid move
  defp update_board(agent, origin = {row_or, col_or}, dest = {row_dest, col_dest}) do
    board = Agent.get(agent, fn(state) -> Map.get(state, :board) end)
    origin_data = get_tile_data(board, origin)
    dest_data = get_tile_data(board, dest)

    row = Map.get(board, row_dest)
    row = Map.put(row, col_dest, origin_data)
    board = Map.put(board, row_dest, row)

    row = Map.get(board, row_or)
    row = Map.put(row, col_or, dest_data)
    board = Map.put(board, row_or, row)

    Agent.update(agent, fn(state) -> Map.put(state, :board, board) end)
  end


  ####### Building board functions #######
  defp det_checker(row_num) do
    cond do
      row_num < 3 -> :red
      row_num > 5 -> :black
      true        -> :none
    end
  end

  defp init_row_with_checkers(color, row) do
    Enum.into(0..7, [], fn k ->
      if (rem(k, 2) == 0 and row == 1) or (rem(k, 2) == 1 and row == 0) do
        %{k => %{tile: :playable, color: color}}
      else
        %{k => %{tile: :illegal}}
      end
    end) |> Enum.reduce(%{}, &Map.merge/2)
  end

  defp new_game do
    Enum.into(0..7, [], fn k ->
      color = det_checker(k)
      %{k =>  init_row_with_checkers(color, rem(k, 2))}
    end) |> Enum.reduce(%{}, &Map.merge/2)
  end
  ####### End of board functions #######

end
