module Views.Login exposing(signin)

import Types exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick, onInput)

import Json.Decode exposing (int, list, string, float, Decoder)


buttonBar model =
  div [id "buttonBar"] [
     button [onClick GoToReader] [text "Read"]
  ]

signinView : Model -> Html Msg
signinView model =
    div [] [
    buttonBar model
    , div [id "login"] [
       h3 [] [ text "Sign in"]
      , signinForm model
    ]
   ]

signin : Model -> Html Msg
signin model =
  if model.user_token == "" then
    signinView model
  else
    signoutView model


signinForm : Model -> Html Msg
signinForm model =
  div [ id "loginForm"] [
    input [id "email", type_ "text" , placeholder "Email", onInput Email] []
    , br [] [], br [] []
    , input [id "password", type_ "text" , placeholder "Password", onInput Password] []
    , br [] [], br [] []
    , button [ id "loginButton", onClick Login ] [text "Sign in"]
    , br [] [], br [] []
    , p [id "info"] [ text ("Token: " ++ model.user_token) ]
  ]

signoutView : Model -> Html Msg
signoutView model =
  div [] [
    buttonBar model
    , div [id "login"] [
       p [id "username"] [ text ("Signed in as " ++ model.username)]
      , br [] [], br [] []
      , button [ id "logoutButton", onClick Signout ] [text "Sign out"]
      , p [id "info"] [ text model.info ]
    ]
  ]
