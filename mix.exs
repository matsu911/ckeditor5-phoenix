defmodule CKEditor5.MixProject do
  use Mix.Project

  def project do
    [
      app: :ckeditor5,
      description: "CKEditor 5 integration for Phoenix Framework",
      version: "0.1.0",
      cke: %{
        default_cloud_editor_version: "45.2.1"
      },
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      aliases: aliases(),
      dialyzer: dialyzer()
    ]
  end

  def application do
    [
      extra_applications: extra_apps(Mix.env()),
      preferred_cli_env: [format: :dev]
    ]
  end

  defp extra_apps(:dev), do: [:logger, :dotenv]
  defp extra_apps(_), do: []

  defp deps do
    is_dev = Mix.env() == :dev

    [
      {:phoenix, "~> 1.7.21"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_view, "~> 1.0"},
      {:norm, "~> 0.13"},
      {:memoize, "~> 1.4"},
      {:dotenv, "~> 3.0.0", only: [:dev]},
      {:telemetry_metrics, "~> 1.0", only: [:dev]},
      {:telemetry_poller, "~> 1.0", only: [:dev]},
      {:phoenix_live_reload, "~> 1.6", only: [:dev]},
      {:dns_cluster, "~> 0.1.1", only: [:dev]},
      {:bandit, "~> 1.5", only: [:dev]},
      {:tailwind, "~> 0.3", only: [:dev], runtime: is_dev},
      {:esbuild, "~> 0.7", only: [:dev], runtime: is_dev},
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
      playground: "run -e 'Playground.App.run()'",
      "assets.test": ["cmd npm run npm_package:test"],
      "assets.typecheck": ["cmd npm run typecheck"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": [
        "cmd npm run npm_package:build",
        "tailwind ckeditor --minify",
        "esbuild ckeditor --minify"
      ],
      "assets.deploy": ["assets.setup", "assets.build", "phx.digest playground/priv/static"],
      "assets.lint": ["cmd npx eslint"]
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
