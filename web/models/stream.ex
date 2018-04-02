defmodule  Streaming.Stream do
  use Streaming.Web, :model

  schema "streams" do
    field :title, :string
    field :output, :string
    field :source, :string
    field :ffmpeg_pid, :string
    field :created_at, :utc_datetime
    field :status, :string
    timestamps(updated_at: false, type: :utc_datetime)

  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:output,:source, :title,])
    |> validate_required([:output,:source,:title])
  end
  def changeset_ffmpeg(struct, params \\ %{}) do
    struct
    |> cast(params, [:ffmpeg_pid, :status])
    |> validate_required([:ffmpeg_pid, :status])
  end
  def changeset_play_pause(struct, params \\ %{}) do
    struct
    |> cast(params, [:ffmpeg_pid, :status])
    |> validate_required([:ffmpeg_pid, :status])
  end


end
