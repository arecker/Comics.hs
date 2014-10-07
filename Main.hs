{-# LANGUAGE OverloadedStrings #-}

import Database.SQLite.Simple
import qualified Data.Text as T
import Control.Monad


main = do
	conn <- open "comics.db"
	xs <- query_ conn "select created, title, link from comics"
	forM_ xs $ \(created, title, link) ->
		putStrLn $ T.unpack title ++ " : " ++ link ++ " : " ++ created


getAllComicsInOrder = do
	conn <- open "comics.db"
	query_ conn "SELECT created, title, link FROM comics"