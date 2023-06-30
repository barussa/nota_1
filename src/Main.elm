module Main exposing (main)

import Html exposing (Html, button, div, text, ul, li, p, Attribute)
import Html.Events exposing ( onInput, keyCode, on)
import Browser
import Html exposing (input)
import Json.Decode as Json
import Browser.Events exposing (onKeyDown)

main : Program () Model Msg
main = Browser.sandbox { init = initialModel, update = update, view = view }


type alias Model =
    { taskToDo : String
    , tasks : List Task
    , addTask : String
    }


type alias Task =
    { title : String
    , content : String
    , owner : String
    }


initialModel : Model
initialModel =
    { taskToDo = "TO DO"
    , addTask = ""
    , tasks =
        [ { title = "First APP"
          , content = "Get it done"
          , owner = "EU"
          }
        , { title = "finish APP"
          , content = "Get it done"
          , owner = "EU"
          }
        ]
    }


type Msg
    = UpdateTasks Int
    | NoOp
    | Input String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateTasks key ->
            if key == 13 then 
                { model | tasks = { title = model.addTask, content = model.addTask, owner = model.addTask } :: model.tasks }
            else 
                model
                
        NoOp ->
            model
        Input text ->
            {model|addTask = text} 
        
onKeyDown: (Int -> msg) -> Attribute msg
onKeyDown tagger = on "keydown" (Json.map tagger keyCode)

view : Model -> Html Msg
view model =
    div []
        [ text model.taskToDo
        , ul [] (List.map viewRenderTask model.tasks)
        , input [onKeyDown UpdateTasks, onInput Input] []
        ]
    
    


viewRenderTask : Task -> Html msg
viewRenderTask task =
    li []
        [ p [] [ text task.title ]
        , p [] [ text task.content ]
        , p [] [ text task.owner ]
        ]
