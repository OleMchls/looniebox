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
    ]
  end

  def children(_target) do
    [
      # Starts a worker by calling: Lohi.Worker.start_link(arg)
      # {Lohi.Worker, arg},
      {Lohi.Mpd.Daemon, []},
      {Nerves.IO.RC522, {Lohi.Tag, :scanned}},
      {Lohi.Io.Buttons, []},
      {Lohi.Io.Led, 20}
    ]
  end
end
