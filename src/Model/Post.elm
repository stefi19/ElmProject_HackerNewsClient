module Model.Post exposing (..)

import Json.Decode as De
import Time


type alias Post =
    { by : String, id : Int, score : Int, title : String, url : Maybe String, time : Time.Posix, type_ : String }


{-| Decode a `Post`

See: <https://github.com/HackerNews/API#items>

The post is expected to have fields:

  - by: The username of the item's author.
  - id: The item's unique id.
  - score: The story's score.
  - title: The title of the story.
  - url: The URL of the story. **Optional**
  - time: Creation date of the item, in Unix Time.
  - type: The type of item.

_Note_: The `time` field contains the **seconds** since the unix epoch. Take this into consideration when using `Time.millisToPosix`.

Relevant library functions:

  - [Json.Decode.field](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#field)
  - [Json.Decode.string](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#string)
  - [Json.Decode.int](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#int)
  - [Json.Decode.maybe](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#maybe)

-}
decode : De.Decoder Post
decode =
  let
    urlDecoder : De.Decoder (Maybe String)
    urlDecoder =
      De.oneOf
        [ De.field "url" (De.maybe De.string)
        , De.succeed Nothing
        ]
  in
  De.map7
    (\by id score title url time typeStr ->
      { by = by
      , id = id
      , score = score
      , title = title
      , url = url
      , time = Time.millisToPosix (time * 1000)
      , type_ = typeStr
      })
  (De.field "by" De.string)
  (De.field "id" De.int)
  (De.field "score" De.int)
  (De.field "title" De.string)
    urlDecoder
    (De.field "time" De.int)
  (De.field "type" De.string)
