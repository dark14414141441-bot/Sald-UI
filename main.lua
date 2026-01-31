local Library = {}

function Library:CreateWindow(Settings)
    -- Definindo padrões caso a pessoa esqueça de colocar algo
    local HubName = Settings.Name or "Sald UI"
    local AccentColor = Settings.Color or Color3.fromRGB(0, 120, 215)
    local ButtonText = Settings.ButtonText or "SD"

    -- Instância Principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SaldHub_Gui"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Janela Principal (MainFrame)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Visible = true

    local UICornerMain = Instance.new("UICorner", MainFrame)
    UICornerMain.CornerRadius = UDim.new(0, 10)

    -- Título do Script (Que você pediu)
    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.Text = HubName
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16

    -- BOLINHA DE ABRIR/FECHAR (Estilo Redz)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleButton"
    ToggleBtn.Parent = ScreenGui
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0.02, 0, 0.4, 0)
    ToggleBtn.BackgroundColor3 = AccentColor -- Cor customizável
    ToggleBtn.Text = ButtonText -- Texto customizável (SD)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 18
    ToggleBtn.Draggable = true -- Deixa a bolinha arrastável

    local UICornerBtn = Instance.new("UICorner", ToggleBtn)
    UICornerBtn.CornerRadius = UDim.new(1, 0) -- Deixa redondo

    -- Lógica de Abrir/Fechar
    ToggleBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- SISTEMA DE ARRASTAR O MAINFRAME
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    return {
        -- Aqui você continua com as funções de CreateTab, CreateButton, etc.
    }
end

return Library
