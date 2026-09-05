<p align="center">
  <img src="_static/img/logo-black.png" alt="Strapped" width="560">
</p>

# Strapped

[![Check](https://github.com/azohra/strapped.sh/actions/workflows/check.yml/badge.svg)](https://github.com/azohra/strapped.sh/actions/workflows/check.yml)
[![License](https://img.shields.io/github/license/azohra/strapped.sh.svg)](LICENSE)

Strapped applies a YAML machine setup with reusable Bash scripts called straps. A configuration can use the public straps in this repository or another local or remote collection.

## Install

The installer targets macOS and writes `strapped` to `/usr/local/bin`. Review the [installer](https://stay.strapped.azohra.com) before running it:

```console
curl -fsSL https://stay.strapped.azohra.com | bash
```

Run the same command again, or use `strapped --upgrade`, to replace an existing installation.

## Use

Create a configuration file:

```yaml
strapped:
  repo: https://repo.strapped.azohra.com

bash:
  echo:
    - { msg: "Strapped is ready." }
```

Apply it:

```console
strapped --yml setup.yml
```

Pass `--auto` to skip the confirmation prompt or `--straps brew,git` to run part of a configuration. Run `strapped --help` for the complete command reference.

Each top-level configuration key names a strap. Strapped loads `<repository>/<strap>/<version>/<strap>.sh` and runs the function that script provides. Because straps execute with your account's permissions, review every configuration and strap repository before using it.

The [strap reference](https://docs.strapped.azohra.com) documents the collection included here.

### Strap versions

Set `version` under a strap to select a specific release. If omitted, Strapped uses `latest`:

```yaml
bash:
  version: v0.1.0
  echo:
    - { msg: "Strapped is ready." }
```

When building a strap, its `spec.yml` must declare a version other than `latest`. The compiler writes that version's output and refreshes the strap's `latest` directory. Compilation fails if the version is missing or set to `latest`.

## Repository

- `src/` contains the CLI source; `strapped` is its generated executable.
- `straps/` contains versioned strap implementations and examples.
- `_static/` contains the website, documentation, and installer.
- `wrangler.jsonc` defines the Cloudflare Workers and their asset directories.

Install the repository tools and run its proof before committing:

```console
mise install
mise run check
```

After changing `src/`, run `make binary`. After adding or removing a strap, run `make docs`. Use `mise run deploy --dry-run` to validate every Worker without publishing it. Pushes to `main` deploy through GitHub Actions after the check passes.

Contributions must follow the [Code of Conduct](CODE_OF_CONDUCT.md). Bug reports and focused changes are welcome in the [issue tracker](https://github.com/azohra/strapped.sh/issues).

## License

Strapped is available under the [MIT License](LICENSE).
