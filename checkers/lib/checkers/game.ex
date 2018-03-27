defmodule Checkers.Game do
  use Agent

  def start_link(name) do
    b = new_game()
    Agent.start_link(fn ->
      %{name: name, board: b, player1: nil, player2: nil} #, turn: :red}
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

  defp det_poss_moves(board, row, col, curr_color, direction) do
    next_color = Map.get(board, row) |> Map.get(col) |> Map.get(:color)
    cond do
      next_color == :none ->
        [{row, col}]

      next_color != curr_color and next_color != :none ->
        next_row =
          case curr_color do
            :red -> (row + 1)
            :black -> (row - 1)
          end

        new_col = col + direction

        if new_col == 8 or new_col == -1 do
          []
        else
          if Map.get(board, next_row) |> Map.get(new_col) |> Map.get(:color) == :none do
            [{next_row, new_col}]
          else
            []
          end
        end

      true ->
        []
    end
  end

  defp get_poss_locations(board, checker_location = {row, col}) do
    curr_color = Map.get(board, row) |> Map.get(col) |> Map.get(:color)
    col_left = col - 1
    col_right = col + 1
    possible_moves = []

    new_row =
      case curr_color do
        :red    -> (row + 1)
        :black  -> (row - 1)
      end

    if (new_row == -1 or new_row == 8) do
      possible_moves
    end

    left_moves =
      case col_left do
        -1 -> []
        _ -> det_poss_moves(board, new_row, col_left, curr_color, -1) ++ possible_moves
      end

    right_moves =
      case col_right do
        8 -> []
        _ -> det_poss_moves(board, new_row, col_right, curr_color, 1) ++ possible_moves
      end
    IO.inspect(left_moves)
    IO.inspect(right_moves)
    left_moves ++ right_moves
  end

  # TODO: write this function
  defp valid_move(agent, origin = {row_or, col_or}, dest = {row_dest, col_dest}, player) do
    board = Agent.get(agent, fn (state) -> Map.get(state, :board) end)
    # init booleans in order to have a move
    our_tile? = Map.get(board, row_or) |> Map.get(col_or) |> Map.get(:color) == player
    next_empty_tile? = Map.get(board, row_dest) |> Map.get(col_dest) |> Map.get(:color) == :none
    legal_tile? = Map.get(board, row_dest) |> Map.get(col_dest) |> Map.get(:tile) == :playable
    # our_turn? = Agent.get(agent, fn(state) -> Map.get(state, :turn) end) == player

    if (our_tile? and next_empty_tile? and legal_tile? ) do
      possible_moves = get_poss_locations(board, origin)
      (length(possible_moves) > 0) and (dest in possible_moves)
    else
      false
    end
  end

  # from: (row, col)
  # to:   (row, col)
  def move_checker(agent, origin, dest, player) do
    if (valid_move(agent, origin, dest, player)) do
      update_board(agent, origin, dest)
    end
  end

  # TODO: delete the checker we are possibly jumping over
  # update the board when we have a valid move
  defp update_board(agent, origin = {row_or, col_or}, dest = {row_dest, col_dest}) do
    board = Agent.get(agent, fn(state) -> Map.get(state, :board) end)
    origin_data = get_tile_data(board, origin)
    dest_data = get_tile_data(board, dest)

    # row_diff = abs(row_or - row_dest)
    # col_diff = abs(col_or - col_dest)
    # if (row_diff > 1 and col_diff > 1) do

    # end

    row = Map.get(board, row_dest)
    row = Map.put(row, col_dest, origin_data)
    board = Map.put(board, row_dest, row)

    row = Map.get(board, row_or)
    row = Map.put(row, col_or, dest_data)
    board = Map.put(board, row_or, row)

    Agent.update(agent, fn(state) -> Map.put(state, :board, board) end)
    # next_moves = get_poss_locations(board, dest)

    # if Enum.empty?(next_moves) do
    #   if (Agent.get(agent, fn(state) -> Map.get(state, :turn) end) == :red) do
    #     Agent.update(agent, fn(state) -> Map.put(state, :turn, :black) end)
    #   else
    #     Agent.update(agent, fn(state) -> Map.put(state, :turn, :red) end)
    #   end
    # end
  end


  ####### Building board functions #######
  defp det_checker(row_num) do
    cond do
      row_num < 3 -> :red
      row_num > 4 -> :black
      true        -> :none
    end
  end

  defp init_row_with_checkers(color, row) do
    Enum.into(0..7, [], fn k ->
      if ((rem(k, 2) == 0 and row == 1) or (rem(k, 2) == 1 and row == 0)) do
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
