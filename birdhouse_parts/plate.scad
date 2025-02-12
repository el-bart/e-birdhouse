use <m3d/all.scad>
use <plate_holder.scad>
include <detail/plate_config.scad>
include <m3d/all.scad>

plate_size = [base.x, base.y, 3];
camera_d = 10.1 + 0.5;
LED_d = 5 + 0.4;
LED_off_from_edge = 15;


module move_from_center()
{
  translate(0.5*[base.x, base.y , 0])
    children();
}


module plate()
{
  module camera_slot()
  {
    camera_pos = [plate_size.x/2, plate_size.y/2, 0];
    h = 5;
    difference()
    {
      union()
      {
        children();
        translate(camera_pos)
          cylinder(d=camera_d + 2*5, h=h);
      }
      translate(camera_pos - [0,0,eps])
        cylinder(d=camera_d, h=h+2*eps);
    }
    // rear support block
    translate(camera_pos)
      translate([-27/2, camera_d/2, 0] + [0, 19+1, 0])
        cube([27, 4, 11.25]);
  }

  module LED_holes()
  {
    off = LED_off_from_edge;
    difference()
    {
      children();
      for(dx=[off, plate_size.x-off])
        for(dy=[off, plate_size.y-off])
          translate([dx, dy, -eps])
            cylinder(d=LED_d, h=plate_size.z+2*eps, $fn=fn(30));
    }
  }

  module screw_holes()
  {
    difference()
    {
      children();
      move_from_center()
        holes_pos()
          translate([0,0,-eps])
            cylinder(d=screw_d + 0.5, h=plate_size.z+2*eps, $fn=fn(30));
    }
  }

  module ventilation_holes()
  {
    off_x = 10;
    off_y = 30;
    difference()
    {
      children();
      for(dx=[off_x, base.x/2, base.x-off_x])
        for(dy=[off_y, base.y-off_y])
          translate([dx, dy, -eps])
            cylinder(d=4, h=plate_size.z+2*eps);
    }
  }

  ventilation_holes()
    screw_holes()
      LED_holes()
        camera_slot()
          side_rounded_cube(plate_size, r, $fn=fn(30));
}


plate();

%if($preview)
  translate([0, 0, -2])
    move_from_center()
      rotate([180, 0, 0])
        plate_holder();
