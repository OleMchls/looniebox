defmodule LoonieBox.Mdns.Resolver do
  def resolve(query) do
    Mdns.Client.start()
    Mdns.Client.query(query)

    Mdns.Client.devices()
    |> Map.get(String.to_atom(query), [])
    |> Enum.map(& &1.ip)

    []
  end
end

# :gen_server.call(, {:connect, :normal, :"nerves@192.168.178.63"}, :infinity)

# Mdns.Client.devices() |> Map.get(String.to_atom("_epmd._tcp.local"), []) |> Enum.map(& &1.ip)

# Node.ping(:"nerves@192.168.178.63")
