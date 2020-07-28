require Logger

defmodule Looniebox.Lights do
  use GenServer

  alias Looniebox.Io.Led

  @pins Application.get_env(:looniebox, :lights, %{})

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def flash do
    GenServer.call(__MODULE__, {:flash})
  end

  # Callbacks

  @impl true
  def init(pin) do
    leds = Enum.map(@pins, fn pin -> elem(Led.start_link(pin), 1) end)

    {:ok, leds}
  end

  def handle_call({:flash}, _from, leds) do
    step = 300
    load_duration = length(leds) * step + step

    leds
    |> Enum.with_index()
    |> Enum.map(fn {led, i} ->
      Process.send_after(self(), {:on, led}, i * step)
      Process.send_after(self(), {:off, led}, i * step + step)
      led
    end)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.each(fn {led, i} ->
      Process.send_after(self(), {:on, led}, i * step + load_duration)
      Process.send_after(self(), {:off, led}, i * step + step + load_duration)

      # Turn all on at the same time
      Process.send_after(self(), {:on, led}, load_duration * 2 + 500)
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
