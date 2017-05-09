module Data.Author exposing(..)

import Json.Decode exposing (int, list, string, float, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)

import Types exposing(..)

authorRequestDecoder : String -> Result String (Author)
authorRequestDecoder author_identifier =
  Json.Decode.decodeString authorDecoder author_identifier

authorsRequestDecoder : String -> Result String (List Author)
authorsRequestDecoder author_identifier =
  Json.Decode.decodeString authorsDecoder author_identifier

authorsDecoder : Decoder (List Author)
authorsDecoder = Json.Decode.list authorDecoder

authorDecoder : Decoder Author
authorDecoder =
  decode Author
    |> JPipeline.required "name" string
    |> JPipeline.required "identifier" string
    |> JPipeline.required "url" string
    |> JPipeline.required "photo_url" string
