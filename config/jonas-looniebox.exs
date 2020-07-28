import Config

config :looniebox,
  button_config: %{
    21 => &LohiUi.Controls.skip/0,
    18 => &LohiUi.Controls.volume_up/0,
    12 => &LohiUi.Controls.volume_down/0,
    19 => &LohiUi.Controls.play/0
  },
  lights: [20, 26, 16, 6, 13]

config :mdns_lite,
  host: [:hostname, "jonas-looniebox"]

config :lohi_ui, LohiUiWeb.Endpoint, url: [host: "jonas-looniebox.local"]
