module View.Posts exposing (..)

import Html exposing (Html, a, button, div, label, table, thead, tbody, tr, th, td, text, select, option, input)
import Html.Attributes exposing (class, href, title, id, type_, checked, selected, value)
import Html.Events exposing (onCheck, onInput, onClick)
import Model exposing (Msg(..))
import Model.Post exposing (Post)
import Model.PostsConfig exposing (Change(..), PostsConfig, SortBy(..), sortFromString, sortOptions, sortToString)
import Time
import Util.Time


{-| Show posts as a HTML [table](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/table)

Relevant local functions:

  - Util.Time.formatDate
  - Util.Time.formatTime
  - Util.Time.formatDuration (once implemented)
  - Util.Time.durationBetween (once implemented)

Relevant library functions:

  - [Html.table](https://package.elm-lang.org/packages/elm/html/latest/Html#table)
  - [Html.tr](https://package.elm-lang.org/packages/elm/html/latest/Html#tr)
  - [Html.th](https://package.elm-lang.org/packages/elm/html/latest/Html#th)
  - [Html.td](https://package.elm-lang.org/packages/elm/html/latest/Html#td)

-}
postTable : PostsConfig -> Time.Posix -> List Post -> Html Msg
postTable config now postsList =
  let
    filteredPosts = Model.PostsConfig.filterPosts config postsList
    totalCount = List.length postsList
    shownCount = List.length filteredPosts

    row post =
      let
        visibleTime = Util.Time.formatTime Time.utc post.time
        relative =
          Util.Time.durationBetween post.time now
            |> Maybe.map Util.Time.formatDuration
            |> Maybe.withDefault ""

        urlCell =
          case post.url of
            Just u ->
              a [ href u ] [ text u ]

            Nothing ->
              text ""
      in
      tr []
        [ td [ class "post-score" ] [ text (String.fromInt post.score) ]
        , td [ class "post-title" ] [ text post.title ]
        , td [ class "post-type" ] [ text post.type_ ]
        , td [ class "post-time", title relative ]
          [ text visibleTime
          , (if relative == "" then text "" else text (" (" ++ relative ++ ")"))
          ]
        , td [ class "post-url" ] [ urlCell ]
        ]
  in
  div []
    [ table []
      [ thead []
        [ tr []
          [ th [] [ text "Score" ]
          , th [] [ text "Title" ]
          , th [] [ text "Type" ]
          , th [] [ text "Posted" ]
          , th [] [ text "Link" ]
          ]
        ]
  , tbody [] (filteredPosts |> List.map row)
      ]
    , div [ id "posts-controls" ]
      [ text ("Showing " ++ String.fromInt shownCount ++ " of " ++ String.fromInt totalCount ++ " posts")
      , button [ onClick (ConfigChanged (SetPostsToShow (config.postsToShow + 10))) ] [ text "Load more" ]
      ]
    ]


{-| Show the configuration options for the posts table

Relevant functions:

  - [Html.select](https://package.elm-lang.org/packages/elm/html/latest/Html#select)
  - [Html.option](https://package.elm-lang.org/packages/elm/html/latest/Html#option)
  - [Html.input](https://package.elm-lang.org/packages/elm/html/latest/Html#input)
  - [Html.Attributes.type\_](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#type_)
  - [Html.Attributes.checked](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#checked)
  - [Html.Attributes.selected](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#selected)
  - [Html.Events.onCheck](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#onCheck)
  - [Html.Events.onInput](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#onInput)

-}
postsConfigView : PostsConfig -> Html Msg
postsConfigView config =
  let
    postsOptions = [ 10, 25, 50 ]
    postsOptionsView =
      postsOptions
        |> List.map
            (\n ->
                option
                    [ value (String.fromInt n), selected (n == config.postsToShow) ]
                    [ text (String.fromInt n) ]
            )
    sortOptionsView =
      sortOptions |> List.map (\fmt ->
            let
              str = sortToString fmt
            in
            option
              [ value str, selected (fmt == config.sortBy) ]
              [ text str ])
    
  in
  div []
    [ -- posts per page select
    select
    [ id "select-posts-per-page"
    , onInput (String.toInt >> Maybe.map SetPostsToShow >> Maybe.withDefault ChangeTODO >> ConfigChanged)
    ]
    postsOptionsView
      -- sort by select
  , select
    [ id "select-sort-by"
    , onInput (sortFromString >> Maybe.map SetSortBy >> Maybe.withDefault ChangeTODO >> ConfigChanged)
    ]
    sortOptionsView
      -- show job posts checkbox
  , label [] [ input [ id "checkbox-show-job-posts", type_ "checkbox", checked config.showJobs, onCheck (SetShowJobs >> ConfigChanged) ] [], text " Show job posts" ]
      -- show text-only posts checkbox
  , label [] [ input [ id "checkbox-show-text-only-posts", type_ "checkbox", checked config.showTextOnly, onCheck (SetShowTextOnly >> ConfigChanged) ] [], text " Show text posts" ]
    
    -- theme toggle
  , button [ onClick ToggleTheme ] [ text "Toggle theme" ]
    ]
