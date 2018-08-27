defmodule Lohi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.Project.config()[:target]

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lohi.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  # List all child processes to be supervised
  def children("host") do
    [
      # Starts a worker by calling: Lohi.Worker.start_link(arg)
      # {Lohi.Worker, arg},
      {Lohi.Mpd.Daemon, []}
    ] ++ paracusia_childs()
  end

  def children(_target) do
    [
      # Starts a worker by calling: Lohi.Worker.start_link(arg)
      # {Lohi.Worker, arg},
      {Lohi.Mpd.Daemon, []},
      {Nerves.IO.RC522, {Lohi.Tag, :scanned}}
    ] ++ paracusia_childs()
  end

  defp paracusia_childs do
    # subscriptions are stored in an agent in order to retain them during restarts.
    {:ok, agent} = Agent.start_link(fn -> [] end)
    # opts = [strategy: :rest_for_one, name: Paracusia.Supervisor]
    # Supervisor.start_link(children, opts)
    [
      {Paracusia.MpdClient,
       [
         retry_after: Application.fetch_env!(:paracusia, :retry_after),
         max_attempts: Application.fetch_env!(:paracusia, :max_retry_attempts)
       ]},
      {Paracusia.PlayerState, agent}
    ]
  end
end
