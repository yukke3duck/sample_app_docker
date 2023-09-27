FROM ruby:3.1

RUN mkdir /app
WORKDIR /app

# COPY Gemfile /app/Gemfile
# COPY Gemfile.lock /app/Gemfile.lock
COPY . /app

# RubyGemsをアップデート
RUN gem update --system ${RUBYGEMS_VERSION} && bundle install

# コンテナ起動時に実行させるスクリプトを追加
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# CMD:コンテナ実行時、デフォルトで実行したいコマンド
# Rails サーバ起動
CMD ["rails", "server", "-b", "0.0.0.0"]
