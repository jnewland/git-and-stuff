# jnewland/git-and-stuff

Sometimes, you want a Docker container with git, bash, ssh, jq, curl, and vim. Or is that just me?

[![docker](https://github.com/jnewland/git-and-stuff/workflows/docker/badge.svg)](https://github.com/jnewland/git-and-stuff/actions?query=workflow%3Adocker)
[![renovate](https://github.com/jnewland/git-and-stuff/workflows/renovate/badge.svg)](https://github.com/jnewland/git-and-stuff/actions?query=workflow%3Arenovate)

## GitHub Container Registry

- <code>[ghcr.io/jnewland/git-and-stuff](https://github.com/users/jnewland/packages/container/package/git-and-stuff):main</code> tracks the default branch of this repo
- <code>[ghcr.io/jnewland/git-and-stuff](https://github.com/users/jnewland/packages/container/package/git-and-stuff):latest</code> tracks the latest [release](https://github.com/jnewland/git-and-stuff/releases)

## Usage

This container is great for use with [`kubectl debug`](https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/#ephemeral-container). For example, to debug a pod with a broken image:

```console
$ kubectl debug -it <pod> --image=ghcr.io/jnewland/git-and-stuff:latest
```

Or to debug a node:

```console
$ kubectl debug -it node/<node> --image=ghcr.io/jnewland/git-and-stuff:latest
```
