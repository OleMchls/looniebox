import Config

config :libcluster,
  debug: true,
  topologies: [
    lohi: [
      strategy: Cluster.Strategy.DNSPoll,
      config: [
        polling_interval: 5_000,
        query: "_epmd._tcp.local",
        node_basename: "nerves",
        resolver: &LoonieBox.Mdns.Resolver.resolve/1
      ]
    ]
  ]
