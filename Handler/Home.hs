{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Home where

import Import

getHomeR :: Handler Html
getHomeR = do
  defaultLayout $ do
    addScriptRemote "//ajax.googleapis.com/ajax/libs/angularjs/1.0.7/angular.min.js"
    addScriptRemote "http://ajax.googleapis.com/ajax/libs/angularjs/1.0.7/angular-resource.min.js"
    $(widgetFile "homepage")

