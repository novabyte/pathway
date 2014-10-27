defmodule Pathway do

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

  def page_view(distinct_id, title, url), do: track(distinct_id, "Page view", %{title: title, url: url})

  def page_view!(distinct_id, title, url) do
    case page_view(distinct_id, title, url) do
      {:ok, result} -> result
      {_, ex} -> raise ex["message"]
    end
  end

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
