module Views.Editor exposing(editor)

import Types exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick)

buttonBar model =
  div [id "buttonBar"] [
     button [onClick GoToReader] [text "Read"]
     , button [onClick GoToNewDocument, class "anotherButton"] [text "New"]
  ]

editor model =
  div [] [
    buttonBar model
    , div [id "editor"] [
       h3 [] [ text "Editor"]
      , p [] [ text "Under construction ..."]
    ]
   ]
