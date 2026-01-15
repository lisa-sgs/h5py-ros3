ARG BASE_IMAGE=quay.io/pypa/manylinux_2_34_x86_64
FROM ${BASE_IMAGE}

ARG HDF5_VERSION=2.0.0
ENV CMAKE_INSTALL_PREFIX=/usr
ENV CMAKE_BUILD_PARALLEL_LEVEL=4
ENV CMAKE_BUILD_TYPE=Release

WORKDIR /scratch

RUN dnf install -y ninja-build

RUN git clone https://github.com/aws/aws-lc.git --depth 1 && \
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
    cmake -S aws-lc -B aws-lc/build -DBUILD_SHARED_LIBS=1 -DDISABLE_GO=1 && \
    cmake --build aws-lc/build --target install && \
    cmake -S s2n-tls -B s2n-tls/build -DBUILD_SHARED_LIBS=1 && \
    cmake --build s2n-tls/build --target install && \
    cmake -S aws-c-common -B aws-c-common/build -DBUILD_SHARED_LIBS=1 && \
    cmake --build aws-c-common/build --target install && \
    cmake -S aws-checksums -B aws-checksums/build -DBUILD_SHARED_LIBS=1 && \
    cmake --build aws-checksums/build --target install && \
    cmake -S aws-c-cal -B aws-c-cal/build -DBUILD_SHARED_LIBS=1 && \
    cmake --build aws-c-cal/build --target install && \
    cmake -S aws-c-io -B aws-c-io/build -DBUILD_SHARED_LIBS=1 && \
    cmake --build aws-c-io/build --target install && \
    cmake -S aws-c-compression -B aws-c-compression/build -DBUILD_SHARED_LIBS=1 && \
    cmake --build aws-c-compression/build --target install && \
    cmake -S aws-c-http -B aws-c-http/build -DBUILD_SHARED_LIBS=1 && \
    cmake --build aws-c-http/build --target install && \
    cmake -S aws-c-sdkutils -B aws-c-sdkutils/build -DBUILD_SHARED_LIBS=1 && \
    cmake --build aws-c-sdkutils/build --target install && \
    cmake -S aws-c-auth -B aws-c-auth/build -DBUILD_SHARED_LIBS=1 && \
    cmake --build aws-c-auth/build --target install && \
    cmake -S aws-c-s3 -B aws-c-s3/build -DBUILD_SHARED_LIBS=1 && \
    cmake --build aws-c-s3/build --target install && \
    cmake -S hdf5 -B hdf5/build --preset ci-StdShar-GNUC-S3 -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} && \
    cmake --build hdf5/build --target install
