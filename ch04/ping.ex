defmodule Ping do
  @moduledoc """
   1> c "Ping.ex"
   2> GenServer.start_link(Ping, [], name: :ping)
   3> GenServer.call(:ping, :pause)
   4> GenServer.call(:ping, :start)
  """

  use GenServer

  @timeout 5000

  def init(_args), do: {:ok, :undefined, @timeout}

  def handle_call(:start, _from, loop_data) do
    {:reply, :started, loop_data, @timeout}
  end

  def handle_call(:pause, _from, loop_data) do
    {:reply, :paused, loop_data}
  end

  def handle_info(:timeout, loop_data) do
    {_hour, _min, sec} = Time.utc_now() |> Time.to_erl
    IO.puts("#{sec}")
    {:noreply, loop_data, @timeout}
  end
  
end