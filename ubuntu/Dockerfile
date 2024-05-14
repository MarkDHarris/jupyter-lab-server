FROM ubuntu:22.04

ARG TIMEZONE="America/New_York"
ARG USERNAME=user
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ARG ARCH="amd64"


ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update \
    && apt-get -y install \
        apt-transport-https \
        software-properties-common \
        ca-certificates \
        locales \
        sudo

RUN sudo add-apt-repository ppa:git-core/ppa \
    && sudo apt-get update \
    && sudo apt-get -y install \
        gcc \
        apt-utils \
        git \
        lsb-release \
        net-tools \
        unzip \
        vim \
        tar \
        curl \
        wget \
        tmux \
        dos2unix 

# Install python from source
# RUN sudo apt-get install -y \
#         build-essential \
#         zlib1g-dev \
#         libncurses5-dev \
#         libgdbm-dev \
#         libnss3-dev \
#         libssl-dev \
#         libreadline-dev \
#         libffi-dev \
#         wget

# RUN wget https://www.python.org/ftp/python/3.12.3/Python-3.12.3.tgz \
#     && tar -xf Python-3.12.3.tgz \
#     && rm ./Python-3.12.3.tgz \
#     && cd ./Python-3.12.3 \
#     && ./configure --enable-optimizations --prefix=/usr/local --with-ensurepip=install \
#     && make install 

# Install python from repos
RUN apt-get update && apt-get install -y \
    python3 \
    python3-dev \
    python3-venv \
    python3-pip \
    python3-wheel \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the time zone
RUN echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen \
    && locale-gen \
    && echo $TIMEZONE | sudo tee -a /etc/timezone \
    && sudo ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime

# Add a non-root user and enable them to use sudo without password
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' \
    && sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' \
    && sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' \
    && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && echo "Customized the sudoers file for passwordless access to the $USERNAME user!" \
    && echo "$USERNAME user:";  su - $USERNAME -c id

# Now run as non-root user from this point forward
USER $USERNAME
WORKDIR /home/$USERNAME


################################################################################
# install pyenv and python3
# ENV PYENV_ROOT="/home/$USERNAME/.pyenv"
# ENV PATH="${PYENV_ROOT}/bin:${PATH}:/home/.local/brin"

# RUN sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
#         libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
#         libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
#     && sudo apt-get clean all \
#     && curl https://pyenv.run | bash \
#     && echo eval "$(~/.pyenv/bin/pyenv init -)" >> ~/.bashrc \
#     && echo eval "$(~/.pyenv/bin/pyenv virtualenv-init -)"  >> ~/.bashrc \
#     && pyenv install 3.12.2 \
#     && pyenv global 3.12.2 \
#     && ~/.pyenv/shims/python3 -m pip install --upgrade pip
################################################################################

################################################################################
# install rust
ENV CARGO_HOME="/home/$USERNAME/.cargo"
ENV RUSTUP_HOME="/home/$USERNAME/.rustup"
ENV PATH="$CARGO_HOME/bin:$RUSTUP_HOME:$PATH"

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -sSf | sh -s -- --verbose -y --profile default \
    && rustup component add rust-analysis \
    && rustup component add rust-src \
    && rustup component add rls \
    && rustup target add wasm32-wasi
################################################################################

################################################################################
# install go
ENV GOROOT="/usr/local/go"
ENV GOPATH="/home/$USERNAME/go"
ENV GOBIN="/home/$USERNAME/go/bin"
ENV PATH="$PATH:$GOROOT/bin:$GOPATH:$GOBIN"

RUN GO_VERSION=$(curl -sSL "https://golang.org/VERSION?m=text" | sed -n '/^go/s///p' ) \
    && sudo wget "https://golang.org/dl/go$GO_VERSION.linux-$ARCH.tar.gz" \
    && sudo tar -xzf "go$GO_VERSION.linux-$ARCH.tar.gz" -C "/usr/local" \
    && sudo rm "go$GO_VERSION.linux-$ARCH.tar.gz" \
    && echo 'export GOPATH=$GOPATH'  >> /home/$USERNAME/.zshrc
################################################################################

################################################################################
# install .NET 
RUN sudo apt-get install -y wget apt-transport-https software-properties-common \
    && wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" \
    && sudo dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && sudo apt-get update -y \
    && sudo apt-get install -y dotnet-sdk-8.0
################################################################################

################################################################################
# install java
RUN sudo apt-get install -y default-jdk
################################################################################

################################################################################
# install jupyter and rust, go, and .net kernels
ENV DOTNET_INTERACTIVE_CLI_TELEMETRY_OPTOUT=true
ENV DOTNET_INTERACTIVE_SKIP_FIRST_TIME_EXPERIENCE=true
ENV PATH="~/.local/bin:$PATH"
ENV PATH=$PATH:"/home/$USERNAME/.dotnet/tools"

RUN python3 -m pip install jupyter \
    && cargo install evcxr_repl \
    && cargo install evcxr_jupyter \
    && evcxr_jupyter --install \
    && go install github.com/gopherdata/gophernotes@v0.7.5 \
    && mkdir -p ~/.local/share/jupyter/kernels/gophernotes \
    && cd ~/.local/share/jupyter/kernels/gophernotes \
    && cp "$(go env GOPATH)"/pkg/mod/github.com/gopherdata/gophernotes@v0.7.5/kernel/*  "." \
    && chmod +w ./kernel.json \
    && sed "s|gophernotes|$(go env GOPATH)/bin/gophernotes|" < kernel.json.in > kernel.json \
    && dotnet tool install -g microsoft.dotnet-interactive \
    && "/home/$USERNAME/.dotnet/tools/dotnet-interactive" jupyter install \
    && "/home/$USERNAME/.local/bin/jupyter" kernelspec list
################################################################################

ENV DEBIAN_FRONTEND=dialog

EXPOSE 8888

CMD [ "/home/maharris/.local/bin/jupyter", "lab", \
      "--ip=0.0.0.0", "--port=8888", \
      "--notebook-dir=/opt/notebooks", "--allow-root", "--no-browser" ]

# jupyter lab --ip=0.0.0.0 --port=8888 --notebook-dir=/opt/notebooks --allow-root --no-browser

# version: "3.9"
# services:
#   web:
#     build: .
#     ports:
#       - "8888:8888"
#     volumes:
#       - ./notebooks:/opt/notebooks



