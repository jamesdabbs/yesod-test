module Handler.Spaces where

import Import


-- Collection

getSpacesR :: Handler Html
getSpacesR = do
  defaultLayout $ do
    $(widgetFile "spaces/index")

postSpacesR :: Handler Html
postSpacesR = error "Not yet implemented: postSpacesR"

getNewSpaceR :: Handler Html
getNewSpaceR = do
  defaultLayout $ do
    $(widgetFile "spaces/new")


-- Objects

getSpaceR :: SpaceId -> Handler Html
getSpaceR spaceId = do
  defaultLayout $ do
    $(widgetFile "spaces/show")

putSpaceR :: SpaceId -> Handler Html
putSpaceR = error "Not yet implemented: putSpaceR"

