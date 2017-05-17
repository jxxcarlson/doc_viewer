module Views.Editor exposing(editor)
import Json.Decode exposing (int, list, string, float, Decoder)

import Types exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick)

import Css exposing(asPairs)

styles =
    Css.asPairs >> Html.Attributes.style

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
      , editorInputsPane model
      , editorTextPane model
    ]
   ]

editorTextPane : Model -> Html Msg
editorTextPane model =
  div [] [
      textarea [id "editor_text"
      , Html.Attributes.value model.selectedDocument.text
      , HE.onInput UpdateSelectedDocument
      , onKeyDown KeyDown]
      [ ]
    ]

editorInputsPane : Model -> Html Msg
editorInputsPane model =
  div [styles [ Css.marginBottom (Css.px 12), Css.fontSize (Css.em 1.2) ]] [
    label [for "title_input", id "title_input_label"] [text "Title"]
    , input [styles [ Css.fontSize (Css.em 1.0) ],
        type_ "text" , value model.selectedDocument.title, HE.onInput InputTitle] []
    , input [styles [ Css.fontSize (Css.em 1.0) ],
            type_ "text" , value model.selectedDocument.author, HE.onInput InputAuthor] []
    , span [styles [ Css.marginLeft (Css.px 12), Css.fontSize (Css.em 0.6) ]] [text model.selectedDocument.author_identifier]
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
