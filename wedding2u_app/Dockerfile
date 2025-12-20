# Analysis-only Dockerfile for Wedding2U Flutter app
# Uses a small prebuilt Flutter image to run static analysis and tests

# Use the Cirrus Labs Flutter image you pulled (pinned for reproducibility)
FROM ghcr.io/cirruslabs/flutter:3.40.0-0.2.pre

# Create a non-root user to avoid running flutter as root and to have a writable pub cache
RUN useradd --create-home --user-group flutter \
  && mkdir -p /workspace /workspace/.pub-cache \
  && chown -R flutter:flutter /workspace /workspace/.pub-cache \
  # Make the preinstalled Flutter SDK writable by the flutter user so it doesn't try unsafe operations
  && if [ -d /sdks/flutter ]; then chown -R flutter:flutter /sdks/flutter; fi \
  # Add /sdks/flutter to Git safe.directory so Git won't refuse operations due to ownership
  && git config --system --add safe.directory /sdks/flutter || true

WORKDIR /workspace
ENV PUB_CACHE=/workspace/.pub-cache
# Disable Flutter analytics; rely on the pinned image's Dart/Flutter SDK
ENV FLUTTER_SUPPRESS_ANALYTICS=true
RUN flutter config --no-analytics

# Copy only pubspec first for caching (do this as root, then set ownership for flutter user)
COPY pubspec.yaml pubspec.lock* ./
# Ensure pubspec files are writable by the flutter user (ignore if pubspec.lock doesn't exist yet)
RUN chown flutter:flutter pubspec.yaml pubspec.lock || true

# Switch to non-root user and run pub get
USER flutter
RUN flutter pub get

# Copy only code needed for analysis to keep the build context small
COPY analysis_options.yaml ./
COPY lib ./lib
COPY test ./test
# If the analyzer needs assets or other directories for analysis, add them explicitly:
# COPY assets ./assets

# (Optional) show Flutter version to help debugging cache issues
RUN flutter --version

# Default command: run static analysis
CMD ["bash", "-lc", "flutter analyze"]