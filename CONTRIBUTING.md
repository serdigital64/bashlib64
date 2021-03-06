# Contributing

## Prepare Development Environment

- Prepare dev tools
  - Install GIT
  - Install [TestManSH](https://github.com/serdigital64/testmansh): for testing and linting
- Clone GIT repository

  ```shell
  git clone https://github.com/serdigital64/bashlib64.git
  ```

- Adjust environment variables to reflect your configuration:

  ```shell
  # Copy environment definition files from templates:
  cp dot.local .local
  cp dot.secrets .secrets
  # Review and update content for both files
  ```

- Initialize dev environment variables

  ```shell
  source bin/devbl-set
  ```

## Update source code

- Add/Edit source code in: `src/`
- Build production library and refresh docs:

```shell
 ./bin/devbl-build -p
 ./bin/devbl-build -d
```

## Test source code

- Add/update test-cases in: `test/batscore`
- Build testing library:

```shell
 ./bin/devbl-build -t
```

- Run test-cases using container images bundled with the `testmansh` tool

```shell
testmansh -b -o
```

## Repositories

- Project GIT repository: [https://github.com/serdigital64/bashlib64](https://github.com/serdigital64/bashlib64)
- Project Documentation: [https://serdigital64.github.io/bashlib64/](https://serdigital64.github.io/bashlib64/)
- Release history: [CHANGELOG](CHANGELOG.md)
