mutable struct Camera
  scrollValue::GLfloat
  position::Vector{GLfloat}
  target::Vector{GLfloat}
  up::Vector{GLfloat}
  viewMatrix::Matrix{GLfloat}
  projMatrix::Matrix{GLfloat}
end
