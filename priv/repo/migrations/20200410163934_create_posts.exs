defmodule Upsert.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add(:title, :string)
      add(:author_id, references(:authors))
      timestamps()
    end
  end
end
