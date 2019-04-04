defmodule Ex2 do

  def print_all([]), do: :io.format("~n")
  def print_all([h|t]) do
    :io.format("~p\t", [h])
    print_all(t)
  end 

end
