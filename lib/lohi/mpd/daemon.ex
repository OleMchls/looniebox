require Logger

defmodule Lohi.Mpd.Daemon do
  use GenServer

  def create_directories(base) do
    File.mkdir_p!(base <> "/music")
    File.mkdir_p!(base <> "/playlists")

    File.cp("/etc/chime.mp3", base <> "/music/chime.mp3")
    File.cp("/etc/chime_long.mp3", base <> "/music/chime_long.mp3")
  end

  # Client

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [])
  end

  # Server (callbacks)

  @impl true
  def init(_opts) do
    port =
      Port.open({:spawn_executable, System.find_executable("mpd")}, [
        :binary,
        :stderr_to_stdout,
        :exit_status,
        args: ["-v", "--no-daemon"]
      ])

    Port.monitor(port)

    {:ok, port}
  end

  # {:DOWN, #Reference<0.1801756118.703856643.20670>, :port, #Port<0.7>, :normal}
  @impl true
  def handle_info({:DOWN, _reference, :port, _port, reason}, state) do
    Logger.debug("MPD down. Reason: #{reason}")
    {:stop, reason, state}
  end

  @impl true
  def handle_info({_port, {:data, output}}, state) do
    Logger.debug("mpd: " <> output)
    {:noreply, state}
  end

  @impl true
  def handle_info(msg, state) do
    Logger.debug("Unexpected message #{inspect(msg)}")
    {:noreply, state}
  end

  @impl true
  def terminate(_reason, state) do
    send(state, {self(), :close})
  end
end
