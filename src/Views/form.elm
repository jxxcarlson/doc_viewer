module Views.Form exposing(authorQueryForm)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick, onInput)

import Json.Decode exposing (int, list, string, float, Decoder)

-- import Types exposing(Model, Msg)
import Types exposing(..)

authorQueryForm : Model -> Html Msg
authorQueryForm model =
  div [ id "authorForm"] [
    label [for "author_identifier", id "searchLabel"] [text "Search"]
    , br [] []
    , input
      [id "author_identifier"
      , type_ "text"
      , Html.Attributes.value model.input_text
      , onInput Input
      , onKeyDown KeyDown
      ]
      []
      , button [onClick GetAllAuthors] [text "All"]
  ]

onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
  HE.on "keydown" (Json.Decode.map tagger HE.keyCode)
