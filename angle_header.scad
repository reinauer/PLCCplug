//Customizable angle header
// by karfes - https://www.thingiverse.com/karfes/designs
// licensed under the Creative Commons - Attribution license.

translate([32.6,16.3,-2.35]) rotate([0,270,0])
  angle_header(rows=21,cols=1,pitch=1.27);
translate([16.3,32.6,-2.35]) rotate([90,270,0])
  angle_header(rows=21,cols=1,pitch=1.27);
translate([0,16.3,-2.35]) rotate([180,270,0])
  angle_header(rows=21,cols=1,pitch=1.27);
translate([16.3,0,-2.35]) rotate([270,270,0])
  angle_header(rows=21,cols=1,pitch=1.27);

module angle_header(rows,cols,pitch){
    offsety=((cols+1)*pitch)-((cols+1)*pitch)/2;
    offsetx=-1*((rows-1)/2*pitch);
    rotate([0,90,0])
    translate([0,offsetx,offsety])
    union(){
        for(j=[0:1:cols-1]){
            translate([-1*pitch*j,0,0])
            for(i=[0:1:rows-1]){
                translate([0,pitch*i,0])angle_pin(pitch,j);
            }
        }
    }
}
module angle_pin(pitch=2.54,col=0){
    rotate([90,0,0])corner(r=pitch, s=pitch, p=pitch,column=col);
    translate([-pitch,0,0])h_pin(p=pitch);
}
module corner(r=1,s=1,p=2.54,column=0){
    s=p/4+0.005;
    w=(r<1)?1:r*2;
    h=p*4-0.5;
    d=s/2;

    if(column==0){
        color("gold"){
        translate([0,-1*(p+d),d])rotate([0,90,0])cube([s,s,p],center=false);
        translate([p,-p,0])rotate([0,-90,0])mirror([0,0,d])
        rotate([0,0,45])cylinder($fn=4,r1=sqrt(2*pow(d,2)),r2=0,h=d,center=false);
        rotate_extrude($fn=100,angle=90)translate([-r,0,0])square(s,center=true);
        }
        translate([0,-1*(p+d),d])rotate([0,90,0])cube([s,s,p],center=false);
        translate([p,-p,0])
        rotate([0,-90,0])
        mirror([0,0,d])
        rotate([0,0,45])cylinder($fn=4,r1=sqrt(2*pow(d,2)),r2=0,h=d,center=false);
    }else{
        color("gold"){
        translate([-1*(p+d),0,-d])rotate([90,0,0])cube([s,s,p*column],center=false);
        translate([0,-column*p,0])
        rotate_extrude($fn=100,angle=90)translate([-r,0,0])square(s,center=true);
        }
        translate([0,-1*(column+1)*p-d,d])rotate([0,90,0])
        cube([s,s,(column+1)*p],center=false);
        translate([(column+1)*p,-1*(column+1)*p,0])
        rotate([0,-90,0])mirror([0,0,d])rotate([0,0,45])
        cylinder($fn=4,r1=sqrt(2*pow(d,2)),r2=0,h=d,center=false);
    }
}
module h_pin(p=2.54){
    s=p/4+0.005;
    h=p*4-0.5 +1.9;
    base=0.3;//h/3;
    //h=p*4-0.5;
    //base=h/3;
    d=s/2;
    union(){
        color("gold")union(){
            translate([0,0,h])rotate([0,0,45])
            cylinder($fn=4,r1=sqrt(2*pow(d,2)),r2=0,h=d,center=false);
            translate([-d,-d,0])cube([s,s,h],center=false);
        }
       color("Dimgray")difference(){
            translate([0,0,base+d])cube([p,p,p],center=true);
            union(){
            translate([1.9*s,1.9*s,base+d])rotate([0,0,45])
                cylinder($fn=3,r=2*d,h=p+1,center=true);
            translate([1.9*s,-1.9*s,base+d-0.15])rotate([0,0,-45])
                cylinder($fn=3,r=2*d,h=p+1,center=true);
            translate([-1.9*s,-1.9*s,base+d-0.3])rotate([0,0,180+45])
                cylinder($fn=3,r=2*d,h=p+1,center=true);
            translate([-1.9*s,1.9*s,base+d-0.3])rotate([0,0,180-45])
                cylinder($fn=3,r=2*d,h=p+1,center=true);
        }
    }
    }
}
