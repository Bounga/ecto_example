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

```elixir
%Upsert.Author{name: "Nico"} |> Upsert.Repo.insert()
%Upsert.Author{name: "Chuck"} |> Upsert.Repo.insert()
```

```elixir
%Upsert.Post{title: "Integrating Ecto", author_id: 1} |> Upsert.Repo.insert()
%Upsert.Post{title: "Using Ecto", author_id: 2} |> Upsert.Repo.insert()
```

### List available data

You can now list all authors and posts:

```elixir
Upsert.Repo.all Upsert.Author
Upsert.Repo.all Upsert.Post
```

### Query data

You can also get one post matching a given `author_id`:

```elixir
import Ecto.Query
Upsert.Repo.one(from post in Upsert.Post, where: post.author_id == 1)
```

And you could also load this post and load the author info at the same
time:

```elixir
Upsert.Repo.one(from post in Upsert.Post, where: post.author_id == 1, preload: :author)
```

### Modify existing data

Now let's say we want to change the author which is associated to a
given post:

```elixir
post = Upsert.Repo.one(from post in Upsert.Post, where: post.author_id == 1, preload: :author)
changed = Ecto.Changeset.change(post, %{author_id: 2})
changed |> Upsert.Repo.update()
```

### Modifying the other way around

Now let's say we retrieve the author along with its post. We want to
change the author's name **and** the post's title:

```elixir
author = Upsert.Repo.one(from a in Upsert.Author, where: a.id == 1, preload: :post)
author_changeset = Ecto.Changeset.change(author, %{name: "New name"})
author_post_changeset = author_changeset |> Ecto.Changeset.put_assoc(:post, %{title: "New title"})
Upsert.Repo.update(author_post_changeset)
```

or even shorter:

```elixir
author_changeset = Ecto.Changeset.change(author, %{name: "New name", post: %{title: "New title"}})
Upsert.Repo.update(author_changeset)
```

### Moving a child from a parent to another one

There's no easy way to change a record parent from within the parent
so something like the following won't work:

```elixir
author_changeset = Ecto.Changeset.change(author, %{name: "New name", post: %{author_id: 2}})
Upsert.Repo.update(author_changeset)
```

The `author_id` change won't be applied on update. Ecto always takes
care of associating children with their parent structure.

If you need to change the parent you have to work on the child itself:

```elixir
author = Upsert.Repo.one(from a in Upsert.Author, where: a.id == 1, preload: :post)
changeset = Ecto.Changeset.change(author.post, %{author_id: 2})
Upsert.Repo.update(changeset)
```
