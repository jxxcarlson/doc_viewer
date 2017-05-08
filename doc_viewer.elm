module DocumentViewer exposing (..)
-- https://github.com/mpizenberg/elm_api_test/blob/master/src/Main.elm
-- https://guide.elm-lang.org/interop/json.html
-- https://robots.thoughtbot.com/decoding-json-structures-with-elm (GOOD, uses |:)
-- http://tylerscode.com/2016/06/decoding-json-elm/ (GOOD!)
-- http://noredink.github.io/json-to-elm/
-- http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/3.0.0/
-- http://package.elm-lang.org/packages/elm-community/elm-test/latest

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick, onInput)
import Http
import Json.Encode as Encode

import Json.Decode exposing (int, list, string, float, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)

-- TYPES

type alias Document = { title : String, author: String, text : String }

type alias Model = {
     info: String,
     input_text: String,
     author_identifier: String,
     documents: List Document,
     selectedDocument: Document
}

type Msg
  = SelectDocument Document
    | Input String
    | KeyDown Int
    | GetDocuments (Result Http.Error String)

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

-- API

api : String
api = "http://localhost:4000/api/v1/"
getDocumentsUrlPrefix = api ++ "documents?author="
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

-- INITIALIZATION

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

view : Model -> Html Msg
view model =
    div [] [
      p [id "info"] [ text model.info]
      , h1 [] [ text "Poetry" ]
      , authorQueryForm model
      , p [] [ text model.author_identifier]
      , br [] []
      , img [ src "https://upload.wikimedia.org/wikipedia/commons/8/87/Ezra_Pound_2.jpg"] []
      , p [] [a [href "http://www.internal.org/Ezra_Pound"] [ text "Poems of Ezra Pound"]]
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
          , getDocuments model.input_text
          )
        else
          ( model, Cmd.none )
      GetDocuments (Ok serverReply) ->
        case (documentsRequestDecoder serverReply) of
          (Ok documents) -> ( {model | documents =  documents, info = "HTTP request OK"}, Cmd.none)
          (Err _) -> ( {model | info = "Could not decode server reply"}, Cmd.none)

      GetDocuments (Err _) ->
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
