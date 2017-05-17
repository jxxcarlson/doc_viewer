module Utility exposing(..)

import Types exposing(Model)

signinButtonText : Model -> String
signinButtonText model =
  if model.current_user.token == "" then
    "Sign in"
  else
    "Sign out"

normalizeString : String -> String
normalizeString str =
  str |> String.trim |> String.toLower |> String.map (\c -> if c == ' ' then '_' else c)