defmodule EctoDiffMigrate.Repo do
  @moduledoc false
  use Ecto.Repo,
    adapter: Ecto.Adapters.Postgres,
    otp_app: :ecto_diff_migrate
end
