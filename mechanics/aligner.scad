/// \file
/// Screw-on piece to accurately align the pen at the bottom.

use <components.scad>

include <BOSL2/std.scad>
include <BOSL2/screws.scad>

include <parameters.scad>

height = 10;

module aligner_stabilo() {
    // the aligner is mounted up side down
    xflip()
    difference () {
        union() {
            offset_sweep(rect([18, 12], rounding=2.4), h=3, ends=os_chamfer(chamfer));

            difference() {
                cyl(d=12, h=height, chamfer=chamfer, anchor=BOTTOM);

                for (position = positions_aligner_mounts) {
                    move(position)
                    cyl(d=4, h=height, chamfer=-chamfer, extra=$overlap, anchor=BOTTOM);
                }
            }
        }

        pen_stabilo(height);

        for (position = positions_aligner_mounts) {
            move(position)
            // M2 screw
            cyl(d=2.2, l=10);
        }
    }
}

aligner_stabilo();
