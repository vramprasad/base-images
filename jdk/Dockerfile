FROM almalinux/9-minimal

LABEL maintainer="me@gmail.com"

ARG JAVA_VERSION=21
ARG TAR_VERSION=1.34
ARG GZIP_VERSION=1.12
ARG GIT_VERSION="2.39.3"

# Install OpenJDK 21 and clean up
RUN <<EOF
    microdnf install -y \
        tar-${TAR_VERSION} \
        gzip-${GZIP_VERSION} \
        git-${GIT_VERSION}
    microdnf install -y \
        java-${JAVA_VERSION}-openjdk \
        java-${JAVA_VERSION}-openjdk-devel
    microdnf clean all
EOF

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Verify Java installation
RUN java -version && javac -version && tar --version && gzip --version && git --version

# Default command
CMD ["/bin/bash"]