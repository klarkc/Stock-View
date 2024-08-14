{ name = "localVentory"
, dependencies = [ "console"
                , "effect"
                , "arrays"
                , "lists"
                , "prelude"
                , "maybe"
                , "either"
                , "aff"
                , "halogen"
                , "halogen-css"
                , "tuples"
                 ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
