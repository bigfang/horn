Code.require_file("../mix_helper.exs", __DIR__)

defmodule Mix.Tasks.Horn.NewTest do
  use ExUnit.Case, async: false
  import MixHelper

  @app_name "horn_blog"

  test "returns the version" do
    Mix.Tasks.Horn.New.run(["-v"])
    assert_received {:mix_shell, :info, ["Horn v" <> _]}

    Mix.Tasks.Horn.New.run(["--version"])
    assert_received {:mix_shell, :info, ["Horn v" <> _]}
  end

  test "new with defaults" do
    in_tmp("new with defaults", fn ->
      Mix.Tasks.Horn.New.run([@app_name])
    end)
  end
end
