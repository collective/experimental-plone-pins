# Experimental Plone Pins

Experimental dependency pins (Buildout `versions.cfg` and pip constraints) for Plone.

## Purpose

Plone releases provide a tested and consistent set of dependency versions.
However, between two official releases, some dependencies may receive important updates, particularly security fixes.

**The goal of this repository is to provide updated dependency pins between official Plone releases**, allowing projects to incorporate newer dependency versions without having to wait for the next Plone release.

This can be particularly useful when security vulnerabilities are discovered in dependencies and patched versions are already available upstream.

## What's included

For each supported Plone and Python version, the repository provides:

- `requirements.txt` — fully resolved Python dependencies.
- `constraints.txt` — pinned dependency versions suitable for pip and uv.
- `versions.cfg` — equivalent dependency pins for Buildout.
- `outdated-requirements.txt` — lists outdated packages with newer versions available.
- `pip-audit-report.txt` — known vulnerabilities reported by `pip-audit`.

The pins are generated using the `build-plone-pins.sh` script.

## Requirements

You will need `uv` to run the script.

## How to use

### pip / uv

Use the generated `constraints.txt` for your target Plone and Python version:

```bash
pip install -c constraints.txt -r requirements.txt
```

Alternatively, use `uv`:

```bash
uv pip install -c constraints.txt -r requirements.txt
```

Replace `constraints.txt` with the path to the appropriate generated file, or download it directly from the repository.

### Buildout

Extend the generated `versions.cfg` in your project's `buildout.cfg`:

```ini
[buildout]
extends =
    https://raw.githubusercontent.com/collective/experimental-plone-pins/refs/heads/main/plone62-py311+/versions.cfg
```

Adjust the path to match your Plone and Python versions.

## Generating updated pins

To regenerate the dependency pins locally, run:

```bash
./build-plone-pins.sh
```

The script creates isolated Python environments, resolves dependencies, and generates the corresponding constraints, Buildout versions, and audit reports.

Generated artifacts are committed to the repository so changes can be reviewed and tracked over time.

## Important considerations

**These pins are experimental and are not part of the official Plone release process.**

While updated dependencies may address known security vulnerabilities, newer versions can also introduce regressions or incompatibilities.

In particular:

- Updated pins have not necessarily undergone the same testing as official Plone release constraints.
- A successful dependency resolution does not guarantee application compatibility.
- Security audit results reflect known vulnerabilities at the time of generation and do not guarantee that an environment is secure.
- Projects should run their own test suites before deploying updated pins to production.

**Use the official Plone release constraints by default.** Consider these experimental pins when newer dependency versions are needed, particularly to address security vulnerabilities between releases.

## Contributing

Contributions, testing, and feedback are welcome.

If you encounter dependency conflicts, regressions, or compatibility issues with these pins, please open an issue or submit a pull request.
