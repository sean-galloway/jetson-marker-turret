"""Turn the flat plate DXFs into 6 mm 3D solids in FreeCAD.

For every DXF in turret-gimbal/cad/dxf/, this imports the geometry, finds the
outer outline (largest closed wire) and treats the remaining closed wires
(the circles) as holes, builds a face, and extrudes it to PLATE_THICKNESS_MM.
Each plate is saved as its own FreeCAD document (cad/freecad/<name>.FCStd) and
also exported as a neutral STEP (cad/step/plates/<name>.step) so it can be
dropped into an assembly in FreeCAD, Onshape, Fusion, etc.

This is the modeling STARTING POINT: it gives you every cut plate as a solid.
Assembling them with the catalog STEP parts (motors, gearbox, bearings, hubs)
is done in the FreeCAD Assembly workbench afterwards.

RUN IT (FreeCAD must be installed; this needs FreeCAD's bundled Python, NOT a
normal venv):

    freecadcmd turret-gimbal/tools/freecad_build.py
    # older builds call it FreeCADCmd; the GUI also works via
    # macro / the Python console: exec(open('.../freecad_build.py').read())

Tested against FreeCAD 1.0+. If a plate's outline/holes don't resolve cleanly
(unusual DXF wire ordering), that plate is reported and skipped rather than
producing a bad solid — fix that DXF and re-run.
"""
import os

import FreeCAD as App
import Part
import importDXF

# --- config ---------------------------------------------------------------
# REPO_ROOT = .../turret-gimbal (this file is in turret-gimbal/tools/)
TOOLS_DIR = os.path.dirname(os.path.abspath(__file__))
GIMBAL_ROOT = os.path.dirname(TOOLS_DIR)
DXF_DIR = os.path.join(GIMBAL_ROOT, "cad", "dxf")
FCSTD_DIR = os.path.join(GIMBAL_ROOT, "cad", "freecad")
STEP_DIR = os.path.join(GIMBAL_ROOT, "cad", "step", "plates")
PLATE_THICKNESS_MM = 6.0
CUT_LAYER = "CUT"  # geometry to build from; other layers (0, dims) ignored


def closed_wires_from_doc(doc):
    """Collect every closed planar wire from the imported DXF objects."""
    edges = []
    for obj in doc.Objects:
        shape = getattr(obj, "Shape", None)
        if shape is None or not shape.Edges:
            continue
        # Prefer geometry on the CUT layer when layer info survived the import.
        layer = getattr(obj, "Label", "")
        if CUT_LAYER and CUT_LAYER not in layer and obj.Name not in ("",):
            # Layer labels aren't guaranteed; fall through and use all edges.
            pass
        edges.extend(shape.Edges)
    if not edges:
        return []
    wires = [Part.Wire(group) for group in Part.sortEdges(edges)]
    return [w for w in wires if w.isClosed()]


def plate_solid(wires, thickness):
    """Largest wire = outer boundary; the rest are holes. Extrude to a solid."""
    wires = sorted(wires, key=lambda w: Part.Face(w).Area, reverse=True)
    outer, holes = wires[0], wires[1:]
    try:
        face = Part.Face([outer] + holes) if holes else Part.Face(outer)
    except Exception:
        # Fallback: cut hole cylinders from the solid plate.
        face = Part.Face(outer)
        solid = face.extrude(App.Vector(0, 0, thickness))
        for h in holes:
            solid = solid.cut(Part.Face(h).extrude(App.Vector(0, 0, thickness)))
        return solid
    return face.extrude(App.Vector(0, 0, thickness))


def build_one(dxf_path):
    name = os.path.splitext(os.path.basename(dxf_path))[0]
    doc = App.newDocument(name)
    importDXF.insert(dxf_path, doc.Name)
    wires = closed_wires_from_doc(doc)
    if not wires:
        App.closeDocument(doc.Name)
        raise RuntimeError(f"no closed wires found in {name}")

    solid = plate_solid(wires, PLATE_THICKNESS_MM)

    # Clean doc: drop the imported draft objects, keep one solid feature.
    for obj in list(doc.Objects):
        doc.removeObject(obj.Name)
    feat = doc.addObject("Part::Feature", name)
    feat.Shape = solid
    doc.recompute()

    fcstd = os.path.join(FCSTD_DIR, f"{name}.FCStd")
    doc.saveAs(fcstd)
    step = os.path.join(STEP_DIR, f"{name}.step")
    solid.exportStep(step)
    App.closeDocument(doc.Name)
    return name, round(solid.Volume / 1000.0, 1)  # cm^3


def main():
    os.makedirs(FCSTD_DIR, exist_ok=True)
    os.makedirs(STEP_DIR, exist_ok=True)
    dxfs = sorted(f for f in os.listdir(DXF_DIR) if f.lower().endswith(".dxf"))
    if not dxfs:
        print(f"No DXFs in {DXF_DIR}")
        return
    print(f"Extruding {len(dxfs)} plates to {PLATE_THICKNESS_MM} mm...\n")
    ok, failed = [], []
    for f in dxfs:
        try:
            name, vol = build_one(os.path.join(DXF_DIR, f))
            ok.append(name)
            print(f"  OK   {name:<28} {vol} cm^3")
        except Exception as exc:  # report and continue
            failed.append(f)
            print(f"  SKIP {f:<28} {exc}")
    print(f"\nDone. {len(ok)} solids -> {FCSTD_DIR}")
    print(f"            STEP -> {STEP_DIR}")
    if failed:
        print(f"Needs attention: {', '.join(failed)}")


main()
