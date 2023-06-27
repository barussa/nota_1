module Main exposing (main)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, hidden)
import Browser


main = Browser.sandbox { init = initialModel, update = update, view = view }



type alias Model =
    { taskToDo : String
    , tasks : List Tasks
    }

type alias Tasks = 
    { title : String
    , content : String
    , owner : String
    }
    

initialModel : Model
initialModel = 
    { taskToDo = "TO DO"
    , tasks = 
        [ {title = "First APP"
        , content = "Get it done"
        , owner = "EU"
        }
        ]
    }

type Msg
    = NewTaskButtonClick

update : Msg -> Model -> Model
update msg model = model
       


view: Model -> Html Msg
view model = 
    div []
        [text model.taskToDo]