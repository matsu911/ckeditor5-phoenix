defmodule CKEditor.MixProject do
  use Mix.Project

  def project do
    [
      app: :ckeditor,
      description: "CKEditor 5 integration for Phoenix Framework",
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      aliases: aliases(),
      dialyzer: dialyzer(),
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      preferred_cli_env: [format: :dev]
    ]
  end

  defp deps do
    [
      {:phoenix, "~> 1.7.0"},
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_live_reload, "~> 1.6", only: [:dev]},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Mateusz Bagiński"],
      licenses: ["MIT"],
      files: [
        "lib",
        "dist",
        "mix.exs",
        ".formatter.exs",
        ".credo.exs",
        "README.md",
        "CHANGELOG.md",
        "LICENSE"
      ],
      links: [
        GitHub: "https://github.com/Mati365/ckeditor5-phoenix"
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "playground", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "playground"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      playground: "run --no-halt -e 'Playground.App.run()'"
    ]
  end

  defp dialyzer do
    [
      plt_file: {:no_warn, "priv/plts/project.plt"},
      plt_add_apps: [:mix],
      ignore_warnings: ".dialyzer_ignore.exs"
    ]
  end
end
