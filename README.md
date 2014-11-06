Pathway
=======

An Erlang/Elixir client for the Trak.io [REST API](http://docs.trak.io/).

[Trak.io](http://trak.io/) is a service that allows you to save details about your users (people) and their behaviour (events). The service can take in different types of customer data, such as feature usage, payments, support tickets and email history, and then automatically segment users based on that data.

Pathway is created and maintained by Chris Molozian (@novabyte) and contributors.
<br/>
Code licensed under the [Apache License v2.0](http://www.apache.org/licenses/LICENSE-2.0).
 Documentation licensed under [CC BY 3.0](http://creativecommons.org/licenses/by/3.0/).

## Download ##

Pathway is available on [Hex.pm](https://hex.pm/packages/pathway).

Adding Pathway to your application takes two steps:

1. Add `pathway` to your `mix.exs` dependencies:

    ```elixir
    def deps do
      [{:pathway, "~> 0.1"}]
    end
    ```

2. Add `:pathway` to your application dependencies:

    ```elixir
    def application do
      [applications: [:pathway]]
    end
    ```

## Usage ##

You'll need an API key to use the Trak.io service so you must create an account before you can configure the client.

### Configuration ###

The client can be configured in the usual way by adding these settings to your `config.exs` file:

```elixir
config :pathway,
  apikey: "a Trak.io apikey",
  timeout: 3000 # optional
  retries: 2    # optional
```

Only the __apikey__ is a required configuration property. The other properties are initialised with default values.

### Example ###

The client creates a connection to the Trak.io API server on `Pathway.Client.start_link`. The `Pathway.Client` is a `GenServer` whose process is linked to the connection's `pid`. If the connection dies the `Pathway.Client` will also die. For this reason it's recommended to supervise the client in your application:

```elixir
  # within your Application start callback
  children = [
    worker(Pathway.Client, [[]])
  ]
  opts = [strategy: :one_for_one, name: YourApp.Supervisor]
  Supervisor.start_link(children, opts)
```

Alternatively, if you don't want to supervise the client or you're experimenting in the iex console you can manually start the client:

```
{:ok, _pid} = Pathway.Client.start_link()
```

See [Supervisor and Application](http://elixir-lang.org/getting_started/mix_otp/5.html) and [`Application`](http://elixir-lang.org/docs/stable/elixir/Application.html) for more information.

### Sending Events ###

Once the client has been initialised you can start making requests to the Trak.io API. For example, let's assume you have a signup function that gets called when a user signs up, this would be a good opportunity to create an __identity__ for the new user.

```elixir
# create a map of whatever properties you want to associate
# with the user's identity
user = %{name: "Some User", email: "user@email.com", id: "a new user's ID"}
Pathway.identity(user.id, user)

# you might also want to send an event for the action
Pathway.track(user.id, "user signed up")
```

For more detailed examples on using Pathway check out the [documentation](http://hexdocs.pm/pathway/) and Trak.io's [API documentation](https://docs.trak.io/).

__Note__: This client is complete but under development, any feedback and bug reports are welcome.

### Usage with Erlang ###

Elixir code compiles down directly to BEAM bytecode and is completely compatible with Erlang without requiring a "translation layer", runtime introspection or any kind of compatibility layer.

Working with this library from Erlang is as simple as remembering the module prefix created by the Elixir compiler and calling the module's function.

An equivalent Erlang example to the one above:

```erlang
User = #{"name" => <<"Some User">>, "email" => <<"user@email.com">>, "id" => <<"a new user's ID">>}
UserId = maps:get(User, "id")
'Elixir.Pathway':identify(UserId, User)
'Elixir.Pathway':track(UserId, <<"user signed up">>)
```

## Developer Notes ##

This codebase uses [`fusco`](https://github.com/esl/fusco) to make HTTP requests to the Trak.io API and [`poison`](https://github.com/devinus/poison) to handle JSON serialization.

### Errors ###

If you see a `GenServer` error message like (or similar):

```
** (exit) exited in: GenServer.call(Pathway.Client, ["..."], 5000)
    ** (EXIT) no process
     (elixir) lib/gen_server.ex:356: GenServer.call/3
    (pathway) lib/pathway/client.ex:43: Pathway.Client.request/2
```

It means the `Pathway.Client` process has died or was not started. See [here](#usage) for how to supervise the client.

### Contribute ###

All contributions to the documentation and the codebase are very welcome.
