module Data.Document exposing(..)

import Json.Decode exposing (int, list, string, float, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)

import Types exposing(..)

type alias DocumentListRecord = { documents: List Document }

-- Nested JSON: https://gist.github.com/hipertracker/36afd3fa89c1f446cddd0a1fd1d53b6b
-- {
--   "documents": [
--     {
--       "updated_at": "2017-05-06T21:19:05.085975",
--       "title": "Alba",
--       "text": "As cool as the pale wet leaves ... ",
--       "inserted_at": "2017-05-06T21:19:05.028019",
--       "identifier": "alba",
--       "id": 1,
--       "author_identifier": "ezra_pound",
--       "author": "Ezra Pound"
--     },
--     {
--       "updated_at": "2017-05-06T21:20:38.836250",
--       "title": "Metro",
--       "text": "The apparition of these faces in the crowd ...",
--       "inserted_at": "2017-05-06T21:20:38.836241",
--       "identifier": "metro",
--       "id": 2,
--       "author_identifier": "ezra_pound",
--       "author": "Ezra Pound"
--     }
--   ]
-- }

-- data : String

-- documentsRecordDecoder : String -> Result String (List Document)
-- documentsRecordDecoder author_identifier =
--   decode DocumentListRecord
--     |> JPipeline.required "documents"
--     |> Json.Decode.decodeString documentsDecoder author_identifier

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
