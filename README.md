# Elm Hacker News Client

This project is a small Hacker News client built using **Elm**, displaying top Hacker News stories in a configurable and filterable table.

It follows the Elm architecture, uses HTTP requests to fetch data, and comes with a full test suite for validation.

## Project Structure

- src/ – Elm source files  
- tests/ – automated tests  
- scripts/ – helper scripts  
- elm.json – Elm project configuration  
- package.json – npm configuration  

## Getting Started

### Install dependencies
npm install

### Run the development server
elm reactor

### Run the test suite
npm test

npm run grade

npx elm-test

## Features

- Fetch and display top Hacker News posts  
- Table with score, title, type, posted date, link, relative time  
- Configuration controls: number of posts, sorting mode, show/hide job posts, show/hide text-only posts  
- Filter and sort posts based on user settings  
- Reactive UI  
- Implementations for Cursor, Model.Post, Model.PostIds, Model.PostsConfig, Util.Time  

## Development Tips

- Start by commenting out parts of Main.view  
- Keep code idiomatic (pipelines, List.map, Maybe.map, etc.)

## Building the Submission

npm run zip

## Resources

- Elm Core  
- Elm HTML  
- Elm HTTP  
- Elm JSON  
- Elm Test

Talks:
- The Life of a File – Evan Czaplicki  
- Making Impossible States Impossible – Richard Feldman  
- Immutable Relational Data – Richard Feldman
