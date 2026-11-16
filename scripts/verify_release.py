"""Build and kernel-audit the public Klein–Gordon release."""

from __future__ import annotations

import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ALLOWED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
AXIOM_REPORT = re.compile(
    r"(?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)"
)


def run(*command: str) -> str:
    print("+", " ".join(command), flush=True)
    completed = subprocess.run(
        command,
        cwd=ROOT,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    print(completed.stdout, end="")
    return completed.stdout


def check_axiom_reports(report: str) -> None:
    matches = AXIOM_REPORT.findall(report)
    if len(matches) != 2:
        raise SystemExit(f"Expected two kernel axiom reports, found {len(matches)}")
    for raw_names in matches:
        if not raw_names:
            continue
        names = {name.strip() for name in raw_names.split(",") if name.strip()}
        unexpected = names - ALLOWED_AXIOMS
        if unexpected:
            raise SystemExit(
                "Unexpected kernel axiom dependencies: " + ", ".join(sorted(unexpected))
            )


def main() -> int:
    run("lake", "build", "KleinGordonFormal")
    report = run("lake", "env", "lean", "KleinGordonFormal/PublicationAudit.lean")
    check_axiom_reports(report)
    print("KLEIN_GORDON_RELEASE_VERIFICATION_PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
