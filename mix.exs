defmodule Pathway.Mixfile do
  use Mix.Project

  def project do
    [app: :pathway,
     name: "Pathway",
     version: "0.1.0",
     source_url: "https://github.com/novabyte/pathway",
     homepage_url: "http://hexdocs.pm/pathway/",
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
     {:fusco, git: "https://github.com/esl/fusco.git"},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.6", only: :dev}]
  end
end
