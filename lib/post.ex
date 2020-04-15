defmodule Upsert.Post do
  use Ecto.Schema

  schema "posts" do
    field(:title, :string)
    belongs_to(:author, Upsert.Author)
    timestamps()
  end
end
