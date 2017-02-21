defmodule Dial9.Mixfile do
  use Mix.Project

  def project do
    [app: :dial9,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger],
     mod: {Dial9.Application, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:cowboy, "~> 1.0.0"},
    {:plug, "~> 1.0"},
    {:ex_twiml, "~> 2.1.2"},
    {:credo, "~> 0.5", only: [:dev, :test]},
    {:dialyxir, "~> 0.4", only: [:dev], runtime: false},
    {:poison, "~> 3.0"},
    {:cors_plug, "~> 1.2"},
    {:distillery, "~> 1.0"}]
  end
end
