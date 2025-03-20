function look_at!(camera)
  direction = normalize(camera.position - camera.target)
  right = normalize(cross(camera.up, direction))
  camera.up = cross(direction, right)
  camera.viewMatrix[1, 1:3] .= right
  camera.viewMatrix[2, 1:3] .= camera.up
  camera.viewMatrix[3, 1:3] .= direction
  camera.projMatrix[1:3, 4] .= -camera.position
  return camera.viewMatrix * camera.projMatrix
end

function rotate(vector::Vector{T}, a) where {T}
  rot = T[cos(a), -sin(a), 0, sin(a), cos(a), 0, 0, 0, 0]
  return reshape(rot, 3, 3) * vector
end

function perspective(fovy, aspect, zNear, zFar)
  f = cot(fovy / 2)
  mat = GLfloat[f/aspect, 0, 0, 0,
    0, f, 0, 0,
    0, 0, (zFar+zNear)/(zNear-zFar), -1,
    0, 0, (2*zFar*zNear)/(zNear-zFar), 0]
  return reshape(mat, 4, 4)
end
