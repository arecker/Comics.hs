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


main = do
  scotty 3000 $ do
    get "/" $ do
      S.html . renderHtml $ do getHome

    get "/archives/" $ do
      S.html . renderHtml $ do getArchives


getHome :: Html
getHome = do
  H.head $ do
    meta ! charset "UTF-8"
    H.title "Comics, Man"
    getCSS
  H.body $ do
    H.div ! class_ "container-fluid main" $ do
      getJumbotron
      getNav
      getLatest


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
      H.p "hello"


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
  link ! href "http://bootswatch.com/journal/bootstrap.min.css" ! rel "stylesheet"
  H.style ".main {max-width: 500px;margin-bottom: 3em;} .jumbotron {background-color: transparent;}"


getBootstrap :: Html
getBootstrap = link ! href "http://bootswatch.com/journal/bootstrap.min.css" ! rel "stylesheet"


getCustomCSS :: Html
getCustomCSS = H.style ".main {max-width: 500px;margin-bottom: 3em;} .jumbotron {background-color: transparent;}"