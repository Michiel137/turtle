/// Default chamfer.
chamfer = 0.4;

/// Layer height used for printing.
layer = 0.2;

thickness_chassis = 2.4;
thickness_nut = 2.4;


//
// Wheel
//

/// Diameter of wheel (rim + tire).
// diameter_wheel = 56;  // OSTR V3
diameter_wheel = 50.5;  // OSTR V2
radius_wheel = diameter_wheel / 2;

/// Size of o-ring used as tire.
diameter_tire = 3;
radius_tire = diameter_tire / 2;


//
// Motor
//

diameter_motor = 28;
radius_motor = diameter_motor / 2;
spacing_motor_mounts = 35;
/// Mounting height of the motor from the top of the chassis plate.
height_motor = 13.1;
/// The axle is offset from the mounting holes of the motor.
height_axle = height_motor - 8;


//
// Pen (Stabilo 88/32)
//

diameter_pen = 7.75;
radius_pen = diameter_pen / 2;
tolerance_pen = 0.05;

/// The positions of the pen aligner mounting holes.
positions_aligner_mounts = [[-12.5 / 2, +8 / 2], [+12.5 / 2, -8 / 2]];


//
// Electronics
//

/// The radius of the board corners.
/// \note The back mounting hole is at the center of the rounding radius.
rounding_board = 4;
/// The width of the board (side-to-side).
width_board = 52;
/// The length of the board (back-to-front).
length_board = 48;
/// The side-to-side distance of the board mounts.
width_board_mounts = width_board - 2 * rounding_board;
/// The back-to-front distance of the board mounts.
/// \note The board mounts are at the back corner, but not at the front corner.
length_board_mounts = 33;
/// positions of the board mounts with the board anchored at the back
positions_board_mounts = [
    [+width_board_mounts / 2, -rounding_board],
    [+width_board_mounts / 2, -rounding_board - length_board_mounts],
    [-width_board_mounts / 2, -rounding_board - length_board_mounts],
];

width_battery_holder = 33;


//
// quality
//

$fa = $preview ? 12 : 3;
$fs = $preview ? 2 : 0.2;
$overlap = 0.01;
