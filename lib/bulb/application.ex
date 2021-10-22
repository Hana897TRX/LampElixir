defmodule Bulb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BulbWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bulb.PubSub},
      # Start the Endpoint (http/https)
      BulbWeb.Endpoint
      # Start a worker by calling: Bulb.Worker.start_link(arg)
      # {Bulb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bulb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BulbWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
