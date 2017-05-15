module Utility exposing(..)

import Types exposing(Model)

signinButtonText : Model -> String
signinButtonText model =
  if model.user_token == "" then
    "Sign in"
  else
    "Sign out"
