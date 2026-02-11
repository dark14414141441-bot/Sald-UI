local SaldLib = {}
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

-- Mata a seleção azul do sistema do Roblox pra sempre
GuiService.AutoSelectGuiEnabled = false
GuiService.SelectedObject = nil

function SaldLib:CreateWindow()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "SaldHub_Final" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SaldHub_Final"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Botão Flutuante (Arredondado e Arrastável)
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Parent = ScreenGui
    OpenBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    OpenBtn.Size = UDim2.new(0, 55, 0, 55)
    OpenBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
    OpenBtn.Text = "SALD"
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenBtn.TextSize = 14
    OpenBtn.Active = true
    OpenBtn.Draggable = true -- Fallback para mobile
    local BtnCorner = Instance.new("UICorner", OpenBtn)
    BtnCorner.CornerRadius = UDim.new(0, 12)

    -- Janela Principal
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.3, 0, 0.2, 0)
    Main.Visible = false
    Main.Active = true
    local MainCorner = Instance.new("UICorner", Main)
    MainCorner.CornerRadius = UDim.new(0, 6)

    OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    -- Função de Arrasto Universal (Robusta)
    local function MakeDraggable(obj)
        local dragging, dragInput, dragStart, startPos
        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = obj.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    MakeDraggable(Main)

    -- Header
    local Title = Instance.new("TextLabel")
    Title.Parent = Main
    Title.Size = UDim2.new(1, -15, 0, 40)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = "SALD HUB | PRECISÃO"
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Container de Tabs (Quadrado e Colado)
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Parent = Main
    TabScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabScroll.BorderSizePixel = 0 -- SEM UICORNER NAS TABS
    TabScroll.Position = UDim2.new(0, 0, 0, 40)
    TabScroll.Size = UDim2.new(1, 0, 0, 35)
    TabScroll.ScrollBarThickness = 0
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    local TabList = Instance.new("UIListLayout", TabScroll)
    TabList.FillDirection = Enum.FillDirection.Horizontal

    local Content = Instance.new("Frame")
    Content.Parent = Main
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 10, 0, 85)
    Content.Size = UDim2.new(1, -20, 1, -95)

    -- Função para limpar borda azul de qualquer objeto
    local function NoBlue(obj)
        obj.SelectionImageObject = Instance.new("Frame")
        obj.SelectionImageObject.Transparency = 1
        obj.SelectionGroup = false
    end

    local Tabs = {}
    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabScroll
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.BorderSizePixel = 1
        TabBtn.BorderColor3 = Color3.fromRGB(45, 45, 45)
        TabBtn.Size = UDim2.new(0, 110, 1, 0)
        TabBtn.Text = tostring(name):upper()
        TabBtn.Font = Enum.Font.SourceSansBold
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.TextSize = 14
        NoBlue(TabBtn)

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = Content
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 3
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Content:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
            for _, t in pairs(TabScroll:GetChildren()) do if t:IsA("TextButton") then t.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)

        local Elements = {}

        -- TOGGLE COM UICORNER
        function Elements:CreateToggle(text, callback)
            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(1, 0, 0, 38)
            Tgl.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Tgl.BorderSizePixel = 0
            Tgl.Text = "    " .. text
            Tgl.Font = Enum.Font.SourceSansBold
            Tgl.TextColor3 = Color3.fromRGB(200, 200, 200)
            Tgl.TextSize = 16
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Tgl.Parent = Page
            NoBlue(Tgl)
            Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 6)

            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 20, 0, 20)
            Box.Position = UDim2.new(1, -30, 0.5, -10)
            Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Box.Parent = Tgl
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
            
            local Check = Instance.new("Frame")
            Check.Size = UDim2.new(1, -6, 1, -6)
            Check.Position = UDim2.new(0, 3, 0, 3)
            Check.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Check.BackgroundTransparency = 1
            Check.Parent = Box
            Instance.new("UICorner", Check).CornerRadius = UDim.new(0, 4)

            local on = false
            Tgl.MouseButton1Click:Connect(function()
                on = not on
                Check.BackgroundTransparency = on and 0 or 1
                callback(on)
            end)
        end

        -- SLIDER COM UICORNER
        function Elements:CreateSlider(text, min, max, callback)
            local SFrame = Instance.new("Frame")
            SFrame.Size = UDim2.new(1, 0, 0, 55)
            SFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            SFrame.BorderSizePixel = 0
            SFrame.Parent = Page
            Instance.new("UICorner", SFrame).CornerRadius = UDim.new(0, 6)

            local Lab = Instance.new("TextLabel")
            Lab.Size = UDim2.new(1, 0, 0, 30)
            Lab.Position = UDim2.new(0, 12, 0, 0)
            Lab.Text = text .. ": " .. min
            Lab.TextColor3 = Color3.fromRGB(255, 255, 255)
            Lab.BackgroundTransparency = 1
            Lab.Font = Enum.Font.SourceSansBold
            Lab.TextSize = 15
            Lab.TextXAlignment = Enum.TextXAlignment.Left
            Lab.Parent = SFrame

            local Rail = Instance.new("TextButton")
            Rail.Size = UDim2.new(1, -24, 0, 6)
            Rail.Position = UDim2.new(0, 12, 0, 35)
            Rail.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Rail.Text = ""
            Rail.Parent = SFrame
            NoBlue(Rail)
            Instance.new("UICorner", Rail)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new(0, 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Fill.Parent = Rail
            Instance.new("UICorner", Fill)

            local function Update()
                local pos = math.clamp((UserInputService:GetMouseLocation().X - Rail.AbsolutePosition.X) / Rail.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                Lab.Text = text .. ": " .. val
                callback(val)
            end

            Rail.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local move = UserInputService.InputChanged:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then Update() end
                    end)
                    input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then move:Disconnect() end end)
                    Update()
                end
            end)
        end

        -- INPUT COM UICORNER
        function Elements:CreateInput(text, placeholder, callback)
            local IFrame = Instance.new("Frame")
            IFrame.Size = UDim2.new(1, 0, 0, 45)
            IFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            IFrame.BorderSizePixel = 0
            IFrame.Parent = Page
            Instance.new("UICorner", IFrame).CornerRadius = UDim.new(0, 6)

            local Lab = Instance.new("TextLabel")
            Lab.Size = UDim2.new(0, 120, 1, 0)
            Lab.Position = UDim2.new(0, 12, 0, 0)
            Lab.Text = text
            Lab.TextColor3 = Color3.fromRGB(255, 255, 255)
            Lab.BackgroundTransparency = 1
            Lab.Font = Enum.Font.SourceSansBold
            Lab.TextSize = 15
            Lab.TextXAlignment = Enum.TextXAlignment.Left
            Lab.Parent = IFrame

            local Box = Instance.new("TextBox")
            Box.Size = UDim2.new(0, 160, 0, 28)
            Box.Position = UDim2.new(1, -170, 0.5, -14)
            Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Box.Text = ""
            Box.PlaceholderText = placeholder
            Box.TextColor3 = Color3.fromRGB(255, 255, 255)
            Box.Parent = IFrame
            NoBlue(Box)
            Instance.new("UICorner", Box)
            Box.FocusLost:Connect(function() callback(Box.Text) end)
        end

        return Elements
    end
    return Tabs
end

return SaldLib
