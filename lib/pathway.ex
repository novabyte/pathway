defmodule Pathway do

  def alias(distinct_id, alias) do
    %{distinct_id: distinct_id, alias: alias}
    |> Poison.encode!
    |> build_req("/v1/alias")
    |> execute
    |> parse_resp
  end

  def annotate(event, properties \\ %{}, channel \\ nil) do
    %{event: event, properties: properties, channel: channel}
    |> Poison.encode!
    |> build_req("/v1/annotate")
    |> execute
    |> parse_resp
  end

  def identify(distinct_id, properties \\ %{}) do
    %{distinct_id: distinct_id, properties: properties}
    |> Poison.encode!
    |> build_req("/v1/identify")
    |> execute
    |> parse_resp
  end

  def page_view(distinct_id, title, url), do: track(distinct_id, "Page view", %{title: title, url: url})

  def track(distinct_id, event, properties \\ %{}, channel \\ "web_site", company_id \\ nil) do
    %{distinct_id: distinct_id, event: event, properties: properties,
      company_id: company_id, channel: channel}
    |> Poison.encode!
    |> build_req("/v1/track")
    |> execute
    |> parse_resp
  end

  defp build_req(json, path), do: [path, 'POST', [], "data=#{json}"]

  defp execute(req), do: GenServer.call(Pathway.Client, req)

  defp parse_resp({:error, _} = resp), do: resp
  defp parse_resp({:ok, {{"200", _}, _, body, _, _}}) do
    {:ok, Poison.decode!(body)}
  end
  defp parse_resp({:ok, {_, _, body, _, _}}) do
    {:error, Poison.decode!(body)}
  end

end
