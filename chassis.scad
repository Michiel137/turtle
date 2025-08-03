include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <BOSL2/rounding.scad>

$fa = $preview ? 12 : 3;
$fs = $preview ? 2 : 0.2;
$overlap = 0.01;

function inch(value) = value * 25.4;

diameter_pen = 10.75;
radius_pen = diameter_pen / 2;
height_pen = 26.5;

layer = 0.2;

rounding_board = inch(0.14);
width_board = inch(2);
length_board = inch(2);
right_board_mount = width_board / 2 - rounding_board;
left_board_mount = -right_board_mount;
width_board_mounts = right_board_mount - left_board_mount;
back_board_mount = length_board / 2 - rounding_board;
front_board_mount = back_board_mount - inch(1.4);
length_board_mounts = back_board_mount - front_board_mount;
position_board_mounts = [
    [right_board_mount, back_board_mount],
    [right_board_mount, front_board_mount],
    [left_board_mount, front_board_mount],
];

diameter_motor = 28;
radius_motor = diameter_motor / 2;
spacing_mounts = 35;
// mounting height of the motor
height_motor = 13.1;

chamfer = 0.4;

module board() {
    difference() {
        offset_sweep(rect([width_board, length_board], rounding=rounding_board), h=1.6, anchor=BOTTOM);

        for (position = position_board_mounts) {
            move(position)
            cyl(d=3.2, h=10);
        }
    }
}

// /// Holder for 4x AAA batteries with on/off switch.
// width_battery = 48.5;
// module batteries() {
//     width = width_battery;
//     height = 16;
//     length = 63;
//     down(height / 2)
//     offset_sweep(rect([height, width], rounding=2.5), h=length, ends=os_chamfer(chamfer), anchor=FRONT, orient=RIGHT);
// }

/// Holder for 2x AA batteries.
width_battery = 33;
spacing_battery = 30 + 15;
module batteries() {
    width = width_battery;
    height = 16;
    length = 58;
    down(height / 2)
    difference() {
        offset_sweep(rect([height, width], rounding=2.5), h=length, ends=os_chamfer(chamfer), anchor=CENTER, orient=RIGHT);
        cuboid([length - 4, 100, 100], anchor=TOP);
    }
}

// bottom
width_chassis = 63;
rounding_chassis = rounding_board + width_chassis / 2 - width_board / 2;
front_chassis = -radius_motor - rounding_board - length_board_mounts - rounding_chassis;
back_chassis = spacing_battery / 2 + width_battery / 2 + 9;
length_chassis = back_chassis - front_chassis;
thickness_chassis = 2.4;
thickness_nut = 2.4;

width_spine = 12 + 3;
offset_board = -length_board / 2 - radius_motor;

module motor_mount() {
    s = 35 / 2;
    r = 5.5;
    h = height_motor + r;
    w = s + r;

    path1 = turtle([
        "left",
        "untily", h,
        "right",
        "untilx", w,
        "right",
        "untily", -thickness_chassis + $overlap,
        "right",
        "untilx", 0,
        "right",
        "untily", 0,
    ], state=[6, 0]);
    path2 = round_corners(path1, radius=[6, r, r, 0, 0, 0]);
    path3 = union([path2, xflip(path2)])[0];

    xflip_copy()
    right(width_chassis / 2)
    zrot(-90)
    xrot(+90)
    difference() {
        offset_sweep(path3, h=3, ends=os_chamfer(chamfer));

        move([0, height_motor, 0])
        xcopies(s * 2)
        cyl(d=3.2, h=3, chamfer=-chamfer, extra=$overlap, anchor=BOTTOM);
    }
}

module chassis() {
    difference() {
        union() {
            back(front_chassis)
            offset_sweep(rect([width_chassis, length_chassis], rounding=rounding_chassis), h=thickness_chassis, ends=os_chamfer(chamfer), anchor=TOP+FRONT);

            // spine
            down(chamfer)
            difference() {
                back(front_chassis)
                cuboid([12 + 3, length_chassis, 1.8 + chamfer], rounding=1.8, edges=[TOP+FRONT, TOP+BACK], anchor=BOTTOM+FRONT);
                yflip_copy()
                back(10)
                cuboid([12 - 3, 100, 10], anchor=FRONT);
            }

            motor_mount();

            // pen holder
            cyl(d=15, h=height_pen, chamfer2=chamfer, anchor=BOTTOM);
            move([-12 / 2, 20 + 3 / 2, 0])
            zrot(-90)
            xrot(+90)
            down(2 / 2)
            offset_sweep([[0, 0], [0, 32], [32, 0]], h=2, ends=os_chamfer(chamfer));

            // servo mount
            width_servo = 23;
            hight_servo = 36;
            center_mount = (width_servo - 12 - 3) / 2;
            back(20)
            top_half(z=-chamfer)
            xrot(90)
            difference() {
                union() {
                    right(center_mount)
                    offset_sweep(rect([23, 36 * 2], rounding=2), h=3, ends=os_chamfer(chamfer), anchor=TOP);
                    cuboid([width_chassis - chamfer * 2, 7.6 * 2, 3], chamfer=chamfer, edges=BACK, anchor=TOP);
                }

                move([center_mount, 6.6 + 24 / 2, $overlap])
                union() {
                    // body
                    cuboid([13, 24, 3 + $overlap * 2], chamfer=-chamfer - $overlap, anchor=TOP);
                    // screws
                    ycopies(27.5)
                    cyl(d=1.5, h=10);
                }
            }

            // board mounting holes
            back(offset_board)
            for (position = position_board_mounts) {
                move(position)
                cyl(r=3.6, h=3.2, extra1=chamfer, anchor=BOTTOM);
            }

            // board mounting holes
            ycopies(15 + 30)
            ycopies(15)
            cyl(r=4.0, h=1.4, extra1=chamfer, anchor=BOTTOM);

            // mounting holes caster
            back(back_chassis - 4.0)
            xcopies(30)
            cyl(r=4.0, h=1.4, extra1=chamfer, anchor=BOTTOM);
        }

        // pen
        down(thickness_chassis)
        cyl(d=diameter_pen, h=height_pen + thickness_chassis, chamfer=-chamfer, extra=$overlap, anchor=BOTTOM);

        // clearance for the motor
        xflip_copy() {
            move([width_chassis / 2 - 7, 0, $overlap])
            cuboid([12, 20, thickness_chassis + $overlap * 2], chamfer=-chamfer, anchor=TOP+RIGHT);

            move([width_spine / 2, 0, height_motor])
            cyl(d=28, h=width_chassis / 2 - width_spine / 2 - 3 + chamfer, anchor=BOTTOM, orient=RIGHT);
        }

        // mounting holes board
        back(offset_board)
        for (position = position_board_mounts) {
            move(position)
            // self-tapping screw
            cyl(d=2.0, h=10);
            // // M3 heat-set insert
            // cyl(d=4.7, h=10);
        }

        // mounting holes battery holders
        ycopies(15 + 30)
        ycopies(15)
        union() {
            cyl(d=3.2, h=10);
            down(thickness_nut - 1.4)
            regular_prism(n=6, d=6.5, h=10, anchor=BOTTOM);
        }

        // mounting holes caster
        back(back_chassis - 4.0)
        xcopies(30)
        union() {
            cyl(d=3.2, h=10);
            down(thickness_nut - 1.4)
            regular_prism(n=6, d=6.5, h=10, anchor=BOTTOM);
        }

        // mounting holes for aligner
        up(1.8 + layer)
        for(position = [[-12.5 / 2, +8 / 2], [+12.5 / 2, -8 / 2]]) {
            move(position)
            // self-tapping screw
            cyl(d=2, h=10, anchor=TOP);
        }
    }
}

color("green")
move([0, offset_board, 3.2])
board();

color("grey")
ycopies(spacing_battery)
down(3)
batteries();

chassis();
