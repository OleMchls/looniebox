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
  init: [:nerves_runtime, :nerves_network, {Lohi.Mpd.Daemon, :create_directories, ["/root/mpd"]}],
  app: Mix.Project.config()[:app]

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
    ssid: System.get_env("NERVES_NETWORK_SSID"),
    psk: System.get_env("NERVES_NETWORK_PSK"),
    key_mgmt: "WPA-PSK"
  ],
  eth0: [
    ipv4_address_method: :dhcp
  ]

config :lohi_ui, LohiUiWeb.Endpoint,
  url: [host: "nerves-a9c2"],
  http: [port: 80],
  secret_key_base: "I40cUG6cqA15XsNa4tajPdhdrw5JQq5PXES2kW5ypR7IFVfta5JlXSSJ9JR+JLos",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [view: LohiUiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LohiUi.PubSub, adapter: Phoenix.PubSub.PG2],
  code_reloader: false,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :debug

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

import_config "#{Mix.Project.config()[:target]}.exs"
