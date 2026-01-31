local Library = {}

function Library:CreateWindow(hubName, gameName)
    -- Instância Principal
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Sidebar = Instance.new("Frame")
    local Container = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")

    -- Configuração da ScreenGui
    ScreenGui.Name = "CustomHub"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Janela Principal (Estilo Fluent/Redz)
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Fundo Escuro
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.ClipsDescendants = true

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    -- Barra Lateral (Inspirada no Rayfield)
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Sidebar.Size = UDim2.new(0, 150, 1, 0)

    Title.Parent = Sidebar
    Title.Text = hubName
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18

    -- Área de Conteúdo
    Container.Name = "Container"
    Container.Parent = MainFrame
    Container.Position = UDim2.new(0, 160, 0, 10)
    Container.Size = UDim2.new(1, -170, 1, -20)
    Container.BackgroundTransparency = 1

    return {
        AddTab = function(self, tabName)
            -- Aqui você adicionaria a lógica de criar botões na Sidebar 
            -- e trocar as páginas no Container.
            print("Aba criada: " .. tabName)
        end
    }
end

return Library
