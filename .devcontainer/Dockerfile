FROM debian:bookworm

RUN apt-get update && apt-get -y install git curl unzip

RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /home/codespace
WORKDIR /home/codespace

ENV PUB_CACHE=/home/codespace/.pub_cache
ENV PATH="/home/codespace/flutter/bin:$PATH"

# Clone the Flutter repository and checkout the specific version
RUN git clone https://github.com/flutter/flutter
WORKDIR /home/codespace/flutter
RUN git checkout 3.13.5  # Replace with the specific version tag that includes Dart SDK 3.1.2

# Pre-download development binaries.
RUN flutter precache

# Enable Flutter web.
RUN flutter config --enable-web

# Accept Android licenses.
RUN yes | flutter doctor --android-licenses

# Run flutter doctor to complete setup.
RUN flutter doctor