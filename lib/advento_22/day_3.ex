defmodule Advento.Day3 do
  file_name = "/Users/luisenriqueaguilar/Private/Adviento2022/inputs/3/input.txt"
  file_name_test = "/Users/luisenriqueaguilar/Private/Adviento2022/inputs/3/input_test.txt"

  # Advientum3.get_priority_values_part_2 file_name_test
  # Advientum3.g file_name_test
  #

  defp read_file(file_name_c) do
    file_name_c
    |> File.read!()
    |> String.split("\n")
  end

  def get_priority_values_part_2(file_name_check) do
    file_name_check
    |> read_file()
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&Enum.sort/1)
    |> Enum.chunk_every(3)
    |> Enum.map(fn
      [[]] ->
        0

      [e1, e2, e3] ->
        e1
        |> find_sames(e2)
        |> find_sames(e3)
        |> hd()
        |> get_value()
    end)
    # |> Enum.sum()
  end

  def get_priority_values(file_name_check) do
    file_name_check
    |> read_file()
    |> Enum.map(fn s ->
      mochila = String.codepoints(s)

      mitad = Integer.floor_div(length(mochila), 2)
      {bolsa_iz, bolsa_de} = Enum.split(mochila, mitad)
      mismo = find_same(bolsa_iz, bolsa_de)
      get_value(mismo)
    end)
    |> Enum.sum()
  end

  def find_same([], _), do: 0

  def find_same([valor | cola], compara) do
    case Enum.find(compara, fn c -> valor == c end) do
      nil -> find_same(cola, compara)
      encontrado -> encontrado
    end
  end

  def find_sames(list1, list2) do
    Enum.filter(list1, fn l1 -> Enum.any?(list2, fn l2 -> l1 == l2 end) end)
  end

  def get_value(<<v>>) when v > 96, do: v - 96
  def get_value(<<v>>), do: v - 38
  def get_value(_), do: 0
end
