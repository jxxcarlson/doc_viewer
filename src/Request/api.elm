module Request.Api exposing(..)

api : String
-- api = "http://localhost:4000/api/v1/"
api = "https://warm-hamlet-26117.herokuapp.com/api/v1/"


getDocumentsUrlPrefix = api ++ "documents?author="
getAuthorUrlPrefix = api ++ "authors/"
getAuthorsUrlPrefix = api ++ "authors?author="
initialDocumentsUrl = api ++ "documents/author=ezra_pound"
