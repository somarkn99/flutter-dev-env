# Use Ubuntu as the base image
FROM ubuntu:latest

# Install basic tools and dependencies
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa wget clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev sudo

# Install Java
RUN apt-get install -y openjdk-11-jdk

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Define Flutter and Android SDK environment variables
ENV FLUTTER_HOME=/usr/local/flutter
ENV FLUTTER_VERSION="3.19.1"
ENV ANDROID_HOME=/home/developer/android-sdk
ENV PATH="$PATH:$FLUTTER_HOME/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"

# Download and extract Flutter SDK as root
RUN mkdir -p $FLUTTER_HOME \
    && curl --fail --remote-time --silent --location -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
    && tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -C $FLUTTER_HOME --strip-components=1 \
    && rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz

# Create a non-root user for Flutter and Android operations
RUN useradd -m developer && echo "developer:developer" | chpasswd && adduser developer sudo

# Change ownership of the Flutter directory to the developer user
RUN chown -R developer:developer $FLUTTER_HOME

# Switch to the non-root user
USER developer

# Configure Git for Flutter to recognize the Flutter directory as safe
RUN git config --global --add safe.directory $FLUTTER_HOME

# Set WORKDIR in the user's home directory
WORKDIR /home/developer

# Install Android SDK command-line tools and platform-tools as root
USER root
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    wget -q -O cmdline-tools.zip "https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip" && \
    unzip cmdline-tools.zip -d $ANDROID_HOME/cmdline-tools && \
    mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest && \
    rm cmdline-tools.zip

# Accept Android SDK licenses
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses

# Install platform-tools, and update tools
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platform-tools" "tools" "build-tools;30.0.3" "platforms;android-30"

# Change ownership of the Android SDK directory to the developer user
RUN chown -R developer:developer $ANDROID_HOME

USER developer

# Run flutter doctor to check the installation and setup
RUN flutter doctor -v

# Set the final working directory to /app within the container
WORKDIR /app


# The following COPY command assumes you are building the Docker image
# in a directory containing your Flutter project.
# If your project is located elsewhere, adjust the source path accordingly.
COPY --chown=developer:developer . /app

# Get packages for the project (if applicable)
# RUN flutter pub get

# Set the default command or entry point
CMD ["/bin/bash"]
