local SaldHub = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Função de Arraste (Universal)
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
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    -- --- BOTÃO S (O único item novo mantido) ---
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
    
    MakeDraggable(LogoS, LogoS) -- Botão arrastável

    -- --- MENU PRINCIPAL (Visual Original Restaurado) ---
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Cor original escura
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350) -- Tamanho original
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    
    MakeDraggable(MainFrame, MainFrame) -- Menu arrastável

    -- Toggle Visibilidade
    LogoS.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- Título
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

    -- Sidebar (Lista Lateral Original)
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundTransparency = 1
    Sidebar.Position = UDim2.new(0, 10, 0, 50)
    Sidebar.Size = UDim2.new(0, 170, 1, -60)
    Sidebar.ScrollBarThickness = 0
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Sidebar
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    -- Container do Conteúdo (Lado Direito)
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "Content"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 190, 0, 50)
    ContentContainer.Size = UDim2.new(1, -200, 1, -60)

    -- Funções da Library
    local Tabs = {}
    local FirstTab = true

    function Tabs:CreateTab(name)
        -- Botão da Aba (Estilo Original: Cinza escuro, texto simples)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name
        TabBtn.Parent = Sidebar
        TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Fundo sutil
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.Text = "        " .. name -- Espaço para o ícone
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabBtn

        -- ÍCONE DE MOUSE NA ABA
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Parent = TabBtn
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 8, 0.5, -8)
        TabIcon.Size = UDim2.new(0, 16, 0, 16)
        TabIcon.Image = "rbxassetid://6031225818"
        TabIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        
        -- Indicador de Seleção (Barra Azul)
        local SelectionBar = Instance.new("Frame")
        SelectionBar.Parent = TabBtn
        SelectionBar.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
        SelectionBar.Position = UDim2.new(0, 0, 0.2, 0)
        SelectionBar.Size = UDim2.new(0, 3, 0.6, 0)
        SelectionBar.Visible = false

        -- Página de Conteúdo
        local Page = Instance.new("ScrollingFrame")
        Page.Name = name .. "_Page"
        Page.Parent = ContentContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

        -- Lógica de Seleção
        if FirstTab then
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0.8
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            SelectionBar.Visible = true
            FirstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            -- Reseta todas as abas
            for _, v in pairs(ContentContainer:GetChildren()) do v.Visible = false end
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundTransparency = 1
                    v.TextColor3 = Color3.fromRGB(150, 150, 150)
                    v.ImageLabel.ImageColor3 = Color3.fromRGB(150, 150, 150)
                    v.Frame.Visible = false
                end
            end
            -- Ativa a atual
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0.8
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            SelectionBar.Visible = true
        end)

        local Elements = {}

        -- BUTTON
        function Elements:CreateButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Parent = Page
            Btn.Size = UDim2.new(1, -5, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Btn.Font = Enum.Font.Gotham
            Btn.Text = "        " .. text -- Espaço para o ícone
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextSize = 14
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            
            local BtnIcon = Instance.new("ImageLabel")
            BtnIcon.Parent = Btn
            BtnIcon.BackgroundTransparency = 1
            BtnIcon.Position = UDim2.new(0, 8, 0.5, -8)
            BtnIcon.Size = UDim2.new(0, 16, 0, 16)
            BtnIcon.Image = "rbxassetid://6031225818"

            Btn.MouseButton1Click:Connect(callback)
        end

        -- TOGGLE (Switch Simples e Limpo)
        function Elements:CreateToggle(text, callback)
            local TglBtn = Instance.new("TextButton")
            TglBtn.Parent = Page
            TglBtn.Size = UDim2.new(1, -5, 0, 35)
            TglBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TglBtn.Text = "   " .. text
            TglBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TglBtn.TextSize = 14
            TglBtn.TextXAlignment = Enum.TextXAlignment.Left
            TglBtn.Font = Enum.Font.Gotham
            Instance.new("UICorner", TglBtn).CornerRadius = UDim.new(0, 6)

            local Status = Instance.new("Frame")
            Status.Parent = TglBtn
            Status.Size = UDim2.new(0, 30, 0, 16)
            Status.Position = UDim2.new(1, -40, 0.5, -8)
            Status.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)

            local Ball = Instance.new("Frame")
            Ball.Parent = Status
            Ball.Size = UDim2.new(0, 12, 0, 12)
            Ball.Position = UDim2.new(0, 2, 0.5, -6)
            Ball.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", Ball).CornerRadius = UDim.new(1, 0)

            local toggled = false
            TglBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                if toggled then
                    Status.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
                    TweenService:Create(Ball, TweenInfo.new(0.2), {Position = UDim2.new(1, -14, 0.5, -6)}):Play()
                else
                    Status.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    TweenService:Create(Ball, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -6)}):Play()
                end
                callback(toggled)
            end)
        end

        -- SLIDER (ESTILO ORIGINAL RESTAURADO + NÚMERO)
        function Elements:CreateSlider(text, min, max, callback)
            local SldFrame = Instance.new("Frame")
            SldFrame.Parent = Page
            SldFrame.Size = UDim2.new(1, -5, 0, 45)
            SldFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Instance.new("UICorner", SldFrame).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel")
            Label.Parent = SldFrame
            Label.Text = "   " .. text .. ": " .. min
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14

            local BarBack = Instance.new("Frame")
            BarBack.Parent = SldFrame
            BarBack.Size = UDim2.new(1, -20, 0, 4)
            BarBack.Position = UDim2.new(0, 10, 0, 30)
            BarBack.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Instance.new("UICorner", BarBack)

            local BarFill = Instance.new("Frame")
            BarFill.Parent = BarBack
            BarFill.Size = UDim2.new(0, 0, 1, 0)
            BarFill.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
            Instance.new("UICorner", BarFill)

            local function update()
                local mouseX = UserInputService:GetMouseLocation().X
                local relativeX = mouseX - BarBack.AbsolutePosition.X
                local percent = math.clamp(relativeX / BarBack.AbsoluteSize.X, 0, 1)
                BarFill.Size = UDim2.new(percent, 0, 1, 0)
                local value = math.floor(min + (max - min) * percent)
                Label.Text = "   " .. text .. ": " .. value
                callback(value)
            end

            local dragging = false
            BarBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            RunService.RenderStepped:Connect(function()
                if dragging then
                    update()
                end
            end)
        end

        -- INPUT
        function Elements:CreateInput(placeholder, callback)
            local InputFrame = Instance.new("Frame")
            InputFrame.Parent = Page
            InputFrame.Size = UDim2.new(1, -5, 0, 35)
            InputFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 6)

            local TextBox = Instance.new("TextBox")
            TextBox.Parent = InputFrame
            TextBox.Size = UDim2.new(1, -10, 1, 0)
            TextBox.Position = UDim2.new(0, 10, 0, 0)
            TextBox.BackgroundTransparency = 1
            TextBox.Text = ""
            TextBox.PlaceholderText = placeholder
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.TextXAlignment = Enum.TextXAlignment.Left
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 14
            
            TextBox.FocusLost:Connect(function()
                callback(TextBox.Text)
            end)
        end

        return Elements
    end

    return Tabs
end

return SaldHub
