defmodule Dial9.User do
  @moduledoc """
  Module for handling which number to dial
  """
  @users Application.get_env(:dial9, :users)

  @derive [Poison.Encoder]
  defstruct name: "default", number: @users["default"]

  @spec select(String.t) :: %Dial9.User{name: String.t} | {:error, String.t}
  def select(name) do
    case Map.fetch(@users, name) do
      {:ok, number} -> %Dial9.User{name: name, number: number}
      :error -> {:error, "#{name} not found"}
    end
  end

  @spec reset :: %Dial9.User{}
  def reset do
    %Dial9.User{}
  end

  def all do
    @users
  end
end
