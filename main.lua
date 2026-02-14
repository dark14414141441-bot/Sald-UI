local SaldHub = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Função de Arraste Real (Mobile e PC)
local function Drag(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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

    -- Botão "S" (Gradiente Azul/Cinza)
    local Logo = Instance.new("TextButton")
    Logo.Name = "Logo"
    Logo.Parent = ScreenGui
    Logo.Size = UDim2.new(0, 55, 0, 55)
    Logo.Position = UDim2.new(0, 50, 0, 50)
    Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Logo.BorderSizePixel = 0
    Logo.Text = "S"
    Logo.Font = Enum.Font.GothamBold
    Logo.TextSize = 35
    Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Logo).CornerRadius = UDim.new(0, 10)
    local grad = Instance.new("UIGradient", Logo)
    grad.Color = ColorSequence.new(Color3.fromRGB(0, 80, 200), Color3.fromRGB(60, 60, 60))
    grad.Rotation = 90
    Drag(Logo)

    -- Main Menu (500x350)
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    Drag(Main)

    Logo.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    local Title = Instance.new("TextLabel", Main)
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.Size = UDim2.new(0, 300, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Text = "Sald Hub <font color='#555555'>| Blox Fruits</font>"
    Title.RichText = true
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = "Left"

    local Sidebar = Instance.new("ScrollingFrame", Main)
    Sidebar.Position = UDim2.new(0, 10, 0, 50)
    Sidebar.Size = UDim2.new(0, 160, 1, -60)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 0
    local sbl = Instance.new("UIListLayout", Sidebar)
    sbl.Padding = UDim.new(0, 5)

    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 180, 0, 50)
    Container.Size = UDim2.new(1, -190, 1, -60)
    Container.BackgroundTransparency = 1

    function SaldHub:CreateTab(name)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, -10, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "  " .. name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 15
        TabBtn.TextXAlignment = "Left"

        local Bar = Instance.new("Frame", TabBtn)
        Bar.Size = UDim2.new(0, 3, 0.6, 0)
        Bar.Position = UDim2.new(0, 0, 0.2, 0)
        Bar.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
        Bar.Visible = false

        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do v.Visible = false end
            for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) v.Frame.Visible = false end end
            Page.Visible = true; Bar.Visible = true; TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local Elements = {}

        -- TOGGLE (Estilo Switch)
        function Elements:CreateToggle(text, cb)
            local Tgl = Instance.new("TextButton", Page)
            Tgl.Size = UDim2.new(1, -10, 0, 38)
            Tgl.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Tgl.Text = "   " .. text
            Tgl.TextColor3 = Color3.fromRGB(255, 255, 255)
            Tgl.Font = Enum.Font.Gotham; Tgl.TextSize = 14; Tgl.TextXAlignment = "Left"
            Instance.new("UICorner", Tgl)

            local Switch = Instance.new("Frame", Tgl)
            Switch.Size = UDim2.new(0, 35, 0, 18); Switch.Position = UDim2.new(1, -45, 0.5, -9); Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

            local Circle = Instance.new("Frame", Switch)
            Circle.Size = UDim2.new(0, 14, 0, 14); Circle.Position = UDim2.new(0, 2, 0.5, -7); Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            local state = false
            Tgl.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
                Switch.BackgroundColor3 = state and Color3.fromRGB(0, 80, 200) or Color3.fromRGB(50, 50, 50)
                cb(state)
            end)
        end

        -- SLIDER
        function Elements:CreateSlider(text, min, max, cb)
            local Sld = Instance.new("Frame", Page)
            Sld.Size = UDim2.new(1, -10, 0, 50); Sld.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Instance.new("UICorner", Sld)

            local Txt = Instance.new("TextLabel", Sld)
            Txt.Text = "   " .. text; Txt.Size = UDim2.new(1, 0, 0, 25); Txt.TextColor3 = Color3.fromRGB(200, 200, 200); Txt.BackgroundTransparency = 1; Txt.Font = "Gotham"; Txt.TextSize = 13; Txt.TextXAlignment = "Left"

            local Bar = Instance.new("Frame", Sld)
            Bar.Size = UDim2.new(1, -20, 0, 4); Bar.Position = UDim2.new(0, 10, 1, -12); Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Instance.new("UICorner", Bar)

            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new(0, 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
            Instance.new("UICorner", Fill)

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local function update()
                        local percent = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        Fill.Size = UDim2.new(percent, 0, 1, 0)
                        cb(math.floor(min + (max - min) * percent))
                    end
                    update()
                    local move = UserInputService.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
                    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end end)
                end
            end)
        end

        -- INPUT
        function Elements:CreateInput(text, cb)
            local Inp = Instance.new("TextBox", Page)
            Inp.Size = UDim2.new(1, -10, 0, 38); Inp.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Inp.PlaceholderText = "   " .. text; Inp.Text = ""; Inp.TextColor3 = Color3.fromRGB(255, 255, 255); Inp.Font = "Gotham"; Inp.TextSize = 14; Inp.TextXAlignment = "Left"
            Instance.new("UICorner", Inp)
            Inp.FocusLost:Connect(function() cb(Inp.Text) end)
        end

        function Elements:CreateButton(text, cb)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, -10, 0, 38); Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Btn.Text = text; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = "GothamMedium"; Btn.TextSize = 14
            Instance.new("UICorner", Btn)
            Btn.MouseButton1Click:Connect(cb)
        end

        return Elements
    end
    return SaldHub
end

return SaldHub

