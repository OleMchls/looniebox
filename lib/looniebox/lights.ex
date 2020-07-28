require Logger

defmodule Looniebox.Lights do
  use GenServer

  alias Looniebox.Io.Led

  @volume_duration 5
  @pins Application.get_env(:looniebox, :lights, %{})

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def flash do
    GenServer.call(__MODULE__, :flash)
  end

  def volume(volume) do
    GenServer.call(__MODULE__, {:volume, volume})
  end

  def blink do
    GenServer.call(__MODULE__, :blink)
  end

  # Callbacks

  @impl true
  def init(pin) do
    leds = Enum.map(@pins, fn pin -> elem(Led.start_link(pin), 1) end)

    {:ok, %{leds: leds, last_volume_change: Time.utc_now()}}
  end

  def handle_call(:flash, _from, %{leds: leds} = state) do
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

    {:reply, true, state}
  end

  def handle_call({:volume, volume}, _from, %{leds: leds} = state) do
    num_lights = round(length(leds) / 100 * volume)

    leds
    |> Enum.map(fn led ->
      Process.send_after(self(), {:off, led}, 0)
    end)

    Enum.take(leds, num_lights)
    |> Enum.map(fn led ->
      Process.send_after(self(), {:on, led}, 0)
    end)

    Process.send_after(self(), :clear_volume_lights, @volume_duration * 1000)

    {:reply, true, %{state | last_volume_change: Time.utc_now()}}
  end

  def handle_info(
        :clear_volume_lights,
        %{leds: leds, last_volume_change: last_volume_change} = state
      ) do
    if Time.utc_now() > Time.add(last_volume_change, @volume_duration) do
      turn_all_on(leds)
    end

    {:noreply, state}
  end

  defp turn_all_on(leds) do
    Enum.map(leds, &Process.send_after(self(), {:on, &1}, 0))
  end

  def handle_call(:blink, _from, %{leds: leds} = state) do
    step = 500

    Enum.map(leds, fn led ->
      Process.send_after(self(), {:off, led}, 0)
      Process.send_after(self(), {:on, led}, step)

      Process.send_after(self(), {:off, led}, step * 2)
      Process.send_after(self(), {:on, led}, step * 3)
    end)

    {:reply, true, state}
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
