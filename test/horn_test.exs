defmodule HornTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  test "greets the world" do
    assert capture_io(fn ->
             Horn.say()
           end) == "Hello, World!\n"
  end
end
