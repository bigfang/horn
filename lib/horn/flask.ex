defmodule Horn.New.Flask do
  @moduledoc false
  use Horn.New.Generator
  alias Horn.New.{Project}

  template(:root, [
    {:eex, "horn_proj/Pipfile", :project, "Pipfile"},
    {:eex, "horn_proj/README.md", :project, "README.md"},
    {:eex, "horn_proj/pytest.ini", :project, "pytest.ini"},
    {:eex, "horn_proj/instance/prod.secret.cfg", :project, "instance/prod.secret.cfg"},
    {:text, "horn_proj/gitignore", :project, ".gitignore"},
    {:eex, "horn_proj/logging.ini", :project, "logging.ini"},
    {:keep, "horn_proj/log", :project, "log"},
    {:keep, "horn_app/models", :project, ":app/models"},
    {:keep, "horn_app/schemas", :project, ":app/schemas"},
    {:keep, "horn_app/views", :project, ":app/views"}
  ])

  template(:app, [
    {:text, "horn_app/__init__.py", :project, ":app/__init__.py"},
    {:text, "horn_app/cmds.py", :project, ":app/cmds.py"},
    {:eex, "horn_app/exts.py", :project, ":app/exts.py"},
    {:eex, "horn_app/router.py", :project, ":app/router.py"},
    {:eex, "horn_app/run.py", :project, ":app/run.py"},
    {:eex, "horn_app/swagger.py", :project, ":app/swagger.py"},
    {:text, "horn_app/core/__init__.py", :project, ":app/core/__init__.py"},
    {:eex, "horn_app/core/database.py", :project, ":app/core/database.py"},
    {:eex, "horn_app/core/schema.py", :project, ":app/core/schema.py"},
    {:eex, "horn_app/core/errors.py", :project, ":app/core/errors.py"},
    {:eex, "horn_app/configs/__init__.py", :project, ":app/configs/__init__.py"},
    {:eex, "horn_app/configs/default.py", :project, ":app/configs/default.py"},
    {:eex, "horn_app/configs/development.py", :project, ":app/configs/development.py"},
    {:eex, "horn_app/configs/production.py", :project, ":app/configs/production.py"},
    {:eex, "horn_app/configs/testing.py", :project, ":app/configs/testing.py"},
    {:text, "horn_app/models/__init__.py", :project, ":app/models/__init__.py"},
    {:eex, "horn_app/models/helpers.py", :project, ":app/models/helpers.py"},
    {:text, "horn_app/schemas/__init__.py", :project, ":app/schemas/__init__.py"},
    {:eex, "horn_app/schemas/helpers.py", :project, ":app/schemas/helpers.py"},
    {:text, "horn_app/views/__init__.py", :project, ":app/views/__init__.py"},
    {:eex, "horn_app/views/home.py", :project, ":app/views/home.py"}
  ])

  template(:test, [
    {:eex, "horn_test/__init__.py", :project, "test/__init__.py"},
    {:eex, "horn_test/conftest.py", :project, "test/conftest.py"},
    {:eex, "horn_test/factories.py", :project, "test/factories.py"},
    {:text, "horn_test/test_swagger.py", :project, "test/test_swagger.py"},
    {:text, "horn_test/test_home.py", :project, "test/test_home.py"}
  ])

  template(:user, [
    {:eex, "horn_app/models/user.py", :project, ":app/models/user.py"},
    {:eex, "horn_app/schemas/user.py", :project, ":app/schemas/user.py"},
    {:eex, "horn_app/views/user.py", :project, ":app/views/user.py"},
    {:eex, "horn_app/views/session.py", :project, ":app/views/session.py"},
    {:eex, "horn_app/helpers.py", :project, ":app/helpers.py"},
    {:text, "horn_test/test_user.py", :project, "test/test_user.py"},
    {:text, "horn_test/test_session.py", :project, "test/test_session.py"}
  ])

  def prepare_project(%Project{app: app} = project) when not is_nil(app) do
    %Project{
      project
      | project_path: project.base_path,
        app_path: project.base_path
    }
  end

  def generate(%Project{} = project) do
    copy_from(project, __MODULE__, :root)
    copy_from(project, __MODULE__, :app)
    copy_from(project, __MODULE__, :test)

    unless Project.bare(project), do: gen_user(project)

    project
  end

  def gen_user(project) do
    copy_from(project, __MODULE__, :user)
  end
end
