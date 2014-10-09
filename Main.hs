{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Data.Monoid (mconcat)
import Control.Monad (forM_)
import Text.Blaze.Html5
import Text.Blaze.Html5.Attributes
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
      title <- lift getLatestManager
      S.html . renderHtml $ do 
        getHome title

    get "/archives/" $ do
      S.html . renderHtml $ do getArchives

    --get "/test" $ do
    --  title <- lift dbHelper
    --  text title

    notFound $ do
      text "404, man"


--getHome :: Html
getHome variable = do
  H.head $ do
    meta ! charset "UTF-8"
    H.title "Comics, Man"
    getCSS
  H.body $ do
    H.div ! class_ "container-fluid main" $ do
      getJumbotron
      getNav
      getLatest
      H.p (toHtml variable)

getArchives :: Html
getArchives = do
  H.head $ do
    meta ! charset "UTF-8"
    H.title "Comics, Man | Archives"
    getCSS
  H.body $ do
    H.div ! class_ "container-fluid main" $ do
      getJumbotron
      getNav


-- DB  -------------------
getLatestManager = do
  c <- DB.open "comics.db"
  x <- (getLatestComic c)
  return $ TL.pack (getTitle (Prelude.head (x)))


getAllComics :: Connection -> IO [Comic]
getAllComics connection = do
  let q = stringToQuery "SELECT id, created, title, link FROM comics"
  DB.query_ connection q :: IO [Comic]


getComicById :: Connection -> Int -> IO [Comic]
getComicById connection id = do
  let q = stringToQuery ("SELECT id, created, title, link FROM comics WHERE id = '" ++ (show id) ++ "'")
  results <- DB.query_ connection q :: IO [Comic]
  return results


getLatestComic :: Connection -> IO [Comic]
getLatestComic connection = do
  let q = stringToQuery ("SELECT id, created, title, link FROM comics ORDER BY id DESC LIMIT 1")
  results <- DB.query_ connection q :: IO [Comic]
  return results


stringToQuery :: [Char] -> Query
stringToQuery a = Query (T.pack a)


-- Object Helpers --------
getTitle :: Comic -> String
getTitle (Comic { Main.title=t, Main.link=l}) = t


getLink :: Comic -> String
getLink (Comic { Main.title=t, Main.link=l}) = l


-- HTML Helpers ----------
getJumbotron :: Html
getJumbotron = H.div ! class_ "jumbotron" $ h1 "Comics, man."


getNav :: Html
getNav = do
  H.div ! class_ "nav nav-pills" $ do
    li ! class_ "active" $ a ! href "/" $ "Latest"
    li $ a ! href "/archives/" $ "Everything"
    li $ a ! href "/follow/" $ "Follow"


getLatest :: Html
getLatest = do
  H.div ! class_ "page-header" $ do
      h1 ! class_ "lead" $ "Mitochondrial Eve"
      p "October 5, 2014"
  img ! src "http://www.explosm.net/db/files/Comics/Dave/EVE.png" ! alt "" ! class_ "img-responsive"
  
          
getCSS :: Html
getCSS = do
  H.link ! href "http://bootswatch.com/journal/bootstrap.min.css" ! rel "stylesheet"
  H.style ".main {max-width: 500px;margin-bottom: 3em;} .jumbotron {background-color: transparent;}"
