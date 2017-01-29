# Flask environment

## Overview

## Description

## Demo

## Requirement

- Ruby
- Chef

## Usage

### EC2 instance

You must select ubuntu AMI.

```bash
$ berks vendor cookbooks
$ knife solo prepare ubuntu@<YOUR_EC2_INSTANCE_HOST> -i <YOUR_AWS_KEY_PATH>
```

```bash
$ vim nodes/<YOUR_EC2_INSTANCE_HOST>.json
```

&lt;YOUR_EC2_INSTANCE_HOST&gt;.json

```json
{
  "environment": "ec2_ubuntu",
  "run_list": [
    "role[web]"
  ],
  "automatic": {
    "ipaddress": "<YOUR_EC2_INSTANCE_HOST>"
  }
}
```

```bash
$ knife solo cook ubuntu@<YOUR_EC2_INSTANCE_HOST> -i <YOUR_AWS_KEY_PATH>
```

### Vagrant

```bash
$ berks vendor cookbooks
$ vagrant up --provision
```

### Config

## Contribution

## Licence

## Author
