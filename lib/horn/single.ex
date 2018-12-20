defmodule Horn.New.Single do
  @moduledoc false
  use Horn.New.Generator
  alias Horn.New.{Project}

  template(:new, [
    {:eex, "horn_single/README.md", :project, "README.md"}
    # {:eex,  "horn_single/gitignore",                    :project, ".gitignore"},
    # {:eex,  "horn_single/config/default.py",            :project, "config/default.py"},
    # {:eex,  "horn_single/config/dev.py",                :project, "config/dev.py"},
    # {:eex,  "horn_single/config/prod.py",               :project, "config/prod.py"},
    # {:eex,  "horn_single/config/test.py",               :project, "config/test.py"},
  ])

  def prepare_project(%Project{app: app} = project) when not is_nil(app) do
    %Project{
      project
      | project_path: project.base_path,
        app_path: project.base_path,
        root_app: app,
        root_mod: Module.concat([Macro.camelize(app)])
    }
  end

  def generate(%Project{} = project) do
    copy_from(project, __MODULE__, :new)
    project
  end
end
