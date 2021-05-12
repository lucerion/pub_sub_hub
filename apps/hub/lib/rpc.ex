defmodule PubSubHub.Hub.RPC do
  @moduledoc "RPC common functions"

  defmacro __using__(_opts) do
    quote do
      @type user_options :: %{
              url: String.t(),
              supervisor: atom,
              module: atom
            }

      @publisher %{
        url: Application.get_env(:publisher, :rpc_url),
        supervisor: PubSubHub.Publisher.RPC.Supervisor,
        module: PubSubHub.Publisher
      }

      @subscriber %{
        url: Application.get_env(:subscriber, :rpc_url),
        supervisor: PubSubHub.Subscriber.RPC.Supervisor,
        module: PubSubHub.Subscriber
      }

      @response_function :receive

      alias PubSubHub.Hub.{Users, Secret, Token}

      @doc "Authenticate user"
      @spec auth(user_options, %{email: String.t(), secret: Secret.t()}) :: term
      def auth(user_options, %{email: email, secret: secret}) do
        with user when not is_nil(user) <- Users.find_by(%{email: email}),
             true <- Secret.verify(user, secret) do
          user
          |> Token.refresh()
          |> send_response(user_options)
        end
      end

      defp send_response(response, %{url: url, supervisor: supervisor, module: module}) do
        {supervisor, String.to_atom(url)}
        |> Task.Supervisor.async(module, @response_function, [response])
        |> Task.await()
      end
    end
  end
end
