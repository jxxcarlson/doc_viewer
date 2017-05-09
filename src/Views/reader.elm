module Views.Reader exposing(reader)

import Types exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick)

import Views.Document exposing(documentViewer)
import Views.Author exposing(authorSidebar)

buttonBar model =
  div [id "buttonBar"] [
     button [onClick GoToEditor] [text "Edit"]
   , button [onClick GoToNewDocument, class "anotherButton"] [text "New"]
  ]

reader model =
    div [id "reader"] [
      -- p [id "info"] [ text model.info]
       buttonBar model     
       , authorSidebar model
       , documentViewer model
    ]
