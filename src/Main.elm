module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
-- import Svg exposing (..)
-- import Svg.Attributes exposing (..)

---- MODEL ----


type alias Model =
    {}

-- main1 : Html msg
-- main1 =
--   svg
--     [ ]
--     [ circle
--         [ cx "50"
--         , cy "50"
--         , r "40"
--         , fill "red"
--         , stroke "red"
--         , strokeWidth "3"
--         ]
--         []
--     , rect
--         [ x "100"
--         , y "10"
--         , width "40"
--         , height "40"
--         , fill "green"
--         , stroke "black"
--         , strokeWidth "2"
--         ]
--         []]

init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )

phrase: String
phrase = "the red house"
boxes: List String
boxes = ["red 1", "red 2", "red 3"]

---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        phrasehtml = div [] [text phrase]
           
        wordshtml =
            phrase 
            |> String.split " " 
            |> List.map ( \word ->
               tr[] [th [] [ button [] [text word]]]) 
            |> table [id "words"]
        
        boxeshtml=
            boxes
            |> List.map (\word -> li[] [button[ ] [text word]])
            |> ul [ id "grammar-boxes"] 
            
        navpanel = button[ onClick "openNav()" ] [text "Open"]

        -- shapetable = 
        --     table [] [td [] [img src Triangle.png]]

    in
    div []
        [   h1 [ id "phrases"] [phrasehtml ]
        -- ,   div [] [navpanel]
        ,   div [ id "sidebar"] [
                div [ ] [boxeshtml]
            ,   div [] [wordshtml]
            ]
        ,   div [ id "bottompanel" ] 
            []
        ]

--create a table which can automatically fill with shapes



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }