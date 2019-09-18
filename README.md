## Shell

Build and launch an Ubuntu container for testing all the things...

Set the **IMAGE** environment variable and run make to create the image.

```
export IMAGE=local_shell
```

Change into the target OS

```
cd amazon
```

Build the image

```
make
```

Connect to the local container

```
make local
```
