/// \file
/// Separate components for the turtle robot (not printed).

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

include <parameters.scad>

/// Electronics board anchored at the bottom + back.
module board() {
    color("green")
    difference() {
        offset_sweep(rect([width_board, length_board], rounding=rounding_board), h=1.6, anchor=BOTTOM+BACK);

        for (position = positions_board_mounts) {
            move(position)
            cyl(d=3.2, h=10);
        }
    }

    // buzzer sticking out below the board
    fwd(39.764)
    color("black")
    cyl(d=12, h=6, anchor=TOP);
}

/// Holder for 2x AA batteries anchored at the top.
module battery_holder() {
    width = width_battery_holder;
    height = 16;
    length = 58;
    down(height / 2)
    difference() {
        offset_sweep(rect([height, width], rounding=2.5), h=length, ends=os_chamfer(chamfer), anchor=CENTER, orient=RIGHT);
        cuboid([length - 4, 100, 100], anchor=TOP);
    }
}

module pen_stabilo(length=130, slop=0) {
    // Fit a Stabilo 88/32 pen.
    // hexagonal main body
    offset_sweep(hexagon(ir=radius_pen + tolerance_pen + slop), h=length, ends=os_chamfer(-chamfer), extra=$overlap);
    // round end caps
    cyl(r=radius_pen + tolerance_pen * 3 + slop, h=length, chamfer=-chamfer, extra=$overlap, anchor=BOTTOM);
}

pen_stabilo(10, slop=0.2);
