module Frontend exposing (app)

import Lamdera 
import Types exposing (..)
import Html exposing (Html, button, div, text, ul, li, p, input)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (placeholder)

app =
    Lamdera.frontend
        { init = \_ _ -> init
        , onUrlRequest = FNoop
        , onUrlChange = FNoop
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = Sub.none
        , view = view
        }


{-|
line 11 inline function -> will need to adapt the init i've
and needs to provide to lamdera 
receive something from different form

-}
init: (FrontendModel)
init = ({tasks = []
        ,addTaskForm = {title = "", content = "", owner = ""}
        ,clientId = ""}, Cmd.none)

update : FrontendMsg -> FrontendModel -> FrontendModel 
update msg model =
    case msg of
        SaveButtonClicked ->
            { model | tasks = model.addTaskForm :: model.tasks}

        InputTitle text ->
            { model | addTaskForm = { title = text, content = model.addTaskForm.content, owner = model.addTaskForm.owner } }

        InputContent text ->
            { model | addTaskForm = {content = text, title = model.addTaskForm.title, owner = model.addTaskForm.owner } }
 
        InputOwner text ->
            { model | addTaskForm = {owner = text, title = model.addTaskForm.title, content = model.addTaskForm.content } }
 

updateFromBackend : ToFrontend -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        ReplaceTaskList listTask ->
            ( { model | tasks = listTask}, Cmd.none )



view : FrontendModel -> Html FrontendMsg
view model =
    div []
        [ul [] (List.map viewRenderTask model.tasks)
        , input [onInput InputTitle, placeholder "Title"] []
        , input [onInput InputContent, placeholder "Content"] []
        , input [onInput InputOwner, placeholder "Who did?"] []
        , button [onClick SaveButtonClicked] [text "SAVE"]
        ]
    
    


viewRenderTask : Task -> Html msg
viewRenderTask task =
    li []
        [ p [] [ text task.title ]
        , p [] [ text task.content ]
        , p [] [ text task.owner ]
        ]
