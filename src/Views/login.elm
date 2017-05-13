module Views.Login exposing(login)

import Types exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick, onInput)

import Json.Decode exposing (int, list, string, float, Decoder)


buttonBar model =
  div [id "buttonBar"] [
     button [onClick GoToReader] [text "Read"]
  ]

login model =
  div [] [
    buttonBar model
    , div [id "login"] [
       h3 [] [ text "Sign in"]
      , loginForm model
    ]
   ]


loginForm : Model -> Html Msg
loginForm model =
  div [ id "loginForm"] [
    input [id "email", type_ "text" , placeholder "Email", onInput Email] []
    , br [] [], br [] []
    , input [id "password", type_ "text" , placeholder "Password", onInput Password] []
    , br [] [], br [] []
    , button [ id "loginButton", onClick Login ] [text "Sign in"]
    , br [] [], br [] []
    , p [id "info"] [ text model.info ]
  ]
