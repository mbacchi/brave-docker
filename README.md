# Running Brave in a Docker Container

Security minded users often run Docker to create an additional sandbox around an
untrusted application and their system. Web Browsers are among the most
untrusted applications we run today. Here's how to setup the Brave Browser to
run in Docker.

This repository is released in tandem with the blog post
[here](https://mbacchi.github.io/2019/09/09/brave-in-docker.html).

## Host environmnet

There are some issues surrounding user namespaces and SELinux that might be different
depending on the OS you are running this Docker image on. I run Fedora 30 as the host
OS, so this is what I did to get this working.

Much of this configuration is inspired by [Jess Frazelle's chrome
Dockerfile](https://github.com/jessfraz/dockerfiles/blob/master/chrome/stable/Dockerfile).

## Steps to run Brave in Docker

1. Install docker
2. Enable user namespaces (add `user_namespace.enable=1` to `GRUB_CMDLINE_LINUX=` line in `/etc/default/grub` then run `sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg`)
3. Download the custom seccomp profile from [here](https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json): `wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json -O chrome.json`
4. Build container image (`docker build . -t brave-release-fedora`)
5. Add xhost permissions for user using [the command](https://github.com/jessfraz/dockerfiles/issues/65#issuecomment-304463458): `xhost +`
6. Run the container with the command:  `docker run -it --net host --cpuset-cpus 0 --memory 512mb -v /tmp/.X11-unix:/tmp/.X11-unix --security-opt seccomp=./chrome.json -e DISPLAY=unix$DISPLAY --device /dev/dri -v /dev/shm:/dev/shm --device /dev/snd brave-release-fedora`
