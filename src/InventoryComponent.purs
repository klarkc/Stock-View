module InventoryComponent
  ( Action(..)
  , InventoryItem(..)
  , State
  , handleAction
  , initialState
  , inventoryComponent
  , render
  , renderItem
  )
  where

import Prelude

import Data.Array as Array
import Data.List as List
import Data.Either (Either(..))
import Data.List.Types (List(..))
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Effect.Console as Console
import Halogen (ClassName(..), liftAff)
import Halogen as H
import Halogen.HTML (ClassName(..))
import Halogen.HTML as HH
import Halogen.HTML.Properties (class_)
import Halogen.HTML.Properties as HP
import Utils (css, maybeElem, whenElem)

-- Define the InventoryItem type
data InventoryItem = InventoryItem
  { id :: String
  , name :: String
  , description :: String
  , quantity :: Int
  }

-- Define the State type for the component
type State = { items :: List InventoryItem, errorMsg :: Maybe String }

-- Initial state of the component
initialState :: State
initialState = { items: Nil, errorMsg: Nothing }

-- Define actions for the component
data Action
  = Initialize
  | InventoryLoaded (Either String (List InventoryItem))

-- Define the Halogen component
inventoryComponent :: forall q i m. MonadAff m => H.Component q i Void m
inventoryComponent =
  H.mkComponent
    { initialState: \_ -> initialState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction, initialize = Just Initialize }
    }

handleAction :: forall m. MonadAff m => Action -> H.HalogenM State Action () Void m Unit
handleAction = case _ of
  Initialize -> do
    H.liftEffect $ Console.log "Component initializing..."
    result <- liftAff loadInventory
    case result of
      Left err -> H.modify_ \s -> s { errorMsg = Just err }
      Right items -> H.modify_ \s -> s { items = items }
  
  InventoryLoaded (Left err) -> do
    H.modify_ \s -> s { errorMsg = Just err }

  InventoryLoaded (Right items) -> do
    H.modify_ \s -> s { items = items }

-- Render the component
render :: forall m. MonadAff m => State -> H.ComponentHTML Action () m
render state =
  HH.div
    [ css "inventory-container" ]
    [ HH.h1 [ css "inventory-container__title" ] [ HH.text "Inventory" ]
    , maybeElem state.errorMsg \err -> 
        HH.div [ css "error-message" ] [ HH.text $ "Error: " <> err ]
    , whenElem (not $ List.null state.items) \_ ->
        HH.div_ (Array.fromFoldable $ renderItem <$> state.items)
    ]

-- Render each item in the inventory
renderItem :: forall m. MonadAff m => InventoryItem -> H.ComponentHTML Action () m
renderItem (InventoryItem { name, description, quantity }) = 
  HH.div
    [ (css "inventory-item") ]
    [ HH.div [ (css "inventory-item__name") ] [ HH.text name ]
    , HH.div [ (css "inventory-item__description") ] [ HH.text $ "Description: " <> description ]
    , HH.div [ (css "inventory-item__quantity") ] [ HH.text $ "Quantity: " <> show quantity ]
    ]

-- Function to load the inventory (simulated JSON load)
loadInventory :: Aff (Either String (List InventoryItem))
loadInventory = do
  let items = Cons (InventoryItem { id: "1", name: "Item 1", description: "Description for Item 1", quantity: 100 })
                   (Cons (InventoryItem { id: "2", name: "Item 2", description: "Description for Item 2", quantity: 50 }) Nil)
  pure (Right items)
