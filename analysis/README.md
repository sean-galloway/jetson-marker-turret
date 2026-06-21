# `analysis/` — post-run data analysis

Crunches telemetry and captures gathered from the three processors during test
runs (aim error, tracking latency, IMU/lidar traces, step/dir timing, etc.).
Kept separate from the repo-root tooling (`requirements.txt`, which is for
DXF/BOM/PDF generation) so the two dependency sets don't entangle.

## Setup
```bash
python3 -m venv venv && source venv/bin/activate   # or reuse the root venv
pip install -r analysis/requirements.txt
```

## Data layout (git-ignored)
Raw run data is **not** tracked (large/binary/ephemeral — see root `.gitignore`).
Drop captures into these dirs at the repo root:

| Dir | Contents |
|-----|----------|
| `data/`     | curated/processed datasets |
| `runs/`     | per-run folders (`runs/<date>/…`) of raw telemetry |
| `captures/` | ZED `.svo`, rosbags, point clouds |
| `logs/`     | device logs |

Analysis **outputs** (plots, reports) go in `analysis/output/` — also ignored,
except a `.gitkeep` so the folder exists on clone. Force-track a specific
artifact with `git add -f` if you want it in the repo.

## Convention
Keep notebooks for exploration; promote anything reusable into a small module
here so a run can be re-analyzed reproducibly.
