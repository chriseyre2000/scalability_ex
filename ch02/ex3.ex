defmodule Ex3 do
  def filter(_f,[]), do: []
  def filter(f, [h|t]) do 
    case f.(h) do 
      true -> [h| filter(f, t)]
      false -> filter(f, t)
    end
  end

  def even?(n), do: rem(n,2) == 0
end
