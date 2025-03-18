import Gmsh: gmsh

if gmsh.isInitialized() == false
  gmsh.initialize()
end

dir = ""
if basename(pwd()) == "Elementa"
  dir = join([pwd(), "/test/"])
  println("Looking in dir test/input/")
else
  dir = join([pwd(), "/"])
  println("Looking in dir input/")
end

inputdir = join([dir, "input/"])
files = readdir(inputdir)
gmsh.option.setNumber("Mesh.SaveAll", 1)
for f in files
  f_name = f[1:end-4]
  f_ext = f[end-2:end]

  if f_ext == "geo" && !isfile(join([inputdir, f_name, ".msh"]))
    display(join([f_name, ".msh"]))
    gmsh.open(join([inputdir, f]))
    gmsh.model.mesh.generate(2)
    old, new = gmsh.model.mesh.computeRenumbering("RCMK")
    gmsh.model.mesh.renumberNodes(old, new)
    gmsh.write(join([inputdir, f_name, ".msh"]))
  end
end

gmsh.finalize()
