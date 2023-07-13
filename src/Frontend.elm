module Frontend exposing (app)

import Html exposing (Html, button, div, h1, input, li, p, text, ul)
import Html.Attributes exposing (placeholder, style)
import Html.Events exposing (onClick, onInput)
import Lamdera
import Types exposing (..)

app =
    Lamdera.frontend
        { init = \_ _ -> init
        , update = update
        , updateFromBackend = updateFromBackend
        , view = \frontendModel -> { title = "TODO", body = [ view frontendModel, viewDoing frontendModel, viewDone frontendModel ] }
        , subscriptions = \_ -> Sub.none
        , onUrlChange = \_ -> FNoop
        , onUrlRequest = \_ -> FNoop
        }


{-| line 11 inline function -> will need to adapt the init i've
and needs to provide to lamdera
receive something from different form
-}
init : ( FrontendModel, Cmd FrontendMsg )
init =
    ( { tasks = []
      , addTaskForm = { title = "", content = "", owner = "", phase = "" }
      , clientId = ""
      }
    , Cmd.none
    )


update : FrontendMsg -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
update msg model =
    case msg of
        SaveButtonClicked phase ->
            ( { model | tasks = { phase = phase, title = model.addTaskForm.title, content = model.addTaskForm.content, owner = model.addTaskForm.owner } :: model.tasks }, Lamdera.sendToBackend (StoreNewTask { phase = phase, title = model.addTaskForm.title, content = model.addTaskForm.content, owner = model.addTaskForm.owner }) )

        InputTitle text ->
            ( { model | addTaskForm = { phase = "", title = text, content = model.addTaskForm.content, owner = model.addTaskForm.owner } }, Cmd.none )

        InputContent text ->
            ( { model | addTaskForm = { phase = "", title = model.addTaskForm.title, content = text, owner = model.addTaskForm.owner } }, Cmd.none )

        InputOwner text ->
            ( { model | addTaskForm = { phase = "", title = model.addTaskForm.title, content = model.addTaskForm.content, owner = text } }, Cmd.none )

        FNoop ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        ReplaceTaskList listTask ->
            ( { model | tasks = listTask }, Cmd.none )


view : FrontendModel -> Html FrontendMsg
view model =
    div []
        [ h1 [ style "color" "blue" ] [ text "Add new task" ]
        , input [ onInput InputTitle, placeholder "Title" ] []
        , input [ onInput InputContent, placeholder "Content" ] []
        , input [ onInput InputOwner, placeholder "Who did?" ] []
        , button [ onClick (SaveButtonClicked "todo") ] [ text "SAVE as todo" ]
        , button [ onClick (SaveButtonClicked "doing") ] [ text "SAVE as doing" ]
        , button [ onClick (SaveButtonClicked "done") ] [text "SAVE as done"]
        , ul [] [text "Tasks Counter ",(text (String.fromInt (List.length model.tasks)))]
        , h1 [ style "color" "red" ] [ text "TO DOs" ]
        , ul [] (List.map viewRenderTask (List.filter (\x -> x.phase == "todo") model.tasks))
        ]


viewDoing : FrontendModel -> Html FrontendMsg
viewDoing model =
    div []
        [ h1 [ style "color" "red" ] [ text "DOING" ]
        , ul [] (List.map viewRenderTask (List.filter (\x -> x.phase == "doing") model.tasks))
        ]

viewDone : FrontendModel -> Html FrontendMsg
viewDone model =
    div []
        [ h1 [ style "color" "red" ] [ text "DONE" ]
        , ul [] [text "Tasks Done  ", text (String.fromInt(List.length((List.filter (\x -> x.phase == "done") model.tasks))))]
        , ul [] (List.map viewRenderTask (List.filter (\x -> x.phase == "done") model.tasks))
        ]


viewRenderTask : Task -> Html msg
viewRenderTask task =
    li []
        [ p [] [ text ("Title: " ++ task.title) ]
        , p [] [ text ("Content: " ++ task.content) ]
        , p [] [ text ("Phase: " ++ task.phase) ]
        , p [] [ text ("Owner: " ++ task.owner) ]
        ]
