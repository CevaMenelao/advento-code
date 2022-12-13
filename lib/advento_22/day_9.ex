defmodule Advento.Day9 do
  defp file, do: "inputs/advento_22/9/input.txt"
  defp file_test, do: "inputs/advento_22/9/input_test.txt"
  defp file_test_2, do: "inputs/advento_22/9/input_test_2.txt"

  def try_day(), do: result(file)
  def try_day_test(), do: result(file_test)

  def try_day_2(), do: result_2(file)
  def try_day_test_2(), do: result_2(file_test_2)

  defp inisilize(), do: {{0, 0}, {0, 0}, [{0, 0}]}
  defp inisilize_2(), do: {Enum.map(0..9, fn _ -> {0, 0} end), [{0, 0}]}

  def result(input) do
    {_, _, res} =
      input
      |> read_file()
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(fn [m, n] -> [m, String.to_integer(n)] end)
      |> simulate_steps(inisilize())
      |> IO.inspect(label: "response")

    res
    |> uniq()
    |> length()
  end

  def result_2(input) do
    {_, res} =
      input
      |> read_file()
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(fn [m, n] -> [m, String.to_integer(n)] end)
      |> simulate_steps_2(inisilize_2())
      # |> IO.inspect(label: "response")

    print_tab(res)

    res
    |> uniq()
    |> length()
  end

  defp simulate_steps_2([], r, _), do: r

  defp simulate_steps_2(_, {[tail], tail_steps}, _), do: {[tail], [tail | tail_steps]}

  defp simulate_steps_2(
         [[_mov, num] = current_step | steps],
         {[knot_1 | [knot_2 | knots]], tail_steps},
         need_actualize \\ true
       ) do
    {new_knot_1, step} =
      if need_actualize do
        update_head(current_step, knot_1)
      else
        {knot_1, nil}
      end

    [new_mov, _] =
      new_step =
      if !different_coords?(knot_1, new_knot_1) do
        [calculate_mov(knot_1, knot_2), num]
      else
        current_step
      end

    new_knot_2 = update_tail(new_step, new_knot_1, knot_2)

    more_steps =
      case step do
        nil ->
          steps

        _ ->
          [step | steps]
      end

    # IO.inspect("#{inspect(knot_1)}->#{inspect(new_knot_1)}", label: "knot_#{7 - length(knots)}")
    # IO.inspect("#{inspect(knot_2)}->#{inspect(new_knot_2)}", label: "knot_#{8 - length(knots)}")
    # IO.inspect("--------")

    {tail, new_tail_steps} =
      if different_coords?(knot_2, new_knot_2) do
        simulate_steps_2(
          [[new_mov, 1]],
          {[new_knot_2 | knots], tail_steps},
          false
        )
      else
        {[new_knot_2 | knots], tail_steps}
      end

    # if length(knots) == 7 and is_nil(step) do
    #   IO.inspect([new_knot_1 | tail], label: "full_knots")
    # end

    simulate_steps_2(more_steps, {[new_knot_1 | tail], new_tail_steps})
  end

  defp calculate_mov({x1, y1} = c1, {x2, y2} = c2) do

    if abs(x1 - x2) > abs(y1 - y2) do
      if x1 > x2 do
        "R"
      else
        "L"
      end
    else
      if y1 > y2 do
        "U"
      else
        "D"
      end
    end
  end

  defp simulate_steps([], r), do: r

  defp simulate_steps([current_step | steps], {head, tail, tail_steps}) do
    {new_head, step} = update_head(current_step, head)
    # IO.inspect(tail, labe: "tai")
    new_tail = update_tail(current_step, new_head, tail)

    more_steps =
      case step do
        nil -> steps
        _ -> [step | steps]
      end

    IO.inspect(new_head, label: "H")
    IO.inspect(new_tail, label: "T")
    IO.inspect("--------")
    simulate_steps(more_steps, {new_head, new_tail, [new_tail | tail_steps]})
  end

  defp update_tail([mov, _], {x1, y1}, {x2, y2} = tail) do
    if abs(x1 - x2) > 1 or abs(y1 - y2) > 1 do
      if abs(x1 - x2) == 2 and abs(y1 - y2) == 2 do
        move_diagonal({x1, y1}, {x2, y2})
      else
        move_tail(mov, {x1, y1})
      end
    else
      tail
    end
  end

  defp move_diagonal({x1, y1}, {x2, y2}) do
    cond do
      x1 > x2 and y1 > y2 -> {x1 - 1, y1 - 1}
      x1 > x2 and y1 < y2 -> {x1 - 1, y1 + 1}
      x1 < x2 and y1 > y2 -> {x1 + 1, y1 - 1}
      true -> {x1 + 1, y1 + 1}
    end
  end

  defp update_head([mov, 1], pos), do: {move(mov, pos), nil}

  defp update_head([mov, num], pos), do: {move(mov, pos), [mov, num - 1]}

  defp move("U", {x, y}), do: {x, y + 1}
  defp move("D", {x, y}), do: {x, y - 1}
  defp move("R", {x, y}), do: {x + 1, y}
  defp move("L", {x, y}), do: {x - 1, y}

  defp move_tail("U", {x, y}), do: {x, y - 1}
  defp move_tail("D", {x, y}), do: {x, y + 1}
  defp move_tail("R", {x, y}), do: {x - 1, y}
  defp move_tail("L", {x, y}), do: {x + 1, y}

  defp print_tab(res) do
    xs = Enum.map(res, fn {x,_} -> x end)
    ys = Enum.map(res, fn {_,y} -> y end)
    Enum.map(Enum.max(ys)..Enum.min(ys), fn iy ->
      Enum.reduce(Enum.min(xs)..Enum.max(xs), "", fn ix , acc ->
        acc <> if {ix, iy} in res do
	        "#"
          else
            "."
        end
      end) |> IO.inspect()
    end)
  end

  def uniq([]), do: []

  def uniq([{x1, y1} = head | tail]) do
    [head | for({x2, y2} = r <- uniq(tail), x1 != x2 or y1 != y2, do: r)]
  end

  defp different_coords?({x1, y1}, {x2, y2}), do: x1 != x2 or y1 != y2

  defp read_file(file_name_c) do
    content =
      file_name_c
      |> File.read!()
      |> String.split("\n")

    {result, _} = Enum.split(content, length(content) - 1)
    result
  end
end
