require Logger

defmodule Lohi.Io.Buttons do
  use GenServer

  alias ElixirALE.GPIO

  @config %{
    21 => &LohiUi.Controls.play/0,
    14 => &LohiUi.Controls.volume_up/0,
    12 => &LohiUi.Controls.volume_down/0,
    19 => &LohiUi.Controls.skip/0
  }

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default)
  end

  # Callbacks

  @impl true
  def init(pin) do
    Logger.debug("Initializing Lohi Buttons #{pin}")

    input_pids =
      Enum.map(@config, fn {pin, _fun} ->
        {:ok, input_pid} = GPIO.start_link(pin, :input)
        GPIO.set_int(input_pid, :both)
        input_pid
      end)

    {:ok, input_pids}
  end

  def button_pressed(pin), do: @config[pin].()

  @impl true
  def handle_info({:gpio_interrupt, pin, :rising}, state) do
    Logger.debug("Rising on pin #{pin}")
    button_pressed(pin)
    {:noreply, state}
  end

  @impl true
  def handle_info({:gpio_interrupt, pin, :falling}, state) do
    Logger.debug("Falling on pin #{pin}")
    {:noreply, state}
  end
end
