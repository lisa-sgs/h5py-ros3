ARG BASE_IMAGE=debian:latest
FROM ${BASE_IMAGE}

ARG HDF5_VERSION=2.0.0
ARG PREFIX_PATH=/usr
ARG CMAKE_BUILD_PARALLEL_LEVEL=4

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /scratch

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    git \
    golang \
    patchelf && \
    git clone https://github.com/aws/aws-lc.git --depth 1 && \
    git clone https://github.com/aws/s2n-tls.git --depth 1 && \
    git clone https://github.com/awslabs/aws-c-common.git --depth 1 && \
    git clone https://github.com/awslabs/aws-checksums.git --depth 1 && \
    git clone https://github.com/awslabs/aws-c-cal.git --depth 1 && \
    git clone https://github.com/awslabs/aws-c-io.git --depth 1 && \
    git clone https://github.com/awslabs/aws-c-compression.git --depth 1 && \
    git clone https://github.com/awslabs/aws-c-http.git --depth 1 && \
    git clone https://github.com/awslabs/aws-c-sdkutils.git --depth 1 && \
    git clone https://github.com/awslabs/aws-c-auth.git --depth 1 && \
    git clone https://github.com/awslabs/aws-c-s3.git --depth 1 && \
    git clone https://github.com/HDFGroup/hdf5.git --branch hdf5_${HDF5_VERSION} --depth 1 && \
    cmake -S aws-lc -B aws-lc/build -DCMAKE_INSTALL_PREFIX=${PREFIX_PATH} -DBUILD_SHARED_LIBS=1  && \
    cmake --build aws-lc/build --target install  && \
    cmake -S s2n-tls -B s2n-tls/build -DCMAKE_INSTALL_PREFIX=${PREFIX_PATH} -DBUILD_SHARED_LIBS=1  && \
    cmake --build s2n-tls/build --target install  && \
    cmake -S aws-c-common -B aws-c-common/build -DCMAKE_INSTALL_PREFIX=${PREFIX_PATH} -DBUILD_SHARED_LIBS=1  && \
    cmake --build aws-c-common/build --target install  && \
    cmake -S aws-checksums -B aws-checksums/build -DCMAKE_INSTALL_PREFIX=${PREFIX_PATH} -DBUILD_SHARED_LIBS=1  && \
    cmake --build aws-checksums/build --target install  && \
    cmake -S aws-c-cal -B aws-c-cal/build -DCMAKE_INSTALL_PREFIX=${PREFIX_PATH} -DBUILD_SHARED_LIBS=1  && \
    cmake --build aws-c-cal/build --target install  && \
    cmake -S aws-c-io -B aws-c-io/build -DCMAKE_INSTALL_PREFIX=${PREFIX_PATH} -DBUILD_SHARED_LIBS=1  && \
    cmake --build aws-c-io/build --target install  && \
    cmake -S aws-c-compression -B aws-c-compression/build -DCMAKE_INSTALL_PREFIX=${PREFIX_PATH} -DBUILD_SHARED_LIBS=1  && \
    cmake --build aws-c-compression/build --target install  && \
    cmake -S aws-c-http -B aws-c-http/build -DCMAKE_INSTALL_PREFIX=${PREFIX_PATH} -DBUILD_SHARED_LIBS=1  && \
    cmake --build aws-c-http/build --target install  && \
    cmake -S aws-c-sdkutils -B aws-c-sdkutils/build -DCMAKE_INSTALL_PREFIX=${PREFIX_PATH} -DBUILD_SHARED_LIBS=1  && \
    cmake --build aws-c-sdkutils/build --target install  && \
    cmake -S aws-c-auth -B aws-c-auth/build -DCMAKE_INSTALL_PREFIX=${PREFIX_PATH} -DBUILD_SHARED_LIBS=1  && \
    cmake --build aws-c-auth/build --target install  && \
    cmake -S aws-c-s3 -B aws-c-s3/build -DCMAKE_INSTALL_PREFIX=${PREFIX_PATH} -DBUILD_SHARED_LIBS=1  && \
    cmake --build aws-c-s3/build --target install && \
    cmake -S hdf5 -B hdf5/build -DCMAKE_INSTALL_PREFIX=${PREFIX_PATH} -DHDF5_ENABLE_ROS3_VFD=ON -DBUILD_SHARED_LIBS=1 && \
    cmake --build hdf5/build --target install && \
    apt-get remove -y \
    build-essential \
    cmake \
    git \
    golang && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
