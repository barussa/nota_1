module Main exposing (..)module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, hidden)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }


type alias Model =
    { blogTitle : String
    , articles : List Article
    }


type alias Article =
    { title : String
    , content : String
    , showContent : Bool
    }


initialModel : Model
initialModel =
    { blogTitle = "Some posts on Elm"
    , articles =
        [ { title = "Learning Elm"
          , content = "I just started to learn functional frontend development with Elm. How cool is that?"
          , showContent = False
          }
        , { title = "The Elm Architecture"
          , content = "In this post I am trying to explain The Elm Architecture …"
          , showContent = False
          }
        ]
    }

type Msg
    = ToggleContent Article


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleContent article ->
            let
                updateArticle a =
                    if a == article then
                        { a | showContent = (not article.showContent) }
                    else
                        a

                updatedArticles =
                    List.map updateArticle model.articles
            in
                { model | articles = updatedArticles } 

view : Model -> Html Msg
view model =
    div
        [ class "blog" ]
        [ h1 [] [ text model.blogTitle ]
        , p [] [ text "Click the titles to read the full article." ]
        , section
            [ class "articles" ]
            (List.map viewArticle model.articles)
        ]


viewArticle : Article -> Html Msg
viewArticle a =
    article
        [ onClick (ToggleContent a) ]
        [ h2 [] [ text a.title ]
        , div
            [ hidden (not a.showContent) ]
            [ text a.content ]
        ]