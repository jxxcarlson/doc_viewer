module Views.Editor exposing(editor)
import Json.Decode exposing (int, list, string, float, Decoder)

import Types exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick)

buttonBar model =
  div [id "buttonBar"] [
     button [onClick GoToReader] [text "Read"]
     , button [onClick GoToNewDocument, class "anotherButton"] [text "New"]
  ]

editor : Model -> Html Msg
editor model =
  div [] [
    buttonBar model
    , div [id "editor"] [
       editorTools model
      , textarea [id "editor_text"
      , Html.Attributes.value model.input_text
      , HE.onInput Input
      , onKeyDown KeyDown]
      [ ]
    ]
   ]

editorTools : Model -> Html Msg
editorTools model =
  div [id "toolBar"] [
    span [id "buttonBarTitle", class "toolBarItem"] [text "Editor"]
    , button [id "saveEditButton"] [text "Save"]
  ]

onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
  HE.on "keydown" (Json.Decode.map tagger HE.keyCode)
