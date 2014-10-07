{-# LANGUAGE OverloadedStrings #-}

import Control.Applicative
import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import qualified Data.Text as T
import Control.Monad


data Comic = Comic { title :: String, link :: String } deriving (Show)

instance FromRow Comic where
	fromRow = Comic <$> field <*> field


main = do
	conn <- open "comics.db"
	let results = getAllComics conn
	close conn


getAllComics :: Connection -> IO [Comic]
getAllComics connection = do
	let q = stringToQuery "SELECT title, link FROM comics"
	query_ connection q :: IO [Comic]


getTitle :: Comic -> String
getTitle (Comic { title=t, link=l}) = t


getLink :: Comic -> String
getLink (Comic { title=t, link=l}) = l
	

stringToQuery :: [Char] -> Query
stringToQuery a = Query (T.pack a)