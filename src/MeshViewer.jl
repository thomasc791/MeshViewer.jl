module MeshViewer

using GLFW
using CImGui
using CImGui.lib
using ModernGL

include("glfw.jl")

include("shader.jl")

include("view_mesh.jl")
export viewer

end
