local SaldHub = {
    Tabs = {},
    CurrentTab = nil
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Função para tornar qualquer frame arrastável (Real)
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

function SaldHub:CreateWindow()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SaldHub"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- BOTÃO FLUTUANTE "S" (Azul e Cinza conforme a imagem)
    local LogoBtn = Instance.new("TextButton")
    LogoBtn.Name = "Logo"
    LogoBtn.Parent = ScreenGui
    LogoBtn.Size = UDim2.new(0, 50, 0, 50)
    LogoBtn.Position = UDim2.new(0, 50, 0, 50)
    LogoBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    LogoBtn.BorderSizePixel = 0
    LogoBtn.Text = "S"
    LogoBtn.Font = Enum.Font.GothamBold
    LogoBtn.TextSize = 35
    Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(0, 10)
    local grad = Instance.new("UIGradient", LogoBtn)
    grad.Color = ColorSequence.new(Color3.fromRGB(0, 80, 200), Color3.fromRGB(100, 100, 100))
    grad.Rotation = 90
    MakeDraggable(LogoBtn)

    -- MENU (Tamanho exato da imagem)
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BackgroundTransparency = 0.02 -- Opaco
    Main.BorderSizePixel = 0
    Main.Visible = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    MakeDraggable(Main)

    -- Toggle Menu
    LogoBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    -- Título e Subtítulo
    local Title = Instance.new("TextLabel")
    Title.Parent = Main
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.Size = UDim2.new(0, 300, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Text = "Sald Hub <font color='#555555'>| Blox Fruits</font>"
    Title.RichText = true
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Parent = Main
    Sidebar.Position = UDim2.new(0, 10, 0, 50)
    Sidebar.Size = UDim2.new(0, 160, 1, -60)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 0
    local sbl = Instance.new("UIListLayout", Sidebar)
    sbl.Padding = UDim.new(0, 5)

    local Container = Instance.new("Frame")
    Container.Parent = Main
    Container.Position = UDim2.new(0, 180, 0, 50)
    Container.Size = UDim2.new(1, -190, 1, -60)
    Container.BackgroundTransparency = 1

    function SaldHub:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = Sidebar
        TabBtn.Size = UDim2.new(1, -10, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "  " .. name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left

        local Bar = Instance.new("Frame", TabBtn)
        Bar.Size = UDim2.new(0, 3, 0.6, 0)
        Bar.Position = UDim2.new(0, 0, 0.2, 0)
        Bar.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
        Bar.Visible = false

        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do v.Visible = false end
            for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) v.Frame.Visible = false end end
            Page.Visible = true
            Bar.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local Elements = {}

        -- TOGGLE
        function Elements:CreateToggle(text, cb)
            local Tgl = Instance.new("TextButton", Page)
            Tgl.Size = UDim2.new(1, -10, 0, 35)
            Tgl.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Tgl.Text = "   " .. text
            Tgl.TextColor3 = Color3.fromRGB(200, 200, 200)
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Tgl.Font = Enum.Font.Gotham
            Tgl.TextSize = 14
            Instance.new("UICorner", Tgl)

            local Box = Instance.new("Frame", Tgl)
            Box.Size = UDim2.new(0, 18, 0, 18)
            Box.Position = UDim2.new(1, -25, 0.5, -9)
            Box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Instance.new("UICorner", Box)

            local on = false
            Tgl.MouseButton1Click:Connect(function()
                on = not on
                Box.BackgroundColor3 = on and Color3.fromRGB(0, 80, 200) or Color3.fromRGB(50, 50, 50)
                cb(on)
            end)
        end

        -- SLIDER
        function Elements:CreateSlider(text, min, max, cb)
            local Sld = Instance.new("Frame", Page)
            Sld.Size = UDim2.new(1, -10, 0, 45)
            Sld.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Instance.new("UICorner", Sld)

            local Lab = Instance.new("TextLabel", Sbl) -- Label
            Lab.Parent = Sld; Lab.Text = "   " .. text; Lab.Size = UDim2.new(1, 0, 0, 20); Lab.BackgroundTransparency = 1; Lab.TextColor3 = Color3.fromRGB(200, 200, 200); Lab.TextXAlignment = "Left"; Lab.Font = "Gotham"; Lab.TextSize = 12

            local MainS = Instance.new("Frame", Sld)
            MainS.Size = UDim2.new(1, -20, 0, 4); MainS.Position = UDim2.new(0, 10, 1, -10); MainS.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            
            local Fill = Instance.new("Frame", MainS)
            Fill.Size = UDim2.new(0.5, 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 80, 200)

            -- Lógica básica de Slider
            MainS.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local move = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            local percent = math.clamp((input.Position.X - MainS.AbsolutePosition.X) / MainS.AbsoluteSize.X, 0, 1)
                            Fill.Size = UDim2.new(percent, 0, 1, 0)
                            cb(math.floor(min + (max - min) * percent))
                        end
                    end)
                    input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then move:Disconnect() end end)
                end
            end)
        end

        -- INPUT
        function Elements:CreateInput(text, cb)
            local Inp = Instance.new("TextBox", Page)
            Inp.Size = UDim2.new(1, -10, 0, 35)
            Inp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Inp.Text = ""
            Inp.PlaceholderText = "   " .. text
            Inp.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
            Inp.TextColor3 = Color3.fromRGB(255, 255, 255)
            Inp.TextXAlignment = Enum.TextXAlignment.Left
            Inp.Font = Enum.Font.Gotham
            Inp.TextSize = 14
            Instance.new("UICorner", Inp)
            Inp.FocusLost:Connect(function() cb(Inp.Text) end)
        end

        return Elements
    end
    return SaldHub
end

return SaldHub
