![Elixir CI](https://github.com/thulio/ecto_diff_migrate/workflows/Elixir%20CI/badge.svg)
# EctoDiffMigrate

`EctoDiffMigrate` [(documentation)](https://hexdocs.pm/ecto_diff_migrate) keeps track of database structure changes
through diff files.

Diff files make easier for a developer or database
administrator see and evaluate those changes before aplying them
to a production database.


## Installation

Add to your mix.exs:

```elixir
def deps do
  [
    {:ecto_diff_migrate, "~> 0.1.0"}
  ]
end
```

`EctoDiffMigrate` uses `Mix.Tasks.Ecto.Dump` under the hood and
it requires `pg_dump` to be installed. `pg_dump` is (usually)
bundled within `postgresql-client` package in most Linux distributions.

## How to use

`EctoDiffMigrate` provides a mix task `mix ecto.diff.migrate`.
It expects an  output directory (`--diff-output-dir`) to put the diff files in:

```shell
mix ecto.diff.migrate --diff-output-dir sql_diffs
```

```diff
31a32,66
> -- Name: table; Type: TABLE; Schema: public; Owner: -
> --
> 
> CREATE TABLE public."table" (
>     id bigint NOT NULL
> );
> 
> 
> --
> -- Name: table_id_seq; Type: SEQUENCE; Schema: public; Owner: -
> --
> 
> CREATE SEQUENCE public.table_id_seq
>     START WITH 1
>     INCREMENT BY 1
>     NO MINVALUE
>     NO MAXVALUE
>     CACHE 1;
> 
> 
> --
> -- Name: table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
> --
> 
> ALTER SEQUENCE public.table_id_seq OWNED BY public."table".id;
> 
> 
> --
> -- Name: table id; Type: DEFAULT; Schema: public; Owner: -
> --
> 
> ALTER TABLE ONLY public."table" ALTER COLUMN id SET DEFAULT nextval('public.table_id_seq'::regclass);
> 
> 
> --
39a75,82
> -- Name: table table_pkey; Type: CONSTRAINT; Schema: public; Owner: -
> --
> 
> ALTER TABLE ONLY public."table"
>     ADD CONSTRAINT table_pkey PRIMARY KEY (id);
> 
> 
> --
42a86,87
> INSERT INTO public."schema_migrations" (version) VALUES (20200509171630);
> 
```


```diff
36c36,37
<     id bigint NOT NULL
---
>     id bigint NOT NULL,
>     "column" character varying(255)
86c87
< INSERT INTO public."schema_migrations" (version) VALUES (20200509171630);
---
> INSERT INTO public."schema_migrations" (version) VALUES (20200509171630), (20200509175658);
```
