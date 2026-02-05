local SaldUI = {}
SaldUI.__index = SaldUI

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- 

-- // Função de Arrastar (Drag) Otimizada
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function SaldUI:CreateWindow(hubName)
    local self = setmetatable({}, SaldUI)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SaldUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local success, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not success then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- Main Frame (550x380)
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 550, 0, 380)
    Main.Position = UDim2.new(0.5, -275, 0.5, -190)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Main.Active = true 
    Main.Parent = ScreenGui
    MakeDraggable(Main)

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(45, 45, 45)
    Stroke.Thickness = 1.5

    -- Header (Barra Superior)
    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, 0, 0, 42)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Header.BorderSizePixel = 0
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

    local HideC = Instance.new("Frame", Header)
    HideC.Size = UDim2.new(1, 0, 0, 15)
    HideC.Position = UDim2.new(0, 0, 1, -15)
    HideC.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    HideC.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", Header)
    Title.Text = hubName:upper()
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Close = Instance.new("TextButton", Header)
    Close.Text = "X"
    Close.Size = UDim2.new(0, 45, 1, 0)
    Close.Position = UDim2.new(1, -45, 0, 0)
    Close.BackgroundTransparency = 1
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 18
    Close.Font = Enum.Font.GothamBold
    Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- Sidebar (Abas)
    local Sidebar = Instance.new("ScrollingFrame", Main)
    Sidebar.Size = UDim2.new(0, 150, 1, -60)
    Sidebar.Position = UDim2.new(0, 10, 0, 50)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 0
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 6)

    -- Container de Conteúdo
    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -180, 1, -60)
    Container.Position = UDim2.new(0, 170, 0, 50)
    Container.BackgroundTransparency = 1

    self.Container = Container
    self.Sidebar = Sidebar
    self.FirstTab = true

    return self
end

function SaldUI:CreateTab(name)
    local Page = Instance.new("ScrollingFrame", self.Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    Page.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    
    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local TabBtn = Instance.new("TextButton", self.Sidebar)
    TabBtn.Text = name
    TabBtn.Size = UDim2.new(1, -10, 0, 38)
    TabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 14
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
    local TabStroke = Instance.new("UIStroke", TabBtn)
    TabStroke.Color = Color3.fromRGB(40, 40, 40)

    local function Activate()
        for _, v in pairs(self.Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(self.Sidebar:GetChildren()) do 
            if v:IsA("TextButton") then 
                TweenService:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(22, 22, 22), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end 
        end
        Page.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 255, 255), TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
    end

    TabBtn.MouseButton1Click:Connect(Activate)
    if self.FirstTab then Activate(); self.FirstTab = false end

    local Elements = {}

    -- // BOTÃO MELHORADO
    function Elements:CreateButton(text, callback)
        local B = Instance.new("TextButton", Page)
        B.Text = text
        B.Size = UDim2.new(1, -15, 0, 45)
        B.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        B.TextColor3 = Color3.fromRGB(255, 255, 255)
        B.Font = Enum.Font.GothamBold
        B.TextSize = 16
        Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
        local BS = Instance.new("UIStroke", B)
        BS.Color = Color3.fromRGB(60, 60, 60)
        
        B.MouseButton1Down:Connect(function()
            TweenService:Create(B, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        end)
        B.MouseButton1Up:Connect(function()
            TweenService:Create(B, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play()
            callback()
        end)
    end

    -- // TOGGLE SWITCH (PILL)
    function Elements:CreateToggle(text, callback)
        local T = Instance.new("TextButton", Page)
        T.Text = "   " .. text
        T.Size = UDim2.new(1, -15, 0, 48)
        T.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        T.TextColor3 = Color3.fromRGB(255, 255, 255)
        T.TextXAlignment = Enum.TextXAlignment.Left
        T.Font = Enum.Font.GothamBold
        T.TextSize = 16
        Instance.new("UICorner", T).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", T).Color = Color3.fromRGB(60, 60, 60)
        
        local SwitchBg = Instance.new("Frame", T)
        SwitchBg.Size = UDim2.new(0, 44, 0, 22)
        SwitchBg.Position = UDim2.new(1, -55, 0.5, -11)
        SwitchBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)
        
        local Slider = Instance.new("Frame", SwitchBg)
        Slider.Size = UDim2.new(0, 18, 0, 18)
        Slider.Position = UDim2.new(0, 2, 0.5, -9)
        Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", Slider).CornerRadius = UDim.new(1, 0)

        local state = false
        T.MouseButton1Click:Connect(function()
            state = not state
            if state then
                TweenService:Create(SwitchBg, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                TweenService:Create(Slider, TweenInfo.new(0.25), {Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            else
                TweenService:Create(SwitchBg, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                TweenService:Create(Slider, TweenInfo.new(0.25), {Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end
            callback(state)
        end)
    end

    -- // LABEL (SESSÃO)
    function Elements:CreateLabel(text)
        local L = Instance.new("TextLabel", Page)
        L.Text = text
        L.Size = UDim2.new(1, 0, 0, 35)
        L.BackgroundTransparency = 1
        L.TextColor3 = Color3.fromRGB(255, 255, 255)
        L.Font = Enum.Font.GothamBold
        L.TextSize = 15
    end

    return Elements
end

return SaldUI
