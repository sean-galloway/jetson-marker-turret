// =====================================================================
// Ground-station 3U compute bay — IMSAI-8080 front panel + Jetson AGX Orin
//                                  + Raspberry Pi 5
// For the DeskPi RackMate T2 (10" rack). 3D-printable (PETG/ASA recommended).
//
// MERGED DESIGN: the front 3U face IS the IMSAI-8080 smart panel bezel
// (RaspberyPi-IMSAI-8080 sub-project) — LED windows + toggle cutouts + 6 bosses
// that stand the panel PCB off the back of the bezel. Behind it, the same bay
// holds the Jetson and the Pi 5. The Pi 5 is the panel's USB host, so it sits
// right behind the bezel (short RP2040 USB pigtail).
//
// SAFETY (per turret CLAUDE.md): this panel is a SOFT USB peripheral to the Pi.
// It is STATUS + soft-control ONLY. The hardware arming switch, E-stop, and the
// armed/safe LED stay on their own physical interlock lines and NEVER route
// through this board. Panel switches may *request* actions; they never fire.
//
// Design intent:
//   - IMSAI bezel = the 3U rack face: 4 LED windows (diffuser-backed), 12 toggle
//     holes, 6 M2.5 bosses for the panel PCB, 4 oval rack-mount slots.
//   - Jetson dev kit DROPS INTO a locating pocket at the REAR (109x109 footprint).
//   - Pi 5 mounts on 4 standoffs (58 x 49 M2.5) behind the bezel.
//   - Floor vents + rear cable slots. Front is blocked by the bezel, so cool
//     BOTTOM-intake / REAR-exhaust and keep the bay below this shelf open.
//
// >>> CONFIRM params marked [MEASURE] (RackMate T2) and [PANEL] (against the
//     ordered PCB + the toggles/LEDs you actually buy) before printing. The
//     bezel grid mirrors RaspberyPi-IMSAI-8080/docs/panel-layout.md +
//     hardware/design-spec.md; re-verify after the PCB arrives. <<<
// Render/export: open in OpenSCAD, F6, then export STL.
// =====================================================================

// ---- Rack interface (10" 1U panel) — from the mfr mechanical drawing ----------
U              = 44;      // 1U panel height (drawing: 44 mm / 1.73 in)
shelf_U        = 3;       // shelf front-panel height in U
face_width     = 254;     // 10" panel outer width (drawing)
// (front-face thickness is bezel_th, set in the IMSAI bezel block below)
// Mounting: 4 horizontal OVAL slots 9.33w x 6.77h. Drawing gives hole center-to-
// center: 238 mm horizontal, 33 mm vertical (within 1U) -> slot centers 8 mm from
// each side edge, 5.5 mm from top/bottom edge. (Clear panel opening ~214 mm.)
slot_w         = 9.33;    // oval slot width (horizontal = side-to-side adjustment)
slot_h         = 6.77;    // oval slot height
rail_hole_dx   = 238;     // horizontal mounting-hole center-to-center (drawing)
hole_cc_v      = 33;      // vertical mounting-hole C-C within 1U (drawing)
slot_side_ctr  = (face_width - rail_hole_dx) / 2;   // = 8 mm from each side edge
slot_tb_ctr    = (U - hole_cc_v) / 2;               // = 5.5 mm from top/bottom edge

// ---- Tray ----------------------------------------------------------
usable_width   = 214;     // [MEASURE] clear width between rails — set to the RackMate T2
                          // interior; 214 (= panel aperture) so the tray backs the full
                          // switch/LED span with ~12 mm margin each side. Confirm on the rack.
shelf_depth    = 200;     // tray depth (T2 interior ~260; leave room for cables)
floor_th       = 4;       // tray floor thickness (4 mm for the heavy Jetson)
side_wall_h    = 8;       // low stiffening rim along tray sides
rear_lip_h     = 10;      // rear retaining lip
vent_slot_w    = 9;       // Jetson intake-vent slot width (ribs between = support)
vent_rib       = 4;       // rib between vent slots — this is what carries the Jetson
floor_rib_h    = 7;       // underfloor stiffening-rib depth
// Integral CENTRE gusset (in the block gap). Side gussets are separate bolt-on parts
// (see the bolt-on section below). All braces stay BELOW the PCB (board bottom ≈ z39).
gusset_t       = 4;       // centre-brace thickness
gusset_d       = 55;      // how far it reaches back along the tray
gusset_h_ctr   = 32;      // centre-brace height: top ≈ z35, under the PCB
cable_slot_w   = 12;      // centre-gusset cable pass-through (y) for switch/board wiring
cable_slot_h   = 16;      // ... (z)

// ---- Bolt-on SIDE gusset (separate part) ---------------------------------------
// Reuses the PCB's LOWER corner mount hole (H4 left / H6 right): the gusset CARRIES
// that standoff and the board screws into it FROM THE BACK — no new fascia hole, no
// screw near the front. Also bolted to the tray floor. Path: fascia→PCB→gusset→tray.
bg_web_t       = 4;       // web thickness (x)
bg_web_depth   = 50;      // web reach back along the tray (y)
bg_web_top     = 35;      // web top z (below the PCB bottom ≈ z39)
bg_flange_t    = 2.5;     // flange plate thickness (sits in front of the board)
bg_foot_t      = 3;       // foot thickness (flat; bolts through the floor)
bg_foot_w      = 12;      // foot width (x)
bg_foot_d      = 16;      // foot depth (y)
bg_bolt_d      = 3.4;     // M3 clearance (floor bolts, nut underneath)
bg_bolt_l      = [[5, 6], [9, 12]];                   // LEFT floor-bolt positions (world x,y)
bg_bolt_r      = [[usable_width-5, 6], [usable_width-9, 12]];  // RIGHT

// ---- Jetson AGX Orin dev kit (drop-in pocket) ----------------------
jetson_xy      = 109;     // footprint (given)
jetson_h       = 75;      // height incl. feet (72 mm bare). tray floor + this
                          // = ~78 mm = ~1.75U -> shelf_U=3 leaves fan headroom.
jetson_clear   = 1.0;     // pocket clearance per side
jetson_wall    = 10;      // locating wall height (grips the base for transport)
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

// ---- IMSAI-8080 bezel (front face) — [PANEL] mirror of the sub-project ------
// Datum = top-left of the 214 mm x ~122 mm rack APERTURE, +x right, +y DOWN
// (same datum as panel-layout.md / design-spec.md). map_x/map_z below convert a
// datum (x,y) into this file's flange coords (origin at flange bottom-left, z up).
bezel_th       = 5;       // face thickness (rigid, backs the LED windows). The
                          // toggle holes are back-counterbored (below) so the
                          // ~6 mm MTS-1xx bushing still protrudes far enough to nut.
aperture_w     = 214;     // clear aperture width (panel-layout.md)
aperture_h     = 122;     // clear aperture height inside the 3U face (~133 - margins)
content_dx     = -3;      // shift the whole content (LEDs+toggles+bosses) to equal side
                          // margins — the 8L/4R block layout is left-heavy, so -3 centres it

// Vertical balance (ref: built IMSPI 8080) — branding band on top, the LED board
// below it, toggles low. The board (LEDs + bosses) drops by top_brand_band; the
// toggles are placed independently near the bottom (they're wired, not on-board).
top_brand_band = 33;      // top fascia band reserved for branding (LED board drops this far)
toggle_z_ctr   = 24;      // toggle-row center height above the fascia bottom (low)

// LED windows: one diffuser-backed slot per lamp row. {x0, x1, y_center} in datum.
led_win_h      = 6;       // slot height (panel-layout.md); ~6 mm bezel rib between
led_windows    = [ [10, 125, 10],    // row 1 — addr-hi  -> subsystem heartbeat bits
                   [10, 125, 22],    // row 2 — addr-lo  -> pan bargraph
                   [10, 125, 34],    // row 3 — data     -> tilt / confidence
                   [155, 210, 22] ]; // status (4)       -> ARMED/TRACKING/FAULT/PWR

// Toggle cutouts: 8 data (left block) + 4 command (status block), 15 mm pitch,
// centered in the toggle band below the board. [PANEL] set toggle_d to the
// bushing dia of the toggles you buy; y-band to the caps you print.
toggle_d       = 6.5;     // MTS bushing ~6 mm (1/4-40) -> 6.5 hole (same for both)
                          // toggle row height is set by toggle_z_ctr (near bottom)
toggle_x_data  = [15, 30, 45, 60, 75, 90, 105, 120];  // 8 DATA = DPDT maintained (MTS-2xx)
toggle_x_cmd   = [160, 175, 190, 205];                // 4 CMD = SPDT momentary (MTS-123)
                          // DPDT body is deeper/wider — verify clearance at 15 mm
                          // pitch and behind the fascia (vs the PCB) once in hand
tog_cbore_d    = 9;       // back-side counterbore dia (clears the switch shoulder)
tog_cbore_dep  = 2.5;     // leaves bezel_th - this = 2.5 mm at the thread so the nut
                          // catches on a ~6 mm bushing regardless of its exact length

// Panel-PCB standoff bosses (design-spec.md H1..H6), 3-5 mm off the bezel back.
pcb_boss_h     = 5;
pcb_boss_d     = 6;
pcb_screw_d    = 2.6;     // M2.5 clearance
pcb_holes      = [ [7,7], [140,7], [207,7], [7,48], [140,48], [207,48] ]; // datum

// ---- IMSAI blue frame — COSMETIC front-fascia trim (visual only) -----
// A SEPARATE slip-/glue-on ⊓ border printed in IMSAI blue (ref: the built
// IMSPI 8080). Proud side bands + a top bar wrap the sides + top (open at the
// bottom where the tray is). NOT structural: the black fascia mounts to the rack
// on its own slots; the frame just overlays the front. 4 round reliefs let the
// mount screws/driver clear it. Print it separately, or as a 2nd colour on the
// same object (PART="all").
frame_face_w   = 6;       // how far the blue lip covers the front fascia (from edge)
frame_h        = 4;       // how far the frame stands proud of the fascia
frame_top      = 11;      // top-bar height — clears the top LED window by ~1 mm
frame_relief   = 5;       // extra dia of clearance around each mount slot in the frame
PREVIEW        = false;   // true = colour the parts for the F5/preview image

PART           = "shelf"; // "shelf" (functional print) | "frame" (blue print) | "all"
panel_h        = shelf_U * U;         // 3U face height, shared by fascia + frame

// ---- Debossed legend (recess + wipe white paint into the grooves) -----------
// Cut into the fascia FRONT using the same ap_x/ap_z as the holes, so text lands
// on the grid by construction. Mirrors gen_front_panel.py / the reference build.
legend_on      = true;
deboss_d       = 0.5;     // legend recess depth (0.4-0.6 typical for paint-fill)
lf             = "DejaVu Sans Mono";
lf_b           = "DejaVu Sans Mono:style=Bold";
node_lbl   = ["JET", "PI5", "PICO", "ZED", "LIDAR", "NET", "48V", "12V"];
status_lbl = ["ARMED", "TRACK", "FAULT", "PWR"];
data_lbl   = ["MODE", "TRACK", "LASER", "NIGHT", "REC", "VERB", "", ""];
cmd_lbl    = ["TEST", "PAGE", "HOME", "ARM"];

eps = 0.01;
$fn = 32;

// ---------------------------------------------------------------------
module standoff(h, od, id) {
    difference() {
        cylinder(h=h, d=od);
        translate([0,0,-eps]) cylinder(h=h+2*eps, d=id);
    }
}

// Ribbed intake vent: slots along depth with ribs between, so a device rests on a
// continuous support grid (weight on the ribs) instead of a single open hole.
module ribbed_vent(w, d, x0, y0) {
    pitch = vent_slot_w + vent_rib;
    for (sx = [x0 : pitch : x0 + w - vent_slot_w])
        translate([sx, y0, -eps])
            cube([vent_slot_w, d, floor_th + 2*eps]);
}

module tray() {
    // Jetson vent footprint (centred under the pocket, at the rear)
    jvx = 6 + (jetson_xy - jetson_vent)/2;
    jvy = shelf_depth - 10 - jetson_xy + (jetson_xy - jetson_vent)/2;
    difference() {
        union() {
            cube([usable_width, shelf_depth, floor_th]);                          // floor
            cube([usable_width, 3, side_wall_h]);                                 // front rim
            translate([0, shelf_depth-3, 0]) cube([usable_width, 3, rear_lip_h]); // rear lip
            // (side rims dropped — the bolt-on side gussets stiffen the edges instead)
            // underfloor stiffening ribs so the 4 mm floor can't sag under load:
            for (ry = [8, jvy - 8])                       // front + just ahead of the vent
                translate([3, ry, -floor_rib_h]) cube([usable_width-6, 4, floor_rib_h+eps]);
            translate([usable_width/2-2, 3, -floor_rib_h])// centre spine (front to vent)
                cube([4, jvy-6, floor_rib_h+eps]);
            translate([usable_width-40, jvy-8, -floor_rib_h])  // rib under the Pi 5 zone
                cube([4, shelf_depth-3-(jvy-8), floor_rib_h+eps]);
        }
        ribbed_vent(jetson_vent, jetson_vent, jvx, jvy);   // Jetson bottom intake (supported)
        for (cx = [30 : 40 : usable_width-30])             // rear cable slots
            translate([cx, shelf_depth-3-eps, rear_lip_h-6])
                cube([18, 4+2*eps, 8]);
        // through-holes for the bolt-on side-gusset feet (M3, nut under the tray)
        for (b = concat(bg_bolt_l, bg_bolt_r))
            translate([b[0], b[1], -eps]) cylinder(h = floor_th + 2*eps, d = bg_bolt_d);
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

// One horizontal oval mounting slot (9.33w x 6.77h), cut through the fascia (Y).
module oval_slot() {
    off = (slot_w - slot_h) / 2;   // circle-center offset for a horizontal oval
    hull()
        for (dx = [-off, off])
            translate([dx, -eps, 0]) rotate([-90, 0, 0])
                cylinder(h = bezel_th + 2*eps, d = slot_h);
}

// datum (x, y-DOWN from aperture top-left) -> flange-local (x, z-UP)
function ap_x(xd) = (face_width - aperture_w)/2 + content_dx + xd;  // aperture inset + centring
function ap_z(yd) = (panel_h + aperture_h)/2 - top_brand_band - yd;  // board dropped below the branding band

// through-face features (LED windows + toggle holes/counterbores)
module _face_cuts() {
    for (w = led_windows)
        translate([ap_x(w[0]), -eps, ap_z(w[2]) - led_win_h/2])
            cube([ap_x(w[1]) - ap_x(w[0]), bezel_th + 2*eps, led_win_h]);
    for (xd = concat(toggle_x_data, toggle_x_cmd)) {
        translate([ap_x(xd), -eps, toggle_z_ctr])
            rotate([-90, 0, 0]) cylinder(h = bezel_th + 2*eps, d = toggle_d);
        translate([ap_x(xd), bezel_th - tog_cbore_dep, toggle_z_ctr])
            rotate([-90, 0, 0]) cylinder(h = tog_cbore_dep + eps, d = tog_cbore_d);
    }
}

// the 4 rack-mount oval slots (RackMate pattern) — through the fascia
module _slot_cuts() {
    for (sx = [slot_side_ctr, face_width - slot_side_ctr])
        for (sz = [slot_tb_ctr, panel_h - slot_tb_ctr])
            translate([sx, 0, sz]) oval_slot();
}

// one debossed label on the fascia front (front face = local y=0; cuts into +y)
module _dbt(x, z, s, sz, ha="center", bold=false) {
    if (s != "")
        translate([x, deboss_d, z]) rotate([90, 0, 0])
            linear_extrude(deboss_d + eps)
                text(s, size=sz, halign=ha, valign="baseline",
                     font = bold ? lf_b : lf, $fn=20);
}

// full debossed legend (paint-fill), positioned on the same grid as the holes
module _legend_cuts() {
    for (i = [0:len(node_lbl)-1])                       // node bits (above row 1)
        _dbt(ap_x(toggle_x_data[i]), ap_z(10) + 5, node_lbl[i], 2.5);
    _dbt(160, ap_z(10) - 0.9, "NODES", 2.4, "center", true);   // centre-gap row names
    _dbt(160, ap_z(22) - 0.9, "PAN",   2.4, "center", true);
    _dbt(160, ap_z(34) - 0.9, "TILT",  2.4, "center", true);
    _dbt(202.5, ap_z(22) + 5.6, "- STATUS -", 2.4);            // status block
    for (i = [0:len(status_lbl)-1])
        _dbt(ap_x(toggle_x_cmd[i]), ap_z(22) - 7, status_lbl[i], 2.3);
    _dbt(87.5,  toggle_z_ctr + 8.5, "- MODE / CONFIG (latching) -", 2.3);
    _dbt(202.5, toggle_z_ctr + 8.5, "- COMMAND -", 2.3);
    for (i = [0:len(data_lbl)-1])                       // toggle labels (below)
        _dbt(ap_x(toggle_x_data[i]), toggle_z_ctr - 8.6, data_lbl[i], 2.3);
    for (i = [0:len(cmd_lbl)-1])
        _dbt(ap_x(toggle_x_cmd[i]), toggle_z_ctr - 8.6, cmd_lbl[i], 2.3,
             "center", cmd_lbl[i] == "ARM");
    _dbt(ap_x(205), toggle_z_ctr - 11.8, "soft . hw switch arms", 1.8);
    // branding band (top)
    _dbt(14,  108,   "PAINTBALL SENTRY", 3.6, "left", true);
    _dbt(14,  102.5, "GROUND STATION . autonomous marker turret", 2.3, "left");
    _dbt(240, 106,   "IMSPI 8080", 6.0, "right", true);
    _dbt(240, 99,    "SPX LABS . HMI", 2.6, "right");
    translate([190, -eps, 103.4]) cube([50, deboss_d + eps, 0.6]);   // IMSPI underline
}

// Front rack fascia = the IMSAI-8080 bezel (black). Functional; frame is separate.
module imsai_face() {
    translate([(usable_width-face_width)/2, -bezel_th, 0])
    difference() {
        cube([face_width, bezel_th, panel_h]);
        _face_cuts(); _slot_cuts();
        if (legend_on) _legend_cuts();
    }
}

// Cosmetic blue ⊓ trim that overlays the front fascia (VISUAL ONLY, prints
// separately in blue). Side bands + a top bar wrap the sides + top and stand
// proud; round reliefs at the 4 mount slots keep the screws/driver clear.
module blue_frame() {
    translate([(usable_width-face_width)/2, -bezel_th, 0])
    difference() {
        union() {
            translate([0, -frame_h, 0]) cube([frame_face_w, frame_h, panel_h]);       // left
            translate([face_width-frame_face_w, -frame_h, 0])
                cube([frame_face_w, frame_h, panel_h]);                               // right
            translate([frame_face_w, -frame_h, panel_h-frame_top])
                cube([face_width-2*frame_face_w, frame_h, frame_top]);                // top
        }
        for (sx = [slot_side_ctr, face_width - slot_side_ctr])       // screw reliefs
            for (sz = [slot_tb_ctr, panel_h - slot_tb_ctr])
                translate([sx, -frame_h - eps, sz]) rotate([-90, 0, 0])
                    cylinder(h = frame_h + 2*eps, d = slot_w + frame_relief);
    }
}

// 6 bosses on the BACK of the bezel that stand the panel PCB off the face
// (heat-set M2.5 inserts, or self-tapping). Height must match the LED body length
// so the 3 mm domes sit just behind the windows — see design-spec.md.
module panel_pcb_bosses() {
    fx = (usable_width - face_width) / 2;
    for (h = pcb_holes)
        // H4 (7,48) and H6 (207,48) are carried by the bolt-on side gussets instead
        if (!(h[1] == 48 && (h[0] == 7 || h[0] == 207)))
            translate([fx + ap_x(h[0]), 0, ap_z(h[1])])
                rotate([-90, 0, 0])      // grow into the bay from the bezel back (y=0)
                    standoff(pcb_boss_h, pcb_boss_d, pcb_screw_d);
}

// Triangular brace tying the fascia (y≈0) to the tray floor. Right triangle in the
// Y-Z plane, extruded gusset_t in X; overlaps both so it fuses into one print.
module gusset(x0, h) {
    translate([x0, -1, floor_th - 1])
        rotate([90, 0, 90])
            linear_extrude(gusset_t)
                polygon([[0, 0], [gusset_d, 0], [0, h]]);
}

// BOLT-ON side gusset (SEPARATE part, one per side). Built per-side because the
// board's corner holes are asymmetric (left hole clears the end switch; the right
// one sits behind it and needs a notch). Each = flange plate on the fascia back that
// carries the PCB corner standoff (board screws into it from behind) + a diagonal web
// below the PCB + a flat foot bolted through the tray floor.
//
//   ex   = tray edge x (0 left, usable_width right)
//   sgn  = +1 left / -1 right (body extends inward)
//   bx   = board-corner-hole world x (gusset carries this standoff)
//   bolts= floor-bolt positions
//   notch= [z0, h] switch-clearance notch in the flange, or [] for none
module bolt_gusset_side(ex, sgn, bx, bolts, notch) {
    bz  = ap_z(48);                          // corner-hole height (H4/H6) ≈ z46
    fw  = abs(bx - ex) + 1;                  // flange spans edge → just past the boss
    fx0 = min(ex, ex + sgn*fw);              // flange x-start
    difference() {
        union() {
            // web (diagonal, tall at the fascia, tapering back); shape same both sides
            translate([min(ex, ex + sgn*bg_web_t), -1, floor_th - 1])
                rotate([90, 0, 90]) linear_extrude(bg_web_t)
                    polygon([[0,0], [bg_web_depth,0], [0, bg_web_top - (floor_th-1)]]);
            // flange plate on the fascia back (in front of the board), edge → boss
            translate([fx0, 0, floor_th]) cube([fw, bg_flange_t, (bz + 5) - floor_th]);
            // PCB corner standoff the board screws into from the back
            translate([bx, 0, bz]) rotate([-90, 0, 0])
                standoff(pcb_boss_h, pcb_boss_d, pcb_screw_d);
            // flat foot bolted to the floor
            translate([min(ex, ex + sgn*bg_foot_w), 0, floor_th])
                cube([bg_foot_w, bg_foot_d, bg_foot_t]);
        }
        // end-switch clearance notch (leaves a 5 mm strip at the edge for connectivity)
        if (len(notch) > 0) {
            n0 = min(fx0, ex + sgn*5);
            n1 = max(fx0, ex + sgn*5);
            translate([n0, -1, notch[0]]) cube([n1 - n0, bg_flange_t + 2, notch[1]]);
        }
        // floor bolt clearances
        for (b = bolts)
            translate([b[0], b[1], floor_th - eps]) cylinder(h = bg_foot_t + 2*eps, d = bg_bolt_d);
    }
}
module bolt_gusset() {
    lbx = ap_x(7)   + (usable_width - face_width)/2;   // H4 world x (left,  ≈ 4)
    rbx = ap_x(207) + (usable_width - face_width)/2;   // H6 world x (right, ≈ 204)
    bolt_gusset_side(0,            +1, lbx, bg_bolt_l, []);          // left: hole clears the switch
    bolt_gusset_side(usable_width, -1, rbx, bg_bolt_r, [16, 16]);    // right: notch past the switch
}

// CENTRE gusset (under the PCB, in the block gap) with a cable pass-through so the
// switch→74HC165 wiring can cross it. Internal window keeps it one connected piece.
module centre_gusset(x0) {
    difference() {
        gusset(x0, gusset_h_ctr);
        translate([x0 - 1, 2, floor_th + 6])
            cube([gusset_t + 2, cable_slot_w, cable_slot_h]);
    }
}

module rack_shelf() {          // functional print (black PETG/ASA)
    tray();
    jetson_pocket();
    pi5_mounts();
    pico_mounts();        // OPTIONAL: panel RP2040 is on the IMSAI PCB; motion Pico
                          // lives on the turret. Keep only for a spare/bench Pico.
    imsai_face();
    panel_pcb_bosses();
    // integral centre gusset in the true block gap (datum 140); side gussets bolt on
    centre_gusset(ap_x(140) + (usable_width - face_width)/2 - gusset_t/2);
}

// PART selector — each printable part on its own:
//   "shelf" (tray+fascia, black)  "frame" (blue trim)  "gusset" (2 side gussets)  "all"
if (PART == "frame")       blue_frame();
else if (PART == "gusset") bolt_gusset();
else if (PART == "all") {
    if (PREVIEW) { color("Gainsboro") rack_shelf(); color("DodgerBlue") blue_frame();
                   color("Tomato") bolt_gusset(); }
    else         { rack_shelf(); blue_frame(); bolt_gusset(); }
}
else                       rack_shelf();     // "shelf" (default)
