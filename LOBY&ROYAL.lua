-- إنشاء الواجهة الأساسية للسكربت
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SlotsContainer = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- إعدادات الشاشة وحمايتها من الاختفاء عند الموت
ScreenGui.Name = "LOBY_Teleport_System"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- تصميم الإطار الرئيسي (الصفحة الصغيرة)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 360)
MainFrame.Active = true
MainFrame.Draggable = true -- يمكنك تحريك الصفحة بيدك في الشاشة

-- عنوان السكربت (LOBY)
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "LOBY SYSTEM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20.000

-- حاوية الأماكن (Slots)
SlotsContainer.Name = "SlotsContainer"
SlotsContainer.Parent = MainFrame
SlotsContainer.BackgroundTransparency = 1.000
SlotsContainer.Position = UDim2.new(0, 5, 0, 45)
SlotsContainer.Size = UDim2.new(1, -10, 1, -50)
SlotsContainer.ScrollBarThickness = 4

UIListLayout.Parent = SlotsContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- جدول لتخزين الإحداثيات المحفوظة للأماكن الستة
local SavedLocations = {
    [1] = nil, [2] = nil, [3] = nil, [4] = nil, [5] = nil, [6] = nil
}

-- دالة جلب موقع اللاعب الحالي بأمان
local function getPlayerFrame()
    local player = game:GetService("Players").LocalPlayer
    if player and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        return root
    end
    return nil
end

-- دالة برمجية لإنشاء أسطر التحكم (من 1 إلى 6) بكل تنظيم
local function CreateSlot(number)
    local SlotFrame = Instance.new("Frame")
    local SlotName = Instance.new("TextLabel")
    local SaveBtn = Instance.new("TextButton")
    local TeleBtn = Instance.new("TextButton")
    local ClearBtn = Instance.new("TextButton")

    SlotFrame.Name = "Slot" .. number
    SlotFrame.Parent = SlotsContainer
    SlotFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    SlotFrame.Size = UDim2.new(1, 0, 0, 45)
    SlotFrame.BorderSizePixel = 0

    -- رقم المكان
    SlotName.Parent = SlotFrame
    SlotName.BackgroundTransparency = 1.000
    SlotName.Position = UDim2.new(0, 5, 0, 0)
    SlotName.Size = UDim2.new(0, 50, 1, 0)
    SlotName.Font = Enum.Font.SourceSansBold
    SlotName.Text = "مكان " .. number
    SlotName.TextColor3 = Color3.fromRGB(200, 200, 200)
    SlotName.TextSize = 16.000
    SlotName.TextXAlignment = Enum.TextXAlignment.Left

    -- زر حفظ المكان
    SaveBtn.Parent = SlotFrame
    SaveBtn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
    SaveBtn.Position = UDim2.new(0, 60, 0, 8)
    SaveBtn.Size = UDim2.new(0, 50, 0, 28)
    SaveBtn.Font = Enum.Font.SourceSansBold
    SaveBtn.Text = "حفظ"
    SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SaveBtn.TextSize = 14.000

    -- زر الانتقال
    TeleBtn.Parent = SlotFrame
    TeleBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    TeleBtn.Position = UDim2.new(0, 115, 0, 8)
    TeleBtn.Size = UDim2.new(0, 60, 0, 28)
    TeleBtn.Font = Enum.Font.SourceSansBold
    TeleBtn.Text = "انتقال"
    TeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleBtn.TextSize = 14.000

    -- زر إلغاء الحفظ
    ClearBtn.Parent = SlotFrame
    ClearBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
    ClearBtn.Position = UDim2.new(0, 180, 0, 8)
    ClearBtn.Size = UDim2.new(0, 65, 0, 28)
    ClearBtn.Font = Enum.Font.SourceSansBold
    ClearBtn.Text = "إلغاء"
    ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ClearBtn.TextSize = 14.000

    -- تفعيل الأزرار برمجياً لكل مكان بشكل منفصل
    
    -- 1. زر الحفظ
    SaveBtn.MouseButton1Click:Connect(function()
        local root = getPlayerFrame()
        if root then
            SavedLocations[number] = root.CFrame
            SaveBtn.Text = "تم ✅"
            task.wait(1)
            SaveBtn.Text = "حفظ"
        end
    end)

    -- 2. زر الانتقال
    TeleBtn.MouseButton1Click:Connect(function()
        local root = getPlayerFrame()
        if root and SavedLocations[number] then
            root.CFrame = SavedLocations[number]
        elseif not SavedLocations[number] then
            TeleBtn.Text = "فارغ X"
            task.wait(1)
            TeleBtn.Text = "انتقال"
        end
    end)

    -- 3. زر إلغاء الحفظ ومسح الإحداثيات
    ClearBtn.MouseButton1Click:Connect(function()
        if SavedLocations[number] then
            SavedLocations[number] = nil
            ClearBtn.Text = "مُسِح"
            task.wait(1)
            ClearBtn.Text = "إلغاء"
        end
    end)
end

-- تكرار لإنشاء الأماكن من 1 إلى 6 بشكل تلقائي ومنظم
for i = 1, 6 do
    CreateSlot(i)
end
