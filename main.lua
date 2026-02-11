local SaldLib = {}
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

-- REMOVE BORDA AZUL GLOBALMENTE
GuiService.AutoSelectGuiEnabled = false
GuiService.SelectedObject = nil

function SaldLib:CreateWindow()
    -- Limpa UI antiga
    if game.CoreGui:FindFirstChild("SaldHub_Lib") then
        game.CoreGui.SaldHub_Lib:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SaldHub_Lib"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- FUNÇÕES AUXILIARES
    local function KillBlue(obj)
        local frame = Instance.new("Frame")
        frame.BackgroundTransparency = 1
        obj.SelectionImageObject = frame
        obj.SelectionGroup = false
    end

    local function MakeDraggable(obj, dragHandle)
        local dragging, dragInput, dragStart, startPos
        dragHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = obj.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        dragHandle.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    -- 1. BOTÃO FLUTUANTE (REDONDO)
    local FloatBtn = Instance.new("TextButton")
    FloatBtn.Name = "OpenBtn"
    FloatBtn.Parent = ScreenGui
    FloatBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    FloatBtn.Size = UDim2.new(0, 50, 0, 50)
    FloatBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
    FloatBtn.Text = "S"
    FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    FloatBtn.TextSize = 20
    FloatBtn.Font = Enum.Font.GothamBold
    KillBlue(FloatBtn)
    
    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(1, 0) -- CIRCULO PERFEITO
    FloatCorner.Parent = FloatBtn
    
    MakeDraggable(FloatBtn, FloatBtn) -- Arrastável

    -- 2. MAIN FRAME (REDONDO)
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.3, 0, 0.3, 0)
    Main.Visible = false
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main

    -- Header (Arrastável)
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundTransparency = 1
    Header.Parent = Main
    MakeDraggable(Main, Header)

    local Title = Instance.new("TextLabel")
    Title.Parent = Header
    Title.Text = "SALD HUB | LIBRARY"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Lógica Abrir/Fechar
    FloatBtn.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    -- 3. TAB CONTAINER (QUADRADO E COLADO)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = Main
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.Size = UDim2.new(1, 0, 0, 35)
    TabContainer.ScrollBarThickness = 0
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.BorderSizePixel = 0 -- SEM BORDA

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 0) -- COLADO
    TabList.SortOrder = Enum.SortOrder.LayoutOrder

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Parent = Main
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 10, 0, 85)
    ContentContainer.Size = UDim2.new(1, -20, 1, -95)

    -- RETORNO DA JANELA
    local WindowFunctions = {}

    function WindowFunctions:CreateTab(name)
        -- BOTÃO DA TAB (QUADRADO - SEM UICORNER)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabContainer
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Size = UDim2.new(0, 120, 1, 0) -- Largura fixa
        TabBtn.Text = name:upper()
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.SourceSansBold
        TabBtn.TextSize = 14
        TabBtn.BorderSizePixel = 0
        KillBlue(TabBtn)

        -- PÁGINA
        local Page = Instance.new("ScrollingFrame")
        Page.Parent = ContentContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local PageList = Instance.new("UIListLayout")
        PageList.Parent = Page
        PageList.Padding = UDim.new(0, 5)

        -- Lógica de Clique na Tab
        TabBtn.MouseButton1Click:Connect(function()
            -- Esconde todas as páginas
            for _, v in pairs(ContentContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            -- Reseta cor de todas as tabs
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    v.TextColor3 = Color3.fromRGB(150, 150, 150)
                end
            end
            -- Ativa a atual
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Cor de destaque
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local ElementFunctions = {}

        -- TOGGLE (REDONDO)
        function ElementFunctions:CreateToggle(text, callback)
            local TglBtn = Instance.new("TextButton")
            TglBtn.Parent = Page
            TglBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            TglBtn.Size = UDim2.new(1, 0, 0, 40)
            TglBtn.Text = "   " .. text
            TglBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            TglBtn.TextSize = 14
            TglBtn.TextXAlignment = Enum.TextXAlignment.Left
            TglBtn.Font = Enum.Font.SourceSansBold
            KillBlue(TglBtn)
            
            local TglCorner = Instance.new("UICorner")
            TglCorner.CornerRadius = UDim.new(0, 6)
            TglCorner.Parent = TglBtn

            local Status = Instance.new("Frame")
            Status.Size = UDim2.new(0, 20, 0, 20)
            Status.Position = UDim2.new(1, -30, 0.5, -10)
            Status.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Status.Parent = TglBtn
            Instance.new("UICorner", Status).CornerRadius = UDim.new(0, 4)

            local Check = Instance.new("Frame")
            Check.Size = UDim2.new(1, -4, 1, -4)
            Check.Position = UDim2.new(0, 2, 0, 2)
            Check.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Check.BackgroundTransparency = 1
            Check.Parent = Status
            Instance.new("UICorner", Check).CornerRadius = UDim.new(0, 4)

            local enabled = false
            TglBtn.MouseButton1Click:Connect(function()
                enabled = not enabled
                Check.BackgroundTransparency = enabled and 0 or 1
                callback(enabled)
            end)
        end

        -- SLIDER (REDONDO)
        function ElementFunctions:CreateSlider(text, min, max, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = Page
            SliderFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            
            local SlCorner = Instance.new("UICorner")
            SlCorner.CornerRadius = UDim.new(0, 6)
            SlCorner.Parent = SliderFrame

            local Label = Instance.new("TextLabel")
            Label.Parent = SliderFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Text = text .. ": " .. min
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.SourceSansBold
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextSize = 14

            local SlideBtn = Instance.new("TextButton")
            SlideBtn.Parent = SliderFrame
            SlideBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            SlideBtn.Size = UDim2.new(1, -20, 0, 8)
            SlideBtn.Position = UDim2.new(0, 10, 0, 30)
            SlideBtn.Text = ""
            SlideBtn.AutoButtonColor = false
            KillBlue(SlideBtn)
            Instance.new("UICorner", SlideBtn).CornerRadius = UDim.new(0, 10)

            local Fill = Instance.new("Frame")
            Fill.Parent = SlideBtn
            Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Fill.Size = UDim2.new(0, 0, 1, 0)
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 10)

            local function Update(input)
                local pos = math.clamp((input.Position.X - SlideBtn.AbsolutePosition.X) / SlideBtn.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                Label.Text = text .. ": " .. val
                callback(val)
            end

            SlideBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Update(input)
                    local move = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                            Update(input)
                        end
                    end)
                    local release
                    release = input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            move:Disconnect()
                            release:Disconnect()
                        end
                    end)
                end
            end)
        end

        -- INPUT (REDONDO)
        function ElementFunctions:CreateInput(text, placeholder, callback)
            local InputFrame = Instance.new("Frame")
            InputFrame.Parent = Page
            InputFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            InputFrame.Size = UDim2.new(1, 0, 0, 45)
            Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel")
            Label.Parent = InputFrame
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(0.4, 0, 1, 0)
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Enum.Font.SourceSansBold
            Label.TextSize = 14

            local Box = Instance.new("TextBox")
            Box.Parent = InputFrame
            Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Box.Size = UDim2.new(0.5, 0, 0.6, 0)
            Box.Position = UDim2.new(0.45, 0, 0.2, 0)
            Box.PlaceholderText = placeholder
            Box.Text = ""
            Box.TextColor3 = Color3.fromRGB(255, 255, 255)
            Box.Font = Enum.Font.SourceSans
            KillBlue(Box)
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

            Box.FocusLost:Connect(function()
                callback(Box.Text)
            end)
        end

        return ElementFunctions
    end

    return WindowFunctions
end

return SaldLib

