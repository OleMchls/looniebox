import Config

config :looniebox,
  button_config: %{
    21 => &LohiUi.Controls.skip/0,
    18 => &LohiUi.Controls.volume_up/0,
    12 => &LohiUi.Controls.volume_down/0,
    19 => &LohiUi.Controls.play/0
  },
  lights: [26, 16, 6, 13]

config :mdns_lite,
  host: [:hostname, "luisa-looniebox"]

config :lohi_ui, LohiUiWeb.Endpoint, url: [host: "luisa-looniebox.local"]
