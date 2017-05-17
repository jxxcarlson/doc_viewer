module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation exposing(Location)

import Types exposing(..)
import Views.Document exposing(documentViewer)
import Views.Author exposing(authorSidebar)

import Request.Author exposing(..)
import Request.Document exposing(..)

import Views.Reader exposing(reader)
import Views.Editor exposing(editor)
import Views.NewDocument exposing(newDocument)
import Views.Login exposing(signin)

import Data.Author exposing(..)
import Data.Document exposing(..)
import Data.Init exposing(initialModel, document0)

import Request.User exposing(loginUserCmd, getTokenCompleted, registerUserCmd)
import Request.Api exposing(loginUrl, registerUserUrl)

import Action.Document exposing(updateDocuments)
import Action.User exposing(..)

import Utility exposing(normalizeString)

-- import Routing exposing(parseLocation)

-- The view is a function of the current page
view : Model -> Html Msg
view model =
  div [] [ page model ]

page : Model -> Html Msg
page model =
  case model.page of
    ReaderPage ->
      reader model
    EditorPage ->
      editor model
    NewDocumentPage ->
      newDocument model
    LoginPage ->
      signin model
    NotFoundPage ->
      notFound model

notFound model =
  div [] [
    h3 [] [ text "Not Found"]
   ]


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of

      SelectDocument document ->
        ( { model | selectedDocument = document }, Cmd.none )
      SelectAuthor author ->
        ( { model | selectedAuthor = author }, getDocuments author.identifier )

      Input text ->
        ( {model | input_text = text }
        , Cmd.none
        )
      KeyDown key ->
        if key == 13 then
          ( {model | author_identifier = model.input_text, info = "Enter pressed"}
          , getAuthors model.input_text  -- getAuthor model.input_text
          )
        else
          ( model, Cmd.none )

      GetDocuments (Ok serverReply) ->
        case (documents serverReply) of
          (Ok documentsRecord) ->
            updateDocuments model documentsRecord
          (Err _) -> ( {model | info = "Could not decode server reply"}, Cmd.none)
      GetDocuments (Err _) ->
        ( {model | info = "Error on GET: " ++ (toString Err) }, Cmd.none )


      GetAuthor (Ok serverReply) ->
        case (author serverReply) of
          (Ok authorRecord) -> ( {model | selectedAuthor =  authorRecord },
             getDocuments authorRecord.identifier)
          (Err _) -> ( {model | info = "Could not decode server reply"}, Cmd.none)
      GetAuthor (Err _) ->
        ( {model | info = "Error on GET: " ++ (toString Err) }, Cmd.none )


      GetAuthors (Ok serverReply) ->
        case (authors serverReply) of
          (Ok authorsRecord) -> ( {model | authors =  authorsRecord.authors, info = "Author list loaded"}, Cmd.none)
          (Err _) -> ( {model | info = "Could not decode server reply"}, Cmd.none)
      GetAuthors (Err _) ->
        ( {model | info = "Error on GET: " ++ (toString Err) }, Cmd.none )-- MAIN
      GetAllAuthors ->
        ( {model | input_text = "all" } , getAuthors "all" )


      GoToEditor ->
        ( {model | page = EditorPage }, Cmd.none )
      GoToReader ->
        ( {model | page = ReaderPage, info = "" }, Cmd.none )
      GoToNewDocument ->
        ( {model | page = NewDocumentPage }, Cmd.none )
      GoToLogin ->
        ( {model | page = LoginPage }, Cmd.none )
      ToggleRegister ->
        ( {model | registerUser = not model.registerUser }, Cmd.none )

      InputTitle title ->
        Action.Document.updateTitle model title

      InputAuthor author ->
        Action.Document.updateAuthor model author
        

      Name name ->
        updateName model name
      Username username ->
        updateUsername model username
      Email email ->
        updateEmail model email
      Password password ->
        updatePassword model password
      Login ->
        ( model, loginUserCmd model loginUrl )
      Register ->
              ( model, registerUserCmd model registerUserUrl )
      GetTokenCompleted result ->
        getTokenCompleted model result
      Signout ->
        signout model



      UpdateSelectedDocument text ->
        let
          currentDocument  = model.selectedDocument
          updatedDocument = { currentDocument | text = text }
        in ( { model | selectedDocument = updatedDocument }, Cmd.none)
      -- OnLocationChange location ->
      --   let
      --     newRoute =
      --       parseLocation location
      --   in
      --     ( { model | route = newRoute, info = "location change" }, Cmd.none )

main : Program Never Model Msg
main =
    Html.program
      { init = (initialModel, Cmd.none )
            , view = view
            , update = update
            , subscriptions = \_ -> Sub.none
    }
