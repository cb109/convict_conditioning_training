module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)



---- MODEL ----


type alias Item a =
    { a | id : Int, name : String }


type alias Level =
    { id : Int
    , name : String
    }


type alias Exercise =
    { id : Int
    , name : String
    , levels : List Level
    }


getListItemAt : List a -> Int -> Maybe a
getListItemAt things index =
    things
        |> List.drop (index - 1)
        |> List.head


defaultLevel : Level
defaultLevel =
    { id = 0
    , name = "Choose level"
    }


defaultExercise : Exercise
defaultExercise =
    { id = 0
    , name = "Choose exercise"
    , levels =
        []
    }


exercises : List Exercise
exercises =
    [ { id = 1
      , name = "Kniebeuge"
      , levels =
            [ { id = 10
              , name = "Schulterstand Kniebeuge"
              }
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
            [ { id = 60, name = "Kurze Brücke" }
            , { id = 61, name = "Gerade Brücke" }
            , { id = 62, name = "Angewinkelte Brücke" }
            , { id = 63, name = "Kopf-Brücke" }
            , { id = 64, name = "Halbe Brücke" }
            , { id = 65, name = "Vollständige Brücke" }
            , { id = 66, name = "Brücke an der Wand abwärts" }
            , { id = 67, name = "Brücke an der Wand aufwärts" }
            , { id = 68, name = "Brücke aus dem Stand" }
            , { id = 69, name = "Stand-zu-Stand Brücke" }
            ]
      }
    ]


type alias Model =
    { exercises : List Exercise
    , dropdownActiveExercise : Bool
    , dropdownActiveLevel : Bool
    , showDropdowns : Bool
    , chosenExercise : Exercise
    , chosenLevel : Level
    }


init : ( Model, Cmd Msg )
init =
    ( { exercises = exercises
      , dropdownActiveExercise = False
      , dropdownActiveLevel = False
      , showDropdowns = True
      , chosenExercise = defaultExercise
      , chosenLevel = defaultLevel
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = ToggleShowDropdowns
    | ToggleDropdownExercise
    | ToggleDropdownLevel
    | SelectExercise Exercise
    | SelectLevel Level


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleShowDropdowns ->
            ( { model
                | showDropdowns = not model.showDropdowns
              }
            , Cmd.none
            )

        ToggleDropdownExercise ->
            ( { model
                | dropdownActiveExercise = not model.dropdownActiveExercise
                , dropdownActiveLevel = False
              }
            , Cmd.none
            )

        ToggleDropdownLevel ->
            ( { model
                | dropdownActiveExercise = False
                , dropdownActiveLevel = not model.dropdownActiveLevel
              }
            , Cmd.none
            )

        SelectExercise exercise ->
            ( { model
                | chosenExercise = exercise
                , chosenLevel = defaultLevel
              }
            , Cmd.none
            )

        SelectLevel level ->
            ( { model
                | chosenLevel = level
              }
            , Cmd.none
            )



---- VIEW ----


viewHeader : Model -> Html Msg
viewHeader _ =
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
    button
        [ class "button is-medium is-success is-inverted has-margin-top-6"
        , onClick ToggleShowDropdowns
        ]
        [ span [ class "icon" ]
            [ i [ class "fas fa-plus" ]
                []
            ]
        , span []
            [ text "Add Exercise" ]
        ]


viewDropdownItemExercise : Exercise -> Exercise -> Html Msg
viewDropdownItemExercise chosenExercise exercise =
    a
        [ class "dropdown-item"
        , classList
            [ ( "is-active", exercise.id == chosenExercise.id ) ]
        , onClick (SelectExercise exercise)
        ]
        [ text exercise.name ]


viewDropdownItemLevel : Level -> Int -> Level -> Html Msg
viewDropdownItemLevel chosenLevel index level =
    let
        displayIndex =
            String.fromInt (index + 1)
    in
    a
        [ class "dropdown-item"
        , classList
            [ ( "is-active", level.id == chosenLevel.id ) ]
        , onClick (SelectLevel level)
        ]
        [ text (displayIndex ++ ". " ++ level.name) ]


viewDropdownExercise : Model -> Html Msg
viewDropdownExercise model =
    div
        [ class "dropdown has-margin-right-7"
        , classList
            [ ( "is-active", model.dropdownActiveExercise ) ]
        , onClick ToggleDropdownExercise
        ]
        [ div [ class "dropdown-trigger" ]
            [ button [ class "button" ]
                [ span []
                    [ text model.chosenExercise.name ]
                , span [ class "icon is-small" ]
                    [ i [ class "fas fa-angle-down" ]
                        []
                    ]
                ]
            ]
        , div [ class "dropdown-menu", id "dropdown-menu" ]
            [ div
                [ class "dropdown-content" ]
                (List.map (viewDropdownItemExercise model.chosenExercise) model.exercises)
            ]
        ]


viewDropdownLevel : Model -> Html Msg
viewDropdownLevel model =
    div
        [ class "dropdown has-margin-right-7"
        , classList
            [ ( "is-active", model.dropdownActiveLevel )
            , ( "is-disabled", model.chosenExercise == defaultExercise )
            ]
        , onClick ToggleDropdownLevel
        ]
        [ div [ class "dropdown-trigger" ]
            [ button [ class "button" ]
                [ span []
                    [ text model.chosenLevel.name ]
                , span [ class "icon is-small" ]
                    [ i [ class "fas fa-angle-down" ]
                        []
                    ]
                ]
            ]
        , div [ class "dropdown-menu", id "dropdown-menu" ]
            [ div [ class "dropdown-content" ]
                (List.indexedMap (viewDropdownItemLevel model.chosenLevel) model.chosenExercise.levels)
            ]
        ]


viewButtonsAddExerciseConfirmAbort : Model -> Html Msg
viewButtonsAddExerciseConfirmAbort model =
    div [ class "buttons is-centered" ]
        [ button [ class "button is-medium is-success is-inverted" ]
            [ span [ class "icon" ]
                [ i [ class "fas fa-check" ] [] ]
            , span [] [ text "Add" ]
            ]
        , button
            [ class "button is-medium is-danger is-inverted"
            , onClick ToggleShowDropdowns
            ]
            [ span [ class "icon" ] [ i [ class "fas fa-times" ] [] ]
            , span [] [ text "Cancel" ]
            ]
        ]


viewTransformingAddButton : Model -> Html Msg
viewTransformingAddButton model =
    if model.showDropdowns then
        div [ class "columns is-gapless is-centered is-vcentered has-margin-top-7" ]
            [ div [ class "column is-narrow has-margin-top-7" ] [ viewDropdownExercise model ]
            , div [ class "column is-narrow has-margin-top-7" ] [ viewDropdownLevel model ]
            , div [ class "column is-narrow has-margin-top-7" ] [ viewButtonsAddExerciseConfirmAbort model ]
            ]

    else
        div [ class "level" ]
            [ div [ class "level-item" ]
                [ viewButtonAddExercise model ]
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
            [ viewTransformingAddButton model
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



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
