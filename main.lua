local SaldHub = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Função de Arraste Real
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
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
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function SaldHub:CreateWindow()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SaldHub"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    -- Botão "S" (Gradiente Azul/Cinza)
    local LogoS = Instance.new("TextButton", ScreenGui)
    LogoS.Size = UDim2.new(0, 50, 0, 50)
    LogoS.Position = UDim2.new(0, 50, 0, 50)
    LogoS.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    LogoS.Text = "S"
    LogoS.Font = "GothamBold"; LogoS.TextSize = 30; LogoS.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", LogoS).CornerRadius = UDim.new(0, 10)
    local g = Instance.new("UIGradient", LogoS)
    g.Color = ColorSequence.new(Color3.fromRGB(0, 80, 200), Color3.fromRGB(60, 60, 60))
    g.Rotation = 90
    MakeDraggable(LogoS)

    -- Menu Principal
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    MakeDraggable(Main)

    LogoS.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    -- Sidebar e Conteúdo
    local Sidebar = Instance.new("ScrollingFrame", Main)
    Sidebar.Position = UDim2.new(0, 10, 0, 50); Sidebar.Size = UDim2.new(0, 170, 1, -60)
    Sidebar.BackgroundTransparency = 1; Sidebar.ScrollBarThickness = 0
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 190, 0, 50); Container.Size = UDim2.new(1, -200, 1, -60)
    Container.BackgroundTransparency = 1

    local First = true
    function SaldHub:CreateTab(name)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 35); TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "        " .. name; TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = "Gotham"; TabBtn.TextSize = 14; TabBtn.TextXAlignment = "Left"
        
        -- Ícone de Mouse (ImageLabel)
        local Icon = Instance.new("ImageLabel", TabBtn)
        Icon.Size = UDim2.new(0, 16, 0, 16); Icon.Position = UDim2.new(0, 5, 0.5, -8)
        Icon.BackgroundTransparency = 1; Icon.Image = "rbxassetid://6031225818" -- ID de Mouse/Cursor
        Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)

        local Bar = Instance.new("Frame", TabBtn)
        Bar.Size = UDim2.new(0, 3, 0.6, 0); Bar.Position = UDim2.new(0, 0, 0.2, 0)
        Bar.BackgroundColor3 = Color3.fromRGB(0, 80, 200); Bar.Visible = false

        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do v.Visible = false end
            for _, v in pairs(Sidebar:GetChildren()) do 
                if v:IsA("TextButton") then 
                    v.TextColor3 = Color3.fromRGB(150, 150, 150) 
                    v.Frame.Visible = false 
                    v.ImageLabel.ImageColor3 = Color3.fromRGB(150, 150, 150)
                end 
            end
            Page.Visible = true; Bar.Visible = true; TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255); Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end)

        if First then TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255); Bar.Visible = true; Page.Visible = true; Icon.ImageColor3 = Color3.fromRGB(255, 255, 255); First = false end

        local Elements = {}

        function Elements:CreateButton(text, cb)
            local b = Instance.new("TextButton", Page)
            b.Size = UDim2.new(1, -5, 0, 35); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            b.Text = "        " .. text; b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = "Gotham"; b.TextSize = 14; b.TextXAlignment = "Left"
            Instance.new("UICorner", b)
            
            local BIcon = Instance.new("ImageLabel", b)
            BIcon.Size = UDim2.new(0, 16, 0, 16); BIcon.Position = UDim2.new(0, 8, 0.5, -8)
            BIcon.BackgroundTransparency = 1; BIcon.Image = "rbxassetid://6031225818"
            
            b.MouseButton1Click:Connect(cb)
        end

        function Elements:CreateSlider(text, min, max, cb)
            local s = Instance.new("Frame", Page)
            s.Size = UDim2.new(1, -5, 0, 50); s.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Instance.new("UICorner", s)

            local l = Instance.new("TextLabel", s)
            l.Size = UDim2.new(1, -10, 0, 25); l.Position = UDim2.new(0, 10, 0, 0)
            l.BackgroundTransparency = 1; l.Text = text .. " [ " .. min .. " ]"; l.TextColor3 = Color3.fromRGB(255, 255, 255)
            l.Font = "Gotham"; l.TextSize = 13; l.TextXAlignment = "Left"

            local b = Instance.new("TextButton", s) -- Botão invisível para capturar o clique no slider
            b.Size = UDim2.new(1, -20, 0, 6); b.Position = UDim2.new(0, 10, 0.7, 0)
            b.BackgroundColor3 = Color3.fromRGB(50, 50, 50); b.Text = ""
            Instance.new("UICorner", b)

            local f = Instance.new("Frame", b)
            f.Size = UDim2.new(0, 0, 1, 0); f.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
            Instance.new("UICorner", f)

            local function update()
                local mousePos = UserInputService:GetMouseLocation().X
                local relativeX = math.clamp(mousePos - b.AbsolutePosition.X, 0, b.AbsoluteSize.X)
                local percent = relativeX / b.AbsoluteSize.X
                f.Size = UDim2.new(percent, 0, 1, 0)
                local val = math.floor(min + (max - min) * percent)
                l.Text = text .. " [ " .. val .. " ]"
                cb(val)
            end

            local dragging = false
            b.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    update()
                end
            end)
            
            UserInputService.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    update()
                end
            end)

            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
        end

        function Elements:CreateToggle(text, cb)
            local t = Instance.new("TextButton", Page)
            t.Size = UDim2.new(1, -5, 0, 35); t.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            t.Text = "   " .. text; t.TextColor3 = Color3.fromRGB(255, 255, 255); t.TextXAlignment = "Left"; t.Font = "Gotham"; t.TextSize = 14
            Instance.new("UICorner", t)
            
            local box = Instance.new("Frame", t)
            box.Size = UDim2.new(0, 30, 0, 16); box.Position = UDim2.new(1, -40, 0.5, -8); box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Instance.new("UICorner", box).CornerRadius = UDim.new(1,0)
            
            local ball = Instance.new("Frame", box)
            ball.Size = UDim2.new(0, 12, 0, 12); ball.Position = UDim2.new(0, 2, 0.5, -6); ball.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

            local on = false
            t.MouseButton1Click:Connect(function()
                on = not on
                box.BackgroundColor3 = on and Color3.fromRGB(0, 80, 200) or Color3.fromRGB(50, 50, 50)
                TweenService:Create(ball, TweenInfo.new(0.2), {Position = on and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
                cb(on)
            end)
        end

        return Elements
    end
    return SaldHub
end

return SaldHub

