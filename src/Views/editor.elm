module Views.Editor exposing(editor)

import Types exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick)

editor model =
  div [] [
    button [onClick GoToReader] [text "Read"]
    , button [onClick GoToNewDocument, class "anotherButton"] [text "New"]
    , h3 [] [ text "Editor"]
    , p [] [ text "Under construction ..."]
   ]
