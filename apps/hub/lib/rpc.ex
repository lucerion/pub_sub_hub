defmodule PubSubHub.Hub.RPC do
  @moduledoc "RPC functions for work with Publisher and Subscriber"

  defmacro __using__(_opts) do
    quote do
      @type user_options :: %{
              url: atom,
              supervisor: atom,
              app: atom
            }

      @publisher %{
        url: Application.get_env(:publisher, :rpc_url),
        supervisor: PubSubHub.Publisher.RPC.Supervisor,
        app: PubSubHub.Publisher.Clients.RPCClient
      }

      @subscriber %{
        url: Application.get_env(:subscriber, :rpc_url),
        supervisor: PubSubHub.Subscriber.RPC.Supervisor,
        app: PubSubHub.Subscriber.Clients.RPCClient
      }

      @reponse_function :receive

      alias PubSubHub.Hub.{Secret, Token}

      @doc "Authenticate user"
      @spec auth(user_options, atom, %{email: String.t(), secret: Secret.t()}) :: atom
      def auth(user_options, repo, %{email: email, secret: secret}) do
        with user when not is_nil(user) <- repo.find_by(%{email: email}),
             true <- Secret.verify(user, secret) do
          user
          |> Token.refresh()
          |> send_response(user_options)
        end
      end

      defp send_response(response, %{supervisor: supervisor, url: url, app: app}) do
        {supervisor, url}
        |> Task.Supervisor.async(app, @reponse_function, [response])
        |> Task.await()
      end
    end
  end
end
