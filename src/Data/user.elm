module Data.User exposing(userEncoder, jwtDecoder)

import Json.Encode as Encode exposing (..)
import Json.Decode exposing (at, int, list, string, decodeString, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)

import Types exposing(Model)


userEncoder : Model -> Encode.Value
userEncoder model =
  Encode.object [ ("user",
    Encode.object
          [ ("email", Encode.string model.user_email)
          , ("password", Encode.string model.user_password)
          ]
  )]

type alias Claims = { username: String, user_id: Int }

jwtDecoder : Decoder Claims
jwtDecoder =
  decode Claims
    |> JPipeline.required "username" Json.Decode.string
    |> JPipeline.required "user_id" Json.Decode.int
