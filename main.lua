local SaldLib = {}
local UserInputService = game:GetService("UserInputService")

function SaldLib:CreateWindow()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "SaldHub_Final" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SaldHub_Final"
    ScreenGui.Parent = game.CoreGui

    -- BOTÃO FLUTUANTE (ABRIR/FECHAR)
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Parent = ScreenGui
    OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    OpenBtn.Size = UDim2.new(0, 60, 0, 60)
    OpenBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
    OpenBtn.Text = "SALD"
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenBtn.TextSize = 14
    OpenBtn.Draggable = true
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 15)

    -- JANELA PRINCIPAL (Aumentada para 550x400)
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.Size = UDim2.new(0, 550, 0, 400) -- MENU MAIOR
    Main.Position = UDim2.new(0.3, 0, 0.2, 0)
    Main.Visible = false
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    -- CONTAINER DE TABS COM DIVISÃO
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Parent = Main
    TabScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabScroll.Position = UDim2.new(0, 0, 0, 40)
    TabScroll.Size = UDim2.new(1, 0, 0, 45) -- TABS MAIORES
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabScroll.ScrollBarThickness = 2
    TabScroll.BorderSizePixel = 0

    local TabList = Instance.new("UIListLayout", TabScroll)
    TabList.FillDirection = Enum.FillDirection.Horizontal

    local Content = Instance.new("Frame")
    Content.Parent = Main
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 15, 0, 100)
    Content.Size = UDim2.new(1, -30, 1, -115)

    local function NoBlue(obj)
        obj.SelectionImageObject = Instance.new("Frame")
        obj.SelectionImageObject.Transparency = 1
    end

    local Tabs = {}
    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabScroll
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TabBtn.Size = UDim2.new(0, 120, 1, 0)
        TabBtn.BorderSizePixel = 1 -- LINHA DE DIVISÃO
        TabBtn.BorderColor3 = Color3.fromRGB(60, 60, 60) -- COR DA DIVISÃO
        TabBtn.Text = name:upper()
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.TextSize = 14
        NoBlue(TabBtn)

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = Content
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 4
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Content:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
            Page.Visible = true
        end)

        local Elements = {}

        -- INPUT COM TEXTO GRANDE
        function Elements:CreateInput(text, placeholder, callback)
            local IFrame = Instance.new("Frame")
            IFrame.Size = UDim2.new(1, 0, 0, 50)
            IFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            IFrame.Parent = Page
            Instance.new("UICorner", IFrame)

            local Lab = Instance.new("TextLabel")
            Lab.Size = UDim2.new(0, 150, 1, 0)
            Lab.Position = UDim2.new(0, 15, 0, 0)
            Lab.Text = text
            Lab.TextColor3 = Color3.fromRGB(255, 255, 255)
            Lab.TextSize = 16 -- TEXTO MAIOR
            Lab.Font = Enum.Font.GothamBold
            Lab.BackgroundTransparency = 1
            Lab.TextXAlignment = Enum.TextXAlignment.Left
            Lab.Parent = IFrame

            local Box = Instance.new("TextBox")
            Box.Size = UDim2.new(0, 200, 0, 35)
            Box.Position = UDim2.new(1, -215, 0.5, -17)
            Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Box.TextSize = 16 -- INPUT MAIOR
            Box.TextColor3 = Color3.fromRGB(255, 255, 255)
            Box.PlaceholderText = placeholder
            Box.Font = Enum.Font.Gotham
            Box.Parent = IFrame
            Instance.new("UICorner", Box)
            
            Box.FocusLost:Connect(function() callback(Box.Text) end)
        end

        function Elements:CreateToggle(text, callback)
            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(1, 0, 0, 45)
            Tgl.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Tgl.Text = "    " .. text
            Tgl.Font = Enum.Font.GothamBold
            Tgl.TextColor3 = Color3.fromRGB(255, 255, 255)
            Tgl.TextSize = 16
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Tgl.Parent = Page
            Instance.new("UICorner", Tgl)
            
            local on = false
            Tgl.MouseButton1Click:Connect(function()
                on = not on
                Tgl.BackgroundColor3 = on and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
                callback(on)
            end)
        end

        return Elements
    end
    return Tabs
end

return SaldLib

