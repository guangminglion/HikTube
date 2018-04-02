defmodule Streaming.Router do
  use Streaming.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


    #pipe_through :browser # Use the default browser stack

    pipeline :auth do
      plug Streaming.Auth.Pipeline
    end
    pipeline :ensure_auth do
      plug Guardian.Plug.EnsureAuthenticated
    end
    # Maybe logged in scope
      scope "/", Streaming do
      pipe_through [:browser, :auth]

      get "/", StreamController, :index
      post "/", StreamController, :login
      post "/logoutttt", StreamController, :logout
    end
      # Definitely logged in scope
      scope "/", Streaming do
        pipe_through [:browser, :auth, :ensure_auth]
        #post "/streams/edit/stop", StreamController, :stop
        post "/streams/edit", StreamController, :player
        get "/secret", StreamController, :secret
        get "/streams/new", StreamController, :new
        post "/streams", StreamController, :create
        get "/streams/edit", StreamController, :edit
        put "/streams/:id", StreamController, :update
      end


scope "/", Streaming do



  end

  # Other scopes may use custom stacks.
  # scope "/api", Streaming do
  #   pipe_through :api
  # end
end
