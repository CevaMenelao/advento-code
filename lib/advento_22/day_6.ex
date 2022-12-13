defmodule Advento.Day6 do
  def file, do: "/Users/luisenriqueaguilar/Private/Adviento2022/inputs/6/input.txt"
  def file_test, do: "/Users/luisenriqueaguilar/Private/Adviento2022/inputs/6/input_test.txt"

  # Advientum6.result Advientum6.file
  # Advientum6.result Advientum6.file_test
  #
  # Advientum6.result_2 Advientum6.file
  # Advientum6.result_2 Advientum6.file_test

  def result(input) do
    input
    |> read_file()
    |> Enum.map(fn s ->
      v = String.codepoints(s)
      get_marker(0, [], v) |> IO.inspect(label: "result")
    end)
  end

  def result_2(input) do
    input
    |> read_file()
    |> Enum.map(fn s ->
      v = String.codepoints(s)
      get_marker_2(0, [], v) |> IO.inspect(label: "result")
    end)
  end

  defp get_marker_2(m, _, []), do: m

  defp get_marker_2(m, list, [v | buffer]) do
    new_list =
      if length(list) == 14 do
        [v | Enum.drop(list, -1)]
      else
        [v | list]
      end

    IO.inspect({m, new_list, v})

    if check_all_diff(new_list) and length(new_list) == 14 do
      m + 1
    else
      get_marker_2(m + 1, new_list, buffer)
    end
  end

  defp get_marker(m, _, []), do: m

  defp get_marker(m, list, [v | buffer]) do
    new_list =
      if length(list) == 4 do
        [v | Enum.drop(list, -1)]
      else
        [v | list]
      end

    IO.inspect({m, new_list, v})

    if check_all_diff(new_list) and length(new_list) == 4 do
      m + 1
    else
      get_marker(m + 1, new_list, buffer)
    end
  end

  defp check_all_diff([]), do: true

  defp check_all_diff([v | l]) do
    if Enum.any?(l, fn le -> le == v end) do
      false
    else
      check_all_diff(l)
    end
  end

  # defp get_marker(m, list, [v | buffer]) when length(list) == 3, do: m + 1

  # defp get_marker(m, list, [v | buffer]), do: get_marker(m + 1, [m | list], buffer)
  #   new_list = [m | list]

  #   if length(new_list) == 4 do
  #     m + 1
  #   else
  #     get_marker(m + 1, new_list, buffer)
  #   end
  # end

  defp read_file(file_name_c) do
    content =
      file_name_c
      |> File.read!()
      |> String.split("\n")

    {result, _} = Enum.split(content, length(content) - 1)
    result
  end
end
