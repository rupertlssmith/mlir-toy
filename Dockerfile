# ---------- Builder: build & install LLVM/MLIR ----------
FROM debian:bookworm AS builder
ARG DEBIAN_FRONTEND=noninteractive
# Choose a stable LLVM release tag (change as you like)
ARG LLVM_VERSION=21.1.4
# Parallelism for CMake/Ninja
ARG CMAKE_BUILD_PARALLEL_LEVEL=24

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
      -DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
      -DLLVM_ENABLE_ASSERTIONS=ON \
      -DLLVM_ENABLE_RTTI=ON \
      -DMLIR_ENABLE_CMAKE_PACKAGE=ON \
      -DLLVM_ENABLE_ZLIB=OFF \
      -DLLVM_ENABLE_LIBXML2=OFF \
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

# Build args to match host UID/GID at build time
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates git build-essential python3 cmake ninja-build clang lld \
    zlib1g-dev libxml2-dev pkg-config \
 && rm -rf /var/lib/apt/lists/*

# Copy installed LLVM/MLIR from builder
COPY --from=builder /opt/llvm-mlir /opt/llvm-mlir

# Create non-root user
RUN groupadd -g ${USER_GID} ${USERNAME} \
 && useradd -m -u ${USER_UID} -g ${USER_GID} -s /bin/bash ${USERNAME} \
 && mkdir -p /work && chown ${USER_UID}:${USER_GID} /work

# Environment for convenient builds
ENV CMAKE_PREFIX_PATH=/opt/llvm-mlir:${CMAKE_PREFIX_PATH}
ENV LD_LIBRARY_PATH=/opt/llvm-mlir/lib:${LD_LIBRARY_PATH}
ENV PATH=/opt/llvm-mlir/bin:${PATH}
ENV CC=clang
ENV CXX=clang++

USER ${USERNAME}
WORKDIR /work
CMD ["/bin/bash"]