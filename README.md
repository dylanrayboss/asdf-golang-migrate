<div align="center">

# asdf-golang-migrate [![Build](https://github.com/dylanrayboss/asdf-golang-migrate/actions/workflows/build.yml/badge.svg)](https://github.com/dylanrayboss/asdf-golang-migrate/actions/workflows/build.yml) [![Lint](https://github.com/dylanrayboss/asdf-golang-migrate/actions/workflows/lint.yml/badge.svg)](https://github.com/dylanrayboss/asdf-golang-migrate/actions/workflows/lint.yml)

[golang-migrate](https://github.com/golang-migrate/migrate) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add golang-migrate
# or
asdf plugin add golang-migrate https://github.com/dylanrayboss/asdf-golang-migrate.git
```

golang-migrate:

```shell
# Show all installable versions
asdf list-all golang-migrate

# Install specific version
asdf install golang-migrate latest

# Set a version globally (on your ~/.tool-versions file)
asdf global golang-migrate latest

# Now golang-migrate commands are available
migrate --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/dylanrayboss/asdf-golang-migrate/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [dylan](https://github.com/dylanrayboss/)
