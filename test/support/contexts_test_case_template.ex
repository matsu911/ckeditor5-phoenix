defmodule CKEditor5.Test.ContextsTestCaseTemplate do
  @moduledoc """
  A test case for asserting CKEditor5 contexts.
  This module provides a setup for testing CKEditor5 contexts with a focus on context configurations.
  Also imports the use_contexts_env macro for convenient context env management in tests.
  """

  use ExUnit.CaseTemplate

  alias CKEditor5.Context
  alias CKEditor5.Test.ContextsHelper

  setup do
    Memoize.invalidate()

    default_context = %Context{config: %{foo: :bar}}
    original_config = ContextsHelper.put_contexts_env(%{"default" => default_context})

    on_exit(fn -> ContextsHelper.restore_contexts_env(original_config) end)

    {:ok, default_context: default_context}
  end

  using do
    quote do
      import ContextsHelper
    end
  end
end
