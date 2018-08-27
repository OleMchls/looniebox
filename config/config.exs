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
  init: [:nerves_runtime, {Lohi.Mpd.Daemon, :create_directories, ["/root/mpd"]}],
  app: Mix.Project.config()[:app]

config :paracusia,
  hostname: "localhost",
  port: 6697,
  # if connecting to MPD failed, try again after x milliseconds
  retry_after: 1000,
  # Give up if no connection could be established after x attempts.
  max_retry_attempts: 5

config :logger, level: :debug

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

import_config "#{Mix.Project.config()[:target]}.exs"
