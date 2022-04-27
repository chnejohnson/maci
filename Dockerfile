FROM ubuntu:20.04 as maci

# image estimated size: 6.82 GB

# ARG REPO_NAME="https://github.com/chnejohnson/maci.git"
# ARG BRANCH_NAME=v1

# install dependency
RUN apt-get update \
    && apt-get install -y curl wget git jq\
    && apt-get install -y build-essential libgmp-dev libsodium-dev nasm \ 
    && apt-get install -y libgmp-dev nlohmann-json3-dev nasm g++ 
    
# install nvm and nodejs
ENV NODE_VERSION=14.18.1
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm install-latest-npm
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

# add metadata
# RUN echo "REPO_NAME='$REPO_NAME'" > /etc/image-info \
#     && echo "BRANCH_NAME='$BRANCH_NAME'" >> /etc/image-info \
#     && echo "NODE_VERSION='$(node --version)'" >> /etc/image-info 

# install rapicsnark for v1.0.0
RUN cd ~ \
    && git clone https://github.com/iden3/rapidsnark.git \
    && cd rapidsnark \
    && git checkout 1c13721de4a316b0b254c310ccec9341f5e2208e \
    && npm install \
    && git submodule init \
    && git submodule update \
    && npx task createFieldSources \
    && npx task buildProver

# install maci 
COPY . ./root/maci
RUN cd ~ \
    && cd maci \
    && npm i 
RUN cd ~/maci && npm run bootstrap
RUN cd ~/maci && npm run build
RUN cd ~/maci/contracts && npm run compileSol

# install rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# install circom 2
RUN cd ~ \
    && git clone https://github.com/iden3/circom.git \
    && cd circom \
RUN cargo build --release && cargo install --path circom

# copy circom binary to ~/.local/bin/circom
RUN cd ~/.local \
    && mkdir bin \
    && cp ../.cargo/bin/circom ./bin/circom \