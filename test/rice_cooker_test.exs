defmodule RiceCookerTest do
  use ExUnit.Case
  doctest RiceCooker

  test "greets the world" do
    assert RiceCooker.hello() == :world
  end
end
