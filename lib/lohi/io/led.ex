require Logger

defmodule Lohi.Io.Led do
  use GenServer

  alias ElixirALE.GPIO

  def start_link(pin) do
    GenServer.start_link(__MODULE__, pin, name: __MODULE__)
  end

  def on do
    GenServer.call(__MODULE__, {:switch, 1})
  end

  def off do
    GenServer.call(__MODULE__, {:switch, 0})
  end

  # LED Pin 20

  # Callbacks

  @impl true
  def init(pin) do
    Logger.debug("Initializing Lohi Buttons #{pin}")
    {:ok, output_pin} = GPIO.start_link(pin, :output)

    # Turn on for start
    GPIO.write(output_pin, 1)

    {:ok, output_pin}
  end

  def handle_call({:switch, value}, _from, out), do: {:reply, GPIO.write(out, value), out}
end
