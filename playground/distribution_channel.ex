defmodule Playground.DistributionChannel do
  @moduledoc """
  Configuration helpers for CKEditor5 Phoenix integration.
  """

  @distribution_modes [:cloud, :sh]

  @doc """
  Checks if the current distribution mode is Cloud.
  """
  def cloud_mode? do
    distribution_mode() == :cloud
  end

  @doc """
  Checks if the current distribution mode is Self-hosted.
  """
  def sh_mode? do
    distribution_mode() == :sh
  end

  defp distribution_mode do
    Application.get_env(:ckeditor5_phoenix, Playground.DistributionChannel, :sh)
    |> validate_distribution_mode!()
  end

  defp validate_distribution_mode!(mode) when mode in @distribution_modes, do: mode

  defp validate_distribution_mode!(mode) do
    raise ArgumentError, """
    Invalid distribution mode: #{inspect(mode)}

    Valid modes are: #{inspect(@distribution_modes)}

    Configure in your config files:

    config :ckeditor5_phoenix, Playground.Config, distribution_channel: :cdn
    """
  end
end
