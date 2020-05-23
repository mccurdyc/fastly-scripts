# meta-fastly

mata-fastly is designed to be a wrapper of the [Fastly CLI tool](https://github.com/fastly/cli)
to apply `fastly` commands to all services with a name matching a regex pattern.

## Usage

In your Zsh profile (e.g. `${HOME}/.zshrc`), define the following functions:

```bash
$ echo 'meta-fastly() {bash -c "source $(pwd)/meta-fastly.sh; meta-fastly $1 $2 $3 $4"}' >> ${HOME}/.zshrc
$ source ${HOME}/.zshrc
```

1. Create services

```bash
for i in {1..5}; do
  fastly service create --name pattern$i --type vcl
done
```

1. List your services

```bash
$ fastly service list
```

1. Add a domain to all services

```
$ ./meta-fastly.sh "pattern" "domain create -n https://{{ random }}.mccurdyc.dev --version 1" "random"
```

1. Add a backend to all services

```
$ ./meta-fastly.sh "pattern" "backend create --version 1 --name backend --address 127.0.0.1"
```

1. Add a logging endpoint to all services

```bash
$ ./meta-fastly.sh "pattern" "logging ftp create --name blah --address 127.0.0.1 --port 22  --user user --password pass --version 1"
```

1. Activate Version 1 of services

```bash
$ ./meta-fastly.sh "pattern" "service-version activate --version 1"
```

1. Deactivate latest version of services

```bash
$ ./meta-fastly.sh "pattern" "service-version deactivate" "latest"
```

1. Delete services

```bash
$ ./meta-fastly.sh "pattern" "service delete"
```
