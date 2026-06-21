#!/usr/bin/env python3
"""Generate Markdown views of the turret BOM from the canonical xlsx.

Reads the live workbook (turret-gimbal/bom/Turret_BOM.xlsx) and writes two
Markdown files at the repo root:

  * Turret_BOM.md            - one table per section (A-G) + a Bought checkbox
  * Turret_BOM_checklist.md  - clickable task list, two boxes per item
                               (Ordered / Received)

It never modifies the xlsx. Re-run after editing the workbook:

    python3 turret-gimbal/tools/bom2md.py

Paths are resolved relative to this file, so it works from any working dir.
Requires: openpyxl  (see repo-root requirements.txt).
"""
from pathlib import Path

import openpyxl

# --- paths (relative to this script, not the cwd) -------------------------
REPO_ROOT = Path(__file__).resolve().parents[2]
XLSX = REPO_ROOT / "turret-gimbal" / "bom" / "Turret_BOM.xlsx"
TABLE_OUT = REPO_ROOT / "Turret_BOM.md"
CHECKLIST_OUT = REPO_ROOT / "Turret_BOM_checklist.md"
# link target, written relative to the repo root (where the .md files live)
BEARING_DOC = "turret-gimbal/docs/Bearing_Dimensions.md"


def money(v) -> str:
    if v is None or v == "":
        return ""
    try:
        f = float(v)
    except (TypeError, ValueError):
        return str(v)
    if f == 0:
        return "$0"
    if f == int(f):
        return f"${int(f)}"
    return f"${f:,.2f}"


def clean(v) -> str:
    if v is None:
        return ""
    return str(v).strip().replace("|", "\\|").replace("\n", " ")


def parse_item(r):
    """Return a dict for an item row (numeric first cell), else None."""
    if not isinstance(r[0], int):
        return None
    num, item, spec, pn_src, qty, unit = r[0], r[1], r[2], r[3], r[4], r[5]
    ds_needed, notes, pn2, link = r[7], r[9], r[10], r[12]
    src = clean(pn_src)
    if pn2 and str(pn2).strip().lower() not in ("na", "marker scan", "", "none"):
        extra = clean(pn2)
        if extra and extra not in src:
            src = f"{src} · `{extra}`" if src else f"`{extra}`"
    notes = clean(notes)
    link_url = str(link).strip() if link else ""
    if num == 33:  # lazy-susan: wire to the measured-dimensions doc
        notes = (notes + f" — **measured part: see [Bearing_Dimensions]({BEARING_DOC})**").strip(" —")
        if not link_url:
            link_url = BEARING_DOC
    # Compute the line total from qty x unit. openpyxl drops cached formula
    # values on save, so we never rely on the sheet's =E*F result.
    qty_n = qty if isinstance(qty, (int, float)) else 0
    unit_n = unit if isinstance(unit, (int, float)) else 0
    line_raw = qty_n * unit_n
    return dict(num=num, item=clean(item), spec=clean(spec), qty=clean(qty),
                unit=money(unit), line=money(line_raw), line_raw=line_raw,
                src=src, notes=notes, link=link_url,
                owned=(clean(ds_needed) == "Have"))


def load_sections(rows):
    sections, cur = [], None
    for r in rows:
        a = r[0]
        if a in ("#", "Paintball Turret — Bolt-Together BOM"):
            continue
        if isinstance(a, str) and a.startswith("Sections A–D"):
            continue
        it = parse_item(r)
        if it:
            if cur is not None:
                cur[1].append(it)
            continue
        if a is None and r[5]:  # totals row
            continue
        if isinstance(a, str):
            cur = (clean(a), [])
            sections.append(cur)
    return sections


def compute_totals(rows, sections):
    """Compute summary totals from item lines (not the sheet's cached formulas).

    Labels are read from the sheet's totals rows (literal text, cache-safe) and
    matched, in order, to: grand to-buy, electronics A–D, gimbal catalog E,
    DXF plates F.
    """
    by_letter = {}
    for title, items in sections:
        letter = title.strip()[:1].upper()
        by_letter[letter] = by_letter.get(letter, 0) + sum(it["line_raw"] for it in items)
    grand = sum(by_letter.values())
    values = [
        grand,
        by_letter.get("A", 0) + by_letter.get("B", 0)
        + by_letter.get("C", 0) + by_letter.get("D", 0),
        by_letter.get("E", 0),
        by_letter.get("F", 0),
    ]
    labels = [clean(r[5]).rstrip(":") for r in rows if r[0] is None and r[5]]
    return [(lbl, money(val)) for lbl, val in zip(labels, values)]


INTRO = ("> Sections A–D: the turret system (payload on the gun · compute on the tripod · "
         "displays · power/wiring). Sections E–G: the bolt-together gimbal — BUY catalog · "
         "CUT (DXF, SendCutSend) · HAVE. Owned items are priced $0 so they stay out of the totals.")


def write_table(sections, totals):
    header = ("| Bought | # | Item | Spec | Qty | Unit $ | Line $ | P/N / Source | Notes | Link |\n"
              "|:------:|:--|:-----|:-----|:---:|:------:|:------:|:-------------|:------|:----:|")
    out = ["# Paintball Turret — Bolt-Together BOM", "", INTRO, "",
           "**Tick the box in the far-left column once an item is purchased** "
           "(change `[ ]` to `[x]`). Items already owned are pre-ticked.", ""]
    for title, items in sections:
        out += [f"## {title}", "", header]
        for it in items:
            box = "[x]" if it["owned"] else "[ ]"
            link = f"[link]({it['link']})" if it["link"] else ""
            out.append(f"| {box} | {it['num']} | {it['item']} | {it['spec']} | {it['qty']} | "
                       f"{it['unit']} | {it['line']} | {it['src']} | {it['notes']} | {link} |")
        out.append("")
    out += ["## Totals", "", "| | Amount |", "|:--|:--|"]
    out += [f"| {l} | {a} |" for l, a in totals]
    TABLE_OUT.write_text("\n".join(out) + "\n")


def write_checklist(sections, totals):
    out = ["# Paintball Turret — Purchase Checklist", "", INTRO, "",
           "Two clickable boxes per item — **Ordered** and **Received** "
           "(works in GitHub, VS Code, Obsidian). Owned items are pre-ticked on both.", ""]
    for title, items in sections:
        out += [f"## {title}", ""]
        for it in items:
            box = "[x]" if it["owned"] else "[ ]"
            tail = [t for t in (it["spec"],
                                it["line"] if it["line"] != "$0" else "",
                                it["src"]) if t]
            line = f"- **#{it['num']} {it['item']}**"
            if tail:
                line += " — " + " · ".join(tail)
            if it["link"]:
                line += f" · [link]({it['link']})"
            out.append(line)
            out.append(f"  - {box} Ordered")
            out.append(f"  - {box} Received")
            if it["notes"]:
                out.append(f"  - _{it['notes']}_")
        out.append("")
    out += ["## Totals", ""]
    out += [f"- **{l}:** {a}" for l, a in totals]
    CHECKLIST_OUT.write_text("\n".join(out) + "\n")


def main() -> None:
    ws = openpyxl.load_workbook(XLSX, data_only=True).active
    rows = list(ws.iter_rows(values_only=True))
    sections = load_sections(rows)
    totals = compute_totals(rows, sections)
    write_table(sections, totals)
    write_checklist(sections, totals)
    n_items = sum(len(items) for _, items in sections)
    print(f"Source : {XLSX}")
    print(f"Wrote  : {TABLE_OUT.name}, {CHECKLIST_OUT.name}")
    print(f"Sections: {len(sections)}  Items: {n_items}  Totals: {len(totals)}")


if __name__ == "__main__":
    main()
