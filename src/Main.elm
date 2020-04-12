port module Main exposing (..)

import Browser
import Dict exposing (Dict)
import Dict.Extra as DictExtra
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Events.Extra exposing (onChange)
import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import List.Extra as ListExtra
import Task



---- PORTS ----


port ask : Json.Encode.Value -> Cmd msg


port receive : (Json.Encode.Value -> msg) -> Sub msg


port signIn : () -> Cmd msg


port signInInfo : (Json.Encode.Value -> msg) -> Sub msg


port signOut : () -> Cmd msg



---- MODEL ----


type alias UserData =
    { token : String
    , email : String
    , uid : String
    }


type alias Level =
    { id : Int
    , name : String
    }


type alias Exercise =
    { id : Int
    , name : String
    , levels : List Level
    }


type alias Training =
    { id : Int
    , date : String
    , exerciseId : Int
    , levelId : Int
    , repetitions : List Int
    }


type alias Model =
    { today : String
    , userData : Maybe UserData
    , exercises : List Exercise
    , dropdownActiveExercise : Bool
    , dropdownActiveLevel : Bool
    , showDropdowns : Bool
    , chosenExercise : Exercise
    , chosenLevel : Level
    , trainings : List Training
    }


maxRepetition : Int
maxRepetition =
    99


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


trainings : List Training
trainings =
    [ { id = 100
      , date = "01.01.2011"
      , exerciseId = 2
      , levelId = 21
      , repetitions = [ 20, 15, 30, 40, 30 ]
      }
    ]


idToExercise : Dict Int Exercise
idToExercise =
    DictExtra.fromListBy .id exercises


idToTraining : Dict Int Training
idToTraining =
    DictExtra.fromListBy .id trainings


getTrainingLabel : Training -> String
getTrainingLabel training =
    (Maybe.withDefault (Exercise 0 "" []) (Dict.get training.exerciseId idToExercise)).name


getTrainingLevel : Training -> Int
getTrainingLevel training =
    -- Level ids relate to the exercise ids by a factor of 10
    training.levelId - (training.exerciseId * 10) + 1


getTrainingLevelIndex : Training -> Int
getTrainingLevelIndex training =
    getTrainingLevel training - 1


getTrainingSublabel : Training -> String
getTrainingSublabel training =
    let
        exercise =
            Maybe.withDefault (Exercise 0 "" []) (Dict.get training.exerciseId idToExercise)

        levelIndex =
            getTrainingLevelIndex training
    in
    (Maybe.withDefault (Level 0 "") (ListExtra.getAt levelIndex exercise.levels)).name


getTrainingById : Int -> Training
getTrainingById trainingId =
    Maybe.withDefault (Training 0 "" 0 0 []) (Dict.get trainingId idToTraining)


{-| Emit a message e.g. during startup

    https :// blog.revathskumar.com / 2018 / 11 / elm - send - command - on - init.html

-}
emitMessage : Msg -> Cmd Msg
emitMessage msg =
    let
        identity : a -> a
        identity a =
            a
    in
    Task.succeed msg |> Task.perform identity


init : ( Model, Cmd Msg )
init =
    ( { today = "not yet initialized"
      , userData = Maybe.Nothing
      , exercises = exercises
      , dropdownActiveExercise = False
      , dropdownActiveLevel = False
      , showDropdowns = False
      , chosenExercise = defaultExercise
      , chosenLevel = defaultLevel
      , trainings = trainings
      }
    , emitMessage AskForToday
    )



---- UPDATE ----


type Msg
    = LogIn
    | LoggedInData (Result Json.Decode.Error UserData)
    | LogOut
    | AskForToday
    | ReceivedToday (Result Json.Decode.Error String)
    | ToggleShowDropdowns
    | ToggleDropdownExercise
    | ToggleDropdownLevel
    | SelectExercise Exercise
    | SelectLevel Level
    | AddTraining Exercise Level
    | AddRepetition Training Int
    | UpdateRepetition Training Int String
    | DeleteRepetition Training Int
    | DeleteTraining Training


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LogIn ->
            ( model, signIn () )

        LoggedInData result ->
            case result of
                Ok value ->
                    ( { model | userData = Just value }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        LogOut ->
            ( { model | userData = Maybe.Nothing }, signOut () )

        AskForToday ->
            ( model, ask <| Json.Encode.string "today" )

        ReceivedToday result ->
            case result of
                Ok value ->
                    ( { model | today = value }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

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

        AddTraining exercise level ->
            let
                training =
                    Training (generateNewTrainingId model.trainings) model.today exercise.id level.id []
            in
            ( { model
                | trainings = training :: model.trainings
              }
            , Cmd.none
            )

        AddRepetition training repetition ->
            ( addRepetitionToTraining model training repetition, Cmd.none )

        UpdateRepetition training repetitionIndex value ->
            let
                converted =
                    String.toInt value
            in
            case converted of
                Just number ->
                    ( updateRepetitionInTraining model training repetitionIndex number, Cmd.none )

                -- Delete the repetition when input was invalid, that way we can e.g.
                -- just remove the value to trigger the deletion and don't need an extra
                -- button or anything.
                Nothing ->
                    ( deleteRepetitionFromTraining model training repetitionIndex, Cmd.none )

        DeleteRepetition training repetitionIndex ->
            ( deleteRepetitionFromTraining model training repetitionIndex, Cmd.none )

        DeleteTraining training ->
            ( { model | trainings = List.filter (\t -> t.id /= training.id) model.trainings }, Cmd.none )


generateNewTrainingId : List Training -> Int
generateNewTrainingId trainings_ =
    Maybe.withDefault 0 (List.maximum (List.map (\t -> t.id) trainings_)) + 1


addRepetitionToTraining : Model -> Training -> Int -> Model
addRepetitionToTraining model training repetition =
    let
        updatedRepetitions =
            repetition :: training.repetitions

        updateReps currentTraining =
            if currentTraining.id == training.id then
                { currentTraining | repetitions = updatedRepetitions }

            else
                currentTraining

        updatedTrainings =
            List.map updateReps model.trainings
    in
    { model | trainings = updatedTrainings }


updateRepetitionInTraining : Model -> Training -> Int -> Int -> Model
updateRepetitionInTraining model training repetitionIndex newValue =
    -- Limit value to two digits
    if newValue > maxRepetition then
        model

    else
        let
            updateRepetitionValues index oldValue =
                if index == repetitionIndex then
                    newValue

                else
                    oldValue

            updatedRepetitions =
                List.indexedMap updateRepetitionValues training.repetitions

            updateReps currentTraining =
                if currentTraining.id == training.id then
                    { currentTraining | repetitions = updatedRepetitions }

                else
                    currentTraining

            updatedTrainings =
                List.map updateReps model.trainings
        in
        { model | trainings = updatedTrainings }


deleteRepetitionFromTraining : Model -> Training -> Int -> Model
deleteRepetitionFromTraining model training repetitionIndex =
    let
        updatedRepetitions =
            ListExtra.removeAt repetitionIndex training.repetitions

        updateReps currentTraining =
            if currentTraining.id == training.id then
                { currentTraining | repetitions = updatedRepetitions }

            else
                currentTraining

        updatedTrainings =
            List.map updateReps model.trainings
    in
    { model | trainings = updatedTrainings }



---- VIEW ----


viewLoginLogoutButtons : Model -> Html Msg
viewLoginLogoutButtons model =
    let
        email =
            (Maybe.withDefault (UserData "" "" "") model.userData).email
    in
    div []
        [ if model.userData /= Maybe.Nothing then
            div []
                [ button [ class "button is-small is-info is-outlined is-inverted" ]
                    [ span
                        [ onClick LogOut ]
                        [ text ("Logout: " ++ email) ]
                    ]
                ]

          else
            div []
                [ button [ class "button is-small is-info is-outlined is-inverted" ]
                    [ span
                        [ onClick LogIn ]
                        [ text "Login with Google" ]
                    ]
                ]
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    section [ class "hero is-small is-info has-text-centered" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title" ]
                    [ text "Convict Conditioning" ]
                , h2 [ class "subtitle has-margin-bottom-7" ]
                    [ text "Training Progress Log" ]
                , viewLoginLogoutButtons model
                ]
            ]
        ]


viewButtonAddExercise : Html Msg
viewButtonAddExercise =
    button
        [ class "button is-medium is-success is-inverted"
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
        [ button
            [ class "button is-medium is-danger is-inverted"
            , onClick ToggleShowDropdowns
            ]
            [ span [ class "icon" ] [ i [ class "fas fa-times" ] [] ]
            , span [] [ text "Close" ]
            ]
        , button
            [ class "button is-medium is-success is-inverted"
            , disabled (model.chosenLevel == defaultLevel)
            , onClick (AddTraining model.chosenExercise model.chosenLevel)
            ]
            [ span [ class "icon" ]
                [ i [ class "fas fa-check" ] [] ]
            , span [] [ text "Add" ]
            ]
        ]


viewTransformingAddButton : Model -> Html Msg
viewTransformingAddButton model =
    if model.showDropdowns then
        div [ class "columns is-gapless has-text-centered is-centered is-vcentered has-margin-top-7" ]
            [ div [ class "column is-narrow has-margin-top-7" ] [ viewDropdownExercise model ]
            , div [ class "column is-narrow has-margin-top-7" ] [ viewDropdownLevel model ]
            , div [ class "column is-narrow has-margin-top-7" ] [ viewButtonsAddExerciseConfirmAbort model ]
            ]

    else
        div [ class "level" ]
            [ div [ class "level-item has-margin-top-6" ]
                [ viewButtonAddExercise ]
            ]


viewTraining : Int -> Int -> Training -> Html Msg
viewTraining amountTrainings index training =
    let
        label =
            getTrainingLabel training

        level =
            String.fromInt (getTrainingLevel training)

        sublabel =
            getTrainingSublabel training

        isLast =
            index == amountTrainings - 1

        divider =
            if isLast then
                span [] []

            else
                hr [] []
    in
    div []
        [ div [ class "has-margin-bottom-7" ]
            [ div [ class "is-size-5 has-text-grey-light" ]
                [ text training.date ]
            ]
        , div [ class "columns" ]
            [ div [ class "column is-two-fifths" ]
                [ div [ class "columns is-mobile" ]
                    [ div
                        [ class "column is-narrow clickable deleteable"
                        , onClick (deleteTraining training)
                        ]
                        [ p
                            [ class "title is-1  has-text-grey-lighter" ]
                            [ text level ]
                        ]
                    , div [ class "column" ]
                        [ p [ class "title is-4" ]
                            [ text label ]
                        , p [ class "subtitle is-6" ]
                            [ text sublabel ]
                        ]
                    ]
                ]
            , div [ class "column" ]
                [ div [ class "tags" ]
                    (viewTrainingTags training)
                ]
            ]
        , divider
        ]


viewTrainingTags : Training -> List (Html Msg)
viewTrainingTags training =
    let
        mapTraining =
            viewTrainingRepetition training

        reps =
            List.indexedMap mapTraining training.repetitions
    in
    List.reverse (viewTrainingAddRepetitionButton training :: reps)


viewTrainingRepetition : Training -> Int -> Int -> Html Msg
viewTrainingRepetition training index repetition =
    span
        [ class "tag is-large is-paddingless" ]
        [ input
            [ class "input repetition-input"
            , type_ "text"
            , value (String.fromInt repetition)
            , onChange (UpdateRepetition training index)
            ]
            []
        ]


deleteRepetition : Training -> Int -> Msg
deleteRepetition training index =
    DeleteRepetition training index


deleteTraining : Training -> Msg
deleteTraining training =
    DeleteTraining training


addRepetition : Training -> Msg
addRepetition training =
    AddRepetition training 0


viewTrainingAddRepetitionButton : Training -> Html Msg
viewTrainingAddRepetitionButton training =
    button
        [ class "button is-success is-inverted has-margin-bottom-7"
        , onClick (addRepetition training)
        ]
        [ span [ class "icon" ]
            [ i [ class "fas fa-plus" ]
                []
            ]
        , span []
            [ text "Add Set" ]
        ]


viewTrainingsList : Model -> Html Msg
viewTrainingsList model =
    if List.length model.trainings == 0 then
        div [ class "has-text-grey has-text-centered" ]
            [ text "You have not tracked any exercises so far" ]

    else
        div []
            [ div [ class "box has-margin-left-6" ]
                [ ul []
                    [ li []
                        (List.indexedMap (viewTraining (List.length model.trainings)) model.trainings)
                    ]
                ]
            ]


viewBody : Model -> Html Msg
viewBody model =
    section []
        [ div [ class "container" ]
            [ viewTransformingAddButton model
            , hr [] []
            , viewTrainingsList model
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ viewHeader model
        , viewBody model
        ]



---- PROGRAM ----


todayDecoder : Json.Decode.Decoder String
todayDecoder =
    Json.Decode.field "today" Json.Decode.string


userDataDecoder : Json.Decode.Decoder UserData
userDataDecoder =
    Json.Decode.succeed UserData
        |> Json.Decode.Pipeline.required "token" Json.Decode.string
        |> Json.Decode.Pipeline.required "email" Json.Decode.string
        |> Json.Decode.Pipeline.required "uid" Json.Decode.string


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ receive (Json.Decode.decodeValue todayDecoder >> ReceivedToday)
        , signInInfo (Json.Decode.decodeValue userDataDecoder >> LoggedInData)
        ]


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
