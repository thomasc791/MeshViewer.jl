using MeshViewer
using GmshReader

_, n, e, et = readfile("test/input/50x50-tri.msh")
elements = e[3]

vertices = create_vertices(n, e)
viewer(vertices)
