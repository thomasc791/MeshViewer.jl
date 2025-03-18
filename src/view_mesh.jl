function viewer(vertices)
  # create GLFW window and make the window's current context
  window = create_window(800, 600, "Mesh Viewer")
  make_context_current(window)

  # create ImGui context and initialise ImGui
  io = init_imgui(window)

  # initialise the vertex buffer
  data = [GLfloat[0.0, 0.5, 0.0, 0.5, -0.5, 0.0, -0.5, -0.5, 0.0]]
  vao, vbo = init_vertex(data)
  id = init_shaders()

  # use shader program
  glUseProgram(id)

  positionAttrib = glGetAttribLocation(id, "position")
  glVertexAttribPointer(positionAttrib, 3, GL_FLOAT, GL_FALSE, 0, C_NULL)
  glEnableVertexAttribArray(positionAttrib)

  while !window_should_close(window)
    main_loop(window, vao)
  end

  destroy_window(window)
end

function main_loop(window, vao)
  poll_events()
  windowWidth, windowHeight = GLFW.GetFramebufferSize(window)
  glClearColor(0.5, 0.5, 0.3, 1.0)
  glClear(GL_COLOR_BUFFER_BIT)

  for v in vao
    glBindVertexArray(v)
    glDrawArrays(GL_TRIANGLES, 0, 3)
    glBindVertexArray(0)
  end

  # initialising and drawing the ImGui menu
  ImGui_ImplOpenGL3_NewFrame()
  ImGui_ImplGlfw_NewFrame()
  imgui_menu(windowWidth, windowHeight)
  CImGui.Render()

  ImGui_ImplOpenGL3_RenderDrawData(CImGui.GetDrawData())
  swap_buffers(window)
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

  return vbo, vao
end

function init_shaders()
  vertexString = read("src/shaders/vertex.glsl", String)
  fragmentString = read("src/shaders/fragment.glsl", String)

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

function init_imgui(window)
  CImGui.CreateContext()
  io = CImGui.GetIO()
  io.ConfigFlags = unsafe_load(io.ConfigFlags) | ImGuiConfigFlags_NavEnableKeyboard
  CImGui.StyleColorsDark()
  ImGui_ImplGlfw_InitForOpenGL(window.handle, true)
  ImGui_ImplOpenGL3_Init("#version 460")

  return io
end

function imgui_menu(wWidth, wHeight)
  CImGui.NewFrame()
  begin
    CImGui.SetNextWindowSize(ImVec2(200, wHeight / 4))
    CImGui.SetNextWindowPos(ImVec2(0, 0))
    CImGui.Begin("Test")
    CImGui.Text("hello")
    CImGui.End()
  end
end
