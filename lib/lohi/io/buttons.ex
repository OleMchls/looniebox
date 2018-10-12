require Logger

defmodule Lohi.Io.Buttons do
  use GenServer

  alias ElixirALE.GPIO

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default)
  end

  # LED Pin 20

  # BTN PINs
  # - 21 Yellow
  # - 14 White
  # - 20 Blue
  # - 16 Green

  # Callbacks

  @impl true
  def init(pin) do
    Logger.debug("Initializing Lohi Buttons #{pin}")
    {:ok, input_pid} = GPIO.start_link(21, :input)
    GPIO.set_int(input_pid, :both)

    {:ok, [input_pid]}
  end

  def button_pressed(pin) do
    case pin do
      21 -> LohiUi.Controls.play()
    end
  end

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
