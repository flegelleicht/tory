FROM ubuntu:latest
WORKDIR /tmp
RUN apt-get update \
	&& apt-get -y install build-essential sqlite3 libsqlite3-dev ruby ruby-dev curl \
	&& gem install bundler --no-ri --no-rdoc
RUN curl -sL https://deb.nodesource.com/setup_10.x -o node10
RUN bash node10
RUN apt-get install -y nodejs

WORKDIR /app
COPY . /app
RUN bundle install --path vendor/bundle
RUN bundle exec sequel -m db/migrations sqlite://db/database.db

WORKDIR /app/frontend
RUN npm install
RUN npm run build
WORKDIR /app
RUN cp -r frontend/build/* public/

EXPOSE 4567

CMD ["bundle", "exec", "ruby", "server.rb"]
