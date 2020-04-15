import Config

config :upsert, ecto_repos: [Upsert.Repo]

config :upsert, Upsert.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "upsert",
  hostname: "localhost"
