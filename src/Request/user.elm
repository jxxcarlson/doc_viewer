module Request.User exposing(..)

-- https://auth0.com/blog/creating-your-first-elm-app-part-2/

import Http exposing (send)
import Json.Decode as Decode exposing (..)
import Jwt exposing(decodeToken)

import Request.Api exposing(loginUrl)
import Data.User exposing(userEncoder, jwtDecoder)
import Types exposing(..)


loginUserCmd : Model -> String -> Cmd Msg
loginUserCmd model loginUrl =
    Http.send GetTokenCompleted (loginUser model loginUrl)

-- http://package.elm-lang.org/packages/elm-lang/http/1.0.0/Http#
-- http://package.elm-lang.org/packages/elm-lang/http/1.0.0/Http#send
-- http://stackoverflow.com/questions/12320467/jquery-cors-content-type-options
-- http://www.html5rocks.com/en/tutorials/cors/


loginUser : Model -> String -> Http.Request String
loginUser model loginUrl =
    let
        body =
            model
                |> userEncoder
                |> Http.jsonBody
    in
        Http.post loginUrl body tokenDecoder


getTokenCompleted : Model -> Result Http.Error String -> ( Model, Cmd Msg )
getTokenCompleted model result =
    case result of
        Ok newToken ->
           case Jwt.decodeToken jwtDecoder newToken of
             Ok value -> ({model | username = value.username, info = "User: " ++ value.username}, Cmd.none)
             Err error ->({model | info = toString error}, Cmd.none)
        Err error ->
            ( { model | errorMsg = (toString error),
               info = (toString error)} , Cmd.none )

-- |> Debug.log "error in getTokenCompleted"

tokenDecoder : Decoder String
tokenDecoder =
    Decode.field "token" Decode.string
