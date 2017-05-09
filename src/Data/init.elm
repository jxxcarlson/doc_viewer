module Data.Init exposing(initialModel, document0)

import Types exposing(..)

author1 = {name = "Ezra Pound", identifier = "ezra_pound", photo_url = "https://upload.wikimedia.org/wikipedia/commons/8/87/Ezra_Pound_2.jpg", url = "http://www.internal.org/Ezra_Pound"}

document0 = {title = "Oops!", author = "Nobody", text = "Sorry, we couldn't find that document"}

document1 = {title = "Alba", author = "Ezra Pound", text = """As cool as the pale wet leaves
     of lily-of-the-valley
She lay beside me in the dawn. """
    }
document2 = { title = "Metro", author = "Ezra Pound", text = """The apparition of these faces in the crowd;
     Petals on a wet, black bough."""
     }

initialModel : Model
initialModel = {
     info = "No messages"
     , input_text = "ezra_pound"
     , author_identifier = "ezra_pound"
     , selectedAuthor = author1
     , authors = [author1]
     , documents = [ document1, document2 ]
     , selectedDocument = document1
  }
