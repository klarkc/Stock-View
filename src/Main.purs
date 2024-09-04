module Main where

import Prelude (Unit, ($), const)
import Effect (Effect)
import Effect.Console (log)
import Deku.Toplevel (runInBody) as D
import Deku.Attribute as DA
import Deku.Control as DC
import Deku.DOM as DD
import Deku.Listeners as DL

helloWorld :: Effect Unit
helloWorld = log "Hello World!"

main :: Effect Unit
main =
  D.runInBody (DD.div_
    [ DD.button
        [ DL.click_ $ DA.cb $ const helloWorld ]
        [ DC.text_ "Hello World" ]
    ])
