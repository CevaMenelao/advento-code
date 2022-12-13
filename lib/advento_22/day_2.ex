defmodule Advento.Day2 do
  file_name = "/Users/luisenriqueaguilar/Private/Adviento2022/inputs/2/input.txt"
  file_name_test = "/Users/luisenriqueaguilar/Private/Adviento2022/inputs/2/input_test.txt"

  # Advientum2.get_puntuation file_name_test
  # Advientum2.get_puntuation_part_2 file_name_test

  # A for Rock
  # B for Paper
  # C for Scissors
  #
  # X for Rock + 1
  # Y for Paper + 2
  # Z for Scissors + 3
  #
  # X lose -> 0
  # Y draw -> 3
  # Z win -> 6

  def get_puntuation(file_name_check) do
    file_name_check
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn
      "" ->
        {"A", "P"}

      s ->
        [r, m] = String.split(s)
        {r, m}
    end)
    |> Enum.map(fn {r, m} -> math_result({r, m}) + use_tool(m) end)
    |> Enum.sum()
  end

  def get_puntuation_part_2(file_name_check) do
    file_name_check
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn
      "" ->
        {"W", "P"}

      s ->
        [r, m] = String.split(s)
        {r, m}
    end)
    |> Enum.map(fn {r, m} ->
      result = math_result_part_2({r, m})
      result + replace_players_part_2({r, result})
    end)
    |> Enum.sum()
  end

  def use_tool("X"), do: 1
  def use_tool("Y"), do: 2
  def use_tool("Z"), do: 3
  def use_tool(_), do: 0

  def use_tool_part_2("A"), do: 1
  def use_tool_part_2("B"), do: 2
  def use_tool_part_2("C"), do: 3
  def use_tool(_), do: 0

  def math_result({"C", "X"}), do: 6
  def math_result({"A", "Y"}), do: 6
  def math_result({"B", "Z"}), do: 6

  def math_result_part_2({_, "X"}), do: 0
  def math_result_part_2({_, "Y"}), do: 3
  def math_result_part_2({_, "Z"}), do: 6
  def math_result_part_2(_), do: 0

  def math_result({r, m}) do
    if replace_players(r) == m do
      3
    else
      0
    end
  end

  # def math_result({r,m}), do: !math_result({replace_players(m), replace_players(r)})

  def replace_players("A"), do: "X"
  def replace_players("B"), do: "Y"
  def replace_players("C"), do: "Z"

  def replace_players_part_2({"A", 6}), do: 2
  def replace_players_part_2({"A", 3}), do: 1
  def replace_players_part_2({"A", 0}), do: 3

  def replace_players_part_2({"B", 6}), do: 3
  def replace_players_part_2({"B", 3}), do: 2
  def replace_players_part_2({"B", 0}), do: 1

  def replace_players_part_2({"C", 6}), do: 1
  def replace_players_part_2({"C", 3}), do: 3
  def replace_players_part_2({"C", 0}), do: 2

  def replace_players_part_2(_), do: 0
end
