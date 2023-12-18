# Rice cooker

**Elixir** implementation of the _Vilany_ app

### Description

Mimics the behavior of a real rice cooker through command line interface.

### Run locally ✨

#### Setup requirements

- Erlang/OTP 26, download it [here](https://www.erlang.org/downloads/26)
- Elixir 1.15 for OTP 26, download it [here](https://github.com/elixir-lang/elixir/releases)

#### Run

- Clone and checkout the `feature/elixir` branch

  ```shell
  git clone https://github.com/hei-school/cc-d4-rice-cooker-ci-YumeT023
  git checkout feature/elixir
  ```

- Install dependencies

  ```shell
  mix deps.get
  ```

- Build

  ```shell
  sh scripts/build.sh
  ```

- Run the executable

  ```
  ./rice_cooker
  ```

### Circle CI

[described here](https://github.com/hei-school/cc-d4-rice-cooker-ci-YumeT023/blob/feature/elixir/.circleci/config.yml)
