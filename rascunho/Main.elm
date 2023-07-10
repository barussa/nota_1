module Main exposing (main)

import Html exposing (Html, button, div, text, ul, li, p, input)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (placeholder)
import Browser

main : Program () Model Msg
main = Browser.sandbox { init = initialModel, update = update, view = view }


type alias Model =
    { taskToDo : String
    , tasks : List Task
    , addTask : Task
    }


type alias Task =
    { title : String
    , content : String
    , owner : String
    }


initialModel : Model
initialModel =
    { taskToDo = "TO DO"
    , addTask = { title = ""
          , content = ""
          , owner = ""
          }
    , tasks =
        [ 
          { title = "finish APP"
          , content = "Get it done"
          , owner = "EU"
          }
        ]
    }


type Msg
    = UpdateTasks
    | NoOp
    | InputTitle String
    | InputContent String
    | InputOwner String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateTasks ->
            { model | tasks = model.addTask :: model.tasks}

        NoOp ->
            model
        InputTitle text ->
            { model | addTask = { title = text, content = model.addTask.content, owner = model.addTask.owner } }

        InputContent text ->
            { model | addTask = {content = text, title = model.addTask.title, owner = model.addTask.owner } }
 
        InputOwner text ->
            { model | addTask = {owner = text, title = model.addTask.title, content = model.addTask.content } }
 

view : Model -> Html Msg
view model =
    div []
        [ text model.taskToDo
        , ul [] (List.map viewRenderTask model.tasks)
        , input [onInput InputTitle, placeholder "Title"] []
        , input [onInput InputContent, placeholder "Content"] []
        , input [onInput InputOwner, placeholder "Who did?"] []
        , button [onClick UpdateTasks] [text "SAVE"]
        ]
    
    


viewRenderTask : Task -> Html msg
viewRenderTask task =
    li []
        [ p [] [ text task.title ]
        , p [] [ text task.content ]
        , p [] [ text task.owner ]
        ]
