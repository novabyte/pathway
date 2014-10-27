defmodule Pathway do

  def alias(distinct_id, alias) do
    %{distinct_id: distinct_id, alias: alias}
    |> Pathway.Client.parse_req("/v1/alias")
  end

  def annotate(event, properties \\ %{}, channel \\ nil) do
    %{event: event, properties: properties, channel: channel}
    |> Pathway.Client.parse_req("/v1/annotate")
  end

  def identify(distinct_id, properties \\ %{}) do
    %{distinct_id: distinct_id, properties: properties}
    |> Pathway.Client.parse_req("/v1/identify")
  end

  def page_view(distinct_id, title, url), do: track(distinct_id, "Page view", %{title: title, url: url})

  def track(distinct_id, event, properties \\ %{}, channel \\ "web_site", company_id \\ nil) do
    %{distinct_id: distinct_id, event: event, properties: properties,
      company_id: company_id, channel: channel}
    |> Pathway.Client.parse_req("/v1/track")
  end

end
