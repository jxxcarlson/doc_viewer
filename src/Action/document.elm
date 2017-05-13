module Action.Document exposing(updateDocuments)

import Types exposing(Model, Msg, Document)
import Data.Document exposing(Documents)
import Data.Document exposing(Documents)
import Data.Init exposing(document0)

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
