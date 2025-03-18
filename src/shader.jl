function createShader(source, type_)
  shader = glCreateShader(type_)::GLuint
  glShaderSource(shader, 1, convert(Ptr{UInt8}, pointer([convert(Ptr{GLchar}, pointer(source))])), C_NULL)
  glCompileShader(shader)
  !checkShader(shader) && error("Shader compilation error: ", glInfoLog(shader))
  return shader
end

function glInfoLog(object)
  isShader = glIsShader(object)
  iv = isShader == GL_TRUE ? glGetShaderiv : glGetProgramiv
  log = isShader == GL_TRUE ? glGetShaderInfoLog : glGetProgramInfoLog

  len = GLint[0]
  iv(object, GL_INFO_LOG_LENGTH, len)
  maxlength = len[]

  if maxlength > 0
    buffer = zeros(GLchar, maxlength)
    sizei = GLsizei[0]
    log(object, maxlength, sizei, buffer)
    len = sizei[]
    unsafe_string(pointer(buffer), len)
  else
    ""
  end
end

function checkShader(shader)
  success = GLint[0]
  glGetShaderiv(shader, GL_COMPILE_STATUS, success)
  success[] == GL_TRUE
end

function glVertexArrays(n)
  ids = GLuint[i for i in 0:n-1]
  glGenVertexArrays(n, ids)
  return ids
end

function glBuffers(n)
  ids = GLuint[i for i in 0:n-1]
  glGenBuffers(n, ids)
  return ids
end
