module Data.Document exposing(documents, Documents)

import Json.Decode exposing (at, int, list, string, decodeString, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)

import Types exposing(..)

type alias Documents = { documents: List Document }

-- Nested JSON: https://gist.github.com/hipertracker/36afd3fa89c1f446cddd0a1fd1d53b6b
-- Nested JSON: https://gist.github.com/hipertracker/6fcfcc340bc369740afa6b985e64e663

-- Also: https://github.com/eeue56/json-to-elm
--- And this: https://github.com/dragonwasrobot/json-schema-to-elm

-- ARCHITECURE: https://gist.github.com/jah2488/ca3310ad385957e2e616c646de2275fb

-- FLAGS: https://guide.elm-lang.org/interop/javascript.html#flags

documentDecoder : Decoder Document
documentDecoder =
  decode Document
    |> JPipeline.required "title" string
    |> JPipeline.required "author" string
    |> JPipeline.required "text" string

documentsDecoder : Decoder Documents
documentsDecoder =
  decode
    Documents
    |> required "documents" (list documentDecoder)

document : String -> Result String Document
document jsonString =
  decodeString documentDecoder jsonString

documents : String -> Result String Documents
documents jsonString =
  decodeString documentsDecoder jsonString
