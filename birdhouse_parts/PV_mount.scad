include <m3d/all.scad>

roof_panel_angle = 90-50;
holes_span = [260.1+2.6, 150.6+6];
pv_size = [270.5, 169, 1.75];

module PV_mount_holes_pos()
{
  for(dx=[-1, +1])
    for(dy=[-1, +1])
      translate([dx*holes_span.x/2, dy*holes_span.y/2, 0])
        children();
}


module PV_mock()
{
  box = [28, 29.1, 11.5];

  translate([0, 0, -pv_size.z])
    difference()
    {
      translate([-pv_size.x/2, -pv_size.y/2, 0])
      {
        // power socket
        translate([8.2, pv_size.y/2, 0])
          translate([0, -box.y/2, pv_size.z])
            cube(box);
        side_rounded_cube(pv_size, 5);
      }
      translate([0, 0, -eps])
        PV_mount_holes_pos()
          cylinder(d=6.1, h=pv_size.z+2*eps);
    }
}


module PV_mount()
{
  h = 3;

  module booms()
  {
    support_circle_d = 20;

    module semi_circle(dir)
    {
      d = holes_span.y;
      $fn=fn(60);

      module impl(width, h)
      {
        difference()
        {
          cylinder(d=d+width/2, h=h);
          translate([0, 0, -eps])
            cylinder(d=d-width/2, h=h+2*eps);
        }
      }

      scale([1.75, 1, 1])
      {
        difference()
        {
          union()
          {
            impl(support_circle_d, h);
            impl(3, 2*h);
          }
          translate([-d/2 + dir*d/2, -d, -eps])
            cube([d, 2*d, 2*h+2*eps]);
        }
      }
    }

    PV_mount_holes_pos()
      cylinder(d=support_circle_d, h=7); // 6.8mm is threaded insert slot

    for(dir=[-1, +1])
      translate([dir*holes_span.x/2, 0, 0])
        semi_circle(dir);
  }
  
  module roof_mount()
  {
    roof_span_ext = 160.3 + 2*0.5;
    arm_length = 60;

    module assembly()
    {
      module arm(dir, with_top=true)
      {
        wall = 3;
        wall_length = 25;
        span_int = 14.5;
        span_ext = span_int + 2*wall;

        translate([dir==+1 ? -span_ext : 0, 0, 0])
        {
          if(with_top)
            cube([span_ext, 5, arm_length]);
          // external wind
          difference()
          {
            translate([dir==+1 ? span_ext-wall : 0, -wall_length, -arm_length])
              cube([wall, wall_length, 2*arm_length]);
            // screw holes
            rows = 2*3;
            cols = 2;
            translate([0, 0, -arm_length])
              for(i=[0:rows-1])
                for(j=[0:cols-1])
                  translate([-eps + (dir==+1 ? span_int+wall : 0),
                               wall_length/cols/2 - (j+1)* wall_length/cols,
                             -2*arm_length/rows/2 + (i+1)*2*arm_length/rows])
                    rotate([0, 90, 0])
                      cylinder(d=2.8+0.5, h=wall+2*eps, $fn=fn(30));
          }
        }
      }

      module arms(with_top)
      {
        rotate([-roof_panel_angle, 0, 0])
          for(dir=[-1, +1])
            translate([dir*roof_span_ext/2, 0, 0])
              arm(dir, with_top);
      }

      arms();
      difference()
      {
        translate([-roof_span_ext/2, 0, 0])
          cube([roof_span_ext, 30, 35]);
        hull()
          arms(with_top=false);
      }
    }

    translate([0, -pv_size.y/2, 0])
      intersection()
      {
        assembly();
        translate([-pv_size.x/2, -pv_size.y/2, 0])
          cube([pv_size.x, pv_size.y, arm_length]);
      }
  }

  difference()
  {
    booms();
    translate([0, 0, 7+eps])
      PV_mount_holes_pos()
        ti_cnck_m5_short(dl=2);
  }

  roof_mount();

  hull()
  {
    cylinder(d=20, h=2*h, $fn=fn(20));
    translate([-40/2, -pv_size.y/2+20, 0])
    cube([40, eps, 3*h]);
  }
}


PV_mount();

%if($preview)
  PV_mock();
