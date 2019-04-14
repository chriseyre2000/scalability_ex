defmodule Frequency do
  @moduledoc """
  This is now a working example
  """
  use GenServer

 

  def init(_arg) do
    frequencies = {get_frequencies(), []}
    {:ok, frequencies}
  end

  def handle_call({:allocate, pid}, _from, frequencies) do
    {new_frequencies, reply} = allocate(frequencies, pid)
    {:reply, reply, new_frequencies}
  end

  defp get_frequencies, do: [10,11,12,13,14,15]


  def allocate({[], allocated}, _pid), do: {{[], allocated}, {:error, :no_frequency}}

  def allocate({[freq|free], allocated}, pid), do: {{free, [{freq, pid} | allocated ]}, {:ok, freq}}

  def deallocate( {free, allocated}, freq) do
    new_allocated = List.keydelete(allocated, freq, 1)
    {[freq|free], new_allocated}  
  end

  

  def handle_cast({:deallocate, freq}, frequencies) do
    new_frequencies = deallocate(frequencies, freq)
    {:noreply, new_frequencies}
  end
 
  def handle_cast(:stop, loop_data), do: {:stop, :normal, loop_data}

  def handle_info({'EXIT', _pid, :normal}, loop_data), do: {:noreply, loop_data}

  def handle_info({'EXIT', pid, reason}, loop_data) do
    IO.format("Process: ~p exited with reason: ~p~n", [pid, reason])
    {:noreply, loop_data}
  end

  def handle_info(_msg, loop_data), do: {:noreply, loop_data}

  # Client API

  def start do
    GenServer.start_link(__MODULE__, [], name: __MODULE__ )
  end

  def stop, do: GenServer.cast(__MODULE__, :stop)

  def terminate(_reason, _loopdata), do: :ok

  def allocate, do: GenServer.call(__MODULE__, {:allocate, self()})

  def deallocate(frequency), do: GenServer.cast(:frequency, {:deallocate, frequency})
  
end