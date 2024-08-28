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
h1 = 4.3;
// height of the top plate
h2 = 1.2;
// pinwidth=0.3;
pinwidth=0.4;

// edge
edge_top = 3;
edge_bottom = 1.5;


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
    if (pins == 20) { a =  8.70; c = 15.00; d = 15.00; b =  8.70; px =  5; py =  5; plccplug(a,b,c,d,px,py); } else
    if (pins == 28) { a = 11.15; c = 17.40; d = 17.40; b = 11.15; px =  7; py =  7; plccplug(a,b,c,d,px,py); } else
    if (pins == 32) { a = 13.60; c = 19.90; d = 17.40; b = 11.02; px =  9; py =  7; plccplug(a,b,c,d,px,py); } else

    if (pins == 44) { a = 16.40; c = 22.50; d = 22.50; b = 16.40; px = 11; py = 11; plccplug(a,b,c,d,px,py); } else
    if (pins == 52) { a = 18.90; c = 25.10; d = 25.10; b = 18.90; px = 13; py = 13; plccplug(a,b,c,d,px,py); } else
    if (pins == 68) { a = 23.90; c = 30.10; d = 30.10; b = 23.90; px = 17; py = 17; plccplug(a,b,c,d,px,py); } else
    if (pins == 84) { a = 28.90; c = 35.20; d = 35.20; b = 28.90; px = 21; py = 21; plccplug(a,b,c,d,px,py); }
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
    translate([-0.1,-0.1,-0.1])
    cube([pinwidth + 0.2,pinwidth + 0.2,h2 + 0.1]);

    translate([0,0,h2])
    cube([pinwidth,pinwidth,h1+0.1]);
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

    difference()
    {
        color("lavender") {
            // bottom plate (plug)
            translate([dx,dy,h2]) {
                difference() {
                    cube([a,b,h1]);
                    translate([a-edge_bottom,0,0])
                        corner (l=edge_bottom, w=edge_bottom, h=h1);
                    // cut a sqare hole in bottom plate
                    translate([dx*.5, dy*.5, 0])
                        cube([a - dx, b - dy, h1]);
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
                }
            }
        }

        translate([dx,dy,0])  {
            /* pin holes */
            y_shift = pinwidth + (a - (px * cl)) / 2;
            color("purple") for( col  = [0: py-1 ] ) {
                translate( [0, y_shift + (cl * col), 0] ) {
                    pin();
                }
            }

            color("green") for( col  = [0: py-1 ] ) {
                translate( [a-pinwidth, y_shift + (cl * col), 0] ) {
                    pin();
                }
            }

            x_shift = pinwidth + (b - (py * cl)) / 2;
            color("blue") for( row  = [0: px-1 ] ) {
                translate( [x_shift + (cl * row), 0, 0] ) {
                    pin();
                }
            }

            color ("yellow") for( row  = [0: px-1 ] ) {
                translate( [x_shift + (cl * row), b-pinwidth, 0]) {
                    pin();
                }
            }
        }
    }
}
