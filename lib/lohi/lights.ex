require Logger

defmodule Lohi.Lights do
  use GenServer

  alias Lohi.Io.Led

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def flash do
    GenServer.call(__MODULE__, {:flash})
  end

  # Callbacks

  @impl true
  def init(pin) do
    {:ok, led0} = Led.start_link(20)
    {:ok, led1} = Led.start_link(26)
    {:ok, led2} = Led.start_link(16)
    {:ok, led3} = Led.start_link(13)
    {:ok, led4} = Led.start_link(6)

    {:ok, [led0, led1, led2, led3, led4]}
  end

  def handle_call({:flash}, _from, leds), do: {:reply, Enum.map(leds, &Led.on/1), leds}
end
