module Data.Document exposing(..)

import Json.Decode exposing (int, list, string, float, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)

import Types exposing(..)

documentsRequestDecoder : String -> Result String (List Document)
documentsRequestDecoder author_identifier =
  Json.Decode.decodeString documentsDecoder author_identifier

documentsDecoder : Decoder (List Document)
documentsDecoder = Json.Decode.list documentDecoder

documentDecoder : Decoder Document
documentDecoder =
  decode Document
    |> JPipeline.required "title" string
    |> JPipeline.required "author" string
    |> JPipeline.required "text" string
