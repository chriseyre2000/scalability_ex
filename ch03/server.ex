defmodule Server do
  def start(name, args) do
    register(name, spawn(__MODULE__, init, [name, args])) 
  end

  def init(mod, args) do
    state = mod.init(args)
    loop(mod, state)
  end

  def stop(name) do
    send(name, {:stop, self()})
    receive do
      {:reply, reply} ->
        reply
    end
  end

  def call(name, msg) do
    send(name, {:request, self(), msg})
    receive do
      {:reply, reply} ->
        reply
    end
  end

  def reply(to, reply), do: send(to, {:reply, reply})

  def loop(mod, state) do
    receive do
      {:request, from, msg} ->
        {new_state, reply} = mod.handle(msg, state)
        reply(from, reply)
        loop(mod, new_state)
      {:stop, from} ->
        reply = mod.terminate(state)
        reply(from, reply)
    end
  end
end