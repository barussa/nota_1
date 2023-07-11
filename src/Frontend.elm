module Frontend exposing (app)

import Lamdera 
import Types exposing (..)
import Html exposing (Html, button, div, text, ul, li, p, input)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (placeholder)

app =
    Lamdera.frontend
        { init = \_ _ -> init
        , update = update
        , updateFromBackend = updateFromBackend
        , view = \frontendModel -> {title = "TODO", body = [view frontendModel]}
        , subscriptions = \_ -> Sub.none
        , onUrlChange =  \_ -> FNoop
        , onUrlRequest = \_ -> FNoop
        }


{-|
line 11 inline function -> will need to adapt the init i've
and needs to provide to lamdera 
receive something from different form

-}
init: (FrontendModel, Cmd FrontendMsg)
init = ({tasks = []
        ,addTaskForm = {title = "", content = "", owner = ""}
        ,clientId = ""}, Cmd.none)

update : FrontendMsg -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
update msg model =
    case msg of
        SaveButtonClicked ->
            ({ model | tasks = model.addTaskForm :: model.tasks}, Lamdera.sendToBackend (StoreNewTask model.addTaskForm))

        InputTitle text ->
           ({ model | addTaskForm = { title = text, content = model.addTaskForm.content, owner = model.addTaskForm.owner}}, (Cmd.none))

        InputContent text ->
           ({ model | addTaskForm = { title = model.addTaskForm.title, content = text, owner = model.addTaskForm.owner}}, (Cmd.none))
 
        InputOwner text ->
           ({ model | addTaskForm = { title = model.addTaskForm.title, content = model.addTaskForm.content, owner = text}}, (Cmd.none))
    
        FNoop -> (model,Cmd.none)

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
