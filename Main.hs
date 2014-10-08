{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Control.Applicative
import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import qualified Data.Text as T
import Control.Monad



data Comic = Comic { id :: Int, created :: String, title :: String, link :: String } deriving (Show)

instance FromRow Comic where
	fromRow = Comic <$> field <*> field <*> field <*> field


main = do
	conn <- open "comics.db"
	let results = getAllComics conn
	close conn


getAllComics :: Connection -> IO [Comic]
getAllComics connection = do
	let q = stringToQuery "SELECT id, created, title, link FROM comics"
	query_ connection q :: IO [Comic]


getComicById :: Connection -> Int -> IO [Comic]
getComicById connection id = do
	let q = stringToQuery ("SELECT id, created, title, link FROM comics WHERE id = '" ++ (show id) ++ "'")
	results <- query_ connection q :: IO [Comic]
	return results


getLatestComic :: Connection -> IO [Comic]
getLatestComic connection = do
	let q = stringToQuery ("SELECT id, created, title, link FROM comics ORDER BY id DESC LIMIT 1")
	results <- query_ connection q :: IO [Comic]
	return results


getTitle :: Comic -> String
getTitle (Comic { title=t, link=l}) = t


getLink :: Comic -> String
getLink (Comic { title=t, link=l}) = l
	

stringToQuery :: [Char] -> Query
stringToQuery a = Query (T.pack a)