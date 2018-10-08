FROM ubuntu:latest
RUN apt-get update \
	&& apt-get -y install build-essential sqlite3 libsqlite3-dev ruby ruby-dev \
	&& gem install bundler --no-ri --no-rdoc
WORKDIR /app
COPY . /app
RUN bundle install --path vendor/bundle
EXPOSE 4567

CMD ["bundle", "exec", "ruby", "server.rb"]
