module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )

phrase: String
phrase = "the red house"


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
            -- phrase
            -- -- |> String.split " "
            -- -- -- |> List.map (\char->
            -- -- --     if char == " " then 
            -- -- --         " "
            -- -- --     else
            -- -- --         char
            -- -- --     )
            -- -- |> List.map 
            -- -- (\word -> 
            -- --     span [] [text word]
            -- -- )
            -- |> div [] [text phrase]
        wordshtml =
            phrase 
            |> String.split " " 
            |> List.map ( \word ->
               li [] [ button [] [text word]]) 
            |> ul []
            
        navpanel = button[ onClick "openNav()" ] [text "Open"]
    in
    div []
        [   h1 [ id "phrases"] [phrasehtml ]
        -- ,   div [] [navpanel]
        ,   div [ id "sidebar"] [
                div [ id "grammar boxes"] []
            ,   div [id "words"] [wordshtml
                ]
            ]
        ,   div [ id "bottompanel" ] 
            [wordshtml]
        ]




        



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }