defmodule Advento.Day1 do
  # file_1 = File.read!("/Users/luisenriqueaguilar/Private/Adviento2022/inputs/1/input.txt")

  # file_1_test =
  #   File.read!("/Users/luisenriqueaguilar/Private/Adviento2022/inputs/1/input_test.txt")

  # String.split(file_1_test, "\n")

  def get_bigest(name_file) do
    {_, biggest} =
      name_file
      |> File.read!()
      |> String.split("\n")
      |> Enum.reduce({0, 0}, fn c, {acc, bigest} ->
        case c do
          "" ->
            return_bigest({acc, bigest})

          s ->
            {v, _} = Integer.parse(s)
            {acc + v, bigest}
        end
      end)

    biggest
  end

  defp return_bigest({acc, bigest}) when acc > bigest, do: {0, acc}

  defp return_bigest({_acc, bigest}), do: {0, bigest}







  def get_bigest_part_2(name_file) do
    {_, bigest1, bigest2, bigest3} =
      name_file
      |> File.read!()
      |> String.split("\n")
      |> Enum.reduce({0, 0, 0, 0}, fn c, {acc, bigest1, bigest2, bigest3} ->
        case c do
          "" ->
            {b1, b2, b3} = return_bigest_2({acc, bigest1, bigest2, bigest3})
            [bs1, bs2, bs3] = Enum.sort([b1, b2, b3])
            {0, bs1, bs2, bs3}

          s ->
            {v, _} = Integer.parse(s)
            {acc + v, bigest1, bigest2, bigest3}
        end
      end)

    {bigest1 + bigest2 + bigest3, bigest1, bigest2, bigest3}
  end

  defp return_bigest_2({acc, bigest1, bigest2, bigest3}) when acc > bigest1,
    do: {acc, bigest2, bigest3}

  defp return_bigest_2({acc, bigest1, bigest2, bigest3}) when acc > bigest2,
    do: {bigest1, acc, bigest3}

  defp return_bigest_2({acc, bigest1, bigest2, bigest3}) when acc > bigest3,
    do: {bigest1, bigest2, acc}

  defp return_bigest_2({acc, bigest1, bigest2, bigest3}), do: {bigest1, bigest2, bigest3}
end
