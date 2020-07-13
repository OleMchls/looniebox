require Logger

defmodule Looniebox.Io.Buttons do
  use GenServer

  alias ElixirALE.GPIO

  @btn_cooldown 200
  @config %{
    21 => &LohiUi.Controls.skip/0,
    14 => &LohiUi.Controls.volume_up/0,
    12 => &LohiUi.Controls.volume_down/0,
    19 => &LohiUi.Controls.play/0
  }

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default)
  end

  # Callbacks

  @impl true
  def init(pin) do
    Logger.debug("Initializing Lohi Buttons #{pin}")

    Enum.each(@config, fn {pin, _fun} ->
      {:ok, input_pid} = GPIO.start_link(pin, :input)
      GPIO.set_int(input_pid, :both)
    end)

    {:ok, %{enabled: true}}
  end

  def button_pressed(pin), do: @config[pin].()

  @impl true
  def handle_info(:reset, state), do: {:noreply, %{state | enabled: true}}

  @impl true
  def handle_info({:gpio_interrupt, pin, :rising}, state) do
    Logger.debug("Rising on pin #{pin}")

    if state.enabled do
      button_pressed(pin)
      Process.send_after(self(), :reset, @btn_cooldown)
      {:noreply, %{state | enabled: false}}
    else
      {:noreply, state}
    end
  end

  @impl true
  def handle_info({:gpio_interrupt, pin, :falling}, state) do
    Logger.debug("Falling on pin #{pin}")
    {:noreply, state}
  end
end
