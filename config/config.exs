import Config

config :ecto_diff_migrate,
  ecto_repos: [EctoDiffMigrate.Repo]

config :ecto_diff_migrate, EctoDiffMigrate.Repo,
  database: "ecto_diff_migrate_test",
  username: "postgres",
  password: "postgres",
  port: 5432,
  show_sensitive_data_on_connection_error: true
