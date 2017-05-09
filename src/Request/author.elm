module Request.Author exposing(..)

import Http exposing (send)

import Request.Api exposing(getAuthorUrlPrefix, getAuthorsUrlPrefix)
import Types exposing(..)

getAuthor : String -> Cmd Msg
getAuthor author_identifier =
  let
    url =
      getAuthorUrlPrefix ++ author_identifier
    request =
      Http.getString url
  in
    Http.send GetAuthor request

getAuthors : String -> Cmd Msg
getAuthors author_identifier =
  let
    url =
      getAuthorsUrlPrefix ++ author_identifier
    request =
      Http.getString url
  in
    Http.send GetAuthors request
