defmodule Streaming.Usermail do
  import Swoosh.Email

  def welcome(user) do
        new()
        |> to({user.name, user.email})
        |> from({"Hiktube", "hiktube@gmail.com"})
        |> subject("Hiktube verification email")
        |> html_body("<p>Thanks for signing up with us</p>
            <p>Please click the link below to verify your email address</p>
            <p>Hiktube is a real time live streaming tool for CCTV cameras. Hope you enjoy the experience </p>

            <a href=https://sxxxx.com/v1/api/auth/verify_email/#                    {user.token}>Verify address</a>"
          )
    end

end
