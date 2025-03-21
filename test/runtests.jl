using MeshViewer
using Test
using Aqua
using JET

@testset "MeshViewer.jl" begin
  @testset "Code quality (Aqua.jl)" begin
    Aqua.test_all(MeshViewer)
  end
  @testset "Code linting (JET.jl)" begin
    JET.test_package(MeshViewer; target_defined_modules=true)
  end
  # Write your tests here.
end
