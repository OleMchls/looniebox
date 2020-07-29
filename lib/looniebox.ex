defmodule Looniebox do
  def start_node do
    {:ok, hostname} = :inet.gethostname()
    Node.start(:"nerves@#{hostname}.")
  end

  def scanned(uuid), do: LohiUi.Controls.tag(uuid)
end
