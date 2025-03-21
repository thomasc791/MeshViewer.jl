function init_imgui(window)
  CImGui.CreateContext()
  io = CImGui.GetIO()
  io.ConfigFlags = unsafe_load(io.ConfigFlags) | ImGuiConfigFlags_NavEnableKeyboard
  CImGui.StyleColorsDark()
  ImGui_ImplGlfw_InitForOpenGL(window.handle, true)
  ImGui_ImplOpenGL3_Init("#version 460")

  return io
end

function imgui_menu(wWidth, wHeight, showWhat)
  items = ["Surface", "Surface With Edges", "Frame"]
  currentItem = C_NULL
  CImGui.NewFrame()
  begin
    CImGui.SetNextWindowSize(ImVec2(200, wHeight / 4))
    CImGui.SetNextWindowPos(ImVec2(0, 0))
    CImGui.Begin("Test")
    if (CImGui.BeginCombo("##combo", currentItem))
      for item in items
        selected = currentItem == item
        if CImGui.Selectable(item, selected)
          currentItem = item
          if item == "Surface"
            showWhat[1] = true
            showWhat[2] = false
          elseif item == "Surface With Edges"
            showWhat[1] = true
            showWhat[2] = true
          elseif item == "Frame"
            showWhat[1] = false
            showWhat[2] = true
          end
        end
        if selected
          CImGui.SetItemDefaultFocus()
        end
      end
      CImGui.EndCombo()
    end
    CImGui.End()
  end
  return showWhat
end

