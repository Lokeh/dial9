defmodule Dial9.Router do
  @moduledoc """
  Router
  """
  import Plug.Conn
  use Plug.Router

  plug Plug.Logger
  plug CORSPlug
  plug Plug.Static, at: "/", from: "public/"
  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, "public/index.html")
  end

  get "/dial" do
    conn
    |> put_resp_content_type("application/xml")
    |> send_resp(200, Dial9.DialView.render_view(Dial9.State.get.selected.number))
  end

  get "/select/:name" do
    case Dial9.State.get do
      %Dial9.State{locked: true, time_left: time_left} -> conn |> send_resp(409, "Locked for #{time_left}s")
      _ ->
        case Dial9.State.select_user(name, 30) do # wait for 30s
          {:error, reason} -> conn |> send_resp(400, reason)
          :ok ->
            conn |> send_resp(200, "OK")
        end
    end
  end

  get "/state" do
    conn = conn
    |> put_resp_header("content-type", "text/event-stream")
    |> send_chunked(200)
    send_message(conn, Poison.encode! Dial9.State.get)
    Dial9.Events
    |> GenEvent.stream
    |> Stream.each(fn {:update, state} ->
      send_message(conn, Poison.encode! state)
    end)
    |> Stream.run

    conn
  end

  defp send_message(conn, data) do
    chunk(conn, "data: #{data}\n\n")
  end

  get "/reset" do
    Dial9.State.reset
    conn |> send_resp(200, "OK")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
