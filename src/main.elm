module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation exposing(Location)

import Types exposing(..)
import Views.Document exposing(documentViewer)
import Views.Author exposing(authorSidebar)

import Request.Author exposing(..)
import Request.Document exposing(..)

import Views.Reader exposing(reader)
import Views.Editor exposing(editor)
import Views.NewDocument exposing(newDocument)

import Data.Author exposing(..)
import Data.Document exposing(..)
import Data.Init exposing(initialModel, document0)

import Routing exposing(parseLocation)

view : Model -> Html Msg
view model =
  div [] [ page model ]

page model =
  case model.route of
    ReaderRoute ->
      reader model
    EditorRoute ->
      editor model
    NewDocumentRoute ->
      newDocument model
    NotFoundRoute ->
      notFound model

notFound model =
  div [] [
    h3 [] [ text "Not Found"]
   ]


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      SelectDocument document ->
        ( { model | selectedDocument = document }, Cmd.none )
      SelectAuthor author ->
        ( { model | selectedAuthor = author }, getDocuments author.identifier )

      Input text ->
        ( {model | input_text = text }
        , Cmd.none
        )
      KeyDown key ->
        if key == 13 then
          ( {model | author_identifier = model.input_text, info = "Enter pressed"}
          , getAuthors model.input_text  -- getAuthor model.input_text
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
          (Ok author) -> ( {model | selectedAuthor =  author, info = "A.I: " ++ author.identifier}, getDocuments author.identifier)
          (Err _) -> ( {model | info = "Could not decode server reply"}, Cmd.none)
      GetAuthor (Err _) ->
        ( {model | info = "Error on GET: " ++ (toString Err) }, Cmd.none )
      GetAuthors (Ok serverReply) ->
        case (authorsRequestDecoder serverReply) of
          (Ok authors) -> ( {model | authors =  authors, info = "Author list loaded"}, Cmd.none)
          (Err _) -> ( {model | info = "Could not decode server reply"}, Cmd.none)
      GetAuthors (Err _) ->
        ( {model | info = "Error on GET: " ++ (toString Err) }, Cmd.none )-- MAIN
      GetAllAuthors ->
        ( {model | input_text = "all" } , getAuthors "all" )
      GoToEditor ->
        ( {model | route = EditorRoute }, Cmd.none )
      GoToReader ->
        ( {model | route = ReaderRoute }, Cmd.none )
      GoToNewDocument ->
        ( {model | route = NewDocumentRoute }, Cmd.none )
      OnLocationChange location ->
        let
          newRoute =
            parseLocation location
        in
          ( { model | route = newRoute, info = "location change" }, Cmd.none )

main : Program Never Model Msg
main =
    Html.program
      { init = (initialModel, Cmd.none )
            , view = view
            , update = update
            , subscriptions = \_ -> Sub.none
    }
