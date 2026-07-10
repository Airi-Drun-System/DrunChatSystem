-- ============================================
-- AIRI CHAT SYSTEM (Для экзекьютера)
-- Автор: Drun
-- Версия: 2.0 (FIXED)
-- ============================================

-- БЕЗОПАСНОЕ ПОЛУЧЕНИЕ СЛУЖБ
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ВЫБОР ПАПКИ ДЛЯ GUI (CoreGui часто недоступен)
local GUI_PARENT = LocalPlayer:FindFirstChild("PlayerGui")
if not GUI_PARENT then
    GUI_PARENT = game:GetService("CoreGui")
end
if not GUI_PARENT then
    GUI_PARENT = game:GetService("StarterGui")
end

-- ============================================
-- НАСТРОЙКИ
-- ============================================
_G.DrunBubbleColor = Color3.fromRGB(255, 255, 255)
_G.DrunBubbleSize = 24
_G.DrunBubbleFont = Enum.Font.SourceSansBold

local fontList = {
    Enum.Font.SourceSansBold,
    Enum.Font.Comic,
    Enum.Font.SciFi,
    Enum.Font.Arial
}
local fontIndex = 1

-- ============================================
-- ОЧИСТКА СТАРЫХ ДАННЫХ
-- ============================================
if _G.DrunChatConnection then
    pcall(function() _G.DrunChatConnection:Disconnect() end)
    _G.DrunChatConnection = nil
end
if _G.DrunInputConnection then
    pcall(function() _G.DrunInputConnection:Disconnect() end)
    _G.DrunInputConnection = nil
end

-- Удаление старого GUI
pcall(function()
    if GUI_PARENT:FindFirstChild("DrunUniversalP2P") then
        GUI_PARENT.DrunUniversalP2P:Destroy()
    end
end)

-- ============================================
-- СОЗДАНИЕ GUI (БЕЗ CoreGui)
-- ============================================
local SG = Instance.new("ScreenGui")
SG.Name = "DrunUniversalP2P"
SG.Parent = GUI_PARENT

-- ============================================
-- ГЛАВНОЕ ОКНО
-- ============================================
local MainFrame = Instance.new("Frame", SG)
MainFrame.Size = UDim2.new(0, 320, 0, 165)
MainFrame.Position = UDim2.new(0.015, 0, 0.12, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.35
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
MainFrame.Active = true
MainFrame.Draggable = true -- ВОЗМОЖНОСТЬ ПЕРЕТАСКИВАТЬ

-- Чат окно
local ChatFrame = Instance.new("ScrollingFrame", MainFrame)
ChatFrame.Size = UDim2.new(1, -10, 1, -35)
ChatFrame.Position = UDim2.new(0, 5, 0, 5)
ChatFrame.BackgroundTransparency = 1
ChatFrame.BorderSizePixel = 0
ChatFrame.ScrollBarThickness = 3
ChatFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local UIList = Instance.new("UIListLayout", ChatFrame)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 4)

-- Кнопки
local OpenInputBtn = Instance.new("TextButton", MainFrame)
OpenInputBtn.Size = UDim2.new(0, 75, 0, 22)
OpenInputBtn.Position = UDim2.new(0, 5, 1, -27)
OpenInputBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 136)
OpenInputBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenInputBtn.Text = "ПИСАТЬ"
OpenInputBtn.TextSize = 11
OpenInputBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", OpenInputBtn).CornerRadius = UDim.new(0, 4)

local SettingsBtn = Instance.new("TextButton", MainFrame)
SettingsBtn.Size = UDim2.new(0, 45, 0, 22)
SettingsBtn.Position = UDim2.new(0, 85, 1, -27)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
SettingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsBtn.Text = "⚙️"
SettingsBtn.TextSize = 12
Instance.new("UICorner", SettingsBtn).CornerRadius = UDim.new(0, 4)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 110, 0, 22)
CloseBtn.Position = UDim2.new(1, -115, 1, -27)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "ОЧИСТИТЬ СКРИПТ"
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local SettingsFrame = Instance.new("Frame", SG)
SettingsFrame.Size = UDim2.new(0, 220, 0, 130)
SettingsFrame.Position = UDim2.new(0.015, 325, 0.12, 0)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
SettingsFrame.BackgroundTransparency = 0.2
SettingsFrame.Visible = false
Instance.new("UICorner", SettingsFrame).CornerRadius = UDim.new(0, 8)
SettingsFrame.Active = true
SettingsFrame.Draggable = true

local ST = Instance.new("TextLabel", SettingsFrame)
ST.Size = UDim2.new(1, 0, 0, 25)
ST.Text = "НАСТРОЙКИ ОБЛАЧЕК"
ST.TextColor3 = Color3.fromRGB(200, 200, 200)
ST.TextSize = 11
ST.Font = Enum.Font.SourceSansBold
ST.BackgroundTransparency = 1

local RGBInp = Instance.new("TextBox", SettingsFrame)
RGBInp.Size = UDim2.new(1, -20, 0, 22)
RGBInp.Position = UDim2.new(0, 10, 0, 28)
RGBInp.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
RGBInp.TextColor3 = Color3.fromRGB(255, 255, 255)
RGBInp.PlaceholderText = "Цвет: 255,0,0"
RGBInp.Text = ""
RGBInp.TextSize = 11
Instance.new("UICorner", RGBInp).CornerRadius = UDim.new(0, 4)

local FontBtn = Instance.new("TextButton", SettingsFrame)
FontBtn.Size = UDim2.new(1, -20, 0, 22)
FontBtn.Position = UDim2.new(0, 10, 0, 58)
FontBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
FontBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FontBtn.Text = "ШРИФТ: Bold"
FontBtn.TextSize = 11
FontBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", FontBtn).CornerRadius = UDim.new(0, 4)

local SizeBtn = Instance.new("TextButton", SettingsFrame)
SizeBtn.Size = UDim2.new(1, -20, 0, 22)
SizeBtn.Position = UDim2.new(0, 10, 0, 88)
SizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
SizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SizeBtn.Text = "РАЗМЕР: " .. _G.DrunBubbleSize
SizeBtn.TextSize = 11
SizeBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", SizeBtn).CornerRadius = UDim.new(0, 4)

-- ============================================
-- ОБРАБОТЧИКИ
-- ============================================
SettingsBtn.MouseButton1Click:Connect(function()
    SettingsFrame.Visible = not SettingsFrame.Visible
end)

RGBInp.FocusLost:Connect(function(ep)
    if ep and RGBInp.Text ~= "" then
        local r, g, b = RGBInp.Text:match("(%d+),%s*(%d+),%s*(%d+)")
        if r and g and b then
            _G.DrunBubbleColor = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
        end
    end
end)

FontBtn.MouseButton1Click:Connect(function()
    fontIndex = fontIndex + 1
    if fontIndex > #fontList then fontIndex = 1 end
    _G.DrunBubbleFont = fontList[fontIndex]
    FontBtn.Text = "ШРИФТ: " .. _G.DrunBubbleFont.Name
end)

SizeBtn.MouseButton1Click:Connect(function()
    if _G.DrunBubbleSize == 24 then
        _G.DrunBubbleSize = 32
    elseif _G.DrunBubbleSize == 32 then
        _G.DrunBubbleSize = 18
    else
        _G.DrunBubbleSize = 24
    end
    SizeBtn.Text = "РАЗМЕР: " .. _G.DrunBubbleSize
end)

-- ============================================
-- ФУНКЦИЯ ОБЛАЧКА
-- ============================================
local function createTreeBubble(player, message)
    if player and player.Character and player.Character:FindFirstChild("Head") then
        local head = player.Character.Head
        
        if head:FindFirstChild("TreeBubbleText") then
            head.TreeBubbleText:Destroy()
        end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "TreeBubbleText"
        billboard.Size = UDim2.new(0, 300, 0, 60)
        billboard.AlwaysOnTop = true
        billboard.ExtentsOffset = Vector3.new(0, 3.5, 0)
        billboard.Parent = head
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = message
        textLabel.TextColor3 = _G.DrunBubbleColor
        textLabel.TextSize = _G.DrunBubbleSize
        textLabel.Font = _G.DrunBubbleFont
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        textLabel.Parent = billboard
        
        task.delay(5, function()
            if billboard and billboard.Parent then
                billboard:Destroy()
            end
        end)
    end
end

-- ============================================
-- ЛОГ СООБЩЕНИЙ
-- ============================================
local function addMessageToLog(senderName, text)
    local msgLabel = Instance.new("TextLabel", ChatFrame)
    msgLabel.Size = UDim2.new(1, -10, 0, 22)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = " [" .. senderName .. "]: " .. text
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.Font = Enum.Font.SourceSansBold
    msgLabel.TextSize = 14
    msgLabel.TextStrokeTransparency = 0.1
    msgLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    if senderName == LocalPlayer.Name then
        msgLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
    elseif senderName == "Система" then
        msgLabel.TextColor3 = Color3.fromRGB(173, 216, 230)
    else
        msgLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    end
    
    ChatFrame.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
    ChatFrame.CanvasPosition = Vector2.new(0, UIList.AbsoluteContentSize.Y)
end

-- ============================================
-- ПОИСК СОБЫТИЙ (ДЛЯ ЭКЗЕКЬЮТЕРА)
-- ============================================
local networkEvent = nil

-- Ищем события в ReplicatedStorage
for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") then
        local name = obj.Name:lower()
        if name:find("chat") or name:find("message") or name:find("say") or name:find("talk") then
            networkEvent = obj
            break
        end
    end
end

-- Ищем в Workspace (редко, но бывает)
if not networkEvent then
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") and obj.Name:lower():find("chat") then
            networkEvent = obj
            break
        end
    end
end

-- Ищем в Players
if not networkEvent then
    for _, obj in ipairs(Players:GetDescendants()) do
        if obj:IsA("RemoteEvent") and obj.Name:lower():find("chat") then
            networkEvent = obj
            break
        end
    end
end

-- ============================================
-- ПЕРЕХВАТ СООБЩЕНИЙ
-- ============================================
if networkEvent then
    _G.DrunChatConnection = networkEvent.OnClientEvent:Connect(function(...)
        local args = {...}
        local sender = args[1]
        local msg = args[2]
        
        if type(msg) == "string" and msg:sub(1, 8) == "##uP2P##" then
            local cleanMessage = msg:sub(9)
            local senderObj = Players:FindFirstChild(sender)
            
            if senderObj and senderObj ~= LocalPlayer then
                addMessageToLog(senderObj.Name, cleanMessage)
                createTreeBubble(senderObj, cleanMessage)
            end
        end
    end)
    print("✅ Найдено событие чата:", networkEvent.Name)
else
    print("⚠️ Событие чата не найдено. Работаем в оффлайн режиме")
end

-- ============================================
-- ОТКРЫТИЕ ВВОДА
-- ============================================
local function openInputBox()
    local inputGui = Instance.new("ScreenGui")
    inputGui.Parent = GUI_PARENT
    
    local box = Instance.new("TextBox", inputGui)
    box.Size = UDim2.new(0, 320, 0, 32)
    box.Position = UDim2.new(0.015, 0, 0.38, 0)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    box.BorderSizePixel = 0
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderText = " Пиши в закрытый чат..."
    box.TextSize = 14
    box.ClearTextOnFocus = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    
    box.FocusLost:Connect(function(enterPressed)
        if enterPressed and box.Text ~= "" then
            local txt = box.Text
            
            -- Команды
            if txt:sub(1, 2) == "/e" or txt:sub(1, 7) == "/emotes" then
                pcall(function()
                    game:GetService("Players").LocalPlayer.Chatted:Fire(txt)
                end)
                addMessageToLog("Система", "🎭 Анимация: " .. txt)
            else
                local finalMsg = "##uP2P##" .. txt
                
                if networkEvent then
                    pcall(function()
                        networkEvent:FireServer(finalMsg, "All")
                    end)
                end
                
                addMessageToLog(LocalPlayer.Name, txt)
                createTreeBubble(LocalPlayer, txt)
            end
        end
        inputGui:Destroy()
    end)
    
    box:CaptureFocus()
end

-- ============================================
-- КНОПКИ И ГОРЯЧИЕ КЛАВИШИ
-- ============================================
OpenInputBtn.MouseButton1Click:Connect(openInputBox)

_G.DrunInputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        openInputBox()
    end
end)

-- ============================================
-- ЗАКРЫТИЕ
-- ============================================
CloseBtn.MouseButton1Click:Connect(function()
    if _G.DrunChatConnection then
        _G.DrunChatConnection:Disconnect()
        _G.DrunChatConnection = nil
    end
    if _G.DrunInputConnection then
        _G.DrunInputConnection:Disconnect()
        _G.DrunInputConnection = nil
    end
    if SG and SG.Parent then
        SG:Destroy()
    end
end)

-- ============================================
-- ЗАПУСК
-- ============================================
addMessageToLog("Система", "🚀 Airi Chat запущен!")
addMessageToLog("Система", "📌 Нажми K или кнопку 'ПИСАТЬ'")
addMessageToLog("Система", "⚙️ Нажми ⚙️ для настроек")

if networkEvent then
    addMessageToLog("Система", "✅ Событие найдено: " .. networkEvent.Name)
else
    addMessageToLog("Система", "⚠️ Событие не найдено (чат локальный)")
end

print("✅ Скрипт загружен!")
