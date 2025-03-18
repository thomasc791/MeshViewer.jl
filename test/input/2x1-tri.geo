meshSize = 1/1;
Point(1) = {0, 0, 0, meshSize};
Point(2) = {1, 0, 0, meshSize};
Point(3) = {1, 0.5, 0, meshSize};
Point(4) = {1, 1, 0, meshSize};
Point(5) = {0, 1, 0, meshSize};
Point(6) = {0, 0.5, 0, meshSize};
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

Physical Point("origin", 1) = {1};
Physical Point("barPoints", 2) = {2, 3, 4};
Physical Curve("bars", 3) = {1, 3, 6};
Physical Curve("left", 4) = {4, 7};
Physical Curve("right", 5) = {5, 2};
