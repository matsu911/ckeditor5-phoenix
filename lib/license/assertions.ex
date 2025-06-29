defmodule CKEditor5.License.Assertions do
  @moduledoc false

  alias CKEditor5.License

  @doc """
  Checks if the license key is a GPL license.
  """
  def gpl?(%License{key: "GPL"}), do: true
  def gpl?(%License{}), do: false
  def gpl?("GPL"), do: true
  def gpl?(_), do: false

  @doc """
  Checks if the license is for a specific distribution channel.
  """
  def distribution?(%License{distribution_channel: channel}, channel), do: true
  def distribution?(%License{}, _), do: false

  @doc """
  Checks if the license is for cloud distribution.
  """
  def cloud_distribution?(%License{} = license), do: distribution?(license, "cloud")

  @doc """
  Checks if the license is for npm distribution.
  """
  def npm_distribution?(%License{} = license), do: distribution?(license, "npm")

  @doc """
  Checks if the license is compatible with the given distribution channel.
  GPL licenses are compatible with all channels.
  """
  def compatible_distribution?(%License{distribution_channel: nil}, _), do: true
  def compatible_distribution?(%License{distribution_channel: channel}, channel), do: true
  def compatible_distribution?(%License{}, _), do: false

  @doc """
  Checks if the license is compatible with cloud distribution.
  """
  def compatible_cloud_distribution?(%License{} = license),
    do: compatible_distribution?(license, "cloud")

  @doc """
  Checks if the license is compatible with npm distribution.
  """
  def compatible_npm_distribution?(%License{} = license),
    do: compatible_distribution?(license, "npm")
end
