# traefik-iac

A rootless IaC for deploying projects using [Podman](https://github.com/podman-container-tools/podman) (version 5 or earlier), [Traefik](https://github.com/traefik/traefik), etc.

The project uses `.container` files instead of grouping via `.pod`, as pod generation using `.pod` is not supported in Podman 4.9.x—resulting in an `unsupported key 'Pod' in group 'Container'` error (confirmed in issue [#21371](https://github.com/podman-container-tools/podman/issues/21371)). Full support for `.pod` was added in Podman 5.0.0.

## Requirments

- [init-iac](https://github.com/ev-kotov/init-iac)

## Run

```bash
chmod +x deploy.sh
sh deploy.sh
```

## Update

Change iac and execute:

```bash
sh deploy.sh
```
