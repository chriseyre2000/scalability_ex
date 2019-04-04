defmodule Echo do
  def go() do
    pid = spawn(__MODULE__, :loop, [])
    send(pid, {self(), :hello})
    receive do
      {^pid, msg} ->
        :io.format("~w~n", [msg])
    end
    send pid, :stop
  end

  def loop() do
    receive do 
      {from, msg} -> 
        send(from, {self(), msg})
      :stop ->
        :ok
    end    
  end
end