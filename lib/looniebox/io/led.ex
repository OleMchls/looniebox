require Logger

defmodule Looniebox.Io.Led do
  use GenServer

  alias ElixirALE.GPIO

  def start_link(pin) do
    GenServer.start_link(__MODULE__, pin)
  end

  def on(pid) do
    GenServer.call(pid, {:switch, 1})
  end

  def off(pid) do
    GenServer.call(pid, {:switch, 0})
  end

  # LED Pin 20

  # Callbacks

  @impl true
  def init(pin) do
    Logger.debug("Initializing Lohi Led #{pin}")
    GPIO.start_link(pin, :output)
  end

  def handle_call({:switch, value}, _from, out), do: {:reply, GPIO.write(out, value), out}
end
