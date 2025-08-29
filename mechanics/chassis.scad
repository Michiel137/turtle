include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <BOSL2/rounding.scad>

include <parameters.scad>

use <components.scad>

diameter_pen = 10.75;
radius_pen = diameter_pen / 2;
height_pen_holder = 26.5;

spacing_battery_holders = 30 + 15;
width_chassis = 60;
radius_board_posts = 2.2;
rounding_chassis = 2.4;
front_chassis = -radius_motor - rounding_board - length_board_mounts - radius_board_posts;
back_chassis = spacing_battery_holders / 2 + width_battery_holder / 2 + 9;
length_chassis = back_chassis - front_chassis;

spacing_spines = 12;
width_spines = 3;
offset_board = -radius_motor;

module motor_mount() {
    s = spacing_motor_mounts / 2;
    r = 5.5;
    h = height_motor + r;
    w = s + r;

    path1 = turtle([
        "left",
        "untily", h,
        "right",
        "untilx", w,
        "right",
        "untily", -thickness_chassis,
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
            length_cutout = 13;
            width_cutout = 20;
            path1 = [[0, length_cutout], [width_cutout / 2, length_cutout], [width_cutout / 2, 0], [width_chassis / 2, 0], [width_chassis / 2, length_chassis], [0, length_chassis]];
            path2 = round_corners(path1, radius=[0, 1, 1, 1, 1, 0] * rounding_chassis);
            path3 = union([path2, xflip(path2)])[0];
            back(front_chassis)
            offset_sweep(path3, h=thickness_chassis, ends=os_chamfer(chamfer), anchor=TOP+FRONT);

            // spine
            down(chamfer)
            difference() {
                back(back_chassis)
                cuboid([spacing_spines + width_spines, length_chassis - length_cutout, 1.8 + chamfer], rounding=1.8, edges=[TOP+FRONT, TOP+BACK], anchor=BOTTOM+BACK);
                yflip_copy()
                back(10)
                cuboid([spacing_spines - width_spines, 100, 10], anchor=FRONT);
            }

            motor_mount();

            // pen holder
            cyl(d=spacing_spines + width_spines, h=height_pen_holder, chamfer2=chamfer, anchor=BOTTOM);

            // servo mount
            width_servo = 23;
            hight_servo = 36;
            center_servo_mount = (width_servo - 12 - 3) / 2;
            position_servo_mount = [center_servo_mount, 20];
            thickness_servo_mount = 3;
            back(position_servo_mount[1])
            xrot(90)
            back_half(y=-chamfer)
            difference() {
                union() {
                    right(position_servo_mount[0])
                    offset_sweep(rect([23, 36 * 2], rounding=2), h=thickness_servo_mount, ends=os_chamfer(chamfer), anchor=TOP);
                    cuboid([width_chassis - chamfer * 2, 7.6 * 2, thickness_servo_mount], chamfer=chamfer, edges=BACK, anchor=TOP);
                }

                move([position_servo_mount[0], 6.6 + 24 / 2, $overlap])
                union() {
                    // body
                    cuboid([13, 24, thickness_servo_mount + $overlap * 2], chamfer=-chamfer - $overlap, anchor=TOP);
                    // screws
                    ycopies(27.5)
                    cyl(d=1.5, h=10);
                }
            }

            // servo mount bracing
            thickness_servo_brace = 2;
            move([-spacing_spines / 2, position_servo_mount[1] + thickness_servo_mount / 2])
            zrot(-90)
            xrot(+90)
            down(thickness_servo_brace / 2)
            offset_sweep([[0, 0], [0, 32], [32, 0]], h=thickness_servo_brace, ends=os_chamfer(chamfer));

            // board mounting holes
            back(offset_board)
            for (position = positions_board_mounts) {
                move(position)
                cyl(r=radius_board_posts, h=3.2, extra1=chamfer, anchor=BOTTOM);
            }

            // battery holder mounting holes
            ycopies(spacing_battery_holders)
            ycopies(15)
            cyl(r=4.0, h=1.4, extra1=chamfer, anchor=BOTTOM);

            // mounting holes caster
            back(back_chassis - 4.0)
            xcopies(30)
            cyl(r=4.0, h=1.4, extra1=chamfer, anchor=BOTTOM);
        }

        // pen
        down(thickness_chassis)
        pen_stabilo(thickness_chassis + height_pen_holder, slop=0.1);

        // clearance for the motor
        xflip_copy() {
            move([width_chassis / 2 - 7, 0, $overlap])
            cuboid([12, 20, thickness_chassis + $overlap * 2], chamfer=-chamfer, anchor=TOP+RIGHT);

            move([spacing_spines / 2 + width_spines / 2, 0, height_motor])
            cyl(d=28, h=width_chassis / 2 - spacing_spines / 2 - width_spines / 2 - 3 + chamfer, anchor=BOTTOM, orient=RIGHT);
        }

        // mounting holes board
        back(offset_board)
        for (position = positions_board_mounts) {
            move(position)
            // M2 screw threaded into plastic
            cyl(d=1.8, h=10);
        }

        // mounting holes battery holders
        ycopies(spacing_battery_holders)
        ycopies(15)
        union() {
            cyl(d=3.2, h=10);
            down(thickness_nut - 1.4)
            regular_prism(n=6, d=6.4, h=10, anchor=BOTTOM);
        }

        // mounting holes caster
        back(back_chassis - 4.0)
        xcopies(30)
        union() {
            cyl(d=3.2, h=10);
            down(thickness_nut - 1.4)
            regular_prism(n=6, d=6.4, h=10, anchor=BOTTOM);
        }

        // mounting holes pen aligner
        up(1.8 - 3 * layer)
        for(position = positions_aligner_mounts) {
            move(position)
            // M2 screw threaded into plastic
            cyl(d=1.8, h=10, anchor=TOP);
        }
    }
}

move([0, offset_board, 3.2])
board();

color("grey")
ycopies(spacing_battery_holders)
down(3)
battery_holder();

chassis();
