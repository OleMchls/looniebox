require Logger

defmodule Looniebox.Io.Buttons do
  use GenServer

  alias Circuits.GPIO

  @btn_cooldown 200
  @config %{
    21 => &LohiUi.Controls.skip/0,
    18 => &LohiUi.Controls.volume_up/0,
    12 => &LohiUi.Controls.volume_down/0,
    19 => &LohiUi.Controls.play/0
  }

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default)
  end

  # Callbacks

  @impl true
  def init(_default) do
    Logger.debug("Initializing Lohi Buttons")

    btn_refs =
      Enum.map(@config, fn {pin, _fun} ->
        {:ok, gpio} = GPIO.open(pin, :input)
        GPIO.set_pull_mode(gpio, :pullup)
        GPIO.set_interrupts(gpio, :both)
        gpio
      end)

    # Ignore the initial btn reading by Initializing disabled and reset after cooldown
    Process.send_after(self(), :reset, @btn_cooldown)

    {:ok, %{enabled: false, btns: btn_refs}}
  end

  def button_pressed(pin), do: @config[pin].()

  @impl true
  def handle_info(:reset, state), do: {:noreply, %{state | enabled: true}}

  @impl true
  def handle_info({:circuits_gpio, pin, _timestamp, 1}, state) do
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
  def handle_info({:circuits_gpio, pin, _timestamp, 0}, state) do
    Logger.debug("Falling on pin #{pin}")
    {:noreply, state}
  end
end
