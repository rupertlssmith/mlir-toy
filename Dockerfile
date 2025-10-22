# ---------- Builder: build & install LLVM/MLIR ----------
FROM debian:bookworm AS builder
ARG DEBIAN_FRONTEND=noninteractive
# Choose a stable LLVM release tag (change as you like)
ARG LLVM_VERSION=21.1.4
# Parallelism for CMake/Ninja
ARG CMAKE_BUILD_PARALLEL_LEVEL=8

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    build-essential \
    python3 \
    cmake \
    ninja-build \
    clang \
    lld \
    zlib1g-dev \
    libtinfo-dev \
    libxml2-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN git clone --depth=1 --branch "llvmorg-${LLVM_VERSION}" https://github.com/llvm/llvm-project.git

# Build LLVM + MLIR and install to /opt/llvm-mlir
WORKDIR /src/llvm-project
RUN cmake -S llvm -B build -G Ninja \
      -DLLVM_ENABLE_PROJECTS="mlir" \
      -DLLVM_TARGETS_TO_BUILD="host" \
      -DLLVM_ENABLE_ASSERTIONS=ON \
      -DLLVM_ENABLE_RTTI=ON \
      -DMLIR_ENABLE_CMAKE_PACKAGE=ON \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DLLVM_USE_LINKER=lld \
      -DCMAKE_INSTALL_PREFIX=/opt/llvm-mlir \
 && cmake --build build \
 && cmake --install build

# ---------- Runtime: tools + installed MLIR ----------
FROM debian:bookworm
ARG DEBIAN_FRONTEND=noninteractive

# Tools you asked for + standard build bits to build your own project inside the container
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    build-essential \
    python3 \
    cmake \
    ninja-build \
    clang \
    lld \
    # runtime libs commonly needed by LLVM/MLIR tools
    zlib1g \
    libxml2 \
 && rm -rf /var/lib/apt/lists/*

# Bring over the installed LLVM/MLIR
COPY --from=builder /opt/llvm-mlir /opt/llvm-mlir

# Make MLIR easy to find for downstream CMake projects
ENV CMAKE_PREFIX_PATH=/opt/llvm-mlir:${CMAKE_PREFIX_PATH}
ENV LD_LIBRARY_PATH=/opt/llvm-mlir/lib:${LD_LIBRARY_PATH}
# If you ever add LLVM tools to PATH in your build, expose them here too:
ENV PATH=/opt/llvm-mlir/bin:${PATH}
# Prefer clang/clang++ by default inside the container
ENV CC=clang
ENV CXX=clang++

# Nice default workspace
WORKDIR /work
CMD ["/bin/bash"]
