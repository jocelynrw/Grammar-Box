module Main exposing (..)
import List.Extra exposing (getAt) 
--somehow not working
import Browser
import Html as H exposing (..)
import Html.Attributes as HA exposing (..)
import Html.Events exposing (onClick)
import Svg as S exposing (..)
import Svg.Attributes as SA exposing (..)
import Array 
import Draggable
import Html5.DragDrop exposing (Position)

---- MODEL ----

type alias Model =
    {currentPhrase : Maybe String,
    phrases : Array.Array String,
    position : ( Int, Int )
    , drag : Draggable.State String}
--currentPhrase = Array.get 0 myArray

init : ( Model, Cmd Msg )
init =
    let 
        sentences = ["the red house", "that big barn", "a furry cat"]
    in
        ({ phrases = Array.fromList sentences,
        currentPhrase = List.head sentences, 
        position = ( 0, 0 ), drag = Draggable.init},
        Cmd.none)

--Array.get 0 sentences

boxes: List String
boxes = ["red 1", "red 2", "red 3"]




---- UPDATE ----


type Msg
    = Back 
    | Forward
    | None 
    | OnDragBy Draggable.Delta
    | DragMsg (Draggable.Msg String)



update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ position } as model) =
    case msg of
        OnDragBy ( dx, dy ) ->
            let
                ( x, y) =
                    position 
            in 
                ( { model | position = (round (toFloat x + dx), round (toFloat y +dy) ) }, Cmd.none )
        DragMsg dragMsg ->
            Draggable.update dragConfig drag Msg model


dragConfig : Draggable.Config String Msg
dragConfig =
    Draggable.basicConfig OnDragBy

---- VIEW ----


view : Model -> Html Msg
view model =
    let

-- view { xy } =
--     let
--         translate =
--             "translate(" ++ String.fromFloat xy.x ++ "px, " ++ String.fromFloat xy.y ++ "px)"

-- 8. Triggering drag
-- Inside your view function, you must somehow make the element draggable. You do that by adding a trigger for the mousedown event. You must also specify a key for that element. This can be useful when there are multiple drag targets in the same view.

-- Of course, you'll also have to style your DOM element such that it reflects its moving position (with top: x; left: y or transform: translate)
        sentence = case model.currentPhrase of
            Nothing ->
                ""
            Just p ->
                p

        phrasehtml = div [HA.id "phrases"] [H.text sentence]

        sentences = String.join " " (Array.toList model.phrases)
        wordshtml =
            sentences 
            |> String.split " " 
            |> List.map ( \word ->
               tr[] [td ([HA.id "words", Draggable.mouseTrigger () DragMsg]
            ++ Draggable.touchTriggers () DragMsg)  [H.text word] ])
            |> table [HA.id "wordstable"]
        
        boxeshtml=
            boxes
            |> List.map (\word -> li[] [button[ HA.id "grammarboxes" ] [H.text word]])
            |> ul [ HA.id "allboxes"] 
        
        --gbtitleb= div[HA.class "title"] [String "Grammar Boxes"]
        --navpanel = button[ onClick "openNav()" ] [H.text "Open"]

        circlehtml = svg
            [SA.height "130px", SA.width "90px"]
            [ circle
                [ cx "45"
                , cy "45"
                , r "40"
                , fill "red"
                , stroke "red"
                , strokeWidth "3"
                ]
                []]
        creshtml = svg [SA.width "80px", SA.height "130px"]
            [S.path  
                [d "m 30.034 22.3328 c -12.8744 4.06804 -21.9608 15.9459 -21.9254 28.6609 c 0.03536 12.6782 3.28112 16.2321 7.47444 8.18427 c 11.1244 -21.3503 42.5863 -20.4773 49.4476 1.37219 c 1.3828 4.40366 5.09983 3.02741 6.35778 -2.35374 c 5.27362 -22.56 -18.4226 -43.1099 -41.3544 -35.8637"
                , fill "#007f00"
                , stroke "#007f00"
                , strokeWidth "3"

            ]
            
            [ ]]
        recthtml = svg[SA.height "130px", SA.width "80px"]
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
            
        trinhtml = svg[SA.height "130px", SA.width "80px"]
            [polygon
                [points "0,80 80,80 40,0"
                , fill "black"
                , stroke "black"
                , strokeWidth "2"
                ]
            []]
        
        triadjhtml = svg[SA.height "130px", SA.width "80px"]
            [polygon
                [points "10,60 70,60 40,0"
                , fill "darkblue"
                , stroke "darkblue"
                , strokeWidth "2"
                ]
            []]
        
        triarthtml = svg[SA.height "130px", SA.width "80px"]
            [polygon
                [points "20,40 60,40 40,0"
                , fill "skyblue"
                , stroke "skyblue"
                , strokeWidth "2"
                ]
            []]
        -- trianglehtml = picture [triangle green 150]
        
        triphtml = svg[SA.height "130px", SA.width "80px"]
            [polygon
                [points "20,80 60,80 40,0"
                , fill "purple"
                , stroke "purple"
                , strokeWidth "2"
                ]
            []]
        circlephtml = svg
            [SA.height "130px", SA.width "90px"]
            [ circle
                [ cx "45"
                , cy "45"
                , r "20"
                , fill "orange"
                , stroke "orange"
                , strokeWidth "3"
                ]
                []]
        keyholehtml = svg [SA.height "130px", SA.width "80px", transform "scale(.7)"]
            [S.path
                [d "m 10.9173 23.0741 c 0.16702 0.47855 16.2158 53.3224 16.3923 53.9745 c 0.12486 0.46222 -0.00207 0.57534 -1.34097 1.19328 c -16.9309 7.81425 -20.2246 29.4483 -6.32289 41.529 c 21.9109 19.041 57.4778 -1.1025 47.8134 -27.0795 c -2.24286 -6.02826 -8.71964 -12.7444 -14.2862 -14.8145 c -0.64526 -0.2399 -0.72543 -0.34806 -0.5978 -0.808 c 0.19742 -0.71059 16.2444 -53.5383 16.4015 -53.9948 c 0.1168 -0.33896 -1.37 -0.35736 -29.0304 -0.35736 c -27.6614 0 -29.1472 0.01841 -29.0288 0.35736"
                , stroke "rgb(211, 199, 94)"
                , fill "rgb(255,255,0)"
                , strokeWidth "3"
                ]
                []]

        arrowLhtml = svg [SA.height "30px", SA.width "30px"] 
            [ S.path[
                d "M 19 4 L 18 4.57227 L 5 12 L 18 19.4277 L 19 20 L 19 18.8438 L 19 5 L 19 4 Z M 18 5.58398 L 18 18.2715 L 7.02344 12 L 18 5.58398 Z"
                , stroke "darkslategray"
                , fill "darkslategray"        
                ]
            []]
        arrowRhtml = svg [SA.height "30px", SA.width "30px", SA.transform "scale(-1, 1)"] 
            [ S.path[
                d "M 24.695 12.912 L 13.718 19.328 L 24.695 25.599 L 24.695 12.912 Z M 25.695 11.328 L 25.695 12.328 L 25.695 26.172 L 25.695 27.328 L 24.695 26.756 L 11.695 19.328 L 24.695 11.9 L 25.695 11.328 Z"
                , stroke "darkslategray"
                , fill "darkslategray"        
                ]
            []]

    in
    div []
        [   h1 [] [table [] [tr [] [ td[] [arrowLhtml], td[HA.id "sentence"] [phrasehtml], td[HA.id "right"] [arrowRhtml]] ]]
--TO DO: Line up Arrows
        ,   div [ HA.id "sidebar"] [ H.text "Grammar Boxes",
                div [HA.class "bottomborder"] [boxeshtml]
            ,   div [] [wordshtml]
            ]
        ,   div [ HA.id "bottompanel" ] [
            table[] [tr[] [td[] [trinhtml], td[] [triadjhtml], td[] [triarthtml], td[] [triphtml], td[] [circlehtml], td[] [creshtml], td[] [circlephtml], td[] [recthtml], td[] [keyholehtml] ] ] 
        ]]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }

--SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions {drag} =
    Draggable.subscriptions DragMsg drag