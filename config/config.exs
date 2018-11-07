# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.
config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :shoehorn,
  init: [
    :nerves_runtime,
    :nerves_network,
    :nerves_init_gadget,
    {Lohi.Mpd.Daemon, :create_directories, ["/root/mpd"]}
  ],
  app: Mix.Project.config()[:app]

config :nerves_firmware_ssh,
  authorized_keys: [
    "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQByiQjXoWyyugEUfu/Nuzqxr6R4fHjLey1jrABe30FE2ucXNw0ZZtZuLWpJTbVr+s/IXyPMsWugOS+YQEAiRiUV6mFAk7OzLN6UxzDd/scxO4GuS2iOeEDFb4cyw1cHGE2GVn0Wq/I4ZEeJs/M010rF8xnaJmhhAWBGxBGJ3x1aBHnH22ae0OOVjDOE+AgHWBm1vo2SFoQLqDAkXt0+SFRdTtTzilepxgbXUwoPbFlR2Leo6GNwRosggEZfa0FU7LFedu2NXNVBDUh1zs6ZGmZzK+DgjQr+xmJePxEQsX9r6bulpYek9xsWfdDY5Lo2Gqi2BsvrfxuH9ATpPlr0paEt"
  ]

config :paracusia,
  hostname: "localhost",
  port: 6697,
  # if connecting to MPD failed, try again after x milliseconds
  retry_after: 2000,
  # Give up if no connection could be established after x attempts.
  max_retry_attempts: 20

config :logger, level: :debug

# For WiFi, set regulatory domain to avoid restrictive default
config :nerves_network,
  regulatory_domain: "US"

config :nerves_network, :default,
  wlan0: [
    ssid: System.get_env("NERVES_NETWORK_SSID") || raise("NERVES_NETWORK_SSID is undefined"),
    psk: System.get_env("NERVES_NETWORK_PSK") || raise("NERVES_NETWORK_PSK is undefined"),
    key_mgmt: :"WPA-PSK"
  ],
  eth0: [
    ipv4_address_method: :dhcp
  ]

config :nerves_init_gadget,
  ifname: "wlan0",
  address_method: :dhcp,
  mdns_domain: "nerves.local",
  node_name: nil,
  node_host: :mdns_domain

config :lohi_ui, LohiUiWeb.Endpoint,
  url: [host: "nerves.local"],
  http: [port: 80],
  secret_key_base: "I40cUG6cqA15XsNa4tajPdhdrw5JQq5PXES2kW5ypR7IFVfta5JlXSSJ9JR+JLos",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [view: LohiUiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LohiUi.PubSub, adapter: Phoenix.PubSub.PG2],
  code_reloader: false,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :lohi_ui,
  music_directory: "/root/mpd/music",
  playlist_directory: "/root/mpd/playlists",
  load_callback: {Lohi.Lights, :flash, []}

config :logger, level: :debug, backends: [RingLogger]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

import_config "#{Mix.Project.config()[:target]}.exs"
