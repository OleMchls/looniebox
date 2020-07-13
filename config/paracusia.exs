import Config

config :paracusia,
  hostname: "localhost",
  port: 6697,
  # if connecting to MPD failed, try again after x milliseconds
  retry_after: 2000,
  # Give up if no connection could be established after x attempts.
  max_retry_attempts: 20
