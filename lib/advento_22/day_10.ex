defmodule Advento.Day10 do
  defp file, do: "inputs/advento_22/10/input.txt"
  defp file_test, do: "inputs/advento_22/10/input_test.txt"
  # defp file_test_2, do: "inputs/advento_22/10/input_test_2.txt"

  def try_day(), do: result(file)
  def try_day_test(), do: result(file_test)

  def try_day_2(), do: result_2(file)
  def try_day_test_2(), do: result_2(file_test)

  defp inisilize(), do: {0, 1, []}
  # defp inisilize_2(), do: {Enum.map(0..9, fn _ -> {0, 0} end), [{0, 0}]}

  defp result(input) do
    # {_, _, res} =
    {_, _, result} =
      input
      |> read_file()
      |> Enum.map(&String.split(&1, " "))
      |> make_program(inisilize())

    result
    |> uniq()
    |> IO.inspect()
    |> Enum.reduce(0, fn {x,c}, acc -> acc + x * c end)

    # |> Enum.map(fn [m, n] -> [m, String.to_integer(n)] end)
    # |> simulate_steps(inisilize())
    # |> IO.inspect(label: "response")

    # res
    # |> uniq()
    # |> length()
  end

  defp result_2(input) do
  end

  defp make_program([], r), do: r

  defp make_program([["noop"] | inscructions], {cycles, x, list}) do
    new_cycles = cycles + 1

    new_list =
      if rem(new_cycles, 40) == 20 do
        # IO.inspect(new_cycles, label: "new_cycles")
        [{x, 20 * Integer.floor_div(new_cycles, 20)} | list]
      else
        list
      end

    make_program(inscructions, {new_cycles, x, new_list})
  end

  defp make_program([["addx", num] | inscructions], {cycles, x, list} = r) do
    new_cycles = cycles + 2
    new_value = x + String.to_integer(num)

    new_list =
      if Enum.any?(cycles+1..new_cycles, fn c -> rem(c, 40) == 20 end) do
        [{x, 20 * Integer.floor_div(new_cycles, 20)} | list]
      else
        list
      end

    # IO.inspect(r, label: "recieve")
    # IO.inspect({cycles + 2, new_value, new_list}, label: "response")
    make_program(inscructions, {cycles + 2, new_value, new_list})
  end

  def uniq([]), do: []

  def uniq([{x1, y1} = head | tail]) do
    [head | for({x2, y2} = r <- uniq(tail), x1 != x2 or y1 != y2, do: r)]
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
