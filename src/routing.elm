module Routing exposing(parseLocation)

import Navigation exposing (Location)
import Types exposing (Route(..))
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map ReaderRoute top
        , map EditorRoute (s "edit")
        , map NewDocumentRoute (s "new")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parsePath matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
