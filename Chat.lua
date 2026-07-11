-- ============================================================
-- 🕷️ AIRI DARK CHAT ULTIMATE
-- Тёмный подземный чат для избранных
-- Версия: 9.0 (ФИКС ПОЛЯ ВВОДА И БОЛЬШИХ СООБЩЕНИЙ)
-- ============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ═══════════════════════════════════════════════════════════════
-- GUI ПАПКА
-- ═══════════════════════════════════════════════════════════════
local function GetGUIParent()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if gui then return gui end
    gui = Instance.new("ScreenGui")
    gui.Name = "AiriGUI"
    gui.Parent = LocalPlayer
    return gui
end
local GUI_PARENT = GetGUIParent()

-- ═══════════════════════════════════════════════════════════════
-- ЧИСТКА
-- ═══════════════════════════════════════════════════════════════
local old = GUI_PARENT:FindFirstChild("AiriDarkChat")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AiriDarkChat"
ScreenGui.Parent = GUI_PARENT
ScreenGui.ResetOnSpawn = false

-- ═══════════════════════════════════════════════════════════════
-- ПЕРЕМЕННЫЕ
-- ═══════════════════════════════════════════════════════════════
local ChatConnection = nil
local isOpen = false

local function UnloadScript()
    if ChatConnection then pcall(function() ChatConnection:Disconnect() end) end
    if ScreenGui then pcall(function() ScreenGui:Destroy() end) end
    print("💀 Тёмный чат выгружен")
end

-- ═══════════════════════════════════════════════════════════════
-- КНОПКА-ТРИГГЕР 💬 (ЛЕВЫЙ ВЕРХНИЙ УГОЛ)
-- ═══════════════════════════════════════════════════════════════
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.BackgroundTransparency = 0
ToggleBtn.Text = "💬"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 28
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.BorderSizePixel = 2
ToggleBtn.BorderColor3 = Color3.fromRGB(100, 100, 120)
ToggleBtn.Parent = ScreenGui
ToggleBtn.ZIndex = 999
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- ЭФФЕКТЫ ПРИ НАВЕДЕНИИ
ToggleBtn.MouseEnter:Connect(function()
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    ToggleBtn.BorderColor3 = Color3.fromRGB(180, 150, 220)
end)
ToggleBtn.MouseLeave:Connect(function()
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ToggleBtn.BorderColor3 = Color3.fromRGB(100, 100, 120)
end)

-- ═══════════════════════════════════════════════════════════════
-- ГЛАВНОЕ ОКНО (УВЕЛИЧЕННОЕ)
-- ═══════════════════════════════════════════════════════════════
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 550, 0, 450)
Main.Position = UDim2.new(0.5, -275, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(6, 6, 10)
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 1
Main.BorderColor3 = Color3.fromRGB(35, 35, 40)
Main.Visible = false
Main.Parent = ScreenGui
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

-- ТЕНЬ
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.7
Shadow.BorderSizePixel = 0
Shadow.ZIndex = 0
Shadow.Parent = Main
Instance.new("UICorner", Shadow).CornerRadius = UDim.new(0, 14)

-- ═══════════════════════════════════════════════════════════════
-- ЗАГОЛОВОК
-- ═══════════════════════════════════════════════════════════════
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
TitleBar.BackgroundTransparency = 0.5
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 14)

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 16, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🕷️ ТЁМНЫЙ ЧАТ"
TitleText.TextColor3 = Color3.fromRGB(180, 160, 220)
TitleText.TextSize = 17
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.SourceSansBold
TitleText.Parent = TitleBar

-- СТАТУС
local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.Position = UDim2.new(0, 12, 0, 17)
StatusDot.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
StatusDot.BackgroundTransparency = 0
StatusDot.BorderSizePixel = 0
StatusDot.Parent = TitleBar
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

-- КНОПКИ
local buttons = {
    {text = "🔃", pos = -80, action = UnloadScript},
    {text = "❌", pos = -45, action = function() Main.Visible = false end}
}

for _, btnData in ipairs(buttons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(1, btnData.pos, 0, 6)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.BackgroundTransparency = 0.5
    btn.Text = btnData.text
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 18
    btn.Font = Enum.Font.SourceSansBold
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(60, 60, 65)
    btn.Parent = TitleBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0.2
        btn.BorderColor3 = Color3.fromRGB(150, 120, 200)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.5
        btn.BorderColor3 = Color3.fromRGB(60, 60, 65)
    end)
    btn.MouseButton1Click:Connect(btnData.action)
end

-- ═══════════════════════════════════════════════════════════════
-- ЛОГ (С ПРАВИЛЬНЫМ ПЕРЕНОСОМ)
-- ═══════════════════════════════════════════════════════════════
local ChatScroll = Instance.new("ScrollingFrame")
ChatScroll.Size = UDim2.new(1, -16, 1, -140)
ChatScroll.Position = UDim2.new(0, 8, 0, 48)
ChatScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ChatScroll.BackgroundTransparency = 0.5
ChatScroll.BorderSizePixel = 1
ChatScroll.BorderColor3 = Color3.fromRGB(30, 30, 35)
ChatScroll.ScrollBarThickness = 5
ChatScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
ChatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatScroll.Parent = Main
Instance.new("UICorner", ChatScroll).CornerRadius = UDim.new(0, 8)

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)
UIList.Parent = ChatScroll

-- ═══════════════════════════════════════════════════════════════
-- ПОЛЕ ВВОДА (6 СТРОК!) — УВЕЛИЧЕННАЯ ВЫСОТА
-- ═══════════════════════════════════════════════════════════════
local InputContainer = Instance.new("Frame")
InputContainer.Size = UDim2.new(1, -16, 0, 100)  -- 100px ≈ 6 строк
InputContainer.Position = UDim2.new(0, 8, 1, -108)
InputContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
InputContainer.BackgroundTransparency = 0.4
InputContainer.BorderSizePixel = 1
InputContainer.BorderColor3 = Color3.fromRGB(40, 40, 45)
InputContainer.Parent = Main
Instance.new("UICorner", InputContainer).CornerRadius = UDim.new(0, 8)

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -80, 1, 0)
InputBox.Position = UDim2.new(0, 12, 0, 0)
InputBox.BackgroundTransparency = 1
InputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
InputBox.PlaceholderText = "Напиши что-то..."
InputBox.Text = ""
InputBox.TextSize = 14
InputBox.Font = Enum.Font.SourceSans
InputBox.ClearTextOnFocus = false
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.TextYAlignment = Enum.TextYAlignment.Top
InputBox.TextWrapped = true
InputBox.TextScaled = false
InputBox.Parent = InputContainer

-- КНОПКА ОТПРАВКИ 📩
local SendBtn = Instance.new("TextButton")
SendBtn.Size = UDim2.new(0, 60, 1, -6)
SendBtn.Position = UDim2.new(1, -65, 0, 3)
SendBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
SendBtn.BackgroundTransparency = 0.3
SendBtn.Text = "📩"
SendBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
SendBtn.TextSize = 22
SendBtn.Font = Enum.Font.SourceSansBold
SendBtn.BorderSizePixel = 1
SendBtn.BorderColor3 = Color3.fromRGB(60, 60, 65)
SendBtn.Parent = InputContainer
Instance.new("UICorner", SendBtn).CornerRadius = UDim.new(0, 6)

SendBtn.MouseEnter:Connect(function()
    SendBtn.BackgroundTransparency = 0.1
    SendBtn.BorderColor3 = Color3.fromRGB(150, 120, 200)
end)
SendBtn.MouseLeave:Connect(function()
    SendBtn.BackgroundTransparency = 0.3
    SendBtn.BorderColor3 = Color3.fromRGB(60, 60, 65)
end)

-- ═══════════════════════════════════════════════════════════════
-- ФУНКЦИЯ РАСЧЁТА ВЫСОТЫ (ДЛЯ БОЛЬШИХ СООБЩЕНИЙ)
-- ═══════════════════════════════════════════════════════════════
local function calculateHeight(text, maxWidth)
    local fontSize = 13
    local charsPerLine = math.floor(maxWidth / 7.5)
    local lines = math.ceil(#text / charsPerLine)
    if lines < 1 then lines = 1 end
    return lines * (fontSize + 4) + 8
end

-- ═══════════════════════════════════════════════════════════════
-- ДОБАВЛЕНИЕ СООБЩЕНИЯ (С ПРАВИЛЬНЫМ ПЕРЕНОСОМ)
-- ═══════════════════════════════════════════════════════════════
local function AddMsg(name, text, color)
    local maxNameLength = 12
    local displayName = name
    if #displayName > maxNameLength then
        displayName = string.sub(displayName, 1, maxNameLength) .. "."
    end

    local fullText = displayName .. ": " .. text

    local containerWidth = ChatScroll.AbsoluteSize.X - 20
    if containerWidth <= 0 then containerWidth = 450 end

    local calculatedHeight = calculateHeight(fullText, containerWidth)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, calculatedHeight)
    label.BackgroundTransparency = 1
    label.Text = fullText
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    label.TextSize = 13
    label.Font = Enum.Font.SourceSansBold
    label.TextStrokeTransparency = 0.3
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextWrapped = true
    label.TextScaled = false
    label.Parent = ChatScroll

    -- АНИМАЦИЯ
    label.Position = UDim2.new(-0.1, 0, 0, 0)
    label.TextTransparency = 1
    for i = 1, 12 do
        wait(0.015)
        local progress = i / 12
        label.Position = UDim2.new(-0.1 + 0.1 * progress, 0, 0, 0)
        label.TextTransparency = 1 - progress
    end
    label.Position = UDim2.new(0, 0, 0, 0)
    label.TextTransparency = 0

    ChatScroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 10)
    ChatScroll.CanvasPosition = Vector2.new(0, UIList.AbsoluteContentSize.Y)
end

-- ═══════════════════════════════════════════════════════════════
-- ПОИСК СОБЫТИЯ
-- ═══════════════════════════════════════════════════════════════
local ChatEvent = nil
for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") then
        local name = string.lower(obj.Name)
        if name:find("chat") or name:find("message") or name:find("say") then
            ChatEvent = obj
            break
        end
    end
end

if ChatEvent then
    ChatConnection = ChatEvent.OnClientEvent:Connect(function(sender, msg)
        if type(msg) == "string" and string.sub(msg, 1, 8) == "##DARK##" then
            local clean = string.sub(msg, 9)
            local player = Players:FindFirstChild(sender)
            if player and player ~= LocalPlayer then
                AddMsg(player.Name, clean, Color3.fromRGB(200, 180, 255))
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- ОТПРАВКА
-- ═══════════════════════════════════════════════════════════════
local function SendMessage()
    local text = InputBox.Text
    if text == "" then return end
    InputBox.Text = ""

    AddMsg(LocalPlayer.Name, text, Color3.fromRGB(100, 255, 150))

    if ChatEvent then
        pcall(function()
            ChatEvent:FireServer("##DARK##" .. text, "All")
        end)
    end
end

SendBtn.MouseButton1Click:Connect(SendMessage)
InputBox.FocusLost:Connect(function(enter)
    if enter then SendMessage() end
end)

-- ═══════════════════════════════════════════════════════════════
-- ОТКРЫТИЕ/ЗАКРЫТИЕ
-- ═══════════════════════════════════════════════════════════════
ToggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    Main.Visible = isOpen
    if isOpen then
        wait(0.1)
        pcall(function() InputBox:CaptureFocus() end)
    end
end)

ToggleBtn.TouchTap:Connect(function()
    isOpen = not isOpen
    Main.Visible = isOpen
    if isOpen then
        wait(0.1)
        pcall(function() InputBox:CaptureFocus() end)
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- СТАРТ
-- ═══════════════════════════════════════════════════════════════
AddMsg("🕷️ СИСТЕМА", "Тёмный чат активирован", Color3.fromRGB(150, 120, 200))
AddMsg("🕷️ СИСТЕМА", "Нажми 💬 в левом верхнем углу", Color3.fromRGB(150, 120, 200))

print("═══════════════════════════════════════════════════════════")
print("🕷️ ТЁМНЫЙ ЧАТ ЗАГРУЖЕН (v9.0)")
print("📌 Кнопка 💬 в левом верхнем углу")
print("📌 Поле ввода — 6 строк")
print("📌 Большие сообщения ОТОБРАЖАЮТСЯ")
print("═══════════════════════════════════════════════════════════")
