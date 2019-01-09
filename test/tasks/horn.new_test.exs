Code.require_file("../mix_helper.exs", __DIR__)

defmodule Mix.Tasks.Horn.NewTest do
  use ExUnit.Case, async: false
  import MixHelper

  @app_name "horn_blog"

  setup do
    # The shell asks to install deps.
    # We will politely say not.
    send(self(), {:mix_shell_input, :yes?, false})
    :ok
  end

  test "new with defaults" do
    in_tmp("new with defaults", fn ->
      Mix.Tasks.Horn.New.run([@app_name])

      assert_file("#{@app_name}/README.md")
      refute_file("#{@app_name}/Pipfile.lock")
      assert_file("#{@app_name}/Pipfile")

      assert_file("#{@app_name}/app/core/errors.py", fn file ->
        assert file =~ "HornBlogError"
      end)
    end)
  end

  test "new without defaults" do
    in_tmp("new without defaults", fn ->
      Mix.Tasks.Horn.New.run([@app_name, "--app=foobar", "--pypi=pypi.doubanio.com", "--proj=FooBar"])

      assert_file("#{@app_name}/README.md")
      refute_file("#{@app_name}/Pipfile.lock")

      assert_file("#{@app_name}/Pipfile", fn file ->
        assert file =~ "pypi.doubanio.com"
      end)

      assert_file("#{@app_name}/foobar/core/errors.py", fn file ->
        assert file =~ "FooBarError"
      end)
    end)
  end
end
