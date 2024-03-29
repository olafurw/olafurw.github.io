FROM jekyll/jekyll

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install --quiet

CMD ["jekyll", "serve"]
