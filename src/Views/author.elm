module Views.Author exposing(authorSidebar)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick, onInput)

import Types exposing(..)
import Views.Form exposing(authorQueryForm)

authorSidebar : Model -> Html Msg
authorSidebar model =
  div [id "authors"] [
     h3 [] [text "Authors"]
     , authorQueryForm model
     , br [] []
     , ul [] (List.map (viewAuthor model.selectedAuthor) model.authors)
  ]



viewAuthor : Author -> Author -> Html Msg
viewAuthor  selectedAuthor author  =
  li [classList [ ( "selected", selectedAuthor.name == author.name ) ]
    , onClick (SelectAuthor author)
    ] [text author.name]
