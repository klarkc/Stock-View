module Styles.Inventory
  ( inventoryContainerStyle
  , inventoryItemStyle
  ) where

import CSS.Flexbox
import Prelude

import CSS (backgroundColor, color) as Color
import CSS.Border (borderRadius)
import CSS.Border as Border
import CSS.Box (borderBox, boxShadow, boxSizing)
import CSS.Box as CSS
import CSS.Color (black, white) as Color
import CSS.Color (rgba)
import CSS.Display (display, flex)
import CSS.Geometry (margin, padding) as CSS
import CSS.Geometry (width)
import CSS.Size as Size
import CSS.Stylesheet (CSS)

inventoryContainerStyle :: CSS
inventoryContainerStyle = do
  display flex
  flexWrap wrap
  justifyContent spaceAround

inventoryItemStyle :: CSS
inventoryItemStyle = do
  Color.backgroundColor Color.white
  Border.border Border.solid (Size.px 1.0) Color.black
  Border.borderRadius (Size.px 5.0)
  boxShadow 0 2 5 (rgba 0 0 0 0.1)
  CSS.padding (Size.px 15.0)
  CSS.margin (Size.px 10.0)
  width (Size.px 250.0)
  boxSizing borderBox
