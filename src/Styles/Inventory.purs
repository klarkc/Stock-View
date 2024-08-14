module Styles.Inventory
  ( inventoryContainerStyle
  , inventoryItemStyle
  ) where

import Prelude
import CSS
import CSS.Flexbox (flexWrap, justifyContent, wrap, spaceAround)
import CSS.Display (display, flex)
import CSS.Border (border, borderRadius, solid)
import CSS.Box (boxShadow, boxSizing, borderBox, shadowWithBlur, bsColor)
import CSS.Color (rgba, white, black)
import CSS.Geometry (padding, margin, width)
import CSS.Size (px)
import Data.NonEmpty (singleton)

inventoryContainerStyle :: CSS
inventoryContainerStyle = do
  display flex
  flexWrap wrap
  justifyContent spaceAround

inventoryItemStyle :: CSS
inventoryItemStyle = do
  backgroundColor white
  border solid (px 1.0) black
  borderRadius (px 5.0)
  boxShadow $ singleton $ bsColor (rgba 0 0 0 0.1) $ shadowWithBlur (px 0.0) (px 2.0) (px 5.0)
  padding (px 15.0)
  margin (px 10.0)
  width (px 250.0)
  boxSizing borderBox
