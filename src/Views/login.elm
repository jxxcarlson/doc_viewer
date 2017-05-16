module Views.Login exposing(signin)

import Types exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick, onInput)

import Json.Decode exposing (int, list, string, float, Decoder)

signin : Model -> Html Msg
signin model =
  if model.current_user.token == "" then
    if model.registerUser == True then
      registerUserView model
    else
      signinView model
  else
    signoutView model


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
      , button [onClick ToggleRegister] [text "Need to register?"]
    ]
   ]

registerUserView : Model -> Html Msg
registerUserView model =
    div [] [
    buttonBar model
    , div [id "login"] [
       h3 [] [ text "Sign up"]
      , registerUserForm model
      , button [onClick ToggleRegister] [text "Need to sign in?"]
    ]
   ]


signinForm : Model -> Html Msg
signinForm model =
  div [ id "loginForm"] [
    input [id "email", type_ "text" , placeholder "Email", onInput Email] []
    , br [] [], br [] []
    , input [id "password", type_ "text" , placeholder "Password", onInput Password] []
    , br [] [], br [] []
    , button [ id "loginButton", onClick Login ] [text "Sign in"]
    , br [] [], br [] []
    , p [id "info"] [ text model.info ]
  ]

registerUserForm : Model -> Html Msg
registerUserForm model =
   div [ id "loginForm"] [
     input [id "name", type_ "text" , placeholder "Your name", onInput Name] []
     , br [] [], br [] []
     , input [id "username", type_ "text" , placeholder "Username", onInput Username] []
     , br [] [], br [] []
     , input [id "email", type_ "text" , placeholder "Email", onInput Email] []
     , br [] [], br [] []
     , input [id "password", type_ "text" , placeholder "Password", onInput Password] []
     , br [] [], br [] []
     , button [ id "loginButton", onClick Register ] [text "Si                                                                                 gn up"]
     , br [] [], br [] []
     , p [id "info"] [ text model.info ]
   ]


signoutView : Model -> Html Msg
signoutView model =
  div [] [
    buttonBar model
    , div [id "login"] [
       p [id "username"] [ text ("Signed in as " ++ model.current_user.username)]
      , br [] [], br [] []
      , button [ id "logoutButton", onClick Signout ] [text "Sign out"]
      , p [id "info"] [ text model.info ]
    ]
  ]
