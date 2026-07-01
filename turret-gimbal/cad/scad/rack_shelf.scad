// =====================================================================
// Ground-station rack shelf — Jetson AGX Orin + Raspberry Pi 5 + Pico
// For the DeskPi RackMate T2 (10" rack). 3D-printable (PETG/ASA recommended).
//
// Design intent:
//   - Jetson dev kit DROPS INTO a locating pocket (no bolt pattern needed;
//     uses only the 109x109 footprint). Big floor cutout under it for the fan.
//   - Pi 5 mounts on 4 standoffs (58 x 49 M2.5 pattern).
//   - Pico sits on 2 small standoffs in front.
//   - Floor vents + rear cable slots.
//   - Front 3U flange bolts to the rack rails (SLOTTED holes for fit tolerance).
//
// >>> CONFIRM the params marked [MEASURE] against your actual RackMate T2 <<<
// Render/export: open in OpenSCAD, F6, then export STL.
// =====================================================================

// ---- Rack interface (DeskPi RackMate T2, 10") — CONFIRMED from a 1U panel ----
U              = 44.23;   // measured 1U panel height (nominal 44.45; panels run under)
shelf_U        = 3;       // shelf front-panel height in U
face_width     = 254;     // 10" panel outer width (measured)
flange_th      = 4;       // front flange thickness
// Mounting holes: horizontal OVAL slots 9.33w x 6.77h; edge gaps 4.3mm sides,
// 3mm top/bottom. Slot centers -> 8.965mm from sides, 6.385mm from top/bottom edge.
slot_w         = 9.33;    // slot width (horizontal, gives side-to-side adjustment)
slot_h         = 6.77;    // slot height
slot_side_ctr  = 4.3 + slot_w/2;   // 8.965mm: slot center from each side edge
slot_tb_ctr    = 3.0 + slot_h/2;   // 6.385mm: slot center from top/bottom edge
rail_hole_dx   = face_width - 2*slot_side_ctr;  // = 236.07mm center-to-center

// ---- Tray ----------------------------------------------------------
usable_width   = 200;     // [MEASURE] clear width between rails
shelf_depth    = 200;     // tray depth (T2 interior ~260; leave room for cables)
floor_th       = 3;       // tray floor thickness
side_wall_h    = 8;       // low stiffening rim along tray sides
rear_lip_h     = 10;      // rear retaining lip

// ---- Jetson AGX Orin dev kit (drop-in pocket) ----------------------
jetson_xy      = 109;     // footprint (given)
jetson_h       = 75;      // height incl. feet (72 mm bare). tray floor + this
                          // = ~78 mm = ~1.75U -> shelf_U=3 leaves fan headroom.
jetson_clear   = 1.0;     // pocket clearance per side
jetson_wall    = 6;       // locating wall height (just locates the base)
jetson_vent    = 90;      // floor cutout (square) under the fan intake.
                          // FAN = BOTTOM INTAKE: this vent feeds it (feet give the
                          // ~3 mm gap). Keep the rack bay BELOW the shelf open so
                          // the fan has air to pull.

// ---- Raspberry Pi 5 (standoffs) ------------------------------------
pi5_hole_dx    = 58;      // hole rectangle X
pi5_hole_dy    = 49;      // hole rectangle Y
pi5_standoff_h = 5;
pi5_standoff_d = 6;
pi5_screw_d    = 2.6;     // M2.5 clearance

// ---- Pico ----------------------------------------------------------
pico_standoff_h = 4;
pico_dx        = 47;      // Pico mount-hole spacing X (board is 51x21)
pico_dy        = 11.4;    // Pico mount-hole spacing Y
pico_screw_d   = 2.2;     // M2 clearance

eps = 0.01;
$fn = 32;

// ---------------------------------------------------------------------
module standoff(h, od, id) {
    difference() {
        cylinder(h=h, d=od);
        translate([0,0,-eps]) cylinder(h=h+2*eps, d=id);
    }
}

module floor_vents(area_w, area_d, x0, y0) {
    // simple slot grid
    for (sx = [x0 : 12 : x0+area_w-8])
        translate([sx, y0, -eps])
            cube([6, area_d, floor_th+2*eps]);
}

module tray() {
    difference() {
        union() {
            // floor
            cube([usable_width, shelf_depth, floor_th]);
            // side rims
            cube([usable_width, 3, side_wall_h]);                       // front rim
            translate([0, shelf_depth-3, 0]) cube([usable_width, 3, rear_lip_h]); // rear lip
            translate([0,0,0]) cube([3, shelf_depth, side_wall_h]);     // left
            translate([usable_width-3,0,0]) cube([3, shelf_depth, side_wall_h]); // right
        }
        // floor vents under Jetson + general
        translate([ (jetson_xy-jetson_vent)/2 + 6,
                    shelf_depth-10-jetson_xy + (jetson_xy-jetson_vent)/2, -eps])
            cube([jetson_vent, jetson_vent, floor_th+2*eps]);
        // rear cable slots
        for (cx = [30 : 40 : usable_width-30])
            translate([cx, shelf_depth-3-eps, rear_lip_h-6])
                cube([18, 4+2*eps, 8]);
    }
}

// Jetson locating pocket (open-bottom walls) — back-left of tray
module jetson_pocket() {
    jx = 6;                              // left inset
    jy = shelf_depth - 10 - jetson_xy;   // toward rear
    pkt = jetson_xy + 2*jetson_clear;
    translate([jx, jy, floor_th-eps])
    difference() {
        cube([pkt, pkt, jetson_wall]);
        translate([2, 2, -eps]) cube([pkt-4, pkt-4, jetson_wall+2*eps]);
        // open front edge for cabling/insertion
        translate([pkt/2-20, -eps, -eps]) cube([40, 4, jetson_wall+2*eps]);
    }
}

// Pi 5 standoffs — right side of tray
module pi5_mounts() {
    px = usable_width - 6 - 56;   // 56mm board width region (right side)
    py = shelf_depth - 10 - 85;   // 85mm board length region (rear)
    // four holes on 58 x 49 rectangle (origin at first standoff)
    for (dx = [0, pi5_hole_dx])
        for (dy = [0, pi5_hole_dy])
            translate([px+dx - (pi5_hole_dx-49)/2, py+dy, floor_th-eps])
                standoff(pi5_standoff_h, pi5_standoff_d, pi5_screw_d);
}

// Pico standoffs — front-center
module pico_mounts() {
    cx = usable_width/2 - pico_dx/2;
    cy = 16;
    for (dx = [0, pico_dx])
        for (dy = [0, pico_dy])
            translate([cx+dx, cy+dy, floor_th-eps])
                standoff(pico_standoff_h, 4, pico_screw_d);
}

// One horizontal oval mounting slot (9.33w x 6.77h), cut through the flange (Y).
module oval_slot() {
    off = (slot_w - slot_h) / 2;   // circle-center offset for a horizontal oval
    hull()
        for (dx = [-off, off])
            translate([dx, -eps, 0]) rotate([-90, 0, 0])
                cylinder(h = flange_th + 2*eps, d = slot_h);
}

// Front rack-mount flange — 4 corner oval slots per the measured RackMate pattern
module flange() {
    fh = shelf_U * U;                 // 3U tall
    translate([(usable_width-face_width)/2, -flange_th, 0])
    difference() {
        cube([face_width, flange_th, fh]);
        // slot centers: 8.965mm from each side; 6.385mm from top & bottom edges
        for (sx = [slot_side_ctr, face_width - slot_side_ctr])
            for (sz = [slot_tb_ctr, fh - slot_tb_ctr])
                translate([sx, 0, sz]) oval_slot();
    }
}

module rack_shelf() {
    tray();
    jetson_pocket();
    pi5_mounts();
    pico_mounts();
    flange();
}

rack_shelf();
