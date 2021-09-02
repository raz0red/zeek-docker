# Zeek Docker

## Overview

TODO

## Usage

TODO

## Volumes

TODO 

| Path | Description |
| - | - |
| /opt/zeek/etc | Contains the Zeek configuration files.<br><br>In additional to the default Zeek configuration files, this image supports a `docker.config` file that can be used to control how the image starts. (See [Docker Startup Configuration](#docker-startup-configuration) for details). |
| /opt/zeek/logs | Contains the rotated log files. |
| /opt/zeek/spool | Contains the active log files. |

## Docker Startup Configuration

TODO

| Property | Type | Default | Description
| - | - | - | - |
| zkg_autoconfig | Boolean | true | Automatically configures the Zeek Package Manager (zkg).<br><br>*Automatically generates a config file with settings that should work for most Zeek deployments.* <br>(See [Zeek Package Manager Documentation](https://docs.zeek.org/projects/package-manager/en/stable/quickstart.html#basic-configuration)) |
| zkg_bundle | File Location | /opt/zeek/etc/zkg.bundle | If the file exists, attempts to unpack the bundle file formerly created via the bundle command and install all the packages. |
| load_packages | Boolean | true | Will update the `site/local.zeek` file to automatically load the scripts from all installed packages that are also marked as "loaded".<br>(See [Zeek Package Manager Documentation](https://docs.zeek.org/projects/package-manager/en/stable/quickstart.html#basic-configuration)) |
| start_cmd | Command | zeek_deploy | Specifies a command to execute once startup of the image has completed. <br><br>This property can be customized to point to any binary or script to execute.<br><br>See the [Start Commands](#start-commands) list below for a set of commands that are available by default within the image.|
| run_forever | Boolean | true | Whether the container should be prevented from exiting after startup. |

### Start Commands

The following default startup commands are available within the image.

| Command | Description |
|-|-|
| zeek_deploy | Executes the `intsall` and `start` commands via ZeekControl (zeekctl).<br><br>This will perform an initial installation of the ZeekControl configuration and start a Zeek instance. |

