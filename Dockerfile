FROM ruby:2.6.6
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update -qq && apt-get install -y apt-utils build-essential unzip nodejs
# yarnパッケージ管理ツール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn

# 署名を追加(chromeのインストールに必要) -> apt-getでchromeと依存ライブラリをインストール
# RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add \
#   && echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list \
#   && apt-get update -qq \
#   && apt-get install -y google-chrome-stable libnss3 libgconf-2-4

# chromedriverの最新をインストール
# RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` \
#   && curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip \
#   && unzip /tmp/chromedriver_linux64.zip \
#   && mv chromedriver /usr/local/bin/

# aptのダウンロード先リポジトリにgoogleを追加するため、keyを追加
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

# aptのダウンロード先リポジトリにdl.google.com/linux/chrome/debを追加
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

RUN apt-get update -qq && apt-get install -y nodejs vim jq google-chrome-stable

# localeと日本語フォント
RUN apt-get install -y locales locales-all
RUN apt-get remove fonts-vlgothic
RUN apt-get install -y fonts-vlgothic
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LC_CTYPE ja_JP.UTF-8
RUN localedef -f UTF-8 -i ja_JP ja_JP.utf8

RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

RUN yarn install --check-files
RUN bundle exec rails webpacker:compile

