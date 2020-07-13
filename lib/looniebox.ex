defmodule Looniebox do
  @moduledoc """
  Documentation for Looniebox.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Looniebox.hello
      :world

  """
  def hello do
    :world
  end

  def scanned(uuid), do: LohiUi.Controls.tag(uuid)
end
