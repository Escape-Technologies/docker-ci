FROM debian:latest
WORKDIR ~
RUN apt update -y
RUN apt install -y wget curl
RUN apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev libbz2-dev
RUN curl -O https://www.python.org/ftp/python/3.9.1/Python-3.9.1.tar.xz
RUN tar -xf Python-3.9.1.tar.xz
RUN rm -rf Python-3.9.1.tar.xz
WORKDIR Python-3.9.1
RUN ./configure --enable-optimizations
RUN make -j 4
RUN make altinstall
RUN python3.9 -m pip install --upgrade pip
WORKDIR ~
RUN rm -rf Python-3.9.1
RUN apt install -y nodejs npm
RUN apt install -y chromium chromium-driver
RUN npm install -g n
RUN n lts
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh get-docker.sh
RUN export PATH="$PATH"