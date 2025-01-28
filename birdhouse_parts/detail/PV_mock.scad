include <../m3d/all.scad>

// 1st (broken) print + skinner coefficient: [260.1, 150.6] + [2.6, 6] == [262.7, 156.6]
holes_span = [262.5, 157];
pv_size = [275, 170, 1.75];

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
