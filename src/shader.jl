function createShader(source, type_)
  shader = glCreateShader(type_)::GLuint
  glShaderSource(shader, 1, convert(Ptr{UInt8}, pointer([convert(Ptr{GLchar}, pointer(source))])), C_NULL)
  glCompileShader(shader)
  !checkShader(shader) && error("Shader compilation error: ", glInfoLog(shader))
  return shader
end

function init_shaders(vertex, fragment)
  vertexPath = join(["src/shaders/", vertex])
  fragmentPath = join(["src/shaders/", fragment])
  vertexString = read(vertexPath, String)
  fragmentString = read(fragmentPath, String)

  vs = createShader(vertexString, GL_VERTEX_SHADER)
  fs = createShader(fragmentString, GL_FRAGMENT_SHADER)

  id = glCreateProgram()
  glAttachShader(id, vs)
  glAttachShader(id, fs)
  glLinkProgram(id)
  glDeleteShader(vs)
  glDeleteShader(fs)

  return id
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

function set_mat4(program, name, A::Matrix{T}) where {T}
  glUniformMatrix4fv(glGetUniformLocation(program, name), 1, GL_FALSE, A)
end
