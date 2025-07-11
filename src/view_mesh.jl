function viewer(vertices)
   # create GLFW window and make the window's current context
   width, height = 800, 600
   window = create_window(800, 600, "Mesh Viewer")
   make_context_current(window)

   # initialise the vertex buffer
   data = [convert(Vector{GLfloat}, vert) for vert in vertices]

   triID = init_shaders("tri-vertex.glsl", "tri-fragment.glsl")
   lineID = init_shaders("line-vertex.glsl", "line-fragment.glsl")

   # use shader program

   vaoLine, vboLine = init_vertex([data[1]])
   glUseProgram(lineID)
   initialise_id(lineID, width, height)

   vaoTri, vboTri = init_vertex([data[2]])
   glUseProgram(triID)
   initialise_id(triID, width, height)

   # scroll callback
   scrollValue::Float64 = 1.0
   viewMat, projMat = (Matrix{GLfloat}(I, 4, 4) for _ in 1:2)
   position = GLfloat[0.0, 0.0, 3.0]
   target = GLfloat[0.0, 0.0, 0.0]
   up = GLfloat[0.0, 1.0, 0.0]
   camera = Camera(scrollValue, position, target, up, viewMat, projMat)

   function scroll_callback(_::GLFW.Window, _, yoffset)
      camera.scrollValue += 0.025 * yoffset
      camera.position[3] -= 0.025 * yoffset
      camera.position[3] = max(1e-16, camera.position[3])
   end
   GLFW.SetScrollCallback(window, scroll_callback)

   moveCamera, prevPos, modelTranslation = false, GLfloat[0, 0], GLfloat[0, 0, 0, 0]
   function cursor_pos_callback(_, x, y)
      if moveCamera
         modelTranslation[1] += (x - prevPos[1]) * 0.005 * 1 / camera.scrollValue
         modelTranslation[2] -= (y - prevPos[2]) * 0.005 * 1 / camera.scrollValue
         glUseProgram(triID)
         set_vec4(triID, "translation", modelTranslation)
         glUseProgram(lineID)
         set_vec4(lineID, "translation", modelTranslation)
      end
      prevPos[1] = x
      prevPos[2] = y
   end
   GLFW.SetCursorPosCallback(window, cursor_pos_callback)

   function mouse_button_callback(window, button, action, mods)
      io = CImGui.GetIO()
      CImGui.AddMouseButtonEvent(io, button, action == GLFW.PRESS)
      if button == GLFW.MOUSE_BUTTON_LEFT && action == GLFW.PRESS
         moveCamera = true
      elseif button == GLFW.MOUSE_BUTTON_LEFT && action == GLFW.RELEASE
         moveCamera = false
      end
   end
   GLFW.SetMouseButtonCallback(window, mouse_button_callback)

   # framebuffer size callback
   function framebuffer_size_callback(_, width, height)
      glViewport(0, 0, width, height)
      glUseProgram(lineID)
      initialise_id(lineID, width, height)
      glUseProgram(triID)
      initialise_id(triID, width, height)
   end
   GLFW.SetFramebufferSizeCallback(window, framebuffer_size_callback)

   # create ImGui context and initialise ImGui
   io = init_imgui(window)

   # initialise variables
   prev, t = 0, 0
   showMesh = [true, false]
   while !window_should_close(window)
      next = time()
      fps = 1 / (next - prev)
      main_loop(window, camera, [lineID, triID], [vaoLine[], vaoTri[]], [vboLine[], vboTri[]], [length(vertices[1]) / 3, length(vertices[2]) / 3], fps, showMesh)
      t += 0.01
      prev = next
   end

   destroy_window(window)
end

function main_loop(window, camera, ids, vao, vbo, len, fps, showMesh)
   poll_events()
   windowWidth, windowHeight = GLFW.GetFramebufferSize(window)
   glClearColor(0.5, 0.5, 0.3, 1.0)
   glClear(GL_COLOR_BUFFER_BIT)

   if showMesh[1]
      glUseProgram(ids[2])
      set_view(ids[2], camera)
      glBindVertexArray(vao[2])
      glDrawArrays(GL_TRIANGLES, 0, len[2])
   end

   if showMesh[2]
      glUseProgram(ids[1])
      set_view(ids[1], camera)
      glBindBuffer(GL_ARRAY_BUFFER, vbo[1])
      glBindVertexArray(vao[1])
      glDrawArrays(GL_LINES, 0, len[1])
   end

   # initialising and drawing the ImGui menu
   ImGui_ImplOpenGL3_NewFrame()
   ImGui_ImplGlfw_NewFrame()
   showMesh = imgui_menu(windowWidth, windowHeight, showMesh)
   CImGui.Render()

   ImGui_ImplOpenGL3_RenderDrawData(CImGui.GetDrawData())
   swap_buffers(window)
end

function set_view(id, camera::Camera)
   set_mat4(id, "view", look_at!(camera::Camera))
end

function initialise_id(id, width, height)
   positionAttrib = glGetAttribLocation(id, "position")
   glVertexAttribPointer(positionAttrib, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), C_NULL)
   glEnableVertexAttribArray(positionAttrib)

   projection = perspective(pi / 4, width / height, 0.000, 100.0)
   set_mat4(id, "projection", projection)
end
