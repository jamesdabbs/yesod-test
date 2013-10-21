module Handler.Spaces where

import Import


serialize :: Entity Space -> Value
serialize (Entity spaceId space) = object
  [ "id"          .= spaceId
  , "name"        .= spaceName space
  , "description" .= spaceDescription space
  ]

-- Collection

getSpacesR :: Handler Value
getSpacesR = do
  spaces <- runDB $ selectList [] [Asc SpaceId]
  return . array $ map serialize spaces

postSpacesR :: Handler Html
postSpacesR = do
  ((res,form), enctype) <- runFormPost $ spaceForm Nothing
  case res of
    FormSuccess space -> do
      spaceId <- runDB $ insert space
      setMessage . toHtml $ (spaceName space) <> " created"
      redirect $ SpaceR spaceId
    _ -> defaultLayout $ do
      $(widgetFile "spaces/new")

getNewSpaceR :: Handler Html
getNewSpaceR = do
  (form, enctype) <- generateFormPost $ spaceForm Nothing
  defaultLayout $ do
    $(widgetFile "spaces/new")


-- Objects

getSpaceR :: SpaceId -> Handler Value
getSpaceR spaceId = do
  space <- runDB $ get404 spaceId
  return . serialize $ Entity spaceId space

getEditSpaceR :: SpaceId -> Handler Html
getEditSpaceR spaceId = do
  space <- runDB $ get404 spaceId
  (form, enctype) <- generateFormPost $ spaceForm $ Just space
  defaultLayout $ do
    $(widgetFile "spaces/edit")

postSpaceR :: SpaceId -> Handler Html
postSpaceR spaceId = do
  space <- runDB $ get404 spaceId
  ((res,form), enctype) <- runFormPost $ spaceForm $ Just space
  case res of
    FormSuccess edited -> do
      _ <- runDB $ replace spaceId edited
      setMessage . toHtml $ (spaceName edited) <> " updated"
      redirect $ SpaceR spaceId
    _ -> defaultLayout $ do
      $(widgetFile "spaces/edit")

-- Helpers

spaceForm :: Maybe Space -> Form Space
spaceForm space = renderDivs $ Space
  <$> areq textField "Name" (spaceName <$> space)
  <*> areq textField "Description" (spaceDescription <$> space)

