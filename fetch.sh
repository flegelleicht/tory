curl --header "Content-Type: application/json" \
--request POST \
--data '{"user":"test","pass":"test"}' \
http://localhost:4567/api/v1/public/login

curl --header "Content-Type: application/json" \
--request POST \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1MzkwODk1MjQsImlhdCI6MTUzOTAwMzEyNCwiaXNzIjoiZXhlcmNpc2UudGVycml0b3J5LmRlIiwidXNlciI6eyJpZCI6MX19.YIs1jr3NfR1VXxmBkZGv6aUwnkmwgl3a7SMV_suJ92E' \
--data '{"event":{"start":"2018-10-15","end":"2018-10-16","name":"Event 1","description":"Event Description 1","link":"http://www.example.com/"}}' \
http://localhost:4567/api/v1/private/events

curl --header "Content-Type: application/json" \
--request GET \
http://localhost:4567/api/v1/public/events
