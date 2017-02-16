defmodule Dial9.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid} | {:ok, pid, any}
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Dial9.Worker.start_link(arg1, arg2, arg3)
      # worker(Dial9.Worker, [arg1, arg2, arg3]),
      Plug.Adapters.Cowboy.child_spec(:http, Dial9.Router, [], [port: 4000]),
      worker(Dial9.State, []),
      worker(Dial9.Events, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dial9.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
