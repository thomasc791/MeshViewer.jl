function create_tri_vertices(mesh, dim)
   nodes = mesh.nodes
   elements = mesh.connectivity[(dim, 0)]
   vertices = Matrix{Float64}(undef, 2, length(elements) * 3)

   for i in eachindex(elements)
      vertex = nodes[:, elements[i]]
      vertices[1:2, 3*(i-1)+1:3*i] = vertex
   end

   centerX = sum(vertices[1, :]) / size(vertices, 2)
   centerY = sum(vertices[2, :]) / size(vertices, 2)
   center = Float64[centerX, centerY]

   vertices .-= center
   return vec(vertices)
end

function create_line_vertices(mesh, dim)
   nodes = mesh.nodes
   elements = mesh.connectivity[(dim, 0)]
   vertices = Matrix{Float64}(undef, 2, length(elements) * 2)

   for i in eachindex(elements)
      vertex = nodes[:, elements[i]]
      vertices[1:2, 2*(i-1)+1:2*i] = vertex
   end

   centerX = sum(vertices[1, :]) / size(vertices, 2)
   centerY = sum(vertices[2, :]) / size(vertices, 2)
   center = Float64[centerX, centerY]

   vertices .-= center
   return vec(vertices)
end

function init_vertex(data)
   n = size(data, 1)
   vao = glVertexArrays(n)
   vbo = glBuffers(n)
   for i in axes(vao, 1)
      glBindVertexArray(vao[i])
      glBindBuffer(GL_ARRAY_BUFFER, vbo[i])
      glBufferData(GL_ARRAY_BUFFER, sizeof(data[i]), data[i], GL_STATIC_DRAW)
   end
   return vao, vbo
end

