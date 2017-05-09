module Request.Document exposing(getDocuments)

import Http exposing (send)

import Request.Api exposing(getDocumentsUrlPrefix)
import Types exposing(..)

getDocuments : String -> Cmd Msg
getDocuments author_identifier =
  let
    url =
      getDocumentsUrlPrefix ++ author_identifier
    request =
      Http.getString url
  in
    Http.send GetDocuments request
