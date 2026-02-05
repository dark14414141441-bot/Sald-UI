local SaldUI = {}
SaldUI.__index = SaldUI

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- SISTEMA DE ARRASTO (DRAG)
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
    
    local success, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not success then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 550, 0, 380)
    Main.Position = UDim2.new(0.5, -275, 0.5, -190)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Main.BorderSizePixel = 0
    Main.Active = true 
    Main.Parent = ScreenGui

    MakeDraggable(Main)

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(60, 60, 60)
    Stroke.Thickness = 1.2

    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, 0, 0, 42)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Header.BorderSizePixel = 0
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

    local HideC = Instance.new("Frame", Header)
    HideC.Size = UDim2.new(1, 0, 0, 10)
    HideC.Position = UDim2.new(0, 0, 1, -10)
    HideC.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    HideC.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", Header)
    Title.Text = hubName
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 18, 0, 0)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
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

    local Sidebar = Instance.new("ScrollingFrame", Main)
    Sidebar.Size = UDim2.new(0, 140, 1, -55)
    Sidebar.Position = UDim2.new(0, 8, 0, 48)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 0
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 6)

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -165, 1, -55)
    Container.Position = UDim2.new(0, 155, 0, 48)
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
    Page.ScrollBarThickness = 0
    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local TabBtn = Instance.new("TextButton", self.Sidebar)
    TabBtn.Text = name
    TabBtn.Size = UDim2.new(1, -10, 0, 36)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 14
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local function Activate()
        for _, v in pairs(self.Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(self.Sidebar:GetChildren()) do 
            if v:IsA("TextButton") then 
                v.BackgroundColor3 = Color3.fromRGB(25, 25, 25) 
                v.TextColor3 = Color3.fromRGB(255, 255, 255)
            end 
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    end

    TabBtn.MouseButton1Click:Connect(Activate)
    if self.FirstTab then Activate(); self.FirstTab = false end

    local Elements = {}

    function Elements:CreateButton(text, callback)
        local B = Instance.new("TextButton", Page)
        B.Text = text
        B.Size = UDim2.new(1, -12, 0, 42)
        B.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        B.TextColor3 = Color3.fromRGB(255, 255, 255)
        B.Font = Enum.Font.GothamBold
        B.TextSize = 16 -- Aumentado
        Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
        local S = Instance.new("UIStroke", B)
        S.Color = Color3.fromRGB(50, 50, 50)
        B.MouseButton1Click:Connect(callback)
    end

    function Elements:CreateToggle(text, callback)
        local T = Instance.new("TextButton", Page)
        T.Text = "   " .. text
        T.Size = UDim2.new(1, -12, 0, 45) -- Altura maior para o Toggle
        T.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        T.TextColor3 = Color3.fromRGB(255, 255, 255)
        T.TextXAlignment = Enum.TextXAlignment.Left
        T.Font = Enum.Font.GothamBold
        T.TextSize = 16 -- Fonte bem maior para o Kill e outros
        Instance.new("UICorner", T).CornerRadius = UDim.new(0, 8)
        
        local Indicator = Instance.new("Frame", T)
        Indicator.Size = UDim2.new(0, 26, 0, 26) -- Indicador maior
        Indicator.Position = UDim2.new(1, -38, 0.5, -13)
        Indicator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 6)

        local state = false
        T.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(50, 50, 50)}):Play()
            callback(state)
        end)
    end

    function Elements:CreateLabel(text)
        local L = Instance.new("TextLabel", Page)
        L.Text = text
        L.Size = UDim2.new(1, 0, 0, 30)
        L.BackgroundTransparency = 1
        L.TextColor3 = Color3.fromRGB(255, 255, 255)
        L.Font = Enum.Font.GothamBold
        L.TextSize = 15 -- Label um pouco maior
    end

    return Elements
end

return SaldUI

