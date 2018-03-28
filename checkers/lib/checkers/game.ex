defmodule Checkers.Game do
  use Agent

  def start_link(name) do
    b = new_game()
    Agent.start_link(fn ->
      %{name: name, board: b, player1: nil, player2: nil, turn: :red}
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
      player2: Map.get(state, :player2),
      turn: Map.get(state, :turn)
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
          new_color = Map.get(board, next_row) |> Map.get(new_col) |> Map.get(:color)
          if new_color == :none do
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
    else
      IO.inspect(new_row)
      IO.inspect (col_left)
      IO.inspect(col_right)

      left_moves =
        case col_left do
          -1 -> []
          _ -> det_poss_moves(board, new_row, col_left, curr_color, -1) #++ possible_moves
        end

      right_moves =
        case col_right do
          8 -> []
          _ -> det_poss_moves(board, new_row, col_right, curr_color, 1) #++ possible_moves
        end

      possible_moves = left_moves ++ right_moves
      IO.inspect possible_moves
      possible_moves
    end

  end

  # TODO: write this function
  defp valid_move(agent, origin = {row_or, col_or}, dest = {row_dest, col_dest}, player) do
    board = Agent.get(agent, fn (state) -> Map.get(state, :board) end)
    # init booleans in order to have a move
    our_tile? = Map.get(board, row_or) |> Map.get(col_or) |> Map.get(:color) == player
    next_empty_tile? = Map.get(board, row_dest) |> Map.get(col_dest) |> Map.get(:color) == :none
    legal_tile? = Map.get(board, row_dest) |> Map.get(col_dest) |> Map.get(:tile) == :playable
    our_turn? = Agent.get(agent, fn(state) -> Map.get(state, :turn) end) == player

    if (our_tile? and next_empty_tile? and legal_tile? and our_turn?) do
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
      update_board(agent, origin, dest, player)
    end
  end

  # TODO: delete the checker we are possibly jumping over
  # update the board when we have a valid move
  defp update_board(agent, origin = {row_or, col_or}, dest = {row_dest, col_dest}, player) do
    board = Agent.get(agent, fn(state) -> Map.get(state, :board) end)
    origin_data = get_tile_data(board, origin)
    dest_data = get_tile_data(board, dest)

    row_diff = row_or - row_dest
    col_diff = col_or - col_dest


    if (abs(row_diff) == 2 and abs(col_diff) == 2) do
      row_to_skip = trunc(row_or - (row_diff / 2))
      col_to_skip = trunc(col_or - (col_diff / 2))

      row = Map.get(board, row_to_skip) |> Map.put(col_to_skip, dest_data)
      board = Map.put(board, row_to_skip, row)

      row = Map.get(board, row_dest) |> Map.put(col_dest, origin_data)
      board = Map.put(board, row_dest, row)

      row = Map.get(board, row_or) |> Map.put(col_or, dest_data)
      board = Map.put(board, row_or, row)

      Agent.update(agent, fn(state) -> Map.put(state, :board, board) end)
      Agent.update(agent, fn(state) ->
        player1 = Map.get(state, :player1)
        player2 = Map.get(state, :player2)
        origin_color = Map.get(origin_data, :color)
        if player1 |> Map.get(:color) == origin_color do
          player1_score = player1 |> Map.get(:score)
          Map.put(state, :player1, %{color: :red, score: player1_score+1})
        else
          player2_score = player2 |> Map.get(:score)
          Map.put(state, :player2, %{color: :red, score: player2_score+1})
        end
      end)

      IO.inspect dest
      possible_moves = get_poss_locations(board, dest)
      if Enum.empty?(possible_moves) do
        if (Agent.get(agent, fn(state) -> Map.get(state, :turn) end) == :red) do
          Agent.update(agent, fn(state) -> Map.put(state, :turn, :black) end)
        else
          Agent.update(agent, fn(state) -> Map.put(state, :turn, :red) end)
        end
      end

    else
      row = Map.get(board, row_dest) |> Map.put(col_dest, origin_data)
      board = Map.put(board, row_dest, row)

      row = Map.get(board, row_or) |> Map.put(col_or, dest_data)
      board = Map.put(board, row_or, row)

      Agent.update(agent, fn(state) -> Map.put(state, :board, board) end)

      if (Agent.get(agent, fn(state) -> Map.get(state, :turn) end) == :red) do
        Agent.update(agent, fn(state) -> Map.put(state, :turn, :black) end)
      else
        Agent.update(agent, fn(state) -> Map.put(state, :turn, :red) end)
      end
    end
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
