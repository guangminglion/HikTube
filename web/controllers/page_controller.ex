defmodule Streaming.PageController do
  use Streaming.Web, :controller
#this file is not used anywhere, just a file to test things
  def index(conn, _params) do
    File.stream!("README.md")
    |> Stream.map(&String.strip/1)
    |> Stream.with_index
    |> Stream.map(fn ({line, index}) -> IO.puts "#{index + 1} #{line}" end)

    {:ok, file} = File.open("README.md", [:read, :write])
    text=IO.read(file, :line)
    text1= "rien du tout"

    #conn
    #|> put_flash(:info, text)
    #|> put_flash(:error, "Let's pretend we have an error.")
    #|> render("index.html")
    render conn, "index.html", text: text1
  end
end
