import Config

config :libcluster,
  debug: false,
  topologies: [
    lohi: [
      strategy: Elixir.Cluster.Strategy.Gossip,
      config: [
        # port: 45892,
        # if_addr: "0.0.0.0",
        multicast_addr: "192.168.178.255"
        # multicast_ttl: 1,
      ]
    ]
  ]
