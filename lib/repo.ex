defmodule Upsert.Repo do
  use Ecto.Repo,
    otp_app: :upsert,
    adapter: Ecto.Adapters.Postgres
end
