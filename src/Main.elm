module Main exposing (..)
import List.Extra exposing (getAt)
--somehow not working
import Browser
import Html as H exposing (..)
import Html.Attributes as HA exposing (..)
import Html.Events exposing (onClick, onMouseUp)
import Svg as S exposing (..)
import Svg.Attributes as SA exposing (..)
import Array
import Draggable
import List.Extra exposing (group)
import Draggable.Events exposing (onClick, onDragBy, onDragStart)



--SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions {drag} =
    Draggable.subscriptions DragMsg drag


---- MODEL ----
type alias Shape =
    {id: Id
    , position : Position
    }

type alias Id =
    String

type alias Position =
    {x : Float
    , y : Float }

makeShape : Id -> Position -> Shape
makeShape id position =
    Shape id position

dragShapeBy : Position -> Shape -> Shape
dragShapeBy delta shape =
    { shape | position = Position (shape.position.x + delta.x)
     (shape.position.y + delta.y) }

type alias ShapeGroup =
    {uid : Int
    , movingShape : Maybe Shape
    , idleShapes : List Shape}

emptyGroup : ShapeGroup
emptyGroup =
    ShapeGroup 0 Nothing []

addShape : Position -> ShapeGroup -> ShapeGroup
addShape position ({ uid, idleShapes } as group) =
    { group
        | idleShapes = makeShape (String.fromInt uid) position :: idleShapes
        , uid = uid + 1}

makeShapeGroup : List Position -> ShapeGroup
makeShapeGroup positions =
    positions
        |>List.foldl addShape emptyGroup

allShapes : ShapeGroup -> List Shape
allShapes { movingShape, idleShapes} =
    movingShape
        |> Maybe.map (\a -> a :: idleShapes )
        |> Maybe.withDefault idleShapes



startDragging : Id -> ShapeGroup -> ShapeGroup
startDragging id ( { idleShapes, movingShape} as group) =
    let
        ( targetAsList, others) =
            List.partition (.id >> (==) id) idleShapes

    in
    { group
        | idleShapes = others
        , movingShape = targetAsList |> List.head
    }

stopDragging : ShapeGroup -> ShapeGroup
stopDragging group =
    { group
        | idleShapes = allShapes group
        , movingShape = Nothing
    }

dragActiveBy : Position -> ShapeGroup -> ShapeGroup
dragActiveBy delta group =
    { group | movingShape = group.movingShape |> Maybe.map (dragShapeBy delta) }

phrases : List String
phrases = ["the red house", "that big barn", "a furry cat"]

type alias Model =
    { shapeGroup : ShapeGroup
    , wordGroup : ShapeGroup
    , drag : Draggable.State Id
    , currentPhrase : Maybe String
    }

-- phrases : Array.Array String

shapePositions : List Position
shapePositions = --[Position 0 0, Position 80 0, Position 160 0]
    let
        indexToPosition =
            toFloat >> (*) 100 >> (+) 20 >> (\x -> Position x 650)
    in
    List.range 0 9 |> List.map indexToPosition

wordPositions : List Position
wordPositions =
    let
        indexToPosition =
            toFloat >> (*) 100 >> (+) 20 >> (\x -> Position x 10)
    in
    List.range 0 8 |> List.map indexToPosition


init : flag -> ( Model, Cmd Msg )
init _ =
    ( { shapeGroup = makeShapeGroup shapePositions
        , wordGroup = makeShapeGroup wordPositions
        , drag = Draggable.init
        , currentPhrase = Array.get 0 (Array.fromList phrases) }
        , Cmd.none
    )


    -- let
    --     sentences = ["the red house", "that big barn", "a furry cat"]
    -- in
    --     ({ phrases = Array.fromList sentences,
    --     currentPhrase = List.head sentences,
    --     xy = Position 100 100, drag = Draggable.init},
    --     Cmd.none)

--Array.get 0 sentences
-- drag = Draggable.init
boxes: List String
boxes = ["red 1", "red 2", "red 3"]

wordd: String
wordd = "hello"



---- UPDATE ----


type Msg
    = Back
    | Forward
    | None
    | OnDragBy Position --weird still
    | DragMsg (Draggable.Msg Id)
    | StartDragging String
    | StopDragging

--TODO: so much to change here with shapegroup

update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ shapeGroup, wordGroup } as model) =
    case msg of
        OnDragBy delta ->
            ( { model | shapeGroup = shapeGroup |> dragActiveBy delta }, Cmd.none )

        -- ( dx, dy ) ->
        --     ( { model | xy = Position (xy.x + dx) (xy.y + dy)  }, Cmd.none )
        DragMsg dragMsg ->
            Draggable.update dragConfig dragMsg model

        StartDragging id ->
                ( { model | shapeGroup = shapeGroup |> startDragging id }, Cmd.none )

        StopDragging ->
            ( { model | shapeGroup = shapeGroup |> stopDragging }, Cmd.none )

        _ ->
            (model, Cmd.none)


dragConfig : Draggable.Config Id Msg
dragConfig =
    Draggable.customConfig
        [ onDragBy (\( dx, dy ) -> Position dx dy |> OnDragBy )
        , onDragStart StartDragging
        ]


---- VIEW ----


view : Model -> Html Msg
view ({ shapeGroup, wordGroup } as model) =
    let
        phrasehtml = div [HA.id "phrases"] [H.text (Maybe.withDefault "" (List.head phrases))]

        sentences =
            String.join " " --(Array.toList
            phrases
            --)
         --({ phrases = Array.fromList sentences,
    --     currentPhrase = List.head sentences,
    --     xy = Position 100 100, drag = Draggable.init},
    --     Cmd.none)

--I think i need to .... get the words into an array, and then put them into a array

        wordshtml =
            sentences
            |> String.split " "
            |> List.map ( \word ->
               tr[] [td [HA.class "words"
               , Draggable.mouseTrigger "my-element" DragMsg]
                -- ++ Draggable.touchTriggers "my-element" DragMsg
                 [H.text word] ] )
            |> table [HA.id "wordstable"]
            --make this separate into only three rows and append the words into separate tables

        wordtrial = div [ HA.style "display" "flex"
         , HA.style "padding" "16px"
         , HA.style "background-color" "lightgray"
         , HA.style "cursor" "move"
         , HA.style "width" "64px" ]
        --  , HA.style "transform" translate
        --  , Draggable.mouseTrigger "word" DragMsg]
        --     ++ Draggable.touchTriggers "word" DragMsg)
         [H.text "word"]

        boxeshtml=
            boxes
            |> List.map (\word -> li[] [button[ HA.id "grammarboxes" ] [H.text word]])
            |> ul [ HA.id "boxes"]

        --gbtitleb= div[HA.class "title"] [String "Grammar Boxes"]
        --navpanel = button[ onClick "openNav()" ] [H.text "Open"]

        arrowLhtml = svg [SA.height "60px", SA.width "30px"]
            [ S.path[
           --     d "M 19 4 L 18 4.57227 L 5 12 L 18 19.4277 L 19 20 L 19 18.8438 L 19 5 L 19 4 Z M 18 5.58398 L 18 18.2715 L 7.02344 12 L 18 5.58398 Z"
                d "M31.7 239l136-136c9.4-9.4 24.6-9.4 33.9 0l22.6 22.6c9.4 9.4 9.4 24.6 0 33.9L127.9 256l96.4 96.4c9.4 9.4 9.4 24.6 0 33.9L201.7 409c-9.4 9.4-24.6 9.4-33.9 0l-136-136c-9.5-9.4-9.5-24.6-.1-34z"
                , stroke "darkslategray"
                , fill "darkslategray"
                , SA.transform "scale(0.1)"
                ]
            []]
        arrowRhtml = svg [SA.height "60px", SA.width "30", SA.id "right" ]
            [ S.path[
            --    d "M 24.695 12.912 L 13.718 19.328 L 24.695 25.599 L 24.695 12.912 Z M 25.695 11.328 L 25.695 12.328 L 25.695 26.172 L 25.695 27.328 L 24.695 26.756 L 11.695 19.328 L 24.695 11.9 L 25.695 11.328 Z"
                d "M224.3 273l-136 136c-9.4 9.4-24.6 9.4-33.9 0l-22.6-22.6c-9.4-9.4-9.4-24.6 0-33.9l96.4-96.4-96.4-96.4c-9.4-9.4-9.4-24.6 0-33.9L54.3 103c9.4-9.4 24.6-9.4 33.9 0l136 136c9.5 9.4 9.5 24.6.1 34z"
                , stroke "darkslategray"
                , fill "darkslategray"
                , SA.transform "scale(0.1)"
                ]
            []]

--preserveAspectRatio="X200Y200 meet

    in
    div []
        [   h1 [] [table [HA.id "top"] [tr [] [ td [HA.id "left"] [arrowLhtml]
            , td[HA.id "sentence"] [ phrasehtml]
            , td[HA.id "right"] [arrowRhtml]
            ]
            ] ]
        ,   span [] [
            --wordtrial
            ]
        ,   nav [] [ H.text "Grammar Boxes"
        , S.svg
            [SA.style "height: 80%; width: 100%; position: fixed" ]
            [ wordsView wordGroup ]
        --boxeshtml
        ]
        ,   wordshtml
        , S.svg
            [ SA.id "shapes", SA.style "height: 80%; width: 100%; position: fixed" ]
            [ shapesView shapeGroup ]

        ]


shapesView : ShapeGroup -> Svg Msg
shapesView shapeGroup =
    shapeGroup
        |> allShapes
        |> List.reverse
        |> List.map shapeView
        |> S.node "g" []

wordsView : ShapeGroup -> Svg Msg
wordsView wordGroup =
    wordGroup
        |> allShapes
        |> List.reverse
       |> List.map wordView
       |> S.node "h" []


shapeView : Shape -> Html Msg
shapeView { id, position } =
        svg [SA.height "130px", SA.width "80px", num SA.x position.x
        , num SA.y position.y
        , HA.style "cursor" "move"
        , Draggable.mouseTrigger id DragMsg
        , onMouseUp StopDragging
        --, SA.transform "translate(50,0)"
        ]
                        [ Maybe.withDefault (svg [] []) (Array.get (Maybe.withDefault 0 (String.toInt id)) listShapes)]
--TODO: They are sticking to the bottom, but it doesn't change for other screens

wordView: Shape -> Html Msg
wordView { id, position } =
        svg [SA.height "50px", SA.width "fit", num SA.x position.x
        , num SA.y position.y
        , HA.style "cursor" "move"
        , Draggable.mouseTrigger id DragMsg
        , onMouseUp StopDragging]
                        [ Maybe.withDefault (svg [] []) (Array.get (Maybe.withDefault 0 (String.toInt id)) listArticles)]

--listWords : Array.Array (Svg msg)
--List String ->

-- listWords =
-- --phrases
--     let
--         arrayofwords =
--             phrases
--                 |> List.map (String.split " ")
--                 |> List.map Array.fromList

--         articlebox =
--             List.foldl (\x a ->
--                             Maybe.withDefault "" (Array.get 0 x)
--                             :: a)
--                         [] arrayofwords
--                 |> List.map (\word -> S.text_ []
--                 [S.text word])

--     in Array.fromList [articlebox]

listArticles : Array.Array (Svg msg)
listArticles =
--phrases
    let
        arrayofwords =
            phrases
                |> List.map (String.split " ")
                |> List.map Array.fromList

        in
            Array.fromList( List.foldl (\x a ->
                            Maybe.withDefault "" (Array.get 0 x)
                            :: a)
                        [] arrayofwords
                |> List.map (\word -> S.text_ []
                    [S.text word])
            )


-- |> List.map ( \word ->
            --    tr[] [td [HA.class "words"
            --    , Draggable.mouseTrigger "my-element" DragMsg]
            --     -- ++ Draggable.touchTriggers "my-element" DragMsg
            --      [H.text word] ] )


--make svgs from this list

--        adjectivebox =

--        nounbox =




listShapes : Array.Array (Svg msg)
listShapes =
    let
        trinhtml =
                polygon
                    [points "0,80 80,80 40,0"
                    , fill "black"
                    , stroke "black"
                    , strokeWidth "2"
                    ]
                []


        triadjhtml =
                polygon
                    [points "10,60 70,60 40,0"
                    , fill "darkblue"
                    , stroke "darkblue"
                    , strokeWidth "2"
                    ]
                []

        triarthtml =
                polygon
                    [points "20,40 60,40 40,0"
                    , fill "skyblue"
                    , stroke "skyblue"
                    , strokeWidth "2"
                    ]
                []

        circlehtml =
                circle
                    [ cx "40"
                    , cy "40"
                    , r "35"
                    , fill "red"
                    , stroke "red"
                    , strokeWidth "3"
                    ]
                []

        circleadvhtml =
                circle
                    [ cx "45"
                    , cy "45"
                    , r "20"
                    , fill "orange"
                    , stroke "orange"
                    , strokeWidth "3"
                    ]
                []

        creshtml =
                S.path
                    [d "m 30.034 22.3328 c -12.8744 4.06804 -21.9608 15.9459 -21.9254 28.6609 c 0.03536 12.6782 3.28112 16.2321 7.47444 8.18427 c 11.1244 -21.3503 42.5863 -20.4773 49.4476 1.37219 c 1.3828 4.40366 5.09983 3.02741 6.35778 -2.35374 c 5.27362 -22.56 -18.4226 -43.1099 -41.3544 -35.8637"
                    , fill "#007f00"
                    , stroke "#007f00"
                    , strokeWidth "3"
                    ]
                []

        triphtml =
                polygon
                    [points "20,80 60,80 40,0"
                    , fill "purple"
                    , stroke "purple"
                    , strokeWidth "2"
                    ]
                []

        recthtml =
                rect
                    [ x "0"
                    , y "42"
                    , SA.width "80"
                    , SA.height "10"
                    , fill "pink"
                    , stroke "pink"
                    , strokeWidth "2"
                    ]
                []

        keyholehtml =
        --[transform "scale(.7)"]
                    --[
                S.path
                    [d "m 10.9173 23.0741 c 0.16702 0.47855 16.2158 53.3224 16.3923 53.9745 c 0.12486 0.46222 -0.00207 0.57534 -1.34097 1.19328 c -16.9309 7.81425 -20.2246 29.4483 -6.32289 41.529 c 21.9109 19.041 57.4778 -1.1025 47.8134 -27.0795 c -2.24286 -6.02826 -8.71964 -12.7444 -14.2862 -14.8145 c -0.64526 -0.2399 -0.72543 -0.34806 -0.5978 -0.808 c 0.19742 -0.71059 16.2444 -53.5383 16.4015 -53.9948 c 0.1168 -0.33896 -1.37 -0.35736 -29.0304 -0.35736 c -27.6614 0 -29.1472 0.01841 -29.0288 0.35736"
                    , stroke "rgb(211, 199, 94)"
                    , fill "rgb(255,255,0)"
                    , strokeWidth "3"
                    , transform "scale(.7)"]
                []
                        --]
        test =
                S.text_ [textLength "80%", y "45", fontSize "30px", SA.style "border: 5px"][S.text "hey"]




    in Array.fromList [trinhtml, triadjhtml, triarthtml, circlehtml, circleadvhtml, creshtml, triphtml, recthtml, keyholehtml, test]

        -- [ num SA.width 100 --this is fake
        -- , num SA.height 100
        -- , num SA.x position.x
        -- , num SA.y position.y
        -- , Draggable.mouseTrigger id DragMsg
        -- , onMouseUp StopDragging
        -- ]
        -- []

-- background : Svg msg
-- background =
--     S.rect
--         [ SA.x "0"
--         , SA.y "0"
--         , SA.width "100%"
--         --, SA.height "200px"
--         , SA.fill "#eee"
--         ]
--         []

num : (String -> S.Attribute msg) -> Float -> S.Attribute msg
num attr value =
    attr (String.fromFloat value)

---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
