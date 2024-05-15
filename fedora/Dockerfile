FROM fedora:40

ARG TIMEZONE="America/New_York"
ARG USERNAME=user
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ARG ARCH="amd64"

ENV TZ=$TIMEZONE

# Add initial packages
RUN dnf update -y \
    && dnf install -y curl net-tools git vim unzip which sudo tmux dos2unix \
        gcc openssl-devel bzip2-devel libffi-devel zlib-devel wget make \
    && dnf group install -y "C Development Tools and Libraries" "Development Tools" \
    && dnf -y clean all
    
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
# install python, go, .net & java
RUN sudo dnf install -y \
                python3 \
                python3-devel \
                python3-virtualenv \
                python3-pip \
                python3-wheel \
                go \
                dotnet-sdk-8.0 \
                java-latest-openjdk \
                java-latest-openjdk-devel
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

EXPOSE 8888

CMD [ "/home/maharris/.local/bin/jupyter", "lab", \
      "--ip=0.0.0.0", "--port=8888", \
      "--notebook-dir=/opt/notebooks", "--allow-root", "--no-browser" ]
