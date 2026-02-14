local SaldHub = {}

function SaldHub:CreateWindow()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local LogoBtn = Instance.new("TextButton")
    local LogoCorner = Instance.new("UICorner")
    local LogoGradient = Instance.new("UIGradient")
    local Sidebar = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local Title = Instance.new("TextLabel")
    local ContentContainer = Instance.new("Frame")

    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "SaldHub_Lib"
    ScreenGui.ResetOnSpawn = false

    -- --- BOTÃO "S" (LOGO) ---
    LogoBtn.Name = "S_Logo"
    LogoBtn.Parent = ScreenGui
    LogoBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LogoBtn.Position = UDim2.new(0, 50, 0, 50)
    LogoBtn.Size = UDim2.new(0, 55, 0, 55)
    LogoBtn.Font = Enum.Font.GothamBold
    LogoBtn.Text = "S"
    LogoBtn.TextSize = 35
    LogoBtn.Active = true
    LogoBtn.Draggable = true 

    LogoCorner.CornerRadius = UDim.new(0, 15)
    LogoCorner.Parent = LogoBtn

    LogoGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 80, 200)), -- Azul
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))  -- Cinza
    })
    LogoGradient.Rotation = 45
    LogoGradient.Parent = LogoBtn

    -- --- MENU PRINCIPAL ---
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 550, 0, 350)
    MainFrame.Visible = true
    MainFrame.Active = true
    MainFrame.Draggable = true

    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    -- Título Sald Hub
    Title.Parent = MainFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 20, 0, 10)
    Title.Size = UDim2.new(0, 200, 0, 30)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Sald <font color='#0050C8'>Hub</font>"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.RichText = true
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Sidebar
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundTransparency = 1
    Sidebar.Position = UDim2.new(0, 10, 0, 50)
    Sidebar.Size = UDim2.new(0, 160, 1, -60)
    Sidebar.ScrollBarThickness = 0

    UIListLayout.Parent = Sidebar
    UIListLayout.Padding = UDim.new(0, 5)

    -- Container de Conteúdo (Onde os scripts aparecem)
    ContentContainer.Name = "Content"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 180, 0, 50)
    ContentContainer.Size = UDim2.new(1, -190, 1, -60)

    -- Toggle Menu
    LogoBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    local Tabs = {}
    local FirstTab = true

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        local TabCorner = Instance.new("UICorner")
        local TabPage = Instance.new("ScrollingFrame")
        local TabList = Instance.new("UIListLayout")

        -- Botão da Aba
        TabBtn.Parent = Sidebar
        TabBtn.Size = UDim2.new(1, -10, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.Text = "  " .. name
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left

        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabBtn

        -- Página da Aba
        TabPage.Name = name .. "Page"
        TabPage.Parent = ContentContainer
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 2
        
        TabList.Parent = TabPage
        TabList.Padding = UDim.new(0, 8)

        if FirstTab then
            TabPage.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(0, 80, 200)
            FirstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentContainer:GetChildren()) do
                v.Visible = false
            end
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(180, 180, 180) end
            end
            TabPage.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(0, 80, 200)
        end)

        local Elements = {}
        
        function Elements:CreateButton(text, callback)
            local b = Instance.new("TextButton")
            local bc = Instance.new("UICorner")
            b.Parent = TabPage
            b.Size = UDim2.new(1, -10, 0, 40)
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            b.Font = Enum.Font.GothamMedium
            b.Text = text
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.TextSize = 14
            bc.CornerRadius = UDim.new(0, 8)
            bc.Parent = b
            
            b.MouseButton1Click:Connect(function()
                callback()
            end)
        end

        return Elements
    end

    return Tabs
end

-- --- EXEMPLO DE USO DA LIB ---
local lib = SaldHub:CreateWindow()

local Tab1 = lib:CreateTab("Main")
Tab1:CreateButton("Auto Farm (Exemplo)", function()
    print("Auto Farm Ativado!")
end)

local Tab2 = lib:CreateTab("Farming")
Tab2:CreateButton("Farm Baús", function()
    print("Farmando Baús...")
end)

local Tab3 = lib:CreateTab("Settings")
Tab3:CreateButton("Destruir UI", function()
    game.Players.LocalPlayer.PlayerGui.SaldHub_Lib:Destroy()
end)

