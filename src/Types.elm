module Types exposing (..)
import Lamdera exposing (ClientId, SessionId)



type alias BackendModel =
    { tasks : List Task
    }

type alias FrontendModel =
    { tasks : List Task
    , addTaskForm : Task
    , clientId : String
    }


type alias Task =
    { title : String
    , content : String
    , owner : String
    , phase : String
    }


{-|
events the frontend needs to handle
-}
type FrontendMsg
    = SaveButtonClicked String
    | InputTitle String
    | InputContent String
    | InputOwner String
    | FNoop
{-|
all events backend needs to handle
except for communication events betwen the frontend and the backend
-}    
type BackendMsg
    = ClientConnected SessionId ClientId
    | Noop


{-|
send msg from frontend  handled by backend
-}

type ToBackend
    = StoreNewTask Task


type ToFrontend
    = ReplaceTaskList (List Task)

