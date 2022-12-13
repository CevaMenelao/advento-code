defmodule Advento.Day8 do
  defp file, do: "inputs/advento_22/8/input.txt"
  defp file_test, do: "inputs/advento_22/8/input_test.txt"

  def try_day(), do: result(file)
  def try_day_test(), do: result(file_test)

  def try_day_2(), do: result_2(file)
  def try_day_test_2(), do: result_2(file_test)

  def result(input) do
    input =
      input
      |> read_file()
      |> Enum.map(&String.codepoints(&1))
      |> Enum.map(fn r -> Enum.map(r, fn c -> {String.to_integer(c), false, false} end) end)

    horizontal =
      input
      |> Enum.map(&check_row/1)

    # |> IO.inspect(label: "Horizontal")

    vertical =
      input
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)
      # |> Enum.zip_with(& &1)
      |> Enum.map(&check_row/1)
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)

    # |> IO.inspect(label: "Vewrtical")

    Enum.map(0..(length(input) - 1), fn i ->
      row_h = Enum.at(horizontal, i, [])
      row_v = Enum.at(vertical, i, [])
      row_input = Enum.at(input, i, [])

      Enum.map(0..(length(input) - 1), fn i2 ->
        h = Enum.at(row_h, i2, true)
        v = Enum.at(row_v, i2, true)
        # imp = Enum.at(row_input, i2, "?")
        h || v
      end)
      |> Enum.filter(& &1)
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  def result_2(input) do
    input =
      input
      |> read_file()
      |> Enum.map(&String.codepoints(&1))
      |> Enum.map(fn r -> Enum.map(r, fn c -> String.to_integer(c) end) end)

    horizontal =
      input
      |> Enum.map(&check_row_2/1)

    vertical =
      input
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&check_row_2/1)
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)

    Enum.map(0..(length(input) - 1), fn i ->
      row_h = Enum.at(horizontal, i, [])
      row_v = Enum.at(vertical, i, [])
      # row_input = Enum.at(input, i, [])

      Enum.map(0..(length(input) - 1), fn i2 ->
        h = Enum.at(row_h, i2, 0)
        v = Enum.at(row_v, i2, 0)

        h * v
      end)

      |> Enum.max()
    end)
    |> Enum.max()
  end

  defp check_row_2(row) do
    row
    |> Enum.with_index()
    |> Enum.map(fn {value, index} ->
      {l, r} = Enum.split(row, index)
      {_, r} = Enum.split(r, 1)
      get_num_trees(r, value) * get_num_trees(Enum.reverse(l), value)
    end)
  end

  def get_num_trees([], _max), do: 0

  def get_num_trees([tree | _trees], max) when tree == max, do: 1
  def get_num_trees([tree | _trees], max) when tree > max, do: 1
  def get_num_trees([tree | trees], max) do
    if tree < max do
      1 + get_num_trees(trees, max)
    else
      0
    end
  end

  defp check_row(row) do
    row
    |> Enum.with_index()
    |> Enum.map(fn {value, index} ->
      {l, r} = Enum.split(row, index)
      {_, r} = Enum.split(r, 1)
      Enum.all?(r, fn a -> a < value end) || Enum.all?(l, fn a -> a < value end)
    end)
  end

  defp read_file(file_name_c) do
    content =
      file_name_c
      |> File.read!()
      |> String.split("\n")

    {result, _} = Enum.split(content, length(content) - 1)
    result
  end
end
