"""Helpers for loading turret run data into DataFrames.

Starter module — adjust the schema once the on-device loggers settle. Paths are
resolved relative to the repo root so this works from any working directory.

    from analysis.load import run_dir, load_telemetry
    df = load_telemetry("2026-06-21")
"""
from pathlib import Path

import pandas as pd

REPO_ROOT = Path(__file__).resolve().parents[1]
RUNS_DIR = REPO_ROOT / "runs"
OUTPUT_DIR = Path(__file__).resolve().parent / "output"


def run_dir(run: str) -> Path:
    """Return the folder for a given run id (e.g. '2026-06-21'), error if absent."""
    d = RUNS_DIR / run
    if not d.is_dir():
        raise FileNotFoundError(f"no run at {d} (have: "
                                f"{[p.name for p in RUNS_DIR.glob('*')] if RUNS_DIR.exists() else 'runs/ missing'})")
    return d


def load_telemetry(run: str, name: str = "telemetry.csv") -> pd.DataFrame:
    """Load one telemetry file from a run folder (CSV or Parquet by extension)."""
    path = run_dir(run) / name
    if path.suffix == ".parquet":
        return pd.read_parquet(path)
    return pd.read_csv(path)


def save_figure(fig, filename: str) -> Path:
    """Save a matplotlib figure into analysis/output/ and return its path."""
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    out = OUTPUT_DIR / filename
    fig.savefig(out, dpi=150, bbox_inches="tight")
    return out
