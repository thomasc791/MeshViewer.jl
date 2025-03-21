using MeshViewer
using Elementa
using Elementa.GmshReader

pg, n, e, et = Elementa.GmshReader.readfile("test/input/250x1000-tri.msh")
elements = e[end]
mesh = Mesh(pg, n, e, et, 2)
Elementa.create_connectivity!(mesh, 1, 0)
vertices = [create_line_vertices(mesh, 1), create_tri_vertices(mesh, 2)]
viewer(vertices)

