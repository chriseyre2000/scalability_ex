defmodule Hlr do
  def new() do
    :ets.new(:msisdn2pid, [:public, :named_table])
    :ets.new(:pid2msisdn, [:public, :named_table])
    :ok
  end

  def attach(ms) do
    :ets.insert(:msisdn2pid, {ms, self()})
    :ets.insert(:pid2msisdn, {self(), ms})
  end

  def detatch() do
    case :ets.lookup(:pid2msisdn, self()) do
      [{pid, ms}] ->
        :ets.delete(:pid2msisdn, pid)
        :ets.delete(:msisdn2pid, ms)
      [] ->
        :ok  
    end
  end

  def lookup_id(ms) do
    case :ets.lookup(:msisdn2pid, ms) do
      [] -> 
        {:error, :invalid}
      [{^ms, pid}] -> 
        {:ok, pid}
    end
  end

  def lookup_ms(pid) do
    case :ets.lookup(:pid2msisdn, pid) do
      [] -> 
        {:error, :invalid}
      [{^pid, ms}] -> 
        {:ok, ms}
    end
  end
end