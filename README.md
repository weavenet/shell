## Shell

Build and launch a linux container setup with tools I use for developing and testing all the things...

Build the image (by default this will be Amazon Linux 2)

# Setup

```
make image
```

Launch a container from the image

```
make start
```

Connect to the local container

```
make local
```

# Change OS

To build ubuntu, prior to running the above

```
export SHELL_OS=ubuntu
```
