module Utils where

import Prelude

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Data.Maybe (Maybe(..))


-- | Small utility to save characters when applying CSS classes.
css :: forall r i. String -> HH.IProp (class :: String | r) i
css = HP.class_ <<< HH.ClassName

-- | Utility to safely create href attributes from routes.
-- safeHref :: forall r i. Route -> HH.IProp (href :: String | r) i
-- safeHref = HP.href <<< append "#" <<< print routeCodec

-- | Conditionally render an element.
maybeElem :: forall p i a. Maybe a -> (a -> HH.HTML p i) -> HH.HTML p i
maybeElem (Just x) f = f x
maybeElem _ _ = HH.text ""

-- | Conditionally render an element based on a boolean.
whenElem :: forall p i. Boolean -> (Unit -> HH.HTML p i) -> HH.HTML p i
whenElem cond f = if cond then f unit else HH.text ""
