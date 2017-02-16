defmodule Dial9.State do
  use GenServer
  @moduledoc """
  State store
  Get, set and reset the dialer's state

  ## Examples

      iex> Dial9.State.get
      %{user: %Dial9.User{name: "Will", number: "503-939-8737"}}

      iex> Dial9.State.select_user("Georgia", 0)
      %{user: %Dial9.User{name: "Georgia", number: ""}}

      iex> Dial9.State.reset
      %{user: %Dial9.User{name: "Will", number: "503-939-8737"}}
  """
  @name __MODULE__

  defstruct [
    user: %Dial9.User{},
    locked: false,
    timeout: 0, # seconds
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
        GenServer.cast @name, {:update_user, user, timeout}
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
  def handle_cast({:update_user, user, timeout}, _state) do
    new_state = %Dial9.State{user: user, timeout: timeout, locked: true}
    emit new_state
    Process.send_after @name, :tick, 1000
    {:noreply, new_state}
  end

  @spec handle_info(:tick, %Dial9.State{}) :: {:noreply, %Dial9.State{}}
  def handle_info(:tick, state) do
    case state do
      %Dial9.State{timeout: 1} ->
        new_state = %Dial9.State{}
        emit new_state
        {:noreply, new_state}
      state ->
        new_state = Map.update(state, :timeout, 0, fn count ->
          IO.puts count - 1
          count - 1
        end)
        emit new_state
        Process.send_after @name, :tick, 1000
        {:noreply, new_state}
    end
  end

  defp emit(new_state) do
    Dial9.Events.emit_update new_state
  end

end
