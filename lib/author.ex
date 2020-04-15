defmodule Upsert.Author do
  use Ecto.Schema

  schema "authors" do
    field(:name, :string)
    has_one(:post, Upsert.Post)
    timestamps()
  end
end
