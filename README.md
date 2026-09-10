<p align="center">
  <img src="_static/img/logo-black.png" alt="Strapped" width="560">
</p>

# Strapped

Strapped is retired. The website, installer, hosted strap repository, and docs are offline. This repository is archived and no longer maintained.

It had a good run. Thanks to everyone who used it.

Strapped applied YAML machine configurations with reusable Bash scripts called straps. The source remains available under the [MIT License](LICENSE).

## Source archive

- `src/` contains the CLI source; `strapped` is its generated executable.
- `straps/` contains versioned strap implementations and examples.
- `_static/` contains the website, [strap reference](_static/_docs/README.md), and installer.
- `wrangler.jsonc` and the deployment task preserve the former hosting configuration. Running the deployment task would restore the public sites; automatic deployment has been removed.

Existing installations can no longer install or upgrade from the hosted service or fetch its straps. Anyone continuing to use the code must maintain their own installation and strap repository.

To check the archived source:

```console
mise install
mise run check
```

After changing `src/`, run `make binary`. After adding or removing a strap, run `make docs`.
