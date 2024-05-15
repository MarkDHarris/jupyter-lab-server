# jupyter-lab server

Jupyter Lab server running in docker.

## Supported Kernels

### Rust Kernel

- [evcxr/evcxr](https://github.com/evcxr/evcxr/tree/main/evcxr_jupyter) - A Jupyter kernel for the Rust programming language.

### Go Kernel

- [gopherdata/gophernotes](https://github.com/gopherdata/gophernotes) - A Go kernel for Jupyter notebooks and nteract.

### .NET Kernel

- [dotnet/interactive](https://github.com/dotnet/interactive) - A .NET kernel for Jupyter notebooks

### Java Kernel

- [SpencerPark/IJava](https://github.com/SpencerPark/IJava) - A Jupyter kernel for executing Java code

- [dflib/jjava](https://github.com/dflib/jjava) - a supported Java Jupyter kernel evolved from the earlier IJava kernel
- NOTE: [Use --user flag per issue report](https://github.com/SpencerPark/IJava/issues/92)

### C++ 14 Kernel

- [shiroinekotfs/jupyter-cpp-kernel](https://github.com/shiroinekotfs/jupyter-cpp-kernel) - C++ kernel for Jupyter

### SSH Kernel

- [NII-cloud-operation/sshkernel](https://github.com/nii-cloud-operation/sshkernel) - SSH Kernel for Jupyter

## PREREQUISITES

- Docker

## BUILD

On MacOS or Linux

```bash
./scripts/fedora|ubuntu-build.sh
./scripts/fedora|ubuntu-run.sh
```

On Windows

```bash
./scripts/fedora|ubuntu-build.ps1
./scripts/fedora|ubuntu-run.ps1
```

## Research

[Jupyter-kernels](https://github.com/jupyter/jupyter/wiki/Jupyter-kernels)


## Troubleshooting

- Run debug.sh|debug.ps1

```
jupyter lab --ip=0.0.0.0 --port=8888 --notebook-dir=/opt/notebooks --allow-root --no-browser
```

<!-- Example of docker compose 
# version: "3.9"
# services:
#   web:
#     build: .
#     ports:
#       - "8888:8888"
#     volumes:
#       - ./notebooks:/opt/notebooks
 -->