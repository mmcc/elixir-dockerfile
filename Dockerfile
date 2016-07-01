FROM bitwalker/alpine-erlang:latest

# Important!  Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT=2016-06-21 \
    HOME=/opt/app/ \
    # Set this so that CTRL+G works properly
    TERM=xterm

# Install Elixir
RUN \
    apk --no-cache --update add \
      git make g++ wget curl \
      nodejs=6.2.0-r0 && \
    npm install npm -g --no-progress && \
    update-ca-certificates --fresh && \
    rm -rf /var/cache/apk/*

RUN wget -q https://github.com/elixir-lang/elixir/releases/download/v1.3.1/Precompiled.zip && \
    unzip Precompiled.zip && \
    rm -f Precompiled.zip && \
    ls -la bin && \
    ln -s ${HOME}bin/elixirc /usr/local/bin/elixirc && \
    ln -s ${HOME}bin/elixir /usr/local/bin/elixir && \
    ln -s ${HOME}bin/mix /usr/local/bin/mix && \
    ln -s ${HOME}bin/iex /usr/local/bin/iex

# Add local node module binaries to PATH
ENV PATH ./node_modules/.bin:$PATH

# Install Hex+Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /opt/app

CMD ["/bin/sh"]
