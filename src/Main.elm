module Main exposing (..)
-- import Playground exposing (..)

import Browser
import Html as H exposing (..)
import Html.Attributes as HA exposing (..)
import Html.Events exposing (onClick)
import Svg as S exposing (..)
import Svg.Attributes as SA exposing (..) 

---- MODEL ----


type alias Model =
    {}

-- main1 : Html msg
-- main1 =
  
--     , rect
--         [ x "100"
--         , y "10"
--         , SA.width "40"
--         , SA.height "40"
--         , fill "green"
--         , stroke "black"
--         , strokeWidth "2"
--         ]
--         []]
--the problem is that 'height and width' are in html and svg
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
        phrasehtml = div [] [H.text phrase]
           
        wordshtml =
            phrase 
            |> String.split " " 
            |> List.map ( \word ->
               tr[] [th [] [ button [] [H.text word]]]) 
            |> table [HA.id "words"]
        
        boxeshtml=
            boxes
            |> List.map (\word -> li[] [button[ ] [H.text word]])
            |> ul [ HA.id "grammar-boxes"] 
            
        navpanel = button[ onClick "openNav()" ] [H.text "Open"]

        circlehtml = svg
            [SA.width "90px"]
            [ circle
                [ cx "45"
                , cy "45"
                , r "40"
                , fill "red"
                , stroke "red"
                , strokeWidth "3"
                ]
                []]
        creshtml = svg [SA.width "80px", SA.height "150px"]
            [S.path  
                [d "m 25.4334 53.5 a 22.5 22.5 0 1 1 0 43 a 22.5 22.5 0 0 0 0 -43 Z"
                , fill "#007f00"
                , stroke "#007f00"
                , strokeWidth "3"

            ]
            
            [ ]]
        recthtml = svg[SA.width "80px"]
            [rect
                [ x "0"
                , y "42"
                , SA.width "80"
                , SA.height "10"
                , fill "pink"
                , stroke "pink"
                , strokeWidth "2"
                ]
            []]
            
        trinhtml = svg[SA.width "80px"]
            [polygon
                [points "0,80 80,80 40,0"
                , fill "black"
                , stroke "black"
                , strokeWidth "2"
                ]
            []]
        
        triadjhtml = svg[SA.width "80px"]
            [polygon
                [points "0,60 60,60 30,0"
                , fill "darkblue"
                , stroke "darkblue"
                , strokeWidth "2"
                ]
            []]
        
        triarthtml = svg[SA.width "80px"]
            [polygon
                [points "0,40 40,40 20,0"
                , fill "skyblue"
                , stroke "skyblue"
                , strokeWidth "2"
                ]
            []]
        -- trianglehtml = picture [triangle green 150]
        
        triphtml = svg[SA.width "80px"]
            [polygon
                [points "0,80 40,80 20,0"
                , fill "purple"
                , stroke "purple"
                , strokeWidth "2"
                ]
            []]
        circlephtml = svg
            [SA.width "90px"]
            [ circle
                [ cx "45"
                , cy "45"
                , r "20"
                , fill "orange"
                , stroke "orange"
                , strokeWidth "3"
                ]
                []]
        keyholehtml = svg [SA.height "250px"]
            [S.path
                [d "m0,0 c0.332,1.064 33.917,124.223 34.327,125.881c0.266,1.071 0.097,1.324 -1.253,1.883c-19.137,7.927 -34.248,33.769 -33.121,56.641c2.854,57.924 76.739,79.896 110.404,32.832c21.2,-29.638 10.251,-74.941 -21.581,-89.295c-1.664,-0.75 -1.853,-0.998 -1.586,-2.076c0.386,-1.561 33.982,-124.75 34.327,-125.866c0.243,-0.791 -2.869,-0.833 -60.76,-0.833c-57.893,0 -61.003,0.042 -60.757,0.833"
                , stroke "rgb(211, 199, 94)"
                , fill "rgb(255,255,0)"
                , strokeWidth "3"
                ]
                []]


    in
    div []
        [   h1 [ HA.id "phrases"] [phrasehtml ]
        -- ,   div [] [navpanel]
        ,   div [ HA.id "sidebar"] [
                div [ ] [boxeshtml]
            ,   div [] [wordshtml]
            ]
        ,   div [ HA.id "bottompanel" ] 
            [trinhtml, triadjhtml, triarthtml, triphtml, circlehtml, circlephtml, recthtml, creshtml
    
        ]]

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