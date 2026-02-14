local SaldHub = {}
local TweenService = game:GetService("TweenService")

function SaldHub:CreateWindow()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SaldHub_Lib"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    -- --- BOTÃO FLUTUANTE "S" (REFEITO) ---
    local LogoBtn = Instance.new("TextButton")
    local LogoCorner = Instance.new("UICorner")
    local LogoStroke = Instance.new("UIStroke")
    
    LogoBtn.Name = "S_Logo"
    LogoBtn.Parent = ScreenGui
    LogoBtn.Size = UDim2.new(0, 60, 0, 60)
    LogoBtn.Position = UDim2.new(0, 20, 0, 20)
    LogoBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    LogoBtn.Font = Enum.Font.GothamBold
    LogoBtn.Text = "S"
    LogoBtn.TextColor3 = Color3.fromRGB(0, 100, 255)
    LogoBtn.TextSize = 30
    LogoBtn.Draggable = true

    LogoCorner.CornerRadius = UDim.new(1, 0)
    LogoCorner.Parent = LogoBtn
    
    LogoStroke.Thickness = 2
    LogoStroke.Color = Color3.fromRGB(0, 80, 200)
    LogoStroke.Parent = LogoBtn

    -- --- MENU PRINCIPAL ---
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 580, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.Visible = true
    MainFrame.Draggable = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    -- Título e Subtítulo
    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.Position = UDim2.new(0, 20, 0, 15)
    Title.Size = UDim2.new(0, 200, 0, 30)
    Title.RichText = true
    Title.Text = "Sald <font color='#0064FF'>Hub</font> <font color='#555555'>| v1.0</font>"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Parent = MainFrame
    Sidebar.Position = UDim2.new(0, 10, 0, 60)
    Sidebar.Size = UDim2.new(0, 160, 1, -80)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 0

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.Padding = UDim.new(0, 5)

    local Container = Instance.new("Frame")
    Container.Parent = MainFrame
    Container.Position = UDim2.new(0, 180, 0, 60)
    Container.Size = UDim2.new(1, -195, 1, -75)
    Container.BackgroundTransparency = 1

    LogoBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    local Tabs = {}
    local First = true

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        local TabBar = Instance.new("Frame")
        local Page = Instance.new("ScrollingFrame")
        local PageLayout = Instance.new("UIListLayout")

        TabBtn.Parent = Sidebar
        TabBtn.Size = UDim2.new(1, -10, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "   " .. name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left

        TabBar.Parent = TabBtn
        TabBar.Size = UDim2.new(0, 3, 0.6, 0)
        TabBar.Position = UDim2.new(0, 0, 0.2, 0)
        TabBar.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
        TabBar.Visible = false

        Page.Parent = Container
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        
        PageLayout.Parent = Page
        PageLayout.Padding = UDim.new(0, 8)

        if First then
            Page.Visible = true
            TabBar.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            First = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do v.Visible = false end
            for _, v in pairs(Sidebar:GetChildren()) do 
                if v:IsA("TextButton") then 
                    v.TextColor3 = Color3.fromRGB(150, 150, 150) 
                    v.Frame.Visible = false 
                end 
            end
            Page.Visible = true
            TabBar.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local Elements = {}

        -- BOTÃO
        function Elements:CreateButton(txt, cb)
            local b = Instance.new("TextButton")
            b.Parent = Page
            b.Size = UDim2.new(1, -10, 0, 40)
            b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            b.Text = txt
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.Font = Enum.Font.GothamMedium
            b.TextSize = 14
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            b.MouseButton1Click:Connect(cb)
        end

        -- TOGGLE
        function Elements:CreateToggle(txt, cb)
            local t = Instance.new("TextButton")
            local box = Instance.new("Frame")
            local state = false
            t.Parent = Page
            t.Size = UDim2.new(1, -10, 0, 40)
            t.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            t.Text = "   " .. txt
            t.TextColor3 = Color3.fromRGB(255, 255, 255)
            t.Font = Enum.Font.GothamMedium
            t.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)

            box.Parent = t
            box.Size = UDim2.new(0, 20, 0, 20)
            box.Position = UDim2.new(1, -30, 0.5, -10)
            box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

            t.MouseButton1Click:Connect(function()
                state = not state
                box.BackgroundColor3 = state and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(40, 40, 40)
                cb(state)
            end)
        end

        -- INPUT
        function Elements:CreateInput(txt, placeholder, cb)
            local i = Instance.new("Frame")
            local box = Instance.new("TextBox")
            i.Parent = Page
            i.Size = UDim2.new(1, -10, 0, 45)
            i.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Instance.new("UICorner", i)
            
            box.Parent = i
            box.Size = UDim2.new(1, -20, 1, 0)
            box.Position = UDim2.new(0, 10, 0, 0)
            box.BackgroundTransparency = 1
            box.Text = ""
            box.PlaceholderText = txt .. "..."
            box.TextColor3 = Color3.fromRGB(255, 255, 255)
            box.Font = Enum.Font.Gotham
            box.FocusLost:Connect(function() cb(box.Text) end)
        end

        return Elements
    end
    return Tabs
end

return SaldHub

