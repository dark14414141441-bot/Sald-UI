local SaldHub = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Função de Arraste Original (Mantida)
local function MakeDraggable(topbarobject, object)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function SaldHub:CreateWindow()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SaldHub"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    -- --- BOTÃO S (RESTAURADO) ---
    local LogoS = Instance.new("TextButton")
    LogoS.Name = "LogoS"
    LogoS.Parent = ScreenGui
    LogoS.Size = UDim2.new(0, 50, 0, 50)
    LogoS.Position = UDim2.new(0, 50, 0, 50)
    LogoS.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LogoS.Text = "S"
    LogoS.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogoS.Font = Enum.Font.GothamBold
    LogoS.TextSize = 30
    Instance.new("UICorner", LogoS).CornerRadius = UDim.new(0, 12)
    
    local Grad = Instance.new("UIGradient", LogoS)
    Grad.Color = ColorSequence.new(Color3.fromRGB(0, 80, 200), Color3.fromRGB(60, 60, 60))
    Grad.Rotation = 90
    MakeDraggable(LogoS, LogoS)

    -- --- MENU PRINCIPAL (ESTILO DA FOTO) ---
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Escuro e Opaco
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    MakeDraggable(MainFrame, MainFrame)

    LogoS.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 20, 0, 15)
    Title.Size = UDim2.new(0, 200, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Sald Hub <font color='#0064FF'>Blox Fruits</font>"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.RichText = true
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Sidebar com Borda Azul
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundTransparency = 1
    Sidebar.Position = UDim2.new(0, 10, 0, 50)
    Sidebar.Size = UDim2.new(0, 170, 1, -60)
    Sidebar.ScrollBarThickness = 0
    
    local StrokeSide = Instance.new("UIStroke", Sidebar)
    StrokeSide.Color = Color3.fromRGB(0, 80, 200)
    StrokeSide.Thickness = 1.2

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Sidebar
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 190, 0, 50)
    ContentContainer.Size = UDim2.new(1, -200, 1, -60)

    local Tabs = {FirstTab = true}

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = Sidebar
        TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.Text = "        " .. name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        
        -- ÍCONE DE MOUSE (SEM SETAS)
        local Icon = Instance.new("ImageLabel", TabBtn)
        Icon.Size = UDim2.new(0, 16, 0, 16)
        Icon.Position = UDim2.new(0, 10, 0.5, -8)
        Icon.BackgroundTransparency = 1
        Icon.Image = "rbxassetid://6031225818"
        Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)

        local Page = Instance.new("ScrollingFrame", ContentContainer)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 6)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentContainer:GetChildren()) do v.Visible = false end
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundTransparency = 1
                    v.TextColor3 = Color3.fromRGB(150, 150, 150)
                    v.ImageLabel.ImageColor3 = Color3.fromRGB(150, 150, 150)
                end
            end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0.8
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end)

        if Tabs.FirstTab then
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0.8
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            Tabs.FirstTab = false
        end

        local Elements = {}

        function Elements:CreateButton(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, -5, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Btn.Font = Enum.Font.Gotham
            Btn.Text = "        " .. text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextSize = 14
            Btn.TextXAlignment = "Left"
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            
            local bIcon = Instance.new("ImageLabel", Btn)
            bIcon.Size = UDim2.new(0, 16, 0, 16)
            bIcon.Position = UDim2.new(0, 10, 0.5, -8)
            bIcon.BackgroundTransparency = 1
            bIcon.Image = "rbxassetid://6031225818"
            
            Btn.MouseButton1Click:Connect(callback)
        end

        function Elements:CreateSlider(text, min, max, callback)
            local SldFrame = Instance.new("Frame", Page)
            SldFrame.Size = UDim2.new(1, -5, 0, 50)
            SldFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Instance.new("UICorner", SldFrame).CornerRadius = UDim.new(0, 6)
            
            local SStroke = Instance.new("UIStroke", SldFrame)
            SStroke.Color = Color3.fromRGB(0, 80, 200)

            local Label = Instance.new("TextLabel", SldFrame)
            Label.Text = "   " .. text .. ": " .. min
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = "Left"

            local BarBack = Instance.new("TextButton", SldFrame)
            BarBack.Size = UDim2.new(1, -20, 0, 4)
            BarBack.Position = UDim2.new(0, 10, 0, 35)
            BarBack.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            BarBack.Text = ""
            Instance.new("UICorner", BarBack)

            local BarFill = Instance.new("Frame", BarBack)
            BarFill.Size = UDim2.new(0, 0, 1, 0)
            BarFill.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
            Instance.new("UICorner", BarFill)

            local function update()
                local percent = math.clamp((Mouse.X - BarBack.AbsolutePosition.X) / BarBack.AbsoluteSize.X, 0, 1)
                BarFill.Size = UDim2.new(percent, 0, 1, 0)
                local value = math.floor(min + (max - min) * percent)
                Label.Text = "   " .. text .. ": " .. value
                callback(value)
            end

            local dragging = false
            BarBack.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            RunService.RenderStepped:Connect(function() if dragging then update() end end)
        end

        return Elements
    end
    return Tabs
end

return SaldHub
