module Model.PostsConfig exposing (Change(..), PostsConfig, SortBy(..), applyChanges, defaultConfig, filterPosts, sortFromString, sortOptions, sortToCompareFn, sortToString)

import Model.Post exposing (Post)
import Time


type SortBy
    = Score
    | Title
    | Posted
    | None


sortOptions : List SortBy
sortOptions =
    [ Score, Title, Posted, None ]


sortToString : SortBy -> String
sortToString sort =
    case sort of
        Score -> "Score"
        Title -> "Title"
        Posted -> "Posted"
        None -> "None"

{-|

    sortFromString "Score" --> Just Score

    sortFromString "Invalid" --> Nothing

    sortFromString "Title" --> Just Title

-}
sortFromString : String -> Maybe SortBy
sortFromString s =
    case s of
        "Score" -> Just Score
        "Title" -> Just Title
        "Posted" -> Just Posted
        "None" ->Just None
        _ -> Nothing

sortToCompareFn : SortBy -> (Post -> Post -> Order)
sortToCompareFn sort =
    case sort of
        Score ->
            \postA postB -> compare postB.score postA.score

        Title ->
            \postA postB -> compare postA.title postB.title

        Posted ->
            \postA postB -> compare (Time.posixToMillis postB.time) (Time.posixToMillis postA.time)

        None ->
            \_ _ -> EQ


type alias PostsConfig =
    { postsToFetch : Int
    , postsToShow : Int
    , sortBy : SortBy
    , showJobs : Bool
    , showTextOnly : Bool
    }


defaultConfig : PostsConfig
defaultConfig =
    PostsConfig 50 10 None False True


{-| A type that describes what option changed and how
-}
type Change
    = ChangeTODO
    | SetPostsToShow Int
    | SetSortBy SortBy
    | SetShowJobs Bool
    | SetShowTextOnly Bool


{-| Given a change and the current configuration, return a new configuration with the changes applied
-}
applyChanges : Change -> PostsConfig -> PostsConfig
applyChanges change config =
    case change of
        ChangeTODO -> config
        SetPostsToShow n -> { config | postsToShow = n }
        SetSortBy s -> { config | sortBy = s }
        SetShowJobs b -> { config | showJobs = b }
        SetShowTextOnly b -> { config | showTextOnly = b }

{-| Given the configuration and a list of posts, return the relevant subset of posts according to the configuration

Relevant local functions:

  - sortToCompareFn

Relevant library functions:

  - List.sortWith

-}
filterPosts : PostsConfig -> List Post -> List Post
filterPosts config posts =
    let
        -- filter out text-only posts (those with no url) when showTextOnly is False
        postsAfterTextFilter =
            if config.showTextOnly then
                posts
            else
                List.filter (\t -> t.url /= Nothing) posts

        -- filter out job posts when showJobs is False
        postsAfterJobFilter =
            if config.showJobs then
                postsAfterTextFilter
            else
                List.filter (\t -> t.type_ /= "job") postsAfterTextFilter

        -- take at most postsToShow from the filtered list (preserve original order)
        limited =
            List.take config.postsToShow postsAfterJobFilter

        -- sort the limited list according to sortBy
        sortedLimited =
            case config.sortBy of
                None ->
                    limited

                _ ->
                    List.sortWith (sortToCompareFn config.sortBy) limited
    in
    sortedLimited
