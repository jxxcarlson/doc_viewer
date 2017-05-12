module Data.Author exposing(..)

import Json.Decode exposing (at, int, list, string, decodeString, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)

import Types exposing(..)

type alias Authors = { authors: List Author }
type alias AuthorRecord = { author: Author }


authorDecoder : Decoder Author
authorDecoder =
  decode Author
    |> JPipeline.required "name" string
    |> JPipeline.required "identifier" string
    |> JPipeline.required "url" string
    |> JPipeline.required "photo_url" string

authorsDecoder : Decoder Authors
authorsDecoder =
  decode
    Authors
    |> required "authors" (list authorDecoder)

author : String -> Result String Author
author jsonString =
  decodeString authorDecoder jsonString

authors : String -> Result String Authors
authors jsonString =
  decodeString authorsDecoder jsonString


-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
