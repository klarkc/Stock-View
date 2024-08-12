module Main where

import Prelude
import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.VDom.Driver (runUI)
import Halogen.Aff.Util (awaitLoad)
import Web.HTML (window)
import Web.HTML.Window (document)
import Web.HTML.Document (body)
import Data.JSON (JSON, parseJSON, readJSON)
import Effect.Aff (launchAff_, delay)
import Effect.Aff.Class (class MonadAff)
import Web.Fetch as Fetch
import Web.Request (defaultRequest)
import Web.Response as Response
import Data.Maybe (Maybe(..))
import Data.Either (Either(..))

-- | Define the inventory item type
type InventoryItem =
  { id :: String
  , name :: String
  , description :: String
  , quantity :: Int
  }

-- | Define the state for our Halogen component
type State = Array InventoryItem

-- | Define our Halogen component
component :: forall q i o m. MonadAff m => H.Component q i o m
component = H.mkComponent
  { initialState: \_ -> []
  , render: render
  , eval: H.mkEval $ H.defaultEval { initialize = Just init }
  }

-- | Initialize by loading the JSON file
init :: forall m. MonadAff m => H.HalogenM State () () m Unit
init = do
  json <- HA.liftEffect loadInventory
  case json of
    Left _ -> pure unit
    Right items -> H.modify_ \_ -> items

-- | Render function to display the inventory blocks
render :: State -> H.ComponentHTML () () ()
render state = 
  HH.div_
    (map renderItem state)

-- | Render a single item
renderItem :: InventoryItem -> HH.HTML () ()
renderItem item =
  HH.div_
    [ HH.div_ [ HH.text item.name ]
    , HH.div_ [ HH.text $ "Description: " <> item.description ]
    , HH.div_ [ HH.text $ "Quantity: " <> show item.quantity ]
    ]

-- | Function to load the inventory from a JSON file
loadInventory :: Effect (Either String (Array InventoryItem))
loadInventory = do
  req <- defaultRequest
  res <- Fetch.fetch req { url = "/path/to/inventory.json" }
  body <- Response.json res
  pure $ case body of
    Just json -> readJSON json
    Nothing -> Left "Failed to parse JSON"

-- | Main entry point
main :: Effect Unit
main = HA.runHalogenAff do
  awaitLoad
  bodyElement <- HA.liftEffect $ do
    Just doc <- document =<< window
    body doc
  runUI component unit bodyElement
