local SaldLib = {}

function SaldLib:CreateWindow()
    -- Limpeza
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "SaldHub_Final" then v:Destroy() end
    end

    local UserInputService = game:GetService("UserInputService")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SaldHub_Final"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- BOTÃO FLUTUANTE (ABRIR/FECHAR)
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Name = "OpenBtn"
    OpenBtn.Parent = ScreenGui
    OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    OpenBtn.BorderSizePixel = 0
    OpenBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
    OpenBtn.Size = UDim2.new(0, 50, 0, 50)
    OpenBtn.Text = "SALD"
    OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 12
    OpenBtn.Draggable = true -- Facilita no Mobile
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 12)
    BtnCorner.Parent = OpenBtn

    -- JANELA PRINCIPAL
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.3, 0, 0.2, 0)
    Main.Size = UDim2.new(0, 450, 0, 320)
    Main.Visible = false
    Main.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 4)
    MainCorner.Parent = Main

    -- Toggle de Abrir/Fechar
    OpenBtn.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    -- HEADER
    local Title = Instance.new("TextLabel")
    Title.Parent = Main
    Title.Size = UDim2.new(1, -10, 0, 35)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Text = "SALD HUB | BLOX FRUITS"
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- TABS
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = Main
    TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 35)
    TabContainer.Size = UDim2.new(1, 0, 0, 30)
    TabContainer.ScrollBarThickness = 0
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.FillDirection = Enum.FillDirection.Horizontal

    -- CONTEUDO
    local Content = Instance.new("Frame")
    Content.Parent = Main
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 10, 0, 75)
    Content.Size = UDim2.new(1, -20, 1, -85)

    -- ARRASTAR (Lógica Universal)
    local function Drag(obj)
        local dragging, input, startPos, startInputPos
        obj.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                startInputPos = i.Position
                startPos = obj.Position
            end
        end)
        obj.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local delta = i.Position - startInputPos
                obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end
    Drag(Main)

    local function NoBlue(obj)
        obj.SelectionImageObject = Instance.new("Frame")
        obj.SelectionImageObject.Transparency = 1
    end

    local Tabs = {}

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabContainer
        TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabBtn.BorderSizePixel = 1
        TabBtn.BorderColor3 = Color3.fromRGB(50, 50, 50)
        TabBtn.Size = UDim2.new(0, 100, 1, 0)
        TabBtn.Font = Enum.Font.SourceSansBold
        TabBtn.Text = name:upper()
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
            for _, t in pairs(TabContainer:GetChildren()) do if t:IsA("TextButton") then t.BackgroundColor3 = Color3.fromRGB(35, 35, 35) end end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)

        local Elements = {}

        function Elements:CreateToggle(text, callback)
            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(1, 0, 0, 35)
            Tgl.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Tgl.BorderSizePixel = 1
            Tgl.BorderColor3 = Color3.fromRGB(40, 40, 40)
            Tgl.Text = "   " .. text
            Tgl.TextColor3 = Color3.fromRGB(200, 200, 200)
            Tgl.Font = Enum.Font.SourceSansBold
            Tgl.TextSize = 15
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            NoBlue(Tgl)
            Tgl.Parent = Page

            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 18, 0, 18)
            Box.Position = UDim2.new(1, -25, 0.5, -9)
            Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Box.BorderSizePixel = 1
            Box.BorderColor3 = Color3.fromRGB(60, 60, 60)
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

        function Elements:CreateButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Btn.BorderSizePixel = 1
            Btn.BorderColor3 = Color3.fromRGB(60, 60, 60)
            Btn.Text = text
            Btn.Font = Enum.Font.SourceSansBold
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextSize = 15
            NoBlue(Btn)
            Btn.Parent = Page
            Btn.MouseButton1Click:Connect(callback)
        end

        return Elements
    end
    return Tabs
end

-----------------------------------------------------------
-- COMO USAR A LIBRARY (EXEMPLO)
-----------------------------------------------------------

local Window = SaldLib:CreateWindow()

local FarmTab = Window:CreateTab("Farm")
local MiscTab = Window:CreateTab("Misc")

FarmTab:CreateToggle("Auto Farm Level", function(state)
    print("Status:", state)
end)

FarmTab:CreateButton("Distancia do Farm", function()
    print("Ajustado!")
end)

MiscTab:CreateButton("Redeem All Codes", function()
    print("Codigos!")
end)

