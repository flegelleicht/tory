# tory

An exercise in event management

## What works

1. There is a backend server/service that handles authentication and requests for events
2. After login a jwt token is provided for stateless interaction with the backend from then on
3. There is a frontend that displays all (known) events and offers login/logout functionality. It is not pretty. 
4. There is a Dockerfile to bundle everything together

    $ docker build -t exercise .
    $ docker run -p 4567:4567 exercise

## Decisions

* I used [sinatra](https://sinatrarb.com) as ruby backend framework. I have used it more often than rails and felt more comfortable to be productive in the short timeframe
* I used sqlite as database and [Sequel](https://github.com/jeremyevans/sequel) as ruby ORM. I know both of them very well and think they are suited for smaller services
* I used [React](https://reactjs.org) for the frontend, because I learned to like it in the past weeks :)
