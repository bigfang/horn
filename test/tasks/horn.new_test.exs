Code.require_file("../mix_helper.exs", __DIR__)

defmodule Mix.Tasks.Horn.NewTest do
  use ExUnit.Case, async: false

  test "returns the version" do
    Mix.Tasks.Horn.New.run(["-v"])
    assert_received {:mix_shell, :info, ["Horn v" <> _]}

    Mix.Tasks.Horn.New.run(["--version"])
    assert_received {:mix_shell, :info, ["Horn v" <> _]}
  end
end
