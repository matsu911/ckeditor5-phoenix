defmodule CKEditor5.ContextsTest do
  use CKEditor5.Test.ContextsTestCaseTemplate, async: true

  alias CKEditor5.{Context, Contexts, Errors}

  describe "get/1" do
    test "returns {:ok, context} for a valid context" do
      assert {:ok, %Context{} = context} = Contexts.get("default")
      assert is_map(context.config)
    end

    test "returns {:error, %ContextNotFound{}} for non-existent context" do
      assert {:error, %Errors.ContextNotFound{} = error} = Contexts.get("non-existent")
      assert error.context_name == "non-existent"
      assert is_list(error.available_contexts)
    end

    test "returns context from application configuration when available" do
      custom_context = %{config: %{foo: :bar}}
      put_contexts_env(%{"custom" => custom_context})
      assert {:ok, context} = Contexts.get("custom")
      assert context.config.foo == :bar
    end

    test "custom contexts override default contexts" do
      custom_default = %{config: %{foo: :baz}}
      put_contexts_env(%{"default" => custom_default})
      assert {:ok, context} = Contexts.get("default")
      assert context.config.foo == :baz
    end

    test "returns error when context parsing fails" do
      put_contexts_env(%{"invalid" => 2})
      assert {:error, _reason} = Contexts.get("invalid")
    end
  end

  describe "get!/1" do
    test "returns context for valid context name" do
      context = Contexts.get!("default")
      assert %Context{} = context
      assert is_map(context.config)
    end

    test "raises ContextNotFound exception for non-existent context" do
      assert_raise Errors.ContextNotFound, fn ->
        Contexts.get!("non-existent")
      end
    end

    test "raises exception when context parsing fails" do
      put_contexts_env(%{"invalid" => 2})

      assert_raise Errors.InvalidContext, fn ->
        Contexts.get!("invalid")
      end
    end

    test "returns custom context when available" do
      custom_context = %{config: %{foo: :bar}}
      put_contexts_env(%{"custom" => custom_context})
      context = Contexts.get!("custom")
      assert context.config.foo == :bar
    end
  end

  describe "error handling" do
    test "ContextNotFound error contains helpful information" do
      {:error, error} = Contexts.get("non-existent")

      assert %Errors.ContextNotFound{} = error
      assert is_list(error.available_contexts)

      # Test the error message
      message = Exception.message(error)
      assert message =~ "Context 'non-existent' not found"
      assert message =~ "Available contexts:"
    end
  end

  describe "application environment integration" do
    test "handles empty application config gracefully" do
      put_contexts_env(%{})
      assert {:error, _} = Contexts.get("random-context")
    end

    test "handles symbol keys in application config" do
      custom_config = %{
        default: %{config: %{foo: :bar}}
      }

      put_contexts_env(custom_config)
      assert {:ok, context} = Contexts.get("default")
      assert context.config.foo == :bar
    end

    test "handles string keys in application config" do
      custom_config = %{
        "default" => %{config: %{foo: :bar}}
      }

      put_contexts_env(custom_config)
      assert {:ok, context} = Contexts.get("default")
      assert context.config.foo == :bar
    end
  end
end
