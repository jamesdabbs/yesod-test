{-# LANGUAGE OverloadedStrings #-}
import Control.Monad.Logger (runStdoutLoggingT)
import Data.Conduit (runResourceT)
import qualified Data.Text as T
import qualified Database.Persist
import System.Environment (getArgs)
import Text.CSV
import Yesod.Default.Config

import Import
import Settings
import Model


importSpace (id : name : desc : _) =
  insert_ $ Space (T.pack name) (T.pack desc)
importSpace _ =
  liftIO . putStrLn $ "Could not parse `id : name : desc : _` from line"

qs spaces = do
  liftIO . putStrLn $ "Clearing spaces"
  deleteWhere ([] :: [Filter Space])
  liftIO . putStrLn $ "Importing spaces from file"
  mapM_ importSpace spaces

main :: IO ()
main = do
  -- Set up the connection pool
  conf   <- Yesod.Default.Config.loadConfig $ configSettings Development
  dbconf <- withYamlEnvironment "config/sqlite.yml" (appEnv conf)
            Database.Persist.loadConfig >>=
            Database.Persist.applyEnv
  pool   <- Database.Persist.createPoolConfig (dbconf :: Settings.PersistConf)


  -- Get the CSV records
  args <- getArgs
  csv  <- parseCSVFromFile . head $ args

  case csv of
    Left   error          -> putStrLn $ "Error while parsing file: " ++ show error
    Right (header:spaces) ->
      runStdoutLoggingT . runResourceT $ Database.Persist.runPool dbconf (qs spaces) pool

