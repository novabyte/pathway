defmodule Pathway.Mixfile do
  use Mix.Project

  def project do
    [app: :pathway,
     version: "0.1.0-dev",
     elixir: "~> 1.0",
     deps: deps,
     package: [
       contributors: ["Chris Molozian"],
       licenses: ["Apache 2.0"],
       links: %{github: "https://github.com/novabyte/pathway",
                docs: "http://hexdocs.pm/pathway/"}],
     description: """
     A HTTP client library for the Trak.io REST API.
     """]
  end

  def application do
    [applications: [:fusco],
     env: [apikey: "", timeout: 3000, retries: 2]]
  end

  defp deps do
    [{:poison, "~> 1.2"},
     {:fusco, git: "https://github.com/esl/fusco.git"}]
  end
end
