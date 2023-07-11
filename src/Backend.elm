module Backend exposing (app, init)

import Lamdera exposing (ClientId, SessionId, broadcast, sendToFrontend)
import Types exposing (..)

app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }


init : ( BackendModel, Cmd BackendMsg )
init = ({tasks=[]}, Cmd.none)

update : BackendMsg -> BackendModel -> ( BackendModel, Cmd BackendMsg )
update msg model =
    case msg of
        ClientConnected _ clientId ->
            ( model, sendToFrontend clientId <| ReplaceTaskList model.tasks )

        Noop ->
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> BackendModel -> ( BackendModel, Cmd BackendMsg )
updateFromFrontend _ clientId msg model =
    case msg of
        StoreNewTask task ->
            let
                taskToAdd =
                    task :: model.tasks
            in
            ( { model | tasks = taskToAdd }, broadcast(ReplaceTaskList taskToAdd) )



-- ({ model | tasks = taskToAdd}, broadcast(taskToAdd clientId ))


subscriptions model =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        ]
