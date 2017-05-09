module Views.NewDocument exposing (newDocument)

import Types exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick)


newDocument model =
  div [] [
    button [onClick GoToReader] [text "Read"]
    , h3 [] [ text "New Document"]
    , p [] [ text "Under construction ..."]
   ]
