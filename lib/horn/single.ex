defmodule Horn.New.Single do
  @moduledoc false
  use Horn.New.Generator
  alias Horn.New.{Project}

  template(:new, [
    {:text, "horn_single/Pipfile", :project, "Pipfile"},
    {:text, "horn_single/Pipfile.lock", :project, "Pipfile.lock"},
    {:eex, "horn_single/README.md", :project, "README.md"},
    {:text, "horn_single/gitignore", :project, ".gitignore"},
    {:text, "horn_single/logging.ini", :project, "logging.ini"},
    {:eex, "horn_single/pytest.ini", :project, "pytest.ini"},
    {:text, "horn_single/core/__init__.py", :project, ":app/core/__init__.py"},
    {:eex, "horn_single/core/database.py", :project, ":app/core/database.py"},
    {:eex, "horn_single/core/schema.py", :project, ":app/core/schema.py"},
    {:eex, "horn_single/core/errors.py", :project, ":app/core/errors.py"},
    {:eex, "horn_single/configs/__init__.py", :project, ":app/configs/__init__.py"},
    {:eex, "horn_single/configs/default.py", :project, ":app/configs/default.py"},
    {:eex, "horn_single/configs/development.py", :project, ":app/configs/development.py"},
    {:eex, "horn_single/configs/production.py", :project, ":app/configs/production.py"},
    {:eex, "horn_single/configs/testing.py", :project, ":app/configs/testing.py"},
    {:keep, "horn_single/log", :project, "log"},
    {:eex, "horn_test/__init__.py", :project, "test/__init__.py"},
    {:eex, "horn_test/conftest.py", :project, "test/conftest.py"},
    {:eex, "horn_test/factories.py", :project, "test/factories.py"},
    {:text, "horn_test/test_home.py", :project, "test/test_home.py"},
    {:keep, "horn_app/models", :project, ":app/models"},
    {:keep, "horn_app/schemas", :project, ":app/schemas"},
    {:keep, "horn_app/views", :project, ":app/views"},
    {:keep, "horn_app/tasks", :project, ":app/tasks"}
  ])

  template(:app, [
    {:text, "horn_app/__init__.py", :project, ":app/__init__.py"},
    {:text, "horn_app/cmds.py", :project, ":app/cmds.py"},
    {:text, "horn_app/exts.py", :project, ":app/exts.py"},
    {:eex, "horn_app/router.py", :project, ":app/router.py"},
    {:eex, "horn_app/run.py", :project, ":app/run.py"},
    {:eex, "horn_app/swagger.py", :project, ":app/swagger.py"},
    {:text, "horn_app/models/__init__.py", :project, ":app/models/__init__.py"},
    {:eex, "horn_app/models/helpers.py", :project, ":app/models/helpers.py"},
    {:text, "horn_app/schemas/__init__.py", :project, ":app/schemas/__init__.py"},
    {:text, "horn_app/schemas/helpers.py", :project, ":app/schemas/helpers.py"},
    {:text, "horn_app/views/__init__.py", :project, ":app/views/__init__.py"},
    {:eex, "horn_app/views/home.py", :project, ":app/views/home.py"},
    {:text, "horn_app/tasks/__init__.py", :project, ":app/tasks/__init__.py"}
  ])

  def prepare_project(%Project{app: app} = project) when not is_nil(app) do
    %Project{
      project
      | project_path: project.base_path,
        app_path: project.base_path
    }
  end

  def generate(%Project{} = project) do
    copy_from(project, __MODULE__, :new)

    copy_from(project, __MODULE__, :app)
    project
  end
end
