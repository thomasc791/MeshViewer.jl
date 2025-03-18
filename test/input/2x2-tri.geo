// Gmsh project created on Mon Mar  3 11:17:18 2025
SetFactory("OpenCASCADE");
Point(1) = {0, 0, 0, 1.0};
Point(2) = {1, 0, 0, 1.0};
Point(3) = {1, 0.5, 0, 1.0};
Point(4) = {1, 1, 0, 1.0};
Point(5) = {0, 1, 0, 1.0};
Point(6) = {0, 0.5, 0, 1.0};
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 6};
Line(4) = {6, 1};
Line(5) = {3, 4};
Line(6) = {4, 5};
Line(7) = {5, 6};

Curve Loop(1) = {1, 2, 3, 4};
Curve Loop(2) = {6, 7, -3, 5};
Plane Surface(1) = {1};
Plane Surface(2) = {2};

Physical Curve("bars", 8) = {1, 3, 6};
Physical Curve("left", 9) = {4, 7};
Physical Curve("right", 10) = {5, 2};
Physical Point("origin", 11) = {1};

Transfinite Curve {1, 3, 6} = 1 Using Progression 1;
Transfinite Curve {7, 4, 2, 5} = 1 Using Progression 1;
Transfinite Surface {1};
Transfinite Surface {2};
