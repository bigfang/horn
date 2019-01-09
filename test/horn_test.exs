defmodule HornTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  test "greets the world" do
    assert capture_io(fn ->
             Horn.main('arg')
           end) == "Hello, World!\n"
  end
end
