defmodule LoonieboxTest do
  use ExUnit.Case
  doctest Looniebox

  test "greets the world" do
    assert Looniebox.hello() == :world
  end
end
