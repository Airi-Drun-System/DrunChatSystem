-- ============================================================
-- 🕷️ AIRI DARK CHAT (УПРОЩЁННАЯ ВЕРСИЯ)
-- ============================================================

print("🕷️ Тёмный чат загружается...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GUI
local guiParent = LocalPlayer:FindFirstChild("PlayerGui")
if not guiParent then
    guiParent = Instance.new("ScreenGui")
    guiParent.Name = "AiriGUI"
    guiParent.Parent = LocalPlayer
end

local old = guiParent:FindFirstChild("AiriDarkChat")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AiriDarkChat"
ScreenGui.Parent = guiParent
ScreenGui.ResetOnSpawn = false

-- КНОПКА ОТКРЫТИЯ ЧАТА (ЛЕВЫЙ ВЕРХНИЙ УГОЛ)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleBtn.Text = "💬"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 28
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.BorderSizePixel = 2
toggleBtn.BorderColor3 = Color3.fromRGB(100, 100, 120)
toggleBtn.Parent = ScreenGui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

-- ОКНО ЧАТА
local chatFrame = Instance.new("Frame")
chatFrame.Size = UDim2.new(0, 400, 0, 350)
chatFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
chatFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
chatFrame.BackgroundTransparency = 0.1
chatFrame.BorderSizePixel = 1
chatFrame.BorderColor3 = Color3.fromRGB(40, 40, 50)
chatFrame.Visible = false
chatFrame.Parent = ScreenGui
chatFrame.Active = true
chatFrame.Draggable = true
Instance.new("UICorner", chatFrame).CornerRadius = UDim.new(0, 12)

-- ЗАГОЛОВОК
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.Parent = chatFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -80, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🕷️ ТЁМНЫЙ ЧАТ"
titleText.TextColor3 = Color3.fromRGB(180, 160, 220)
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.SourceSansBold
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
closeBtn.BackgroundTransparency = 0.5
closeBtn.Text = "❌"
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.BorderSizePixel = 1
closeBtn.BorderColor3 = Color3.fromRGB(60, 60, 70)
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() chatFrame.Visible = false end)

-- ЛОГ СООБЩЕНИЙ
local chatScroll = Instance.new("ScrollingFrame")
chatScroll.Size = UDim2.new(1, -12, 1, -80)
chatScroll.Position = UDim2.new(0, 6, 0, 40)
chatScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
chatScroll.BackgroundTransparency = 0.4
chatScroll.BorderSizePixel = 1
chatScroll.BorderColor3 = Color3.fromRGB(30, 30, 40)
chatScroll.ScrollBarThickness = 4
chatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
chatScroll.Parent = chatFrame
Instance.new("UICorner", chatScroll).CornerRadius = UDim.new(0, 8)

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 4)
uiList.Parent = chatScroll

-- ПОЛЕ ВВОДА
local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(1, -12, 0, 34)
inputFrame.Position = UDim2.new(0, 6, 1, -40)
inputFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
inputFrame.BackgroundTransparency = 0.4
inputFrame.BorderSizePixel = 1
inputFrame.BorderColor3 = Color3.fromRGB(40, 40, 50)
inputFrame.Parent = chatFrame
Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 8)

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -75, 1, 0)
inputBox.Position = UDim2.new(0, 10, 0, 0)
inputBox.BackgroundTransparency = 1
inputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
inputBox.PlaceholderText = "Напиши..."
inputBox.Text = ""
inputBox.TextSize = 14
inputBox.Font = Enum.Font.SourceSans
inputBox.ClearTextOnFocus = false
inputBox.TextWrapped = true
inputBox.Parent = inputFrame

local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0, 55, 1, -4)
sendBtn.Position = UDim2.new(1, -60, 0, 2)
sendBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
sendBtn.BackgroundTransparency = 0.3
sendBtn.Text = "📩"
sendBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
sendBtn.TextSize = 18
sendBtn.Font = Enum.Font.SourceSansBold
sendBtn.BorderSizePixel = 1
sendBtn.BorderColor3 = Color3.fromRGB(60, 60, 70)
sendBtn.Parent = inputFrame
Instance.new("UICorner", sendBtn).CornerRadius = UDim.new(0, 6)

-- ═══════════════════════════════════════════════════════════════
-- ФУНКЦИИ ЧАТА
-- ═══════════════════════════════════════════════════════════════

local function AddMsg(name, text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    label.TextSize = 13
    label.Font = Enum.Font.SourceSansBold
    label.TextWrapped = true
    label.Parent = chatScroll
    
    wait()
    local height = label.TextBounds.Y + 6
    if height < 20 then height = 20 end
    label.Size = UDim2.new(1, -10, 0, height)
    
    chatScroll.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 10)
    chatScroll.CanvasPosition = Vector2.new(0, uiList.AbsoluteContentSize.Y)
end

-- ═══════════════════════════════════════════════════════════════
-- ОТКРЫТИЕ/ЗАКРЫТИЕ ЧАТА
-- ═══════════════════════════════════════════════════════════════
toggleBtn.MouseButton1Click:Connect(function()
    chatFrame.Visible = not chatFrame.Visible
    if chatFrame.Visible then
        inputBox:CaptureFocus()
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- ОТПРАВКА СООБЩЕНИЯ
-- ═══════════════════════════════════════════════════════════════
local function SendMessage()
    local text = inputBox.Text
    if text == "" then return end
    inputBox.Text = ""
    
    AddMsg(LocalPlayer.Name, text, Color3.fromRGB(100, 255, 150))
    
    -- ОТПРАВКА ДРУГИМ (через стандартный чат Roblox)
    pcall(function()
        local ChatService = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if ChatService then
            local SayMessageRequest = ChatService:FindFirstChild("SayMessageRequest")
            if SayMessageRequest then
                SayMessageRequest:FireServer(text, "All")
            end
        end
    end)
end

sendBtn.MouseButton1Click:Connect(SendMessage)
inputBox.FocusLost:Connect(function(enter)
    if enter then SendMessage() end
end)

-- ═══════════════════════════════════════════════════════════════
-- ЗАПУСК
-- ═══════════════════════════════════════════════════════════════
AddMsg("🕷️ СИСТЕМА", "Тёмный чат активирован", Color3.fromRGB(150, 120, 200))
AddMsg("🕷️ СИСТЕМА", "Нажми 💬 в левом верхнем углу", Color3.fromRGB(150, 120, 200))

print("🕷️ ТЁМНЫЙ ЧАТ ЗАГРУЖЕН!")
