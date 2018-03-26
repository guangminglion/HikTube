defmodule Streaming.StreamController do
  use Streaming.Web, :controller
  alias Streaming.Auth
  alias Streaming.Auth.User
  alias Streaming.Auth.Guardian
  alias Streaming.Stream

  def start_stream(source, output) do

    command= "nohup nice -n -10  ffmpeg   -f  lavfi -i anullsrc -rtsp_transport tcp -i  #{source} -crf 10  -deinterlace -vcodec libx264 -pix_fmt yuv420 -b:v 2500k   -tune zerolatency   -c:v  copy   -s 854x480  -framerate 30 -g 2 -acodec libmp3lame -ar 44100  -threads 2   -f flv #{output}"
    commandlist= String.split("#{command}")
    port =Port.open({:spawn, "#{command}"}, [:binary] )
    {:os_pid, pid} = Port.info(port, :os_pid)
    Process.sleep(600000);
    System.cmd("kill",["-9"," #{pid}"])
    start_stream(source,output)

  end

  def index(conn, _params) do
    changeset = Auth.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)
    message = if maybe_user != nil do
      "Someone is logged in"
    else
      "No one is logged in"
    end
    streams = Repo.all(Stream)

    conn
    |> put_flash(:info, message)
    |> render("index.html", changeset: changeset, action: stream_path(conn, :login), maybe_user: maybe_user, streams: streams)
    #render conn, "index.html", Streams: Streams
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
     Auth.authenticate_user(username, password)
     |> login_reply(conn)
   end
   defp login_reply({:error, error}, conn) do
     conn
     |> put_flash(:error, error)
     |> redirect(to: "/")
   end
   defp login_reply({:ok, user}, conn) do
     conn
     |> put_flash(:success, "Welcome back!")
     |> Guardian.Plug.sign_in(user)
     |> redirect(to: "/")
   end
   def logout(conn, _) do
     conn
     |> Guardian.Plug.sign_out()
     |> redirect(to: stream_path(conn, :login))
   end





  def new(conn,params) do

    changeset=Stream.changeset(%Stream{},%{})

    render conn, "new.html", changeset: changeset
  end

def create(conn, %{"stream" => stream}) do
  changeset=Stream.changeset(%Stream{}, stream)

  case Repo.insert(changeset) do
    {:ok, stream_meta} ->   #IO.inspect(Stream)
    IO.puts stream_meta.id
    old_Stream= Repo.get(Stream, stream_meta.id)
    %{source: source}=old_Stream
    %{output: output}=old_Stream
    pid=spawn (fn ->     start_stream(source,output)      end)

    changeset_ffmpeg= Stream.changeset_ffmpeg(old_Stream, %{"ffmpeg_pid" => " pid" })
    case Repo.update(changeset_ffmpeg) do
      {:ok, _Stream}  ->
          redirect(put_flash(conn, :info, "ffmpeg_pid Updated"), to: stream_path(conn, :index ))
    #after success update the row with the ffmpeg PID and launch stream here
     {:error, changeset} ->
      redirect(put_flash(conn, :error , "ffmpeg_pid update fail"), to: stream_path(conn, :index))
      {:error, changeset} -> IO.inspect(changeset)
    end
      redirect(put_flash(conn,:info,"Stream Created"), to: stream_path(conn,:index) )


      render conn, "new.html", changeset: changeset
  end
end

def edit(conn, %{"id" => Stream_id}) do
  Stream= Repo.get(Stream, Stream_id)
  changeset= Stream.changeset(Stream)
  render conn, "edit.html", changeset: changeset, Stream: Stream
end
def update(conn, %{"id" => Stream_id, "Stream" => Stream}) do
  old_Stream= Repo.get(Stream, Stream_id)
  changeset= Stream.changeset(old_Stream, Stream)

  case Repo.update(changeset) do
    {:ok, _Stream}  ->
        redirect(put_flash(conn, :info, "Stream Updated"), to: stream_path(conn, :index ))
    {:error, changeset} ->
      redirect(put_flash(conn, :error , "error"), to: stream_path(conn, :edit, Stream_id))
  end
end

end
