# Sald UI Library 🚀

Uma Library de interface simples, escura e funcional para Roblox, focada em dispositivos Mobile e PC.

## 📌 Como usar
```lua
local SaldLib = loadstring(game:HttpGet("[https://raw.githubusercontent.com/dark14414141441-bot/Sald-UI/refs/heads/main/main.lua](https://raw.githubusercontent.com/dark14414141441-bot/Sald-UI/refs/heads/main/main.lua)"))()

local Window = SaldLib:CreateWindow()
local Tab = Window:CreateTab("Exemplo")

Tab:CreateToggle("Ativar", function(v) print(v) end)
Tab:CreateSlider("Velocidade", 1, 100, function(v) print(v) end)
Tab:CreateInput("Nome", "Digite...", function(t) print(t) end)
