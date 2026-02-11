local SaldLib = {}

function SaldLib:CreateWindow()
    local UserInputService = game:GetService("UserInputService")
    
    -- Limpeza de UI antiga
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "SaldHub_Final" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SaldHub_Final"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Botão Flutuante (Arredondado)
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Parent = ScreenGui
    OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    OpenBtn.Size = UDim2.new(0, 50, 0, 50)
    OpenBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
    OpenBtn.Text = "SALD"
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenBtn.TextSize = 12
    OpenBtn.Draggable = true
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 12)

    -- Janela Principal
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.3, 0, 0.2, 0)
    Main.Visible = false
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

    OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    -- Header
    local Title = Instance.new("TextLabel")
    Title.Parent = Main
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = "SALD HUB | CUSTOM UI"
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Container de Abas (Horizontal Scroll)
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Parent = Main
    TabScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabScroll.Position = UDim2.new(0, 0, 0, 35)
    TabScroll.Size = UDim2.new(1, 0, 0, 32)
    TabScroll.ScrollBarThickness = 0
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X

    local TabList = Instance.new("UIListLayout", TabScroll)
    TabList.FillDirection = Enum.FillDirection.Horizontal

    -- Container de Conteúdo
    local Content = Instance.new("Frame")
    Content.Parent = Main
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 10, 0, 75)
    Content.Size = UDim2.new(1, -20, 1, -85)

    local function NoBlue(obj)
        obj.SelectionImageObject = Instance.new("Frame")
        obj.SelectionImageObject.Transparency = 1
    end

    local Tabs = {}

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabScroll
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Size = UDim2.new(0, 100, 1, 0)
        TabBtn.BorderSizePixel = 1
        TabBtn.BorderColor3 = Color3.fromRGB(45, 45, 45)
        TabBtn.Text = name:upper()
        TabBtn.Font = Enum.Font.SourceSansBold
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.TextSize = 14
        NoBlue(TabBtn)

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = Content
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Content:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
            for _, t in pairs(TabScroll:GetChildren()) do if t:IsA("TextButton") then t.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)

        local Elements = {}

        function Elements:CreateToggle(text, callback)
            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(1, 0, 0, 35)
            Tgl.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Tgl.BorderSizePixel = 1
            Tgl.BorderColor3 = Color3.fromRGB(40, 40, 40)
            Tgl.Text = "   " .. text
            Tgl.Font = Enum.Font.SourceSansBold
            Tgl.TextColor3 = Color3.fromRGB(200, 200, 200)
            Tgl.TextSize = 15
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Tgl.Parent = Page
            NoBlue(Tgl)

            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 18, 0, 18)
            Box.Position = UDim2.new(1, -25, 0.5, -9)
            Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Box.Parent = Tgl
            
            local Check = Instance.new("Frame")
            Check.Size = UDim2.new(1, -6, 1, -6)
            Check.Position = UDim2.new(0, 3, 0, 3)
            Check.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Check.BackgroundTransparency = 1
            Check.Parent = Box

            local on = false
            Tgl.MouseButton1Click:Connect(function()
                on = not on
                Check.BackgroundTransparency = on and 0 or 1
                callback(on)
            end)
        end

        function Elements:CreateInput(text, placeholder, callback)
            local IFrame = Instance.new("Frame")
            IFrame.Size = UDim2.new(1, 0, 0, 35)
            IFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            IFrame.BorderSizePixel = 1
            IFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
            IFrame.Parent = Page

            local Lab = Instance.new("TextLabel")
            Lab.Size = UDim2.new(0, 100, 1, 0)
            Lab.Position = UDim2.new(0, 10, 0, 0)
            Lab.Text = text
            Lab.TextColor3 = Color3.fromRGB(255, 255, 255)
            Lab.BackgroundTransparency = 1
            Lab.Font = Enum.Font.SourceSansBold
            Lab.TextSize = 15
            Lab.TextXAlignment = Enum.TextXAlignment.Left
            Lab.Parent = IFrame

            local Box = Instance.new("TextBox")
            Box.Size = UDim2.new(0, 150, 0, 25)
            Box.Position = UDim2.new(1, -160, 0.5, -12)
            Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Box.Text = ""
            Box.PlaceholderText = placeholder
            Box.TextColor3 = Color3.fromRGB(255, 255, 255)
            Box.Parent = IFrame
            NoBlue(Box)
            Box.FocusLost:Connect(function() callback(Box.Text) end)
        end

        function Elements:CreateSlider(text, min, max, callback)
            local SFrame = Instance.new("Frame")
            SFrame.Size = UDim2.new(1, 0, 0, 50)
            SFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            SFrame.BorderSizePixel = 1
            SFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
            SFrame.Parent = Page

            local Lab = Instance.new("TextLabel")
            Lab.Size = UDim2.new(1, 0, 0, 25)
            Lab.Position = UDim2.new(0, 10, 0, 0)
            Lab.Text = text .. ": " .. min
            Lab.TextColor3 = Color3.fromRGB(255, 255, 255)
            Lab.BackgroundTransparency = 1
            Lab.Font = Enum.Font.SourceSansBold
            Lab.TextSize = 15
            Lab.TextXAlignment = Enum.TextXAlignment.Left
            Lab.Parent = SFrame

            local Rail = Instance.new("TextButton")
            Rail.Size = UDim2.new(1, -20, 0, 6)
            Rail.Position = UDim2.new(0, 10, 0, 32)
            Rail.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Rail.Text = ""
            Rail.Parent = SFrame
            NoBlue(Rail)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new(0, 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Fill.Parent = Rail

            local function Upd()
                local p = math.clamp((UserInputService:GetMouseLocation().X - Rail.AbsolutePosition.X) / Rail.AbsoluteSize.X, 0, 1)
                local v = math.floor(min + (max - min) * p)
                Fill.Size = UDim2.new(p, 0, 1, 0)
                Lab.Text = text .. ": " .. v
                callback(v)
            end

            Rail.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    local mv = UserInputService.InputChanged:Connect(function(io)
                        if io.UserInputType == Enum.UserInputType.MouseMovement or io.UserInputType == Enum.UserInputType.Touch then Upd() end
                    end)
                    i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then mv:Disconnect() end end)
                    Upd()
                end
            end)
        end

        return Elements
    end
    return Tabs
end

return SaldLib

