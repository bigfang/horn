Code.require_file("../mix_helper.exs", __DIR__)

defmodule Mix.Tasks.HornTest do
  use ExUnit.Case, async: false

  test "returns notes" do
    Mix.Tasks.Horn.run([])
    assert_received {:mix_shell, :info, ["Horn v" <> _]}
  end

  test "returns the version" do
    Mix.Tasks.Horn.run(["-v"])
    assert_received {:mix_shell, :info, ["Horn v" <> _]}

    Mix.Tasks.Horn.run(["--version"])
    assert_received {:mix_shell, :info, ["Horn v" <> _]}
  end
end
