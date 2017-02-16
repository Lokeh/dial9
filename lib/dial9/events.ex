defmodule Dial9.Events do
  @moduledoc """
  Event server
  """
  use GenEvent

  @name __MODULE__

  def start_link do
    GenEvent.start_link name: @name
  end

  def emit_update(new_state) do
    GenEvent.notify @name, {:update, new_state}
  end

  @spec handle_event({:update, %Dial9.State{}}, any) :: {:ok, %Dial9.State{}}
  def handle_event({:update, new_state}, _state) do
    {:ok, new_state}
  end

end
