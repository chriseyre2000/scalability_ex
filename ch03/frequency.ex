defmodule Frequency do
  
  def start(), do: Server.start(__MODULE__, [])
  
  def init(_args), do: {get_frequencies(), []}

  def get_frequencies(), do: [10,11,12,13,14,15]

  def stop(), do: Server.stop(__MODULE__)

  def allocate(), do: Server.call(__MODULE__, {:allocate, self()})

  def deallocate(freq), do: Server.call(__MODULE__, {:deallocate, freq})

  def terminate(_frequencies), do: :ok

  def handle({:allocate, pid, frequencies}), do: allocate(frequencies, pid)
  def handle({:deallocate, freq, frequencies}), do: deallocate(frequencies, freq)

  def allocate({[], allocated}, _pid), do: {{[], allocated}, {:error, :no_frequency}}

  def allocate({[freq|free], allocated}, pid), do: {{free, [{freq, pid} | allocated ]}, {:ok, freq}}

  def deallocate( {free, allocated}, freq) do
    new_allocated = List.keydelete(allocated, freq, 1)
    {[freq|free], new_allocated}  
  end

end