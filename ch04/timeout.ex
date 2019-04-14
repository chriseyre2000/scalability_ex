defmodule Timeout do
  use GenServer

  def init(_args), do: {:ok, :undefined}

  def handle_call({:sleep, ms}, _from, loop_data) do
    :timer.sleep(ms)
    {:reply, :ok, loop_data}
  end
end