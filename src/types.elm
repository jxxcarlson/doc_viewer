module Types exposing(..)

import Http
import Navigation

type alias Document = { title : String, author: String, text : String }
type alias DocumentId = String
type alias Author = { name : String, identifier: String, url: String, photo_url : String }

type alias Model = {
     route: Route,
     info: String,
     input_text: String,
     author_identifier: String,
     selectedAuthor: Author,
     authors: List Author,
     documents: List Document,
     selectedDocument: Document
}

type Msg
  = SelectDocument Document
    | SelectAuthor Author
    | Input String
    | KeyDown Int
    | GetDocuments (Result Http.Error String)
    | GetAuthor (Result Http.Error String)
    | GetAuthors (Result Http.Error String)
    | GetAllAuthors
    | OnLocationChange Navigation.Location
    | GoToEditor
    | GoToReader
    | GoToNewDocument

type Route
   = ReaderRoute
   | EditorRoute
   | NewDocumentRoute
   | NotFoundRoute
