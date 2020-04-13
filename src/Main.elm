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
-- Outgoing ports


port ask : Json.Encode.Value -> Cmd msg


port signIn : () -> Cmd msg


port signOut : () -> Cmd msg


port saveTraining : Json.Encode.Value -> Cmd msg


port removeTraining : Json.Encode.Value -> Cmd msg



-- Incoming ports


port receive : (Json.Encode.Value -> msg) -> Sub msg


port signInInfo : (Json.Encode.Value -> msg) -> Sub msg


port receiveTrainings : (Json.Encode.Value -> msg) -> Sub msg



---- MODEL ----


type alias ErrorData =
    { code : Maybe String
    , message : Maybe String
    , credential : Maybe String
    }


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
    { error : ErrorData
    , today : String
    , userData : Maybe UserData
    , exercises : List Exercise
    , dropdownActiveExercise : Bool
    , dropdownActiveLevel : Bool
    , showDropdowns : Bool
    , chosenDate : String
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


defaultTraining : Training
defaultTraining =
    { id = 0
    , date = ""
    , exerciseId = 0
    , levelId = 0
    , repetitions = []
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
    []


messageToError : String -> ErrorData
messageToError message =
    { code = Maybe.Nothing, credential = Maybe.Nothing, message = Just message }


emptyError : ErrorData
emptyError =
    { code = Maybe.Nothing, credential = Maybe.Nothing, message = Maybe.Nothing }


idToExercise : Dict Int Exercise
idToExercise =
    DictExtra.fromListBy .id exercises


getTrainingLabel : Training -> String
getTrainingLabel training =
    (Maybe.withDefault (Exercise 0 "" [])
        (Dict.get training.exerciseId idToExercise)
    ).name


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
            Maybe.withDefault (Exercise 0 "" [])
                (Dict.get training.exerciseId idToExercise)

        levelIndex =
            getTrainingLevelIndex training
    in
    (Maybe.withDefault (Level 0 "") (ListExtra.getAt levelIndex exercise.levels)).name


getTrainingById : Model -> Int -> Training
getTrainingById model trainingId =
    let
        idToTraining =
            DictExtra.fromListBy .id model.trainings
    in
    Maybe.withDefault defaultTraining (Dict.get trainingId idToTraining)


{-| Emit a message e.g. during startup

-- <https://blog.revathskumar.com/2018/11/elm-send-command-on-init.html>

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
    ( { error = emptyError
      , today = ""
      , userData = Maybe.Nothing
      , exercises = exercises
      , dropdownActiveExercise = False
      , dropdownActiveLevel = False
      , showDropdowns = False
      , chosenDate = ""
      , chosenExercise = defaultExercise
      , chosenLevel = defaultLevel
      , trainings = trainings
      }
    , emitMessage AskForToday
    )



---- UPDATE ----


type Msg
    = RemoveErrorMessage
    | LogIn
    | LoggedInData (Result Json.Decode.Error UserData)
    | LogOut
    | TrainingsReceived (Result Json.Decode.Error (List Training))
    | AskForToday
    | ReceivedToday (Result Json.Decode.Error String)
    | ToggleShowDropdowns
    | ToggleDropdownExercise
    | ToggleDropdownLevel
    | SelectDate String
    | SelectExercise Exercise
    | SelectLevel Level
    | AddTraining String Exercise Level
    | AddRepetition Training Int
    | UpdateRepetition Training Int String
    | DeleteTraining Training


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RemoveErrorMessage ->
            ( { model | error = emptyError }, Cmd.none )

        LogIn ->
            ( model, signIn () )

        LoggedInData result ->
            case result of
                Ok value ->
                    ( { model | userData = Just value }, Cmd.none )

                Err error ->
                    ( { model
                        | error = messageToError <| Json.Decode.errorToString error
                      }
                    , Cmd.none
                    )

        LogOut ->
            ( { model | userData = Maybe.Nothing }, signOut () )

        TrainingsReceived result ->
            case result of
                Ok value ->
                    ( { model | trainings = List.reverse value }, Cmd.none )

                Err error ->
                    ( { model
                        | error = messageToError <| Json.Decode.errorToString error
                      }
                    , Cmd.none
                    )

        AskForToday ->
            ( model, ask <| Json.Encode.string "today" )

        ReceivedToday result ->
            case result of
                Ok value ->
                    ( { model | today = value, chosenDate = value }, Cmd.none )

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

        SelectDate dateString ->
            ( { model
                | chosenDate = dateString
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

        AddTraining dateString exercise level ->
            let
                training =
                    Training (generateNewTrainingId model.trainings) dateString exercise.id level.id []
            in
            ( { model
                | trainings = training :: model.trainings
              }
            , saveTraining <| trainingEncoder model training
            )

        AddRepetition training repetition ->
            ( addRepetitionToTraining model training repetition
            , Cmd.none
            )

        UpdateRepetition training repetitionIndex value ->
            let
                converted =
                    String.toInt value
            in
            case converted of
                Just number ->
                    let
                        updatedModel =
                            updateRepetitionInTraining model training repetitionIndex number

                        updatedTraining =
                            getTrainingById updatedModel training.id
                    in
                    ( updatedModel
                    , saveTraining <| trainingEncoder updatedModel updatedTraining
                    )

                -- Delete the repetition when input was invalid, that way we can e.g.
                -- just remove the value to trigger the deletion and don't need an extra
                -- button or anything.
                Nothing ->
                    let
                        updatedModel =
                            deleteRepetitionFromTraining model training repetitionIndex

                        updatedTraining =
                            getTrainingById updatedModel training.id
                    in
                    ( deleteRepetitionFromTraining model training repetitionIndex
                    , saveTraining <| trainingEncoder updatedModel updatedTraining
                    )

        DeleteTraining training ->
            ( { model
                | trainings = List.filter (\t -> t.id /= training.id) model.trainings
              }
            , removeTraining <| trainingEncoder model training
            )


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


nothing : Html Msg
nothing =
    text ""


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
                [ button [ class "button is-medium has-margin-top-5 is-info is-inverted" ]
                    [ span
                        [ onClick LogIn ]
                        [ text "Login with Google" ]
                    ]
                ]
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    section
        [ class "hero is-small is-info has-text-centered"
        , classList [ ( "is-fullheight", model.userData == Maybe.Nothing ) ]
        ]
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
        [ class "dropdown"
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
                (List.map
                    (viewDropdownItemExercise model.chosenExercise)
                    model.exercises
                )
            ]
        ]


viewDropdownLevel : Model -> Html Msg
viewDropdownLevel model =
    div
        [ class "dropdown"
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
                (List.indexedMap
                    (viewDropdownItemLevel model.chosenLevel)
                    model.chosenExercise.levels
                )
            ]
        ]


viewButtonsAddExerciseConfirmAbort : Model -> Html Msg
viewButtonsAddExerciseConfirmAbort model =
    let
        shouldDisableAddTrainingButton =
            model.chosenDate == "" || model.chosenLevel == defaultLevel
    in
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
            , disabled shouldDisableAddTrainingButton
            , onClick (AddTraining model.chosenDate model.chosenExercise model.chosenLevel)
            ]
            [ span [ class "icon" ]
                [ i [ class "fas fa-check" ] [] ]
            , span [] [ text "Add" ]
            ]
        ]


{-| Convert '2020-03-14' -> '14.03.2020'
-}
formatDateStringForDisplay : String -> String
formatDateStringForDisplay dateString =
    let
        yearMonthDayList =
            String.split "-" dateString

        year =
            Maybe.withDefault "YYYY" (List.head yearMonthDayList)

        monthDayList =
            Maybe.withDefault [] (List.tail yearMonthDayList)

        month =
            Maybe.withDefault "MM" (List.head monthDayList)

        dayList =
            Maybe.withDefault [] (List.tail monthDayList)

        day =
            Maybe.withDefault "DD" (List.head dayList)
    in
    day ++ "." ++ month ++ "." ++ year


viewDateInput : Model -> Html Msg
viewDateInput model =
    div []
        [ input
            [ class "input"
            , style "width" "auto"
            , type_ "date"
            , value model.chosenDate
            , onChange SelectDate
            ]
            []
        ]


viewTransformingAddButton : Model -> Html Msg
viewTransformingAddButton model =
    if model.showDropdowns then
        div [ class "columns is-gapless has-text-centered is-centered is-vcentered has-margin-top-7" ]
            [ div [ class "column is-narrow has-margin-top-7 has-margin-right-7" ]
                [ viewDateInput model ]
            , div [ class "column is-narrow has-margin-top-7 has-margin-right-7" ]
                [ viewDropdownExercise model ]
            , div [ class "column is-narrow has-margin-top-7 has-margin-right-7" ]
                [ viewDropdownLevel model ]
            , div [ class "column is-narrow has-margin-top-7" ]
                [ viewButtonsAddExerciseConfirmAbort model ]
            ]

    else
        div [ class "level" ]
            [ div [ class "level-item has-margin-top-6" ]
                [ viewButtonAddExercise ]
            ]


viewTraining : List Training -> Int -> Training -> Html Msg
viewTraining allTrainings index training =
    let
        label =
            getTrainingLabel training

        level =
            String.fromInt (getTrainingLevel training)

        sublabel =
            getTrainingSublabel training

        isLast =
            index == List.length allTrainings - 1

        nextTraining =
            Maybe.withDefault defaultTraining (ListExtra.getAt (index - 1) allTrainings)

        showDateHeader =
            nextTraining == defaultTraining || nextTraining.date /= training.date

        addBottomSpacing =
            isLast || not showDateHeader
    in
    div
        [ class "box is-radiusless"
        , classList
            [ ( "is-marginless", not addBottomSpacing ) ]
        ]
        [ if showDateHeader then
            div [ class "has-margin-bottom-7" ]
                [ div [ class "is-size-5 has-text-grey-light" ]
                    [ text (formatDateStringForDisplay training.date) ]
                ]

          else
            nothing
        , div [ class "columns" ]
            [ div [ class "column is-two-fifths" ]
                [ div [ class "columns is-mobile" ]
                    [ div
                        [ class "column is-narrow clickable deleteable"
                        , onClick (DeleteTraining training)
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


viewTrainingAddRepetitionButton : Training -> Html Msg
viewTrainingAddRepetitionButton training =
    button
        [ class "button is-success is-inverted has-margin-bottom-7"
        , onClick (AddRepetition training 0)
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
    let
        sortedTrainings =
            List.reverse (List.sortBy .date model.trainings)
    in
    if List.length model.trainings == 0 then
        div [ class "has-text-grey has-text-centered" ]
            [ text "You have not tracked any exercises so far" ]

    else
        div []
            (List.indexedMap (viewTraining sortedTrainings) sortedTrainings)


viewError : Model -> Html Msg
viewError model =
    if model.error /= emptyError then
        div [ class "notification is-danger is-marginless is-radiusless" ]
            [ div [ class "delete", onClick RemoveErrorMessage ] []
            , text (Maybe.withDefault "" model.error.message)
            ]

    else
        nothing


viewBody : Model -> Html Msg
viewBody model =
    section []
        [ div
            [ class "container"
            , style "max-width" "720px"
            ]
            [ viewTransformingAddButton model
            , viewTrainingsList model
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ viewError model
        , viewHeader model
        , if model.userData == Maybe.Nothing then
            nothing

          else
            viewBody model
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


trainingEncoder : Model -> Training -> Json.Encode.Value
trainingEncoder model training =
    Json.Encode.object
        [ ( "content"
          , Json.Encode.object
                [ ( "id", Json.Encode.int training.id )
                , ( "date", Json.Encode.string training.date )
                , ( "exerciseId", Json.Encode.int training.exerciseId )
                , ( "levelId", Json.Encode.int training.levelId )
                , ( "repetitions"
                  , Json.Encode.list Json.Encode.int training.repetitions
                  )
                ]
          )
        , ( "uid"
          , case model.userData of
                Just userData ->
                    Json.Encode.string userData.uid

                Maybe.Nothing ->
                    Json.Encode.null
          )
        ]


trainingDecoder : Json.Decode.Decoder Training
trainingDecoder =
    Json.Decode.succeed Training
        |> Json.Decode.Pipeline.required "id" Json.Decode.int
        |> Json.Decode.Pipeline.required "date" Json.Decode.string
        |> Json.Decode.Pipeline.required "exerciseId" Json.Decode.int
        |> Json.Decode.Pipeline.required "levelId" Json.Decode.int
        |> Json.Decode.Pipeline.required "repetitions" (Json.Decode.list Json.Decode.int)


trainingListDecoder : Json.Decode.Decoder (List Training)
trainingListDecoder =
    Json.Decode.succeed identity
        |> Json.Decode.Pipeline.required "trainings" (Json.Decode.list trainingDecoder)


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ receive (Json.Decode.decodeValue todayDecoder >> ReceivedToday)
        , signInInfo (Json.Decode.decodeValue userDataDecoder >> LoggedInData)
        , receiveTrainings (Json.Decode.decodeValue trainingListDecoder >> TrainingsReceived)
        ]


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
