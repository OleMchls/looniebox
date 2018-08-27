use Mix.Config

config :shoehorn,
  init: [:nerves_runtime, {Lohi.Mpd.Daemon, :create_directories, ["/Users/ole/.mpd"]}],
  app: Mix.Project.config()[:app]
