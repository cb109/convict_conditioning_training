module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    Int


init : Model
init =
    0



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1



-- VIEW


view : Model -> Html Msg
view model =
    -- div []
    --   [ button [ onClick Decrement ] [ text "-" ]
    --   , div [] [ text (String.fromInt model) ]
    --   , button [ onClick Increment ] [ text "+" ]
    --   ]
    div []
        [ section [ class "hero is-small is-info has-text-centered" ]
            [ div [ class "hero-body" ]
                [ div [ class "container" ]
                    [ h1 [ class "title" ]
                        [ text "Convict Conditioning" ]
                    , h2 [ class "subtitle" ]
                        [ text "Training Progress Log" ]
                    ]
                ]
            ]
        , section []
            [ div [ class "container" ]
                [ div [ class "level" ]
                    [ div [ class "level-item" ]
                        [ button [ class "button is-medium is-success is-inverted has-margin-top-6" ]
                            [ span [ class "icon" ]
                                [ i [ class "fas fa-plus" ]
                                    []
                                ]
                            , span []
                                [ text "Add Exercise" ]
                            ]
                        ]
                    ]
                , div [ class "level" ]
                    [ div [ class "level-item" ]
                        [ div [ class "dropdown is-active2 has-margin-right-7" ]
                            [ div [ class "dropdown-trigger" ]
                                [ button [ class "button" ]
                                    [ span []
                                        [ text "Exercise" ]
                                    , span [ class "icon is-small" ]
                                        [ i [ class "fas fa-angle-down" ]
                                            []
                                        ]
                                    ]
                                ]
                            , div [ class "dropdown-menu", id "dropdown-menu" ]
                                [ div [ class "dropdown-content" ]
                                    [ a [ class "dropdown-item" ]
                                        [ text "Liegestütz" ]
                                    , a [ class "dropdown-item is-active" ]
                                        [ text "Klimmzüge" ]
                                    , a [ class "dropdown-item" ]
                                        [ text "Beinheben" ]
                                    , a [ class "dropdown-item" ]
                                        [ text "Kniebeuge" ]
                                    , hr [ class "dropdown-divider" ]
                                        []
                                    , a [ class "dropdown-item" ]
                                        [ text "Brücke" ]
                                    , a [ class "dropdown-item" ]
                                        [ text "Handstand-Liegestütz" ]
                                    ]
                                ]
                            ]
                        , div [ class "dropdown is-active2 has-margin-right-7" ]
                            [ div [ class "dropdown-trigger" ]
                                [ button [ class "button" ]
                                    [ span []
                                        [ text "Level" ]
                                    , span [ class "icon is-small" ]
                                        [ i [ class "fas fa-angle-down" ]
                                            []
                                        ]
                                    ]
                                ]
                            , div [ class "dropdown-menu", id "dropdown-menu" ]
                                [ div [ class "dropdown-content" ]
                                    [ a [ class "dropdown-item is-active" ]
                                        [ text "1. Senkrechter Zug" ]
                                    , a [ class "dropdown-item" ]
                                        [ text "2. Waagerechter Zug" ]
                                    , a [ class "dropdown-item" ]
                                        [ text "3. Waagerechter Zug" ]
                                    , a [ class "dropdown-item" ]
                                        [ text "4. Waagerechter Zug" ]
                                    , a [ class "dropdown-item" ]
                                        [ text "5. Waagerechter Zug" ]
                                    , hr [ class "dropdown-divider" ]
                                        []
                                    , a [ class "dropdown-item" ]
                                        [ text "6. Waagerechter Zug" ]
                                    , a [ class "dropdown-item" ]
                                        [ text "7. Waagerechter Zug" ]
                                    , a [ class "dropdown-item" ]
                                        [ text "8. Waagerechter Zug" ]
                                    , a [ class "dropdown-item" ]
                                        [ text "9. Waagerechter Zug" ]
                                    , a [ class "dropdown-item" ]
                                        [ text "10. Waagerechter Zug" ]
                                    ]
                                ]
                            ]
                        , div [ class "buttons" ]
                            [ button [ class "button is-medium is-success is-inverted" ]
                                [ span [ class "icon" ]
                                    [ i [ class "fas fa-check" ]
                                        []
                                    ]
                                ]
                            , button [ class "button is-medium is-danger is-inverted" ]
                                [ span [ class "icon" ]
                                    [ i [ class "fas fa-times" ]
                                        []
                                    ]
                                ]
                            ]
                        ]
                    ]
                , hr []
                    []
                , div [ class "has-margin-left-6 has-margin-bottom-6" ]
                    [ div [ class "is-size-4 has-text-weight-bold" ]
                        [ text "21.03.2020" ]
                    ]
                , div [ class "box has-margin-left-6" ]
                    [ ul []
                        [ li []
                            [ div [ class "columns" ]
                                [ div [ class "column is-two-fifths" ]
                                    [ div [ class "columns is-mobile" ]
                                        [ div [ class "column is-narrow" ]
                                            [ p [ class "title is-1 has-text-grey-lighter" ]
                                                [ text "2" ]
                                            ]
                                        , div [ class "column" ]
                                            [ p [ class "title is-4" ]
                                                [ text "Push-Ups" ]
                                            , p [ class "subtitle is-6" ]
                                                [ text "On knees" ]
                                            ]
                                        ]
                                    ]
                                , div [ class "column" ]
                                    [ div [ class "tags" ]
                                        [ span [ class "tag is-large" ]
                                            [ text "20" ]
                                        , span [ class "tag is-large" ]
                                            [ text "15" ]
                                        , span [ class "tag is-large" ]
                                            [ text "30" ]
                                        , span [ class "tag is-large" ]
                                            [ text "40" ]
                                        , span [ class "tag is-large" ]
                                            [ text "30" ]
                                        , button [ class "button is-success is-inverted has-margin-bottom-7" ]
                                            [ span [ class "icon" ]
                                                [ i [ class "fas fa-plus" ]
                                                    []
                                                ]
                                            , span []
                                                [ text "Add Set" ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        , hr []
                            []
                        , li []
                            [ div [ class "columns" ]
                                [ div [ class "column is-two-fifths" ]
                                    [ div [ class "columns is-mobile" ]
                                        [ div [ class "column is-narrow" ]
                                            [ p [ class "title is-1 has-text-grey-lighter" ]
                                                [ text "1" ]
                                            ]
                                        , div [ class "column" ]
                                            [ p [ class "title is-4" ]
                                                [ text "Pull-Ups" ]
                                            , p [ class "subtitle is-6" ]
                                                [ text "Vertical pull" ]
                                            ]
                                        ]
                                    ]
                                , div [ class "column" ]
                                    [ div [ class "tags" ]
                                        [ span [ class "tag is-large" ]
                                            [ text "20" ]
                                        , span [ class "tag is-large is-paddingless" ]
                                            [ button [ class "button is-danger" ]
                                                [ span [ class "icon" ]
                                                    [ i [ class "fas fa-times" ]
                                                        []
                                                    ]
                                                ]
                                            ]
                                        , button [ class "button is-success is-inverted has-margin-bottom-7" ]
                                            [ span [ class "icon" ]
                                                [ i [ class "fas fa-plus" ]
                                                    []
                                                ]
                                            , span []
                                                [ text "Add Set" ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
