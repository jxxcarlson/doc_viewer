module Data.Document exposing(..)

import Json.Decode exposing (int, list, string, float, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)

import Types exposing(..)

type alias DocumentListRecord = { documents: List Document }

-- documentsRecordDecoder : String -> Result String (List Document)
-- documentsRecordDecoder author_identifier =
--   decode DocumentListRecord
--     |> Pipeline.required "document"
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
