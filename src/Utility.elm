module Utility exposing(..)

import Types exposing(Model)

signinButtonText : Model -> String
signinButtonText model =
  if model.current_user.token == "" then
    "Sign in"
  else
    "Sign out"
