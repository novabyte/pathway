defmodule Pathway do
  @moduledoc """
  Pathway is a HTTP client library for the
  [Trak.io REST API](http://docs.trak.io/http.html).

  [Trak.io](https://trak.io/) is a service that allows you to save details about
  your users (people) and their behaviour (events). The service can take in
  different types of customer data, such as feature usage, payments, support
  tickets and email history, and then automatically segment users based on that
  data.

  The Trak.io API is made up of `alias`, `annotate`, `identify`, `page_view` and
  `track` actions. These actions are available in the client as functions with
  the same names.

  ## Configuration

  The client can be configured in the usual way by adding these settings to your
  `config.exs` file:

      config :pathway,
        apikey: "a Trak.io apikey",
        timeout: 3000
        retries: 2

  Only the __apikey__ is a required configuration property. The other properties
  are initialised with default values.

  ## Example

  The client creates a connection to the Trak.io API server on
  `Pathway.Client.start_link`. The `Pathway.Client` is a `GenServer` whose
  process is linked to the connection's `pid`. If the connection dies the
  `Pathway.Client` will also die. For this reason it's recommended to
  supervise the client like so:

      # within your Application start callback
      children = [
        worker(Pathway.Client, [[]])
      ]
      opts = [strategy: :one_for_one, name: YourApp.Supervisor]
      Supervisor.start_link(children, opts)

  Alternatively, if you don't want to supervise the client or you're
  experimenting in the iex console you can manually start the client like so:

      Pathway.Client.start_link()

  Once the client has been initialised you can start making requests to the
  Trak.io API. For example, let's assume you have a signup function that gets
  called when a user signs up, this would be a good opportunity to create an
  __identity__ for the new user.

      user = %{name: "Some User", email: "user@email.com", id: "a new user's ID"}
      Pathway.identity(user.id, user)

      # you might also want to send an event for the action
      Pathway.track(user.id, "user signed up")

  __NOTE__: This client is a work-in-progress, any feedback and bug reports are
  welcome.
  """

  @doc """
  Alias is how you set additional distinct ids for a person.

  This is useful if you initially use Trak.io's automatically generated distinct
  id to identify or track a person but then they login or register and you want
  to identify them by their email address or your application's id for them.

  ## Example

      iex> Pathway.alias("some ID", ["person's other ID"])
      {:ok, %{"status" => "success"}}

  See http://docs.trak.io/alias.html
  """
  @spec alias(String.t, [String.t]) :: {:ok, Map.t} | {:error, String.t}
  def alias(distinct_id, alias) do
    %{distinct_id: distinct_id, alias: alias}
    |> Pathway.Client.parse_req("/v1/alias")
  end

  def alias!(distinct_id, alias) do
    case Pathway.alias(distinct_id, alias) do
      {:ok, result} -> result
      {_, ex} -> raise ex["message"]
    end
  end

  @doc """
  Annotate is a way of recording system wide events that affect everyone.

  Annotations are similar to events except they are not associated with any one
  person.

  ## Examples

      iex> Pathway.annotate("Deployed update")
      {:ok, %{"status" => "success"}}

      iex> Pathway.annotate("Deployed Update", %{commit: "5ab430d"}, "Documentation")
      {:ok, %{"status" => "success"}}

  See http://docs.trak.io/annotate.html
  """
  def annotate(event, properties \\ %{}, channel \\ nil) do
    %{event: event, properties: properties, channel: channel}
    |> Pathway.Client.parse_req("/v1/annotate")
  end

  def annotate!(event, properties \\ %{}, channel \\ nil) do
    case annotate(event, properties, channel) do
      {:ok, result} -> result
      {_, ex} -> raise ex["message"]
    end
  end

  @doc """
  Identify is how you send Trak.io properties about a person like email, name,
  account type, age, etc.

  ## Example

      iex> Pathway.identify("some ID", %{name: "A name", email: "email@app.com"})
      {:ok, %{"status" => "success"}}

  See http://docs.trak.io/identify.html
  """
  def identify(distinct_id, properties \\ %{}) do
    %{distinct_id: distinct_id, properties: properties}
    |> Pathway.Client.parse_req("/v1/identify")
  end

  def identify!(distinct_id, properties \\ %{}) do
    case identify(distinct_id, properties) do
      {:ok, result} -> result
      {_, ex} -> raise ex["message"]
    end
  end

  @doc """
  Track is how you record the actions people perform.

  You can also record properties specific to those actions. For a "Purchased
  shirt" event, you might record properties like revenue, size, etc.

  ## Examples

      iex> Pathway.track("12346789", "Page view", %{}, "web site", "acme_ltd")
      {:ok, %{"status" => "success"}}

  See http://docs.trak.io/track.html
  """
  def track(distinct_id, event, properties \\ %{}, channel \\ "web_site", company_id \\ nil) do
    %{distinct_id: distinct_id, event: event, properties: properties,
      company_id: company_id, channel: channel}
    |> Pathway.Client.parse_req("/v1/track")
  end

  def track!(distinct_id, event, properties \\ %{}, channel \\ "web_site", company_id \\ nil) do
    case track(distinct_id, event, properties, channel, company_id) do
      {:ok, result} -> result
      {_, ex} -> raise ex["message"]
    end
  end

end
