# sdk-builder

This Repository contains the Dockerfile for the sdk-builder. The sdk-builder is used as base image for all product sdks (PFC200, PFC300, CC100, VTP/CTP & WP400).
If you prefer to use a virtual machine feel free to use the Dockfile as guideline for the installation process.

## PREREQUISITES

### 1.) Install docker

Make sure that docker is installed on the host system.
To install docker, please refer to the instructions depending on your host system, e.g for Ubuntu use [https://docs.docker.com/install/linux/docker-ce/ubuntu/](https://docs.docker.com/install/linux/docker-ce/ubuntu/).

Make sure docker can be run without root privileged. Refer to [https://docs.docker.com/engine/install/linux-postinstall/](https://docs.docker.com/engine/install/linux-postinstall/) for further information.

### 2.) Download and install GIT

Make sure that you install GIT version >= 1.8.2

    sudo apt install git

### 3.) Check out the correct release

Every FW release is bound to one specific sdk-builder tag. You can look up the corresponding value in the table below.

<table>
    <thead>
        <tr>
            <th>sdk-builder release</th>
            <th>pfc200-sdk</th>
            <th>cc100-sdk</th>
            <th>tp-sdk</th>
            <th>pfc300-sdk</th>
            <th>wp400-sdk</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=1>1.0.0</td>
            <td rowspan=1>FW-24</td>
            <td rowspan=1>FW-24</td>
            <td rowspan=1>FW-24</td>
            <td rowspan=1>-</td>
	        <td rowspan=1>-</td>
        </tr>
        <tr>
            <td rowspan=2>2.0.0</td>
            <td rowspan=1>FW-25</td>
            <td rowspan=1>FW-25</td>
            <td rowspan=1>FW-25</td>
            <td rowspan=1>-</td>
	        <td rowspan=1>-</td>
        </tr>
        <tr>
            <td rowspan=1>FW-26</td>
            <td rowspan=1>FW-26</td>
            <td rowspan=1>FW-26</td>
            <td rowspan=1>-</td>
	        <td rowspan=1>-</td>
        </tr>
        <tr>
            <td rowspan=1>3.0.0</td>
            <td rowspan=1>FW-27</td>
            <td rowspan=1>FW-27</td>
            <td rowspan=1>FW-27</td>
            <td rowspan=1>FW-27</td>
	        <td rowspan=1>-</td>
        </tr>
        <tr>
            <td rowspan=1>3.0.1</td>
            <td rowspan=1>FW-28</td>
            <td rowspan=1>FW-28</td>
            <td rowspan=1>FW-28</td>
            <td rowspan=1>FW-28</td>
	        <td rowspan=1>FW-28</td>
        </tr>
        </tr>
    </tbody>
</table>

You can downloand specific sdk-builder versions in the release section. Alternatively you may use git to clone the repository.

    git clone git@github.com:WAGO/sdk-builder.git && cd sdk-builder

Afterwards you can checkout a custom release.

    git checkout`<sdk-builder release>`

## Build the basis sdk

    docker build  -t wagoautomation/sdk-builder:`<sdk-builder release>` .

## How to proceed

Congrats! You have successfully build the sdk-builder image.
You may proceed with the build of a product sdk listed below.

* [cc100-sdk-firmware-sdk](https://github.com/WAGO/cc100-firmware-sdk)
* [tp-firmware-sdk](https://github.com/WAGO/tp-firmware-sdk)
* [pfc-firmware-sdk-G2](https://github.com/WAGO/pfc-firmware-sdk-G2)
* [pfc300-firmware-sdk](https://github.com/WAGO/pfc300-firmware-sdk)
* [wp400-firmware-sdk](https://github.com/WAGO/wp400-firmware-sdk)
