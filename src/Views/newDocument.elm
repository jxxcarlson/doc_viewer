module Views.NewDocument exposing (newDocument)

import Types exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick)

buttonBar model =
  div [id "buttonBar"] [
     button [onClick GoToReader] [text "Read"]
     , button [onClick GoToEditor, class "anotherButton"] [text "Edit"]
  ]

newDocument model =
  div [] [
    buttonBar model,
    div [id "newDocument"] [
      h3 [] [ text "New Document"]
      , p [] [ text "Under construction ..."]
    ]
   ]
