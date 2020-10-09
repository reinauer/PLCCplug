// PLCC plug model
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
//    =============== h1
//     |           |
//     |___________|  h2
//


// distance between 2 pins
cl = 1.27;
// height of the bottom plate / plug
h1 = 4.45;
// height of the top plate
h2 = 1.47;
// pinwidth=0.3;
pinwidth=0.4;

/* test build all * /
translate([0,0,0]) plug(20);
translate([50,0,0]) plug(28);
translate([100,0,0]) plug(32);
translate([0,50,0]) plug(44);
translate([50,50,0]) plug(52);
translate([100,50,0]) plug(68);
translate([150,50,0]) plug(84);
// */

plug(32);


// no user servicable parts inside

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

// small prism to mark one side of the PLCC
module corner(l, w, h)
{
    polyhedron(
               points=[[0,0,0], [l,0,0], [0,w,0], 
                       [0,0,h], [l,0,h], [0,w,h]],
               faces=[[0,1,2],[5,4,3],[1,4,5,2],[0,3,4,1],[0,2,5,3]]
              );
}

module pin()
{
    cube([pinwidth,pinwidth,h1+h2]);
}

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
    color("grey") {
        // bottom plate
        translate([dx,dy,h2])
            cube([a,b,h1]);
        // top plate
        cube ([c,d,h2]);
    }

    {
        // cutout    
        color("red") {
            // cut a sqare hole in bottom plate
            translate([dx*1.5, dy*1.5, h2])
                cube([a - dx, b - dy, h1]);
            // cut a cylinder in top plate
            translate([c / 2, d / 2, 0])
                cylinder (h = h2, r=2, $fn=100);  
      
            // cut big edge off top plate
            corner (l=3, w=3, h=h2);
            // cut little edge off bottom plate
            translate([dx,dy,h2])
                corner (l=1.5, w=1.5, h=h1);
      
        }

        /* pin holes */
        for( col  = [0: py-1 ] ) {
            translate( [dx, 2 /* FIXME */ +dy+ (cl * col), 0] ) {
                color("purple") pin();
            }
        }
  
        for( col  = [0: py-1 ] ) {
            translate( [c-dx - 0.22 /* why .22 not .3? */, 2 /* FIXME */ +dy+ (cl * col), 0] ) {
                color("green") pin();
            }
        }
  
        for( row  = [0: px-1 ] ) {
            translate( [2+dx + (cl * row), dy, 0] ) {
                color("blue") pin();
            }
        }
  
        for( row  = [0: px-1 ] ) {
            translate( [2+dx + (cl * row), d - dy - 0.38 /* here .3 is not enough ? */, 0] ) {
                color ("yellow") pin();
            }
        }
    }
}
}
