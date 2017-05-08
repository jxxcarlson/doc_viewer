module DocumentViewer exposing (..)

-- https://github.com/mpizenberg/elm_api_test/blob/master/src/Main.elm
-- https://guide.elm-lang.org/interop/json.html
-- https://robots.thoughtbot.com/decoding-json-structures-with-elm (GOOD, uses |:)
-- http://tylerscode.com/2016/06/decoding-json-elm/ (GOOD!)
-- http://noredink.github.io/json-to-elm/
-- http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/3.0.0/

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE exposing(onClick, onInput)
import Http
import Json.Encode as Encode
-- import Json.Decode as Decode exposing(..)

import Json.Decode as Decode exposing (int, string, float, Decoder)
import Json.Decode.Pipeline as Decode exposing (decode, required, optional, hardcoded)

type alias Document = { title : String, author: String, text : String }

foo = """
[{"updated_at":"2017-05-06T21:19:05.085975","title":"Alba","text":"As cool as the pale wet leaves\n     of lily-of-the-valley\nShe lay beside me in the dawn.\n","inserted_at":"2017-05-06T21:19:05.028019","identifier":"alba","id":1,"author_identifier":"ezra_pound","author":"Ezra Pound"},{"updated_at":"2017-05-06T21:20:38.836250","title":"Metro","text":"The apparition of these faces in the crowd;\nPetals on a wet, black bough.\n","inserted_at":"2017-05-06T21:20:38.836241","identifier":"metro","id":2,"author_identifier":"ezra_pound","author":"Ezra Pound"},{"updated_at":"2017-05-06T22:01:14.888420","title":"A Pact","text":"I make a pact with you, Walt Whitman--\nI have detested you long enough.\nI come to you as a grown child\nWho has had a pig-headed father;\nI am old enough now to make friends.\nIt was you that broke the new wood,\nNow is a time for carving.\nWe have one sap and one root--\nLet there be commerce between us.\n","inserted_at":"2017-05-06T22:01:14.884513","identifier":"pact","id":3,"author_identifier":"ezra_pound","author":"Ezra Pound"},{"updated_at":"2017-05-07T07:01:14.884513","title":"In the Old Age of the Soul","text":"I do not choose to dream; there cometh on me\nSome strange old lust for deeds.\nAs to the nerveless hand of some old warrior\nThe sword-hilt or the war-worn wonted helmet\nBrings momentary life and long-fled cunning,\nSo to my soul grown old - \nGrown old with many a jousting, many a foray, \nGrown old with namy a hither-coming and hence-going - \nTill now they send him dreams and no more deed;\nSo doth he flame again with might for action,\nForgetful of the council of elders,\nForgetful that who rules doth no more battle,\nForgetful that such might no more cleaves to him\nSo doth he flame again toward valiant doing.","inserted_at":"2017-05-07T07:01:14.884513","identifier":"old_age_soul","id":6,"author_identifier":"ezra_pound","author":"Ezra Pound"},{"updated_at":"2017-05-05T07:01:14.884513","title":"Canto I","text":"And then went down to the ship,\nSet keel to breakers, forth on the godly sea, and\nWe set up mast and sail on that swart ship,\nBore sheep aboard her, and our bodies also\nHeavy with weeping, and winds from sternward\nBore us onward with bellying canvas,\nCrice's this craft, the trim-coifed goddess.\nThen sat we amidships, wind jamming the tiller,\nThus with stretched sail, we went over sea till day's end.\nSun to his slumber, shadows o'er all the ocean,\nCame we then to the bounds of deepest water,\nTo the Kimmerian lands, and peopled cities\nCovered with close-webbed mist, unpierced ever\nWith glitter of sun-rays\nNor with stars stretched, nor looking back from heaven\nSwartest night stretched over wreteched men there.\nThe ocean flowing backward, came we then to the place\nAforesaid by Circe.\nHere did they rites, Perimedes and Eurylochus,\nAnd drawing sword from my hip\nI dug the ell-square pitkin;\nPoured we libations unto each the dead,\nFirst mead and then sweet wine, water mixed with white flour\nThen prayed I many a prayer to the sickly death's-heads;\nAs set in Ithaca, sterile bulls of the best\nFor sacrifice, heaping the pyre with goods,\nA sheep to Tiresias only, black and a bell-sheep.\nDark blood flowed in the fosse,\nSouls out of Erebus, cadaverous dead, of brides\nOf youths and of the old who had borne much;\nSouls stained with recent tears, girls tender,\nMen many, mauled with bronze lance heads,\nBattle spoil, bearing yet dreory arms,\nThese many crowded about me; with shouting,\nPallor upon me, cried to my men for more beasts;\nSlaughtered the herds, sheep slain of bronze;\nPoured ointment, cried to the gods,\nTo Pluto the strong, and praised Proserpine;\nUnsheathed the narrow sword,\nI sat to keep off the impetuous impotent dead,\nTill I should hear Tiresias.\nBut first Elpenor came, our friend Elpenor,\nUnburied, cast on the wide earth,\nLimbs that we left in the house of Circe,\nUnwept, unwrapped in the sepulchre, since toils urged other.\nPitiful spirit. And I cried in hurried speech:\n\"Elpenor, how art thou come to this dark coast?\n\"Cam'st thou afoot, outstripping seamen?\"\n        And he in heavy speech:\n\"Ill fate and abundant wine. I slept in Crice's ingle.\n\"Going down the long ladder unguarded,\n\"I fell against the buttress,\n\"Shattered the nape-nerve, the soul sought Avernus.\n\"But thou, O King, I bid remember me, unwept, unburied,\n\"Heap up mine arms, be tomb by sea-bord, and inscribed:\n\"A man of no fortune, and with a name to come.\n\"And set my oar up, that I swung mid fellows.\"\n\nAnd Anticlea came, whom I beat off, and then Tiresias Theban,\nHolding his golden wand, knew me, and spoke first:\n\"A second time? why? man of ill star,\n\"Facing the sunless dead and this joyless region?\n\"Stand from the fosse, leave me my bloody bever\n\"For soothsay.\"\n        And I stepped back,\nAnd he strong with the blood, said then: \"Odysseus\n\"Shalt return through spiteful Neptune, over dark seas,\n\"Lose all companions.\" Then Anticlea came.\nLie quiet Divus. I mean, that is Andreas Divus,\nIn officina Wecheli, 1538, out of Homer.\nAnd he sailed, by Sirens and thence outwards and away\nAnd unto Crice.\n        Venerandam,\nIn the Cretan's phrase, with the golden crown, Aphrodite,\nCypri munimenta sortita est, mirthful, oricalchi, with golden\nGirdle and breat bands, thou with dark eyelids\nBearing the golden bough of Argicidia. So that:","inserted_at":"2017-05-05T07:01:14.884513","identifier":"canto_i","id":5,"author_identifier":"ezra_pound","author":"Ezra Pound"}]
"""

nullDocument : Document
nullDocument = { title = "Undefined", author = "Nobody", text = "No content"}

documentsDecoder : Decoder (List Document)
documentsDecoder = Decode.list documentDecoder

documentDecoder : Decoder Document
documentDecoder =
  decode Document
    |> Decode.required "title" string
    |> Decode.required "author" string
    |> Decode.required "text" string

type alias Model = {
     info: String,
     input_text: String,
     author_identifier: String,
     documents: List Document,
     selectedDocument: Document
}
-- type alias Msg = { operation : String, data : Document }

type Msg
  = SelectDocument Document
    | Input String
    | KeyDown Int

api : String
api = "http://localhost:4000/api/v1/"
getDocumentsUrlPrefix = api ++ "documents?author="

initialDocumentsUrl = api ++ "documents/author=ezra_pound"

getInitialDocumentSet : Http.Request String
getInitialDocumentSet =
  Http.getString initialDocumentsUrl

document1 = {title = "Alba", author = "Ezra Pound", text = """As cool as the pale wet leaves
     of lily-of-the-valley
She lay beside me in the dawn. """
    }
document2 = { title = "Metro", author = "Ezra Pound", text = """The apparition of these faces in the crowd;
     Petals on a wet, black bough."""
     }
document3 = { title = "A Pact", author = "Ezra Pound", text = """I make a pact with you, Walt Whitman--
              I have detested you long enough.
              I come to you as a grown child
              Who has had a pig-headed father;
              I am old enough now to make friends.
              It was you that broke the new wood,
              Now is a time for carving.
              We have one sap and one root--
              Let there be commerce between us.
              """
     }


(Ok, docs) = Decode.decodeString documentsDecoder foo

initialModel : Model
initialModel = {
     info = "No messages"
     , input_text = "ezra_pound"
     , author_identifier = "ezra_pound"
     , documents = docs
     , selectedDocument = document1
  }

authorQueryForm : Model -> Html Msg
authorQueryForm model =
  div [ id "authorForm"] [
    label [for "author_identifier"] [text "Author"]
    , input
      [id "author_identifier"
      , type_ "text"
      , Html.Attributes.value model.input_text
      , onInput Input
      , onKeyDown KeyDown
      ]
      []
  ]

onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
  HE.on "keydown" (Decode.map tagger HE.keyCode)


viewDocument : Document -> Html msg
viewDocument document =
  div [] [
    p [id "heading"] [text document.title]
    ,pre [] [text document.text]
  ]

viewTitle : Document -> Document -> Html Msg
viewTitle selectedDocument document  =
  li [classList [ ( "selected", selectedDocument.title == document.title ) ]
    , onClick (SelectDocument document)
    ]
    [text document.title]

view : Model -> Html Msg
view model =
    div [] [
      p [] [ text model.info]
      , br [] []
      , h1 [] [ text "Poetry" ]
      , authorQueryForm model
      , p [] [ text model.author_identifier]
      , br [] []
      , img [ src "https://upload.wikimedia.org/wikipedia/commons/8/87/Ezra_Pound_2.jpg"] []
      , p [] [a [href "http://www.internal.org/Ezra_Pound"] [ text "Poems of Ezra Pound"]]
      , ul [] (List.map (viewTitle model.selectedDocument) model.documents)
      , div [] [viewDocument model.selectedDocument]
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      SelectDocument document ->
        ( { model | selectedDocument = document }, Cmd.none )
      Input text ->
        ( {model | input_text = text }
        , Cmd.none
        )
      KeyDown key ->
        if key == 13 then
          ( {model | author_identifier = model.input_text}
          , Cmd.none
          )
        else
          ( model, Cmd.none )

main : Program Never Model Msg
main =
    Html.program
      { init = (initialModel, Cmd.none )
            , view = view
            , update = update
            , subscriptions = \_ -> Sub.none
    }
