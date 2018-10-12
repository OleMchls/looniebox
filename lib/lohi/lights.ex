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
    {:ok, led3} = Led.start_link(6)
    {:ok, led4} = Led.start_link(13)

    {:ok, [led0, led1, led2, led3, led4]}
  end

  def handle_call({:flash}, _from, [led0, led1, led2, led3, led4] = leds) do
    Process.send_after(self(), {:on, led0}, 0)
    Process.send_after(self(), {:on, led1}, 500)
    Process.send_after(self(), {:on, led2}, 1000)
    Process.send_after(self(), {:on, led3}, 1500)
    Process.send_after(self(), {:on, led4}, 2000)

    Enum.each(leds, fn led ->
      Process.send_after(self(), {:off, led}, 2500)
      Process.send_after(self(), {:on, led}, 2800)
    end)

    {:reply, true, leds}
  end

  def handle_info({:on, led}, state) do
    Led.on(led)
    {:noreply, state}
  end

  def handle_info({:off, led}, state) do
    Led.off(led)
    {:noreply, state}
  end
end
