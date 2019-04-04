defmodule Queens do
  def queens(0), do: [[]]

  def queens(n) do
    for columns <- queens(n - 1), 
        row <- [1,2,3,4,5,6,7,8] -- columns, 
        safe(row, columns, 1) do
      [row | columns] 
    end  
  end

  defp safe(_row, [], _n), do: true

  defp safe(row, [column|columns], n), do: (row != column + n) and ( row != column - n) and safe(row, columns, n + 1)
end