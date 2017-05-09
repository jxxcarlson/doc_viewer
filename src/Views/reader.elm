module Views.Reader exposing(reader)

import Types exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick)

import Views.Document exposing(documentViewer)
import Views.Author exposing(authorSidebar)

reader model =
    div [] [
      p [id "info"] [ text model.info]
      , button [onClick GoToEditor] [text "Edit"]
      , button [onClick GoToNewDocument, class "anotherButton"] [text "New"]
      , authorSidebar model
      , documentViewer model
    ]
