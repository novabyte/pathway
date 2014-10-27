defmodule Pathway.Client do
  @moduledoc false

  use GenServer

  quote do
    unquote(@user_agent "pathway/#{Mix.Project.config[:version]}")
  end

  defstruct [client: nil, apikey: nil, timeout: nil, retries: nil]

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, [name: __MODULE__])
  end

  def init(args), do: init(args, Application.get_env(:pathway, :apikey))

  defp init(_args, ""), do: {:stop, "TrakIO API key must be configured."}
  defp init(args, apikey) do
    {:ok, pid} = :fusco.start('https://api.trak.io/', args)
    Process.link(pid)
    state = struct(__MODULE__, [
      client: pid,
      apikey: apikey,
      timeout: Application.get_env(:pathway, :timeout, 3000),
      retries: Application.get_env(:pathway, :retries, 2)])
    {:ok, state}
  end

  def handle_call(msg, {_from, _ref}, state) do
    hdrs = [{<<"User-Agent">>, @user_agent},
            {<<"X-Token">>, state.apikey}]
    args = [state.client] ++ List.replace_at(msg, 2, hdrs) ++ [state.retries, state.timeout]
    reply = Kernel.apply(:fusco, :request, args)
    {:reply, reply, state}
  end

end
