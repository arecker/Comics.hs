{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Data.Monoid (mconcat)
import Text.Blaze.Html5 hiding (head, title)
import Text.Blaze.Html5.Attributes hiding (title)
import qualified Web.Scotty as S
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.Text
import Control.Applicative
import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import qualified Data.Text as T
import qualified Data.Text.Lazy as TL
import qualified Database.SQLite.Simple as DB
import Control.Monad
import Control.Monad.Trans.Class (lift)

data Comic = Comic { id :: Int, created :: String, title :: String, link :: String } deriving (Show)

instance FromRow Comic where
  fromRow = Comic <$> field <*> field <*> field <*> field


main = do
  scotty 3000 $ do
    get "/" $ do
      comic <- lift getLatestManager
      S.html . renderHtml $ do 
        getHome comic

    get "/archives/" $ do
      comics <- lift getArchivesManager
      S.html . renderHtml $ do 
        getArchives comics


    get "/follow/" $ do
      S.html . renderHtml $ do
        H.head $ do
          meta ! charset "UTF-8"
          H.title "Comics, Man"
          getCSS
        H.body $ do
          H.div ! class_ "container-fluid main" $ do
            getJumbotron
            getNav
            H.p $ "social networking blah blah"


    notFound $ do
      text "404, man"


getHome :: Comic -> Html
getHome comic = do
  H.head $ do
    meta ! charset "UTF-8"
    H.title "Comics, Man"
    getCSS
  H.body $ do
    H.div ! class_ "container-fluid main" $ do
      getJumbotron
      getNav
      getLatest comic

getArchives :: [Comic] -> Html
getArchives comics = do
  H.head $ do
    meta ! charset "UTF-8"
    H.title "Comics, Man | Archives"
    getCSS
  H.body $ do
    H.div ! class_ "container-fluid main" $ do
      getJumbotron
      getNav
      getTable comics


-- DB  -------------------
getLatestManager :: IO Comic
getLatestManager = do
  c <- DB.open "comics.db"
  x <- (getLatestComic c)
  close c
  return (Prelude.head (x))


getArchivesManager :: IO [Comic]
getArchivesManager = do
  c <- DB.open "comics.db"
  x <- (getAllComics c)
  close c
  return x


getAllComics :: Connection -> IO [Comic]
getAllComics connection = do
  let q = stringToQuery "SELECT id, created, title, link FROM comics"
  DB.query_ connection q


getComicById :: Connection -> Int -> IO [Comic]
getComicById connection id = do
  let q = stringToQuery ("SELECT id, created, title, link FROM comics WHERE id = '" ++ show id ++ "'")
  DB.query_ connection q


getLatestComic :: Connection -> IO [Comic]
getLatestComic connection = do
  let q = stringToQuery "SELECT id, created, title, link FROM comics ORDER BY id DESC LIMIT 1"
  DB.query_ connection q


stringToQuery :: String -> Query
stringToQuery a = Query (T.pack a)


-- Object Helpers --------
getTitle :: Comic -> String
getTitle (Comic { Main.title=t, Main.link=l, Main.created=d }) = t


getLink :: Comic -> String
getLink (Comic { Main.title=t, Main.link=l, Main.created=d }) = l


getDate :: Comic -> String
getDate (Comic { Main.title=t, Main.link=l, Main.created=d }) = d


getID :: Comic -> Int
getID (Comic { Main.title=t, Main.link=l, Main.created=d, Main.id=i }) = i


-- HTML Helpers ----------
getJumbotron :: Html
getJumbotron = H.div ! class_ "jumbotron" $ h1 "Comics, man."


getNav :: Html
getNav = do
  H.div ! class_ "nav nav-pills" $ do
    li ! class_ "" $ a ! href "/" $ "Latest"
    li $ a ! href "/archives/" $ "Everything"
    li $ a ! href "/follow/" $ "Follow"


getLatest :: Comic -> Html
getLatest comic = do
  H.div ! class_ "page-header" $ do
      H.h1 ! class_ "lead" $ (toHtml (TL.pack (getTitle comic)))
      H.p (toHtml (TL.pack (getDate comic)))
  img ! alt "" ! class_ "img-responsive" ! src (toValue(getLink comic))
  

getTable :: [Comic] -> Html
getTable comics = do
  H.div ! class_ "page-header" $ do
    H.h1 ! class_ "lead" $ "Comic Archives"
  H.table ! class_ "table" $ do
    toHtml (Prelude.map parseComicIntoArchive comics)
 

parseComicIntoArchive :: Comic -> Html
parseComicIntoArchive comic = do
  H.tr $ do
    H.td $ H.a ! href  (toValue(mconcat ["/", show (getID comic)])) $ (toHtml (TL.pack (getTitle comic)))
    H.td $ (toHtml (TL.pack (getDate comic)))


getCSS :: Html
getCSS = do
  H.link ! href "http://bootswatch.com/journal/bootstrap.min.css" ! rel "stylesheet"
  H.style ".main {max-width: 500px;margin-bottom: 3em;} .jumbotron {background-color: transparent;}"
