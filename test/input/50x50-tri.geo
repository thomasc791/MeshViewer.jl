meshSize = 1/50;

width = 1;
height = 1;

Point(1) = {0, 0, 0, meshSize};
Point(2) = {width, 0, 0, meshSize};
Point(3) = {width, height, 0, meshSize};
Point(4) = {0, height, 0, meshSize};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Curve Loop(1) = {4, 1, 2, 3};
Plane Surface(1) = {1};

// Ensure point is in surface
Physical Curve("bottom", 1) = {1};
Physical Curve("right", 2) = {2};
Physical Curve("left", 3) = {4};
