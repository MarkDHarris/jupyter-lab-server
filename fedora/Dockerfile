FROM fedora:40

ARG TIMEZONE="America/New_York"
ARG USERNAME=user
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ARG ARCH="amd64"

ENV TZ=$TIMEZONE

# Install python from repos
RUN dnf update -y \
    && dnf install -y curl net-tools git vim unzip which sudo tmux dos2unix \
        gcc openssl-devel bzip2-devel libffi-devel zlib-devel wget make \
        python3 \
        python3-devel \
        python3-virtualenv \
        python3-pip \
        python3-wheel \
    && dnf group install -y "C Development Tools and Libraries" "Development Tools" \
    && dnf -y clean all

# # Set the time zone
# RUN echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen \
#     && locale-gen \
#     && echo $TIMEZONE | sudo tee -a /etc/timezone \
#     && sudo ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
    
# Add a non-root user and enable them to use sudo without password
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' \
    && sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' \
    && sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' \
    && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && echo "Customized the sudoers file for passwordless access to the $USERNAME user!" \
    && echo "$USERNAME user:";  su - $USERNAME -c id

USER $USERNAME
WORKDIR /home/$USERNAME/

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
    && echo 'export GOPATH=$GOPATH'  >> /home/$USERNAME/.bashrc

# RUN sudo dnf install -y go
################################################################################

################################################################################
# install .NET 
RUN sudo dnf install -y dotnet-sdk-8.0
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

EXPOSE 8888

CMD [ "/home/maharris/.local/bin/jupyter", "lab", \
      "--ip=0.0.0.0", "--port=8888", \
      "--notebook-dir=/opt/notebooks", "--allow-root", "--no-browser" ]
