{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Data.Monoid (mconcat)
import Text.Blaze.Html5
import Text.Blaze.Html5.Attributes
import qualified Web.Scotty as S
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.Text


main = do
  scotty 3000 $ do
    get "/" $ do
      S.html . renderHtml $ do
        getHead
        h1 "Home"


getHead = do
  H.head $ do
    H.title "Comics"
    getBootstrap


getBootstrap = link ! href "http://bootswatch.com/journal/bootstrap.min.css" ! rel "stylesheet"
