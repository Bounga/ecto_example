# Upsert

This is a demo project to demonstrate how to integrate
[Ecto](https://github.com/elixir-ecto/ecto) in a raw Mix app.

This project uses two really simple models with a one-to-one relation
between them.

## Setup

To start using this demo app you have to run `mix deps.get` to install
and compile the dependencies.

You can then create the database and run migrations:

```sh
$ mix ecto.create
$ mix ecto.migrate
```

You'll then be able to run `iex -S mix` to get an interactive console
with the app code loaded.

## Understanding how Ecto was integrated

To discover how Ecto was integrated to the fresh mix app that was
generated using `mix new upsert --sup` command, you can use `git log
-p` command.

All steps are contained in a separated commit so it's easy to
navigate through.

Before being able to use Ecto in your project, you have to create a
"repo". It can be done by hand but there's a Mix task that can do it
for you:

```sh
$ mix ecto.gen.repo
```

The last steps contains the creation of migrations and models and was
eased by the use of Mix tasks provided by Ecto:

```sh
$ mix ecto.gen.migration create_authors
$ mix ecto.gen.migration create_posts
```

You should take a look at `lib/author.ex` and `lib/post.ex`.

## Playing with Ecto and models


### Add data

First you should create some authors and posts to play with:

```iex
iex> %Upsert.Author{name: "Nico"} |> Upsert.Repo.insert()
iex> %Upsert.Author{name: "Chuck"} |> Upsert.Repo.insert()
```

```iex
iex> %Upsert.Post{title: "Integrating Ecto", author_id: 1} |> Upsert.Repo.insert()
iex> %Upsert.Post{title: "Using Ecto", author_id: 2} |> Upsert.Repo.insert()
```

### List available data

You can now list all authors and posts:

```iex
iex> Upsert.Repo.all Upsert.Author
iex> Upsert.Repo.all Upsert.Post
```

### Query data

You can also get one post matching a given `author_id`:

```iex
iex> import Ecto.Query
iex> Upsert.Repo.one(from post in Upsert.Post, where: post.author_id == 1)
```

And you could also load this post and load the author info at the same
time:

```iex
iex> Upsert.Repo.one(from post in Upsert.Post, where: post.author_id == 1, preload: :author)
```

### Modify existing data

Now let's say we want to change the author which is associated to a
given post:

```iex
iex> post = Upsert.Repo.one(from post in Upsert.Post, where: post.author_id == 1, preload: :author)
iex> changed = Ecto.Changeset.change(post, %{author_id: 2})
iex> changed |> Upsert.Repo.update()
```
