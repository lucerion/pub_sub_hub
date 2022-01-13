defmodule PubSubHub.Hub.RPC do
  @moduledoc "RPC common functions"

  defmacro __using__(_opts) do
    quote do
      @response_function :receive

      alias PubSubHub.Hub.{Users, Secret, Token}

      @doc "Authenticate user"
      @spec auth(%{email: String.t(), secret: Secret.t()}) :: term
      def auth(%{email: email, secret: secret}) do
        with user when not is_nil(user) <- Users.find_by(%{email: email}),
             true <- Secret.verify(user, secret) do
          user
          |> Token.refresh()
          |> send_response(user)
        end
      end

      defp send_response(response, %{rpc_url: url, rpc_supervisor: supervisor, rpc_module: module}) do
        {module_from_string(supervisor), String.to_atom(url)}
        |> Task.Supervisor.async(module_from_string(module), @response_function, [response])
        |> Task.await()
      end

      defp module_from_string(module_string) do
        module_string
        |> Code.eval_string()
        |> elem(0)
      end
    end
  end
end
