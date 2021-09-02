# Zeek Docker

## Overview

This repository includes the files necessary to create Docker images for the [Zeek Network Security Monitor](https://zeek.org/). 

## Usage

By default, creating a container based on this image will result in a fully-functional standalone Zeek instance.
 
For example:
`docker run -d --name zeek raz0red/zeek-docker:latest` 

It is important to note that while a *standalone* instance is created by default, other Zeek-based configurations can be accomplished by providing volume mounts (See [Volumes](#volumes)) and customizing the image startup (See [Docker Startup Configuration](#docker-startup-configuration)).

Once a container is running, commands such as the following can be used to determine its current status, execute commands, etc.

`docker exec zeek zeekctl status`

Result output:

```
Name         Type       Host          Status    Pid    Started
zeek         standalone localhost     running   196    02 Sep 15:13:30
```

## Docker Hub

Pre-built versions of this image are available via the [Docker Hub Repository](https://hub.docker.com/) at the following location:

[https://hub.docker.com/repository/docker/raz0red/zeek-docker](https://hub.docker.com/repository/docker/raz0red/zeek-docker)

## Volumes

The following table contains the paths within the Zeek image that are typically used for Docker volume mounts.  

| Path | Description |
| - | - |
| /opt/zeek/etc | Contains the Zeek configuration files. These configuration files can be used to control the type of Zeek instance (standalone vs. clustered, etc.)<br><br>In addition to the default Zeek configuration files, this image supports a Docker-specific configuration file (`docker.config`) that can be used to control how the image starts. (See [Docker Startup Configuration](#docker-startup-configuration) for details). |
| /opt/zeek/logs | Contains the rotated log files. |
| /opt/zeek/spool | Contains the active log files. |

## Docker Startup Configuration

This image supports a Docker-specific configuration file that can be used to control how the image starts.

This *optional* file is searched for at the following location:

`/opt/zeek/etc/docker.config`

The file format is simple name-value pairs (without any additional spaces). The table below contains the list of available properties.

| Property | Type | Default | Description
| - | - | - | - |
| zkg_autoconfig | Boolean | true | Automatically configures the Zeek Package Manager (zkg).<br><br>*"Automatically generates a config file with settings that should work for most Zeek deployments."* <br>(See [Zeek Package Manager Documentation](https://docs.zeek.org/projects/package-manager/en/stable/quickstart.html#basic-configuration)) |
| zkg_bundle | File Location | /opt/zeek/etc/zkg.bundle | If the bundle file exists, attempts to unpack it and install all the packages. |
| load_packages | Boolean | true | Will update the `site/local.zeek` file to automatically load the scripts from all installed packages that are also marked as "loaded".<br>(See [Zeek Package Manager Documentation](https://docs.zeek.org/projects/package-manager/en/stable/quickstart.html#basic-configuration)) |
| start_cmd | Command | zeek_deploy | Specifies a command to execute once startup of the image has completed. <br><br>This property can be customized to point to any binary or script to execute.<br><br>See the [Start Commands](#start-commands) list below for a set of commands that are available by default within the image.|
| run_forever | Boolean | true | Whether the container should be prevented from exiting after startup. |

### Example

The following is an example of a `docker.config` with the default values:

```
zkg_autoconfig=true
zkg_bundle=/opt/zeek/etc/zkg.bundle
load_packages=true
start_cmd=zeek_deploy
run_forever=true
```

### Start Commands

The following default startup commands are available within the image.

| Command | Description |
|-|-|
| zeek_deploy | Executes the `intsall` and `start` commands via ZeekControl (zeekctl).<br><br>This will perform an initial installation of the ZeekControl configuration and start a Zeek instance. |

