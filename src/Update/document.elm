-- module Update.Document exposing(updateDocuments)
--
-- updateDocuments : Msg -> Model -> (Model, Cmd Msg)
-- updateDocuments msg model =
--   case msg of
--     SelectDocument document ->
--       ( { model | selectedDocument = document }, Cmd.none )
--     SelectAuthor author ->
--       ( { model | selectedAuthor = author }, getDocuments author.identifier )
