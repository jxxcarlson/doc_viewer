module Action.Document exposing(..)

import Types exposing(Model, Msg, Document)
import Data.Document exposing(Documents)
import Data.Document exposing(Documents)
import Data.Init exposing(document0)
import Utility exposing(normalizeString)

updateDocuments : Model -> Documents -> (Model, Cmd Msg)
updateDocuments model documentsRecord =
  let selectedDocument = case List.head documentsRecord.documents of
    (Just document) -> document
    (Nothing) -> document0
  in
     ( {model | documents =  documentsRecord.documents,
                selectedDocument = selectedDocument,
                info = "Documents: HTTP request OK"},
        Cmd.none
      )

updateAuthor : Model -> String -> (Model, Cmd Msg)
updateAuthor model author =
  let
    oldDocument = model.selectedDocument
    newDocument = { oldDocument | title = author, author_identifier = (Utility.normalizeString author) }
  in
    ( {model | selectedDocument = newDocument}, Cmd.none )


updateTitle : Model -> String -> (Model, Cmd Msg)
updateTitle model title =
  let
    oldDocument = model.selectedDocument
    newDocument = { oldDocument | title = title, identifier = (Utility.normalizeString title) }
  in
    ( {model | selectedDocument = newDocument}, Cmd.none )