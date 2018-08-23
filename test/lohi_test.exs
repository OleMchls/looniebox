defmodule LohiTest do
  use ExUnit.Case
  doctest Lohi

  test "greets the world" do
    assert Lohi.hello() == :world
  end
end
