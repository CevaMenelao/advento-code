defmodule Advento.Day4 do
  def file_name, do: "/Users/luisenriqueaguilar/Private/Adviento2022/inputs/4/input.txt"
  def file_name_test, do: "/Users/luisenriqueaguilar/Private/Adviento2022/inputs/4/input_test.txt"

  def find_overlap(file_name_check) do
    file_name_check
    |> read_file()
    |> Enum.map(&split_input_elfs/1)
    |> Enum.map(&check_full_overlap/1)
    |> Enum.filter(& &1)
    |> length()
  end

  def find_overlap_2(file_name_check) do
    file_name_check
    |> read_file()
    |> Enum.map(&split_input_elfs/1)
    |> Enum.map(&check_full_overlap_2/1)
    |> Enum.filter(& &1)
    |> length()
  end

  defp check_full_overlap_2([{e1v1, e1v2}, {e2v1, e2v2}]) do
    ret1 = Enum.any?(e1v1..e1v2, fn v -> v in e2v1..e2v2 end)

    ret2 = Enum.any?(e2v1..e2v2, fn v -> v in e1v1..e1v2 end)

    IO.inspect("#{e1v1}-#{e1v2}, #{e2v1}-#{e2v2} : #{ret1} - #{ret2}")
    ret1 || ret2
    # [{e1v1, e1v2}, {e2v1, e2v2}, ret]
  end

  defp check_full_overlap_2(_), do: false

  defp check_full_overlap([{e1v1, e1v2}, {e2v1, e2v2}] = inp) do
    ret1 =
      if e1v1 <= e2v1 do
        e1v2 >= e2v2
      else
        e1v2 <= e2v2
      end

    ret2 =
      if e2v1 <= e1v1 do
        e2v2 >= e1v2
      else
        e2v2 <= e1v2
      end

    IO.inspect("#{e1v1}-#{e1v2}, #{e2v1}-#{e2v2} : #{ret1} - #{ret2}")
    ret1 || ret2
    # [{e1v1, e1v2}, {e2v1, e2v2}, ret]
  end

  defp check_full_overlap(_), do: false

  defp split_input_elfs(""), do: []

  defp split_input_elfs(s) do
    s
    |> String.split(",")
    |> Enum.map(fn s ->
      [s1, s2] = String.split(s, "-")
      {String.to_integer(s1), String.to_integer(s2)}
    end)
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
