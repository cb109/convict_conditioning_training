module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Level =
    { id : Int
    , name : String
    }


type alias Exercise =
    { id : Int
    , name : String
    , levels : List Level
    }


exercises : List Exercise
exercises =
    [ { id = 1
      , name = "Kniebeuge"
      , levels =
            [ { id = 10, name = "Schulterstand Kniebeuge" }
            , { id = 11, name = "Klappmesser Kniebeuge" }
            , { id = 12, name = "Gestützte Kniebeuge" }
            , { id = 13, name = "Halbe Kniebeuge" }
            , { id = 14, name = "Vollständige Kniebeuge" }
            , { id = 15, name = "Kniebeuge im engen Stand" }
            , { id = 16, name = "Ungleiche Kniebeuge" }
            , { id = 17, name = "Halbe einbeinige Kniebeuge" }
            , { id = 18, name = "Unterstützte einbeinige Kniebeuge" }
            , { id = 19, name = "Einbeinige Kniebeuge" }
            ]
      }
    , { id = 2
      , name = "Klimmzug"
      , levels =
            [ { id = 20, name = "Senkrechter Zug" }
            , { id = 21, name = "Waagerechter Zug" }
            , { id = 22, name = "Klappmesser Klimmzug" }
            , { id = 23, name = "Halber Klimmzug" }
            , { id = 24, name = "Vollständiger Klimmzug" }
            , { id = 25, name = "Enger Klimmzug" }
            , { id = 26, name = "Ungleicher Klimmzug" }
            , { id = 27, name = "Halber einarmiger Klimmzug" }
            , { id = 28, name = "Unterstützter einarmiger Klimmzug" }
            , { id = 29, name = "Einarmiger Klimmzug" }
            ]
      }
    , { id = 3
      , name = "Liegestütz"
      , levels =
            [ { id = 30, name = "Liegestütz an der Wand" }
            , { id = 31, name = "Schräger Liegestütz" }
            , { id = 32, name = "Liegestütz auf den Knien" }
            , { id = 33, name = "Halber Liegestütz" }
            , { id = 34, name = "Vollständiger Liegestütz" }
            , { id = 35, name = "Enger Liegestütz" }
            , { id = 36, name = "Ungleicher Liegestütz" }
            , { id = 37, name = "Halber einarmiger Liegestütz" }
            , { id = 38, name = "Einarmiger Hebel-Liegestütz" }
            , { id = 39, name = "Einarmiger Liegestütz" }
            ]
      }
    , { id = 4
      , name = "Beinheben"
      , levels =
            [ { id = 40, name = "Knieanziehen" }
            , { id = 41, name = "Knieheben im Liegen" }
            , { id = 42, name = "Gebeugtes Beinheben im Liegen" }
            , { id = 43, name = "Froschbeinheben im Liegen" }
            , { id = 44, name = "Gerades Beinheben im Liegen" }
            , { id = 45, name = "Hängendes Knieheben" }
            , { id = 46, name = "Hängendes gebeugtes Knieheben" }
            , { id = 47, name = "Hängendes Froschbeinheben" }
            , { id = 48, name = "Hängendes halbes Beinheben" }
            , { id = 49, name = "Hängendes gerades Beinheben" }
            ]
      }
    , { id = 5
      , name = "Handstand-Liegestütz"
      , levels =
            [ { id = 50, name = "Kopfstand an der Wand" }
            , { id = 51, name = "Die Krähe" }
            , { id = 52, name = "Handstand an der Wand" }
            , { id = 53, name = "Halber Handstand-Liegestütz" }
            , { id = 54, name = "Handstand-Liegestütz" }
            , { id = 55, name = "Enger Handstand-Liegestütz" }
            , { id = 56, name = "Ungleicher Handstand-Liegestütz" }
            , { id = 57, name = "Halber einarmiger Handstand-Liegestütz" }
            , { id = 58, name = "Hebel-Handstand-Liegestütz" }
            , { id = 59, name = "Einarmiger Handstand-Liegestütz" }
            ]
      }
    , { id = 6
      , name = "Brücke"
      , levels =
            [ { id = 50, name = "Kurze Brücke" }
            , { id = 51, name = "Gerade Brücke" }
            , { id = 52, name = "Angewinkelte Brücke" }
            , { id = 53, name = "Kopf-Brücke" }
            , { id = 54, name = "Halbe Brücke" }
            , { id = 55, name = "Vollständige Brücke" }
            , { id = 56, name = "Brücke an der Wand abwärts" }
            , { id = 57, name = "Brücke an der Wand aufwärts" }
            , { id = 58, name = "Brücke aus dem Stand" }
            , { id = 59, name = "Stand-zu-Stand Brücke" }
            ]
      }
    ]


type alias Model =
    { exercises : List Exercise }


init : Model
init =
    { exercises = exercises }


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    model


viewHeader : Model -> Html Msg
viewHeader model =
    section [ class "hero is-small is-info has-text-centered" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "Convict Conditioning" ]
                , h2 [ class "subtitle" ]
                    [ text "Training Progress Log" ]
                ]
            ]
        ]


viewButtonAddExercise : Model -> Html Msg
viewButtonAddExercise model =
    button [ class "button is-medium is-success is-inverted has-margin-top-6" ]
        [ span [ class "icon" ]
            [ i [ class "fas fa-plus" ]
                []
            ]
        , span []
            [ text "Add Exercise" ]
        ]


viewDropdownExercise : Model -> Html Msg
viewDropdownExercise model =
    div [ class "dropdown is-active2 has-margin-right-7" ]
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


viewDropdownLevel : Model -> Html Msg
viewDropdownLevel model =
    div [ class "dropdown is-active2 has-margin-right-7" ]
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


viewButtonsAddExerciseConfirmAbort : Model -> Html Msg
viewButtonsAddExerciseConfirmAbort model =
    div [ class "buttons" ]
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


viewDateSubheader : Model -> Html Msg
viewDateSubheader model =
    div [ class "has-margin-left-6 has-margin-bottom-6" ]
        [ div [ class "is-size-4 has-text-weight-bold" ]
            [ text "21.03.2020" ]
        ]


viewTrainedExercise1 : Model -> Html Msg
viewTrainedExercise1 model =
    div [ class "columns" ]
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


viewTrainedExercise2 : Model -> Html Msg
viewTrainedExercise2 model =
    div [ class "columns" ]
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


viewBody : Model -> Html Msg
viewBody model =
    section []
        [ div [ class "container" ]
            [ div [ class "level" ]
                [ div [ class "level-item" ]
                    [ viewButtonAddExercise model ]
                ]
            , div [ class "level" ]
                [ div [ class "level-item" ]
                    [ viewDropdownExercise model
                    , viewDropdownLevel model
                    , viewButtonsAddExerciseConfirmAbort model
                    ]
                ]
            , hr [] []
            , viewDateSubheader model
            , div [ class "box has-margin-left-6" ]
                [ ul []
                    [ li []
                        [ viewTrainedExercise1 model ]
                    , hr []
                        []
                    , li []
                        [ viewTrainedExercise2 model ]
                    ]
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ viewHeader model
        , viewBody model
        ]
