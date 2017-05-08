module DocumentViewer exposing (..)

-- REFERENCES USED
-- https://github.com/mpizenberg/elm_api_test/blob/master/src/Main.elm
-- https://guide.elm-lang.org/interop/json.html
-- https://robots.thoughtbot.com/decoding-json-structures-with-elm (GOOD, uses |:)
-- http://tylerscode.com/2016/06/decoding-json-elm/ (GOOD!)
-- http://noredink.github.io/json-to-elm/
-- http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/3.0.0/
-- http://package.elm-lang.org/packages/elm-community/elm-test/latest

-- IMPORTS

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick, onInput)
import Http
import Json.Encode as Encode

import Json.Decode exposing (int, list, string, float, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)

-- TYPES

type alias Document = { title : String, author: String, text : String }
type alias Author = { name : String, identifier: String, url: String, photo_url : String }

type alias Model = {
     info: String,
     input_text: String,
     author_identifier: String,
     current_author: Author,
     author_list: List Author,
     documents: List Document,
     selectedDocument: Document
}

type Msg
  = SelectDocument Document
    | Input String
    | KeyDown Int
    | GetDocuments (Result Http.Error String)
    | GetAuthor (Result Http.Error String)

-- DECODERS

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

-- API

api : String
api = "http://localhost:4000/api/v1/"
getDocumentsUrlPrefix = api ++ "documents?author="
getAuthorUrlPrefix = api ++ "authors/"
initialDocumentsUrl = api ++ "documents/author=ezra_pound"


getDocuments : String -> Cmd Msg
getDocuments author_identifier =
  let
    url =
      getDocumentsUrlPrefix ++ author_identifier
    request =
      Http.getString url
  in
    Http.send GetDocuments request


getAuthor : String -> Cmd Msg
getAuthor author_identifier =
  let
    url =
      getAuthorUrlPrefix ++ author_identifier
    request =
      Http.getString url
  in
    Http.send GetAuthor request

-- INITIALIZATION

author1 = {name = "Ezra Pound", identifier = "ezra_pound", photo_url = "https://upload.wikimedia.org/wikipedia/commons/8/87/Ezra_Pound_2.jpg", url = "http://www.internal.org/Ezra_Pound"}

document0 = {title = "Oops!", author = "Nobody", text = "Sorry, we couldn't find that document"}

document1 = {title = "Alba", author = "Ezra Pound", text = """As cool as the pale wet leaves
     of lily-of-the-valley
She lay beside me in the dawn. """
    }
document2 = { title = "Metro", author = "Ezra Pound", text = """The apparition of these faces in the crowd;
     Petals on a wet, black bough."""
     }

initialModel : Model
initialModel = {
     info = "No messages"
     , input_text = "ezra_pound"
     , author_identifier = "ezra_pound"
     , current_author = author1
     , author_list = [author1]
     , documents = [ document1, document2 ]
     , selectedDocument = document1
  }

-- QUERY FORM

authorQueryForm : Model -> Html Msg
authorQueryForm model =
  div [ id "authorForm"] [
    label [for "author_identifier"] [text "Author"]
    , input
      [id "author_identifier"
      , type_ "text"
      , Html.Attributes.value model.input_text
      , onInput Input
      , onKeyDown KeyDown
      ]
      []
  ]

onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
  HE.on "keydown" (Json.Decode.map tagger HE.keyCode)


-- VIEW

viewDocument : Document -> Html msg
viewDocument document =
  div [] [
    p [id "heading"] [text document.title]
    ,pre [] [text document.text]
  ]

viewTitle : Document -> Document -> Html Msg
viewTitle selectedDocument document  =
  li [classList [ ( "selected", selectedDocument.title == document.title ) ]
    , onClick (SelectDocument document)
    ]
    [text document.title]

viewAuthor : Author -> Html Msg
viewAuthor  author  =
  li [] [text author.name]

view : Model -> Html Msg
view model =
    div [] [
      div [id "authors"] [
         h5 [] [text "Authors"]
         , ul [] (List.map viewAuthor model.author_list)
      ]
      ,p [id "info"] [ text model.info]
      , h1 [] [ text "Poetry" ]
      , authorQueryForm model
      , br [] []
      , img [ src model.current_author.photo_url] []
      , p [] [a [href model.current_author.url] [ text ("Poems of " ++ model.current_author.name)]]
      , ul [] (List.map (viewTitle model.selectedDocument) model.documents)
      , div [id "document"] [viewDocument model.selectedDocument]

    ]


-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      SelectDocument document ->
        ( { model | selectedDocument = document }, Cmd.none )
      Input text ->
        ( {model | input_text = text }
        , Cmd.none
        )
      KeyDown key ->
        if key == 13 then
          ( {model | author_identifier = model.input_text, info = "Enter pressed"}
          , getAuthor model.input_text
          )
        else
          ( model, Cmd.none )
      GetDocuments (Ok serverReply) ->
        case (documentsRequestDecoder serverReply) of
          (Ok documents) ->
            let selectedDocument = case List.head documents of
              (Just document) -> document
              (Nothing) -> document0
            in
               ( {model | documents =  documents, selectedDocument = selectedDocument, info = "Documents: HTTP request OK"}, Cmd.none)
          (Err _) -> ( {model | info = "Could not decode server reply"}, Cmd.none)
      GetDocuments (Err _) ->
        ( {model | info = "Error on GET: " ++ (toString Err) }, Cmd.none )
      GetAuthor (Ok serverReply) ->
        case (authorRequestDecoder serverReply) of
          (Ok author) -> ( {model | current_author =  author, info = "A.I: " ++ author.identifier}, getDocuments author.identifier)
          (Err _) -> ( {model | info = "Could not decode server reply"}, Cmd.none)
      GetAuthor (Err _) ->
        ( {model | info = "Error on GET: " ++ (toString Err) }, Cmd.none )

-- MAIN

main : Program Never Model Msg
main =
    Html.program
      { init = (initialModel, Cmd.none )
            , view = view
            , update = update
            , subscriptions = \_ -> Sub.none
    }
