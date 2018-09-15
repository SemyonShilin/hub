defmodule HubWeb.Router do
  use HubWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_chat_id
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HubWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", HubWeb do
  #   pipe_through :api
  # end

  defp put_chat_id(conn, _) do
    case conn.params do
      %{"chat_id" => chat_id} ->
        current_user = Hub.Users.find(%{chat_id: chat_id})
        chat_id_token = Phoenix.Token.sign(conn, "chat_id",
          current_user.chat_id)
        conn
        |> assign(:chat_id, chat_id_token)
      _ -> conn
    end
  end
end
