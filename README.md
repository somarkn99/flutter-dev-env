# Flutter Development Environment Docker Image

This repository contains a Dockerfile for a Flutter development environment. It's designed to provide a ready-to-use Docker image for Flutter development, including the setup for Java and the Android SDK, configured for use with a non-root user.

## Features

- Ubuntu-based image with the latest updates.
- Includes Java and the Android SDK with `platform-tools`.
- Flutter SDK installed and ready to use.
- Non-root user configuration for better security.

## Prerequisites

Before you begin, ensure you have Docker installed on your machine. Visit [Docker's official website](https://docs.docker.com/get-docker/) for installation instructions.

## Building the Docker Image

To build the Docker image, clone this repository and navigate to the directory containing the Dockerfile. Then, run the following command:

```bash
docker build -t somarkesen99/flutter-dev-env .
```

## Running the Docker Container
After building the image, you can run a container using the following command:

```bash
docker run -it --name flutter_dev somarkesen99/flutter-dev-env
```
This command starts a container named flutter_dev where you can begin your Flutter development.

## Using the Docker Image
Once inside the Docker container, you can start developing with Flutter right away. Here are some common Flutter commands:

- To create a new Flutter project:
```bash
flutter create my_project
```
## Contributing
Contributions to improve the Docker image or fix issues are welcome. Please submit a pull request or open an issue if you have suggestions or find bugs.

## License
This Docker image and its configuration are made available under the MIT License. Feel free to use, modify, and distribute as you see fit.

## Contact
For questions or support, please open an issue in the GitHub repository, or contact me directly at contact@somar-kesen.com