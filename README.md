[windows-store]: https://www.microsoft.com/store/productId/9NBLGGH4MSV6
[ubuntu-plug]: https://marketplace.visualstudio.com/items?itemName=Docter60.vscode-terminal-for-ubuntu
[aws-IAM]: https://console.aws.amazon.com/iam/home
[Overview-img]: https://github.com/SeanSnake93/aws-apache/blob/master/Documentation/overview.png

# Bridge

* [Overview](#Overview)
* [Prerequisites](#Prerequisites)
    - [Install Ubuntu](#Install_Ubuntu_[Windows])
        - Windows
        - IAM Roles
* [Instructions](#Instructions)

## Overview

![Network Overview][Overview-img]

This Repository produces an Apache application. All hosted on a Ubuntu 20.04 server in an AWS environment within a Virtual Private Cloud network.

## Prerequisites

* Ubuntu Bash Terminal
* AWS IAM User

### Install Ubuntu [Windows]

Ubuntu can be installed via the [windows store][windows-store].

> When first creating your account you will be asked to set up a new User.
> (NOTE: This is separate from your standard Windows User.)

> If using Visual Studio Code, a [Ubuntu plugin][ubuntu-plug] can be enabled to use this terminal here. Using `Ctrl + atl + U` should display the terminal once enabled.

### IAM Roles

To run this build, you will require a [IAM User][aws-IAM].

> To produce this you will need to have access to the following Policies.
> * AmazonsEC2FullAccess

## Instructions

- `git clone https://github.com/{Git Username}/Bridge`
- `cd aws-apache`
- `sh build.sh`
    - Enter AMI Access Key
    - Enter AMI Secret Access Key
    - Enter AWS Region

> This will then run the folloing processes:
> * Gather 'apt' Updates
> * Build ssh key
> * Install Terraform
> * Install AWSCLI
> * Configure AWS Cradentuals
> * Install AWSCLI
> * Configure Terraform
> * Build Terraform files
>   * Install Ubuntu 20.04
>   * Gather 'apt' Updates
>   * Configure Firewall [ open Ports 22 and 80 ]
>   * Install Apache
> * Display URL access link (http)
> * Remove redundent packages creaded though installs
