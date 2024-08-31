// PLCC plug model
// (C) 2020 Stefan Reinauer
// SPDX-License-Identifier: BSD-2-Clause
//
// OpenSCAD
//
//     /------------+
//    /       A     |
//    |  /--------+ |
//    |  |        | |
//    |  |B       | | D
//    |  |        | |
//    |  +--------+ |
//    |             |
//    +-------------+
//            C
//
//    =============== h2
//     |           |
//     |___________|  h1
//


// distance between 2 pins
cl = 1.27;
// height of the bottom plate / plug
h1 = 4.3; // 4.45;
// height of the top plate
h2 = 1.2; // 1.47;

// 1.27mm pitch pins are 0.4mm, 2.54mm pitch pins are 0.64mm
//pinwidth=0.64;
pinwidth=0.4;

// edge - dimensions of the cutout triangle
edge_top = 3;
edge_bottom = 1.5;

// FDM printers with a very small nozzle size (0.2mm) might work
// So far resin and nylon prints have shown promising success. If
// you don't have a resin printer, you probably want to set this to 1:
clumsy_printer = 0;

/* test build all */

if (is_undef(output_pins)) {
  translate([0,0,0]) plug(20);
  translate([50,0,0]) plug(28);
  translate([100,0,0]) plug(32);
  translate([0,50,0]) plug(44);
  translate([50,50,0]) plug(52);
  translate([100,50,0]) plug(68);
  translate([150,50,0]) plug(84);
} else {
  translate([0,0,0]) plug(output_pins);
}

// No user servicable parts inside
// Set the dimensions for the plug to be rendered and call render function
module plug(pins)
{
    echo (str("Rendering a ", pins, " pin PLCC plug"));
    if (pins == 20) { a =  8.70; c = 12.10; d = 12.10; b =  8.70; px =  5; py =  5; plccplug(a,b,c,d,px,py); } else
    if (pins == 28) { a = 11.15; c = 14.55; d = 14.55; b = 11.15; px =  7; py =  7; plccplug(a,b,c,d,px,py); } else
    if (pins == 32) { a = 13.60; c = 17.00; d = 14.55; b = 11.15; px =  9; py =  7; plccplug(a,b,c,d,px,py); } else

    if (pins == 44) { a = 16.40; c = 19.80; d = 19.80; b = 16.40; px = 11; py = 11; plccplug(a,b,c,d,px,py); } else
    if (pins == 52) { a = 18.90; c = 22.30; d = 22.30; b = 18.90; px = 13; py = 13; plccplug(a,b,c,d,px,py); } else
    if (pins == 68) { a = 23.90; c = 27.30; d = 27.30; b = 23.90; px = 17; py = 17; plccplug(a,b,c,d,px,py); } else
    if (pins == 84) { a = 29.40; c = 32.80; d = 32.80; b = 29.40; px = 21; py = 21; plccplug(a,b,c,d,px,py); }
}

// small prism to mark one side of the PLCC (cutout triangle)
//  l: length
//  w: width
//  h: height (top plate or bottom plate)
module corner(l, w, h)
{
    polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0],
                       [0,0,h], [l,0,h], [l,w,h]],
               faces=[[0,1,2],[5,4,3],[1,4,5,2],[0,3,4,1],[0,2,5,3]]
              );
}

module pin()
{
    // This was just a straight pin, like this:
    //   cube([pinwidth,pinwidth,h1+h2]);
    // But then a Prusa i3 MK3s can't make holes that small
    // on the top plate. So split the pin hole up in a tighter
    // section on the plug to keep the pin header in place, and
    // a wider one to allow printing this with your typical 3d
    // printer

    if (clumsy_printer) {
        echo ("Workaround for FDM printers");
        translate([-0.1,-0.1,-0.1])
          cube([pinwidth + 0.2,pinwidth + 0.2,h2]);

        translate([0,0,h2])
          cube([pinwidth,pinwidth,h1]);
    } else {
        cube([pinwidth,pinwidth,h1+h2]);
    }
}

// Render a PLCC plug
//  A,B,C,D: dimensions of top plate and bottom plate
//  px: pins in x dimension
//  py: pins in y dimension
module plccplug(a,b,c,d,px,py)
{
    // all pins. p == pins
    p  = 2*py + 2*px;
    // space to the left and right of the socket part,
    // assuming the plug sits right in the middle of
    // the construct.
    dy=(c-a) / 2;
    dx=(d-b) / 2;
    // Thickness of the bottom plate walls in mm
    thickness=1.7;
    // width of the airgaps in mm (0 to disable)
    airgaps = (a < 15.0) ? 0 : 1;

    difference()
    {
        color("lavender") {
            // bottom plate (plug)
            translate([dx,dy,h2]) {
                difference() {
                    cube([a,b,h1]);
                    // Cut off one corner
                    translate([a-edge_bottom,0,0])
                        corner (l=edge_bottom, w=edge_bottom, h=h1);
                    // cut a sqare hole in bottom plate
                    translate ([thickness, thickness, 0])
                        cube ([a - 2*thickness, b - 2*thickness, h1]);
                    // little notches on the hillside
                    translate([0.8,b*0.4,h1-0.2])
                        color("red") cube([a-1.6,b*0.2,0.2]);
                    translate([a*0.4,0.8,h1-0.2])
                        color("red") cube([a*0.2,b-1.6,0.2]);
                }
            }

            // top plate (lid)
            translate([0,0,0]) {
                difference() {
                    cube ([c,d,h2]);
                    translate([c-edge_top,0,0])
                        corner (l=edge_top, w=edge_top, h=h2);
                    // cut a cylinder in top plate
                    translate([c / 2, d / 2, 0])
                        cylinder (h = h2, r=2, $fn=100);
                    // fancy airgaps
                    if (airgaps) {
                        // 2/4
                        translate([c*0.25,thickness+dy,0])
                            color("red") cube([c/2,airgaps,h2]);
                        // 4/4
                        translate([c*0.25,d-(thickness+dy+airgaps),0])
                            color("red") cube([c/2,airgaps,h2]);
                        // 3/4
                        translate([dx + thickness,d*0.25,0])
                            color("red") cube([airgaps,d/2,h2]);
                        // 1/4 (Pin 1-)
                        translate([dx + a - thickness - airgaps,d*0.25,0])
                            color("red") cube([airgaps,d/2,h2]);
                    }
                }
            }
        }

        translate([dx,dy,0])  {
            /* pin holes */
            y_shift = pinwidth + (a - (px * cl)) / 2;
            // recess pins slightly
            recess = pinwidth/2;

            color("purple") for( col  = [0: py-1 ] ) {
                translate( [-recess, y_shift + (cl * col), 0] ) {
                    pin();
                }
            }

            color("green") for( col  = [0: py-1 ] ) {
                translate( [a-pinwidth+recess, y_shift + (cl * col), 0] ) {
                    pin();
                }
            }

            x_shift = pinwidth + (b - (py * cl)) / 2;
            color("blue") for( row  = [0: px-1 ] ) {
                translate( [x_shift + (cl * row), -recess, 0] ) {
                    pin();
                }
            }

            color ("yellow") for( row  = [0: px-1 ] ) {
                translate( [x_shift + (cl * row), b-pinwidth+recess, 0]) {
                    pin();
                }
            }
        }
    }
}
