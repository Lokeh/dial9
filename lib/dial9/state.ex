defmodule Dial9.State do
  use GenServer
  @moduledoc """
  State store
  Get, set and reset the dialer's state
  """
  @name __MODULE__

  defstruct [
    selected: %Dial9.User{},
    locked: false,
    timeout: 300, # 10th of seconds
    time_left: 0,
    users: Dial9.User.all
  ]

  @spec start_link :: {:ok, pid} | {:error, any}
  def start_link do
    GenServer.start_link __MODULE__, %Dial9.State{}, name: @name
  end

  @spec get :: %Dial9.State{}
  def get do
    GenServer.call @name, :get
  end

  @spec select_user(String.t, integer) :: :ok | {:error, String.t}
  def select_user(name, timeout) do
    case Dial9.User.select(name) do
      {:error, reason} -> {:error, reason}
      user ->
        GenServer.cast @name, {:update_user, user, timeout*10}
    end
  end

  @spec reset :: :ok
  def reset do
    GenServer.cast @name, :reset
  end

  @spec run_timer :: :ok
  def run_timer do
    GenServer.cast @name, :tick
  end

  @spec handle_call(:get, any, %Dial9.State{}) :: {:reply, %Dial9.State{}, %Dial9.State{}}
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @spec handle_cast(:reset, %Dial9.State{}) :: {:noreply, %Dial9.State{}}
  def handle_cast(:reset, _state) do
    new_state = %Dial9.State{}
    emit new_state
    {:noreply, new_state}
  end

  @spec handle_cast({:update_user, %Dial9.User{}, integer}, %Dial9.State{}) :: {:noreply, %Dial9.State{}}
  def handle_cast({:update_user, user, time_left}, _state) do
    new_state = %Dial9.State{selected: user, time_left: time_left, locked: true}
    emit new_state
    Process.send_after @name, :tick, 100
    {:noreply, new_state}
  end

  @spec handle_info(:tick, %Dial9.State{}) :: {:noreply, %Dial9.State{}}
  def handle_info(:tick, state) do
    case state do
      %Dial9.State{time_left: 1} ->
        new_state = %Dial9.State{}
        emit new_state
        {:noreply, new_state}
      state ->
        new_state = Map.update(state, :time_left, 0, fn count ->
          IO.puts count - 1
          count - 1
        end)
        emit new_state
        Process.send_after @name, :tick, 100
        {:noreply, new_state}
    end
  end

  defp emit(new_state) do
    Dial9.Events.emit_update new_state
  end

end
