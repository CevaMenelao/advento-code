defmodule Advento.Day7 do
  defp file, do: "inputs/advento_22/7/input.txt"
  defp file_test, do: "inputs/advento_22/7/input_test.txt"

  def try_day(), do: result(file)
  def try_day_test(), do: result(file_test)

  def try_day_2(), do: result_2(file)
  def try_day_test_2(), do: result_2(file_test)

  def result(input) do
    inputs =
      input
      |> read_file()
      |> Enum.map(&String.split(&1, " "))

    "/"
    |> make_new_dir()
    |> make_tree(inputs)
    |> put_sizes()
    |> IO.inspect(label: "Tree")
    |> find_size_less(100_000)
  end

  def result_2(input) do
    inputs =
      input
      |> read_file()
      |> Enum.map(&String.split(&1, " "))

    tree =
      "/"
      |> make_new_dir()
      |> make_tree(inputs)
      |> put_sizes()
      |> IO.inspect(label: "Tree")

    tree
    |> find_size_less_2(70_000_000 - Map.get(tree, :size), 30_000_000)
    |> reduce_response()
    # |> Enum.reduce([], fn {_, _} = r -> r end)
    |> Enum.reduce({70_000_000, ""}, fn
      {s, _n} = r, {accs, _accn} = acc ->
      if s < accs do
        r
      else
        acc
      end
      _r, acc -> acc
    end)
  end

  defp reduce_response([]), do: []
  defp reduce_response([[]]), do: []
  defp reduce_response([[] | vs]), do: reduce_response(vs)
  defp reduce_response([{_, _} = v | vs]), do: [v | reduce_response(vs)]
  defp reduce_response([[_ | _] = v | vs]), do: reduce_response(v) ++ reduce_response(vs)

  defp make_tree(tree, []), do: tree

  defp make_tree(tree, [["$" | comand] | inputs]) do
    case comand do
      ["cd", ".."] ->
        tree

      ["cd", name_dir] ->
        dir = Map.get(tree, name_dir, make_new_dir(name_dir))

        {_, until_command_back, next_inputs} =
          Enum.reduce(inputs, {1, [], []}, fn
            c, {0, l, r} -> {0, l, r ++ [c]}
            ["$", "cd", ".."] = c, {v, l, r} -> {v - 1, l ++ [c], r}
            ["$", "cd", _dir] = c, {v, l, r} -> {v + 1, l ++ [c], r}
            c, {v, l, r} -> {v, l ++ [c], r}
          end)

        new_tree = make_tree(dir, until_command_back)

        tree
        |> Map.update(:dirs, [new_tree], fn e -> [new_tree | e] end)
        |> make_tree(next_inputs)

      ["ls"] ->
        {until_command, next_inputs} = split_until_command(inputs)

        {new_dirs, new_files} =
          Enum.reduce(until_command, {[], []}, fn
            ["dir", name_dir], {dirs, files} ->
              {[make_new_dir(name_dir) | dirs], files}

            [fiel_size, name_file], {dirs, files} ->
              {dirs, [{String.to_integer(fiel_size), name_file} | files]}
          end)

        tree
        |> Map.put(:files, new_files)
        # |> Map.put(:dirs, new_dirs)
        |> make_tree(next_inputs)
    end
  end

  defp make_new_dir(name_dir), do: %{name_dir: name_dir, dirs: [], files: []}

  def split_until_command([]), do: {[], []}
  def split_until_command([["$" | _comand] | _inputs] = inputs), do: {[], inputs}

  def split_until_command([input | inputs]) do
    {no_commands, inputs_search} = split_until_command(inputs)
    {[input | no_commands], inputs_search}
  end

  defp put_sizes([]), do: []

  defp put_sizes(%{name_dir: name_dir, dirs: [], files: files} = tree) do
    files_size = Enum.reduce(files, 0, fn {size, _file_name}, acc -> acc + size end)
    Map.put(tree, :size, files_size)
  end

  defp put_sizes(%{name_dir: name_dir, dirs: dirs, files: files} = tree) do
    files_size = Enum.reduce(files, 0, fn {size, _file_name}, acc -> acc + size end)
    new_dirs = Enum.map(dirs, &put_sizes/1)

    tree
    |> Map.put(:dirs, new_dirs)
    |> Map.put(
      :size,
      files_size + Enum.reduce(new_dirs, 0, fn %{size: size}, acc -> size + acc end)
    )
  end

  defp find_size_less(nil, _), do: nil
  defp find_size_less([], _), do: nil

  defp find_size_less(%{name_dir: name_dir, dirs: dirs, size: size}, top) do
    sizes =
      dirs
      |> Enum.map(&find_size_less(&1, top))
      |> Enum.sum()

    if size < top do
      IO.inspect(name_dir)
      size + sizes
    else
      sizes
    end
  end

  defp find_size_less_2([], _, _), do: 0

  defp find_size_less_2(%{name_dir: name_dir, dirs: dirs, size: size}, used, min) do
    sizes =
      case dirs do
        [] -> []
        _ -> Enum.map(dirs, &find_size_less_2(&1, used, min))
      end

    # sizes = Enum.map(dirs, &find_size_less_2(&1, used, min))
    # IO.inspect(name_dir)

    # IO.inspect(used, label: "used")
    # IO.inspect(min, label: "min")
    # IO.inspect(size, label: "size")
    # IO.inspect(size, label: "sizes")

    # IO.inspect(used - size, label: "resta")

    # IO.inspect(used - size)
    if used + size > min do
      [{size, name_dir} | sizes]
    else
      sizes
    end
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
