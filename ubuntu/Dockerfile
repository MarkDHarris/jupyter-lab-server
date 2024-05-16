FROM ubuntu:22.04

ARG USERNAME=user
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ARG ARCH="amd64"

ENV TZ="America/New_York"

ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update \
    && apt-get -y install \
        apt-transport-https \
        software-properties-common \
        ca-certificates \
        tzdata \
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

# Add a non-root user, enable sudo without password, then run as non-root user from this point
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' \
    && sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' \
    && sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' \
    && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && echo "Customized the sudoers file for passwordless access to the $USERNAME user!" \
    && echo "$USERNAME user:";  su - $USERNAME -c id

USER $USERNAME
WORKDIR /home/$USERNAME

################################################################################
# install python3, dotnet, go, and java
RUN sudo apt-get update && sudo apt-get install -y \
    python3 \
    python3-dev \
    python3-venv \
    python3-pip \
    python3-wheel \
    build-essential \
    dotnet-sdk-8.0 \
    golang \
    default-jdk \
    && sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*
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
# install jupyter kernels
ENV DOTNET_INTERACTIVE_CLI_TELEMETRY_OPTOUT=true
ENV DOTNET_INTERACTIVE_SKIP_FIRST_TIME_EXPERIENCE=true

ENV PATH="/home/$USERNAME/.local/bin:/home/$USERNAME/.dotnet/tools:$PATH"

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
    && mkdir jjava && cd jjava \
    && wget https://github.com/dflib/jjava/releases/download/1.0-M1/jjava-1.0-M1.zip \
    && unzip ./jjava-1.0-M1.zip && rm ./jjava-1.0-M1.zip \
    && python3 install.py --user \
    && pip install kotlin-jupyter-kernel \
    && pip install jupyter-cpp-kernel \    
    && pip install sshkernel \
    && python3 -m sshkernel install --user \
    && "/home/$USERNAME/.local/bin/jupyter" kernelspec list   
################################################################################

ENV DEBIAN_FRONTEND=dialog

EXPOSE 8888

CMD [ "/home/maharris/.local/bin/jupyter", "lab", \
      "--ip=0.0.0.0", "--port=8888", \
      "--notebook-dir=/opt/notebooks", "--allow-root", "--no-browser" ]
