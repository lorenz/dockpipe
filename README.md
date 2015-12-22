# Dockpipe
*A docker build pipeline with subcontainers*

## Example
```
# Base image for the resulting image
FROM ubuntu:14.04

# Build a Rust project using a base image with a Rust compiler
SUB schickling/rust
ADD api /source
RUN cargo build --release
RETURN /source/target/release/api /app/server

# Compile and minify a frontend project with Node
SUB node:5
WORKDIR /source
ADD package.json /source/package.json
RUN npm install
ADD . /source
RUN npm run build
RETURN /source/dist /app/dist

# Command to start the server
CMD ["/app/server"]
```

## Dockerfile extensions
Dockpipe adds two commands to Dockerfiles: `SUB` and `RETURN`. The syntax is:

`SUB image_name:tag`

`RETURN /path/in/sub_container /path/in/parent_container`

The first one starts a new subcontainer, the second one ends one and returns data to its parent.

## Command syntax
`./dockpipe.sh TAG DIRECTORY`

Dockpipe pushes the resulting image to a registry if the tag contains one. This facilitates usage when using Dockpipe in a CI.

## Project status
The current version of Dockpipe is written in Bash and therefore relatively unstable. I'm working on a Rust version but that'll take some time because there is currently no good Docker client for Rust.