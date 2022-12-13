defmodule Advento.Day5 do
  def file_name, do: "/Users/luisenriqueaguilar/Private/Adviento2022/inputs/5/input.txt"
  def file_moves, do: "/Users/luisenriqueaguilar/Private/Adviento2022/inputs/5/moves.txt"
  def file_name_test, do: "/Users/luisenriqueaguilar/Private/Adviento2022/inputs/5/input_test.txt"

  def test_moves, do: "/Users/luisenriqueaguilar/Private/Adviento2022/inputs/5/test_moves.txt"

  def test_input,
    do: "/Users/luisenriqueaguilar/Private/Adviento2022/inputs/5/input_test_filtered.txt"

  # file_name_test_filtered =  "/Users/luisenriqueaguilar/Private/Adviento2022/inputs/5/input_test_filtered.txt"

  # Advientum5.result_2 Advientum5.test_input, Advientum5.test_moves
  # Advientum5.result_2 Advientum5.file_name, Advientum5.file_moves


  def result(input, moves) do
    moves =
      moves
      |> read_file()
      |> Enum.map(&get_moves/1)
      |> Enum.reject(&is_nil/1)

    # |> IO.inspect(label: "moves")

    input =
      input
      |> read_file()
      |> Enum.map(&String.split(&1, ","))
      |> Enum.reject(fn v -> v == [""] end)

    # |> IO.inspect(label: "inputs")

    floor = length(input) - 1

    inputs =
      Enum.reduce(0..floor, %{}, fn i, acc ->
        Map.put(acc, Integer.to_string(i + 1), Enum.at(input, i))
      end)

    # |> IO.inspect()

    do_moves(inputs, moves) |> get_result()
  end


  def result_2(input, moves) do
    moves =
      moves
      |> read_file()
      |> Enum.map(&get_moves/1)
      |> Enum.reject(&is_nil/1)

    # |> IO.inspect(label: "moves")

    input =
      input
      |> read_file()
      |> Enum.map(&String.split(&1, ","))
      |> Enum.reject(fn v -> v == [""] end)

    # |> IO.inspect(label: "inputs")

    floor = length(input) - 1

    inputs =
      Enum.reduce(0..floor, %{}, fn i, acc ->
        Map.put(acc, Integer.to_string(i + 1), Enum.at(input, i))
      end)

    # |> IO.inspect()

    do_moves_2(inputs, moves) |> get_result()
  end

  def do_moves_2(input, []), do: input

  def do_moves_2(input, [%{"move" => move, "from" => from, "to" => to} | moves]) do
    {move_from , stay_from} = Map.get(input, from) |> Enum.split(move)
    to_input = Map.get(input, to)

    updated_input =
      input
      |> Map.put(to, move_from ++ to_input )
      |> Map.put(from, stay_from)

    # IO.inspect(updated_input)
    do_moves_2(updated_input, moves)
  end

  # def do_moves_2(input, [_ | moves]), do: do_moves(input, moves)




  def do_moves(input, []), do: input

  def do_moves(input, [%{"move" => move, "from" => from, "to" => to} | moves]) when move > 0 do
    [hd_from | tail_from] = Map.get(input, from)
    to_input = Map.get(input, to)



    IO.inspect("from: #{from} to #{to}")
    updated_input =
      input
      |> IO.inspect()
      |> Map.put(to, [hd_from | to_input])
      |> Map.put(from, tail_from)
      |> IO.inspect()

    # IO.inspect(updated_input)
    do_moves(updated_input, [%{"move" => move - 1, "from" => from, "to" => to} | moves])
  end

  def do_moves(input, [_ | moves]), do: do_moves(input, moves)

  def get_result(result) do
    l = Map.keys(result) |> length() # |> Kernel.-(1)

    Enum.reduce(1..l, "", fn i, acc ->
      t = result |> Map.get(Integer.to_string(i)) |> Enum.at(0)

      acc <> t
    end)
  end

  def get_moves(""), do: nil

  def get_moves(s_m) do
    %{"move" => move_s, "from" => from, "to" => to} =
      Regex.named_captures(
        ~r/move (?<move>\w+) from (?<from>\w+) to (?<to>\w+)/,
        s_m
      )

    %{"move" => String.to_integer(move_s), "from" => from, "to" => to}
  end

  # defp split_ids(elf) do
  #   [id_1, id_2] =
  # end

  defp read_file(file_name_c) do
    file_name_c
    |> File.read!()
    |> String.split("\n")
  end
end
