#!/bin/bash
set -xe
set -o pipefail

# Plone 6.2
plone_version=6.2
version_suffix=latest
python_version=3.11
folder="plone${plone_version//./}-py${python_version//./}+"
overrides="--overrides overrides.txt"
constraints="--constraints additional-constraints.txt"
mkdir -p "$folder"
cd "$folder"
uv venv --allow-existing --seed --python "python${python_version}"
source ".venv/bin/activate"
pip install -U uv
uv pip compile --no-header --no-annotate https://dist.plone.org/release/$plone_version-$version_suffix/constraints.txt ../requirements.in $overrides $constraints --output-file="requirements.txt"
uv pip install -r "requirements.txt"
uv pip list --outdated > "outdated-requirements.txt"
pip-audit > "pip-audit-report.txt"
uv pip freeze > "constraints.txt"
uvx --from plone.releaser manage constraints2versions -p constraints.txt
deactivate
cd ..

# Plone edge version, use at your own risk
plone_version=edge
version_suffix=dev
folder="plone$plone_version-py311+"
mkdir -p "$folder"
cd "$folder"
uv venv --allow-existing --seed --python "python${python_version}"
source ".venv/bin/activate"
pip install -U uv
uv pip install -U -r ../requirements.in
uv pip list --outdated > "outdated-requirements.txt"
pip-audit > "pip-audit-report.txt"
uv pip freeze > "constraints.txt"
uvx --from plone.releaser manage constraints2versions -p versions.cfg
deactivate
cd ..
