module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Types exposing(..)
import Views.Document exposing(documentViewer)
import Views.Author exposing(authorSidebar)

import Request.Author exposing(..)
import Request.Document exposing(..)

import Data.Author exposing(..)
import Data.Document exposing(..)
import Data.Init exposing(initialModel, document0)

view : Model -> Html Msg
view model =
    div [] [
      p [id "info"] [ text model.info]
      , authorSidebar model
      , documentViewer model
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

main : Program Never Model Msg
main =
    Html.program
      { init = (initialModel, Cmd.none )
            , view = view
            , update = update
            , subscriptions = \_ -> Sub.none
    }
