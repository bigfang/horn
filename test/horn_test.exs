defmodule HornTest do
  use ExUnit.Case
  doctest Horn

  test "greets the world" do
    assert Horn.hello() == :world
  end
end
