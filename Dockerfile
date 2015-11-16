FROM ubuntu:14.04

SUB rust:nightly
ADD api /source
RUN cargo build --release
RETURN /source/target/release/api /app/server

SUB nodejs:5
ADD . /source
WORKDIR /source
RUN npm install
RUN npm build
RETURN /source/dist /app/dist