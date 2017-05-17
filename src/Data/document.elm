module Data.Document exposing(documents, Documents)

import Json.Encode as Encode exposing (..)
import Json.Decode as Decode exposing (at, int, list, string, decodeString, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)

import Types exposing(..)

type alias Documents = { documents: List Document }

-- Nested JSON: https://gist.github.com/hipertracker/36afd3fa89c1f446cddd0a1fd1d53b6b
-- Nested JSON: https://gist.github.com/hipertracker/6fcfcc340bc369740afa6b985e64e663

-- Also: https://github.com/eeue56/json-to-elm
--- And this: https://github.com/dragonwasrobot/json-schema-to-elm

-- ARCHITECURE: https://gist.github.com/jah2488/ca3310ad385957e2e616c646de2275fb

-- FLAGS: https://guide.elm-lang.org/interop/javascript.html#flags


documentEncoder : Model -> Encode.Value
documentEncoder model =
  Encode.object [ ("document",
    Encode.object
          [ ("title", Encode.string model.selectedDocument.title)
          , ("author", Encode.string model.selectedDocument.author)
          , ("text", Encode.string model.selectedDocument.text)
          ]
  )]

documentDecoder : Decoder Document
documentDecoder =
  decode Document
    |> JPipeline.required "title" Decode.string
    |> JPipeline.required "author" Decode.string
    |> JPipeline.required "identifier" Decode.string
    |> JPipeline.required "author_identifier" Decode.string
    |> JPipeline.required "text" Decode.string

documentsDecoder : Decoder Documents
documentsDecoder =
  decode
    Documents
    |> required "documents" (Decode.list documentDecoder)

document : String -> Result String Document
document jsonString =
  decodeString documentDecoder jsonString

documents : String -> Result String Documents
documents jsonString =
  decodeString documentsDecoder jsonString
