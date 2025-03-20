module MeshViewer

using GLFW
using CImGui
using CImGui.lib
using LinearAlgebra
using ModernGL
using Printf

include("glfw.jl")

include("shader.jl")

include("linear_algebra.jl")

include("types.jl")
include("imgui.jl")
include("view_mesh.jl")
export viewer

include("vertices.jl")
export create_line_vertices
export create_tri_vertices

end
