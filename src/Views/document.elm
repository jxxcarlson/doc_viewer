module Views.Document exposing(documentViewer)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick, onInput)

import Types exposing(..)

documentViewer : Model -> Html Msg
documentViewer model =
  div [id "documentViewer"] [
     h1 [id "poems_of_author"] [a [href model.selectedAuthor.url] [ text ("Poems of " ++ model.selectedAuthor.name)]]
    , ul [] (List.map (viewTitle model.selectedDocument) model.documents)
    , div [id "document"] [viewDocument model.selectedDocument]
  ]

viewDocument : Document -> Html msg
viewDocument document =
  div [] [
    p [id "heading"] [text document.title]
    ,pre [] [text document.text]
  ]

viewTitle : Document -> Document -> Html Msg
viewTitle selectedDocument document  =
  li [classList [ ( "selected", selectedDocument.title == document.title ) ]
    , onClick (SelectDocument document)
    ]
    [text document.title]
