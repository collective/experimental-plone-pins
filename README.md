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

## Supported combinations

| Plone | Python | Directory         |
| ----- | ------ | ----------------- |
| 6.2   | 3.11   | `plone62-py311+/` |

The `+` suffix indicates that these are experimental pins extending the
official Plone release constraints.

## Requirements

You will need `uv` to run the script.

## How to use

### Pin the repository revision

For reproducible and safer builds, always use a reviewed commit hash when
fetching generated files.
Do not use the moving `main` branch in production;
replace the example hash below with the commit you have reviewed.
The path
should match the Plone and Python version you are using.

### pip / uv

Use the generated `constraints.txt` for your target Plone and Python version:

```bash
COMMIT_HASH=0123456789abcdef0123456789abcdef01234567
CONSTRAINTS_URL="https://raw.githubusercontent.com/collective/experimental-plone-pins/${COMMIT_HASH}/plone62-py311+/constraints.txt"

pip install -c "${CONSTRAINTS_URL}" -r requirements.txt
```

Alternatively, use `uv`:

```bash
COMMIT_HASH=0123456789abcdef0123456789abcdef01234567
CONSTRAINTS_URL="https://raw.githubusercontent.com/collective/experimental-plone-pins/${COMMIT_HASH}/plone62-py311+/constraints.txt"

uv pip install -c "${CONSTRAINTS_URL}" -r requirements.txt
```

Replace the example commit hash and path with the reviewed commit and the
appropriate generated file for your Plone and Python versions. You can also
use a local `constraints.txt` path instead of the URL.

### Buildout

Extend the generated `versions.cfg` in your project's `buildout.cfg`:

```ini
[buildout]
extends =
    https://raw.githubusercontent.com/collective/experimental-plone-pins/<commit-hash>/plone62-py311+/versions.cfg
```

Adjust the path to match your Plone and Python versions.

## Generating updated pins

To regenerate the dependency pins locally, run:

```bash
./build-plone-pins.sh
```

The script creates isolated Python environments, resolves dependencies, and generates the corresponding constraints, Buildout versions, and audit reports.

Generated artifacts are committed to the repository so changes can be reviewed and tracked over time.

## When a report identifies an issue

The generated `outdated-requirements.txt` and `pip-audit-report.txt` files are
review aids, not automatic upgrade instructions.

When a package appears in either report:

1. Check the package's release notes and, for security issues, the relevant vulnerability advisory.
2. Confirm that the proposed version supports the targeted Plone and Python versions.
3. Update `overrides.txt` if the package is already constrained by the official Plone constraints. Use `additional-constraints.txt` if it is not.
4. Regenerate the pins with `make build`.
5. Review the generated diff
6. Open a pull request describing the issue, selected versions, test results, and any compatibility considerations.

For security vulnerabilities, prioritize the advisory's severity and the availability of a compatible fixed release.
If no compatible fix exists, document the risk and consider the issue in the context of the affected project until an appropriate update is available.

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

Pull requests that update pins should include:

- the reason for each changed package
- regenerated constraints, Buildout versions, and reports
- any relevant security advisory or upstream release notes
