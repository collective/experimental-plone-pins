import sys
from pathlib import Path
from packaging.requirements import Requirement
from packaging.utils import canonicalize_name

failed = False

for filename in sys.argv[1:]:
    for lineno, line in enumerate(
        Path(filename).read_text().splitlines(), 1
    ):
        line = line.strip()
        if not line or line[0] in "[#":
            continue

        # Good for versions files
        line = line.replace(" = ", "==")

        try:
            requirement = Requirement(line)
        except Exception:
            print(f"{filename}:{lineno}: {line!r} is not a valid requirement")
            failed = True
            continue
        name = requirement.name
        canonical = canonicalize_name(name)

        if name != canonical:
            print(
                f"{filename}:{lineno}: "
                f"{name!r} should be {canonical!r}"
            )
            failed = True

sys.exit(1 if failed else 0)
