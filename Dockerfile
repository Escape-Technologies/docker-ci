FROM debian:latest
WORKDIR /root
RUN apt update -y
RUN apt install -y wget curl git

# Python #
RUN apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev libbz2-dev
RUN curl -O https://www.python.org/ftp/python/3.9.2/Python-3.9.2.tar.xz
RUN tar -xf Python-3.9.2.tar.xz
RUN rm -rf Python-3.9.2.tar.xz
WORKDIR /root/Python-3.9.2
RUN ./configure --enable-optimizations
RUN make -j 4
RUN make altinstall
RUN python3.9 -m pip install --upgrade pip
WORKDIR /root
RUN rm -rf Python-3.9.2

# Node #
RUN apt install -y nodejs npm
RUN npm install -g n
RUN n lts
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh get-docker.sh
RUN export PATH="$PATH"

# Back-end dependencies
# We install Chrome to get all the OS level dependencies, but Chrome itself
# is not actually used as it's packaged in the node puppeteer library.
# Alternatively, we could could include the entire dep list ourselves
# (https://github.com/puppeteer/puppeteer/blob/master/docs/troubleshooting.md#chrome-headless-doesnt-launch-on-unix)
# but that seems too easy to get out of date.
RUN apt install -y gnupg ca-certificates
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt update
RUN apt install -y google-chrome-stable chromium chromium-driver
RUN rm -rf /var/lib/apt/lists/*
RUN wget --quiet https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /usr/sbin/wait-for-it.sh
RUN chmod +x /usr/sbin/wait-for-it.sh

# Frontend dependencies
RUN npm install -g cypress --unsafe-perm --silent

# Python dependencies
RUN python3.9 -m pip install poetry
RUN python3.9 -m venv /root/.venv
RUN /root/.venv/bin/python -m pip install pytest pytest-cov pylint pylint_quotes yapf unify docformatter mypy data-science-types python-semantic-release
RUN poetry config virtualenvs.path /root/.venv/

CMD . /root/.venv/bin/activate