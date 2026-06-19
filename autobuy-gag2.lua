local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("UltimateSniperGUI") or game:GetService("CoreGui"):FindFirstChild("UltimateSniperGUI")
if oldGui then 
    local stopFlag = oldGui:FindFirstChild("StopFlag")
    if stopFlag then stopFlag.Value = true end
    oldGui:Destroy() 
end

local function getCurrentBalance()
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local moneyObj = leaderstats:FindFirstChild("Coins") 
            or leaderstats:FindFirstChild("Money") 
            or leaderstats:FindFirstChild("Cash")
            or leaderstats:FindFirstChild("CoinsValue")
        if moneyObj then
            return moneyObj.Value
        end
    end
    return 999999999
end

local networking = require(game.ReplicatedStorage.SharedModules.Networking)

local purchaseSeed = networking.SeedShop.PurchaseSeed
local purchaseGear = networking.GearShop.PurchaseGear
local purchaseCrate = networking.CrateShop.PurchaseCrate

local function buySeed(seedName)
    pcall(function() purchaseSeed:Fire(seedName) end)
    pcall(function() purchaseSeed:Send(seedName) end)
    pcall(function() purchaseSeed(seedName) end)
end

local function buyGear(gearName)
    pcall(function() purchaseGear:Fire(gearName) end)
    pcall(function() purchaseGear:Send(gearName) end)
    pcall(function() purchaseGear(gearName) end)
end

local function buyCrate(crateName)
    pcall(function() purchaseCrate:Fire(crateName) end)
    pcall(function() purchaseCrate:Send(crateName) end)
    pcall(function() purchaseCrate(crateName) end)
end

local AutoBuyActive = false

local SeedPrices = {
    ["Carrot"] = 1,
    ["Strawberry"] = 10,
    ["Blueberry"] = 25,
    ["Tulip"] = 40,
    ["Tomato"] = 200,
    ["Apple"] = 400,
    ["Bamboo"] = 700,
    ["Corn"] = 2500,
    ["Cactus"] = 5000,
    ["Pineapple"] = 10000,
    ["Mushroom"] = 15000,
    ["Green Bean"] = 20000,
    ["Banana"] = 30000,
    ["Grape"] = 50000,
    ["Coconut"] = 140000,
    ["Mango"] = 300000,
    ["Dragon Fruit"] = 120000,
    ["Acorn"] = 700000,
    ["Cherry"] = 1200000,
    ["Sunflower"] = 5000000,
    ["Venus Fly Trap"] = 7000000,
    ["Pomegranate"] = 12000000,
    ["Poison Apple"] = 25000000,
    ["Moon Bloom"] = 65000000,
    ["Dragon's Breath"] = 90000000
}

local GearPrices = {
    ["Common Watering Can"] = 2000,
    ["Common Sprinkler"] = 3000,
    ["Sign"] = 4000,
    ["Uncommon Sprinkler"] = 10000,
    ["Trowel"] = 1000,
    ["Rare Sprinkler"] = 80000,
    ["Jump Mushroom"] = 1800,
    ["Speed Mushroom"] = 1500,
    ["Lantern"] = 12000,
    ["Shrink Mushroom"] = 10000,
    ["Supersize Mushroom"] = 4500,
    ["Gnome"] = 100000,
    ["Flashbang"] = 20000,
    ["Basic Pot"] = 300000,
    ["Legendary Sprinkler"] = 1200000,
    ["Invisibility Mushroom"] = 30000,
    ["Teleporter"] = 60000,
    ["Wheelbarrow"] = 500000,
    ["Super Watering Can"] = 1000000,
    ["Super Sprinkler"] = 3000000
}

local seedsList = {}
local gearsList = {}

for name in pairs(SeedPrices) do table.insert(seedsList, name) end
for name in pairs(GearPrices) do table.insert(gearsList, name) end

local TargetSeeds = {}
local TargetGears = {}
for _, name in ipairs(seedsList) do TargetSeeds[name] = false end
for _, name in ipairs(gearsList) do TargetGears[name] = false end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateSniperGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local StopFlag = Instance.new("BoolValue")
StopFlag.Name = "StopFlag"
StopFlag.Value = false
StopFlag.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 340)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Title.Text = "🌱🔧 GaG 2 Auto-Buyer"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 14
CloseBtn.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
MinimizeBtn.Position = UDim2.new(1, -62, 0, 4)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = Title

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 4)
MinCorner.Parent = MinimizeBtn

local MainToggleBtn = Instance.new("TextButton")
MainToggleBtn.Size = UDim2.new(1, -14, 0, 40)
MainToggleBtn.Position = UDim2.new(0, 7, 0, 42)
MainToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
MainToggleBtn.Text = "🔴 Auto-Buy: OFF"
MainToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainToggleBtn.Font = Enum.Font.SourceSansBold
MainToggleBtn.TextSize = 13
MainToggleBtn.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = MainToggleBtn

MainToggleBtn.MouseButton1Click:Connect(function()
    AutoBuyActive = not AutoBuyActive
    if AutoBuyActive then
        MainToggleBtn.BackgroundColor3 = Color3.fromRGB(46, 125, 50)
        MainToggleBtn.Text = "🟢 Auto-Buy: ON"
    else
        MainToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        MainToggleBtn.Text = "🔴 Auto-Buy: OFF"
    end
end)

local ContainerScroll = Instance.new("ScrollingFrame")
ContainerScroll.Size = UDim2.new(1, -14, 1, -95)
ContainerScroll.Position = UDim2.new(0, 7, 0, 88)
ContainerScroll.BackgroundTransparency = 1
ContainerScroll.BorderSizePixel = 0
ContainerScroll.CanvasSize = UDim2.new(0, 0, 0, 300)
ContainerScroll.ScrollBarThickness = 5
ContainerScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
ContainerScroll.Parent = MainFrame

local ContainerLayout = Instance.new("UIListLayout")
ContainerLayout.Padding = UDim.new(0, 8)
ContainerLayout.Parent = ContainerScroll

local function formatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000):gsub("%.0", "")
    elseif num >= 1000 then
        return string.format("%.1fk", num / 1000):gsub("%.0", "")
    end
    return tostring(num)
end

local function createDropdown(titleText, items, targetTable, priceTable)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, -6, 0, 32)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = ContainerScroll

    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 6)
    DropdownCorner.Parent = DropdownFrame

    local HeaderBtn = Instance.new("TextButton")
    HeaderBtn.Size = UDim2.new(1, 0, 0, 32)
    HeaderBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    HeaderBtn.Text = "➕ " .. titleText
    HeaderBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    HeaderBtn.Font = Enum.Font.SourceSansBold
    HeaderBtn.TextSize = 13
    HeaderBtn.Parent = DropdownFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 6)
    HeaderCorner.Parent = HeaderBtn

    local ItemsListFrame = Instance.new("Frame")
    ItemsListFrame.Size = UDim2.new(1, -10, 0, #items * 34)
    ItemsListFrame.Position = UDim2.new(0, 5, 0, 36)
    ItemsListFrame.BackgroundTransparency = 1
    ItemsListFrame.Parent = DropdownFrame

    local ItemsLayout = Instance.new("UIListLayout")
    ItemsLayout.Padding = UDim.new(0, 4)
    ItemsLayout.Parent = ItemsListFrame

    for _, itemName in ipairs(items) do
        local price = priceTable[itemName] or 0
        local priceText = formatNumber(price)
        
        local ItemBtn = Instance.new("TextButton")
        ItemBtn.Size = UDim2.new(1, 0, 0, 30)
        ItemBtn.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
        ItemBtn.Text = string.format("❌ %s (%s ¢)", itemName, priceText)
        ItemBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        ItemBtn.Font = Enum.Font.SourceSansSemibold
        ItemBtn.TextSize = 13
        ItemBtn.Parent = ItemsListFrame

        local ItemCorner = Instance.new("UICorner")
        ItemCorner.CornerRadius = UDim.new(0, 4)
        ItemCorner.Parent = ItemBtn

        ItemBtn.MouseButton1Click:Connect(function()
            targetTable[itemName] = not targetTable[itemName]
            if targetTable[itemName] then
                ItemBtn.BackgroundColor3 = Color3.fromRGB(46, 125, 50)
                ItemBtn.Text = string.format("⚡ СНАЙП: %s (%s ¢)", itemName, priceText)
                ItemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                ItemBtn.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
                ItemBtn.Text = string.format("❌ %s (%s ¢)", itemName, priceText)
                ItemBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
        end)
    end

    local isOpen = false
    local function toggleDropdown()
        isOpen = not isOpen
        local itemCount = #items
        local targetSizeY = isOpen and (36 + (itemCount * 34) + 5) or 32
        HeaderBtn.Text = (isOpen and "➖ " or "➕ ") .. titleText
        
        TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -6, 0, targetSizeY)}):Play()
        task.wait(0.2)
        ContainerScroll.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 20)
    end
    
    HeaderBtn.MouseButton1Click:Connect(toggleDropdown)
end

createDropdown("🌱 Seeds", seedsList, TargetSeeds, SeedPrices)
createDropdown("🔧 Gears", gearsList, TargetGears, GearPrices)

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 250, 0, 35)}):Play()
        ContainerScroll.Visible = false
        MainToggleBtn.Visible = false
        MinimizeBtn.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 250, 0, 340)}):Play()
        ContainerScroll.Visible = true
        MainToggleBtn.Visible = true
        MinimizeBtn.Text = "−"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    StopFlag.Value = true
    ScreenGui:Destroy()
end)

local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

task.spawn(function()
    while not StopFlag.Value do
        if AutoBuyActive then
            local currentBalance = getCurrentBalance()
            
            for seedName, isSelected in pairs(TargetSeeds) do
                if isSelected then
                    local price = SeedPrices[seedName] or 0
                    if currentBalance >= price then
                        buySeed(seedName)
                        buySeed(seedName .. " Seed")
                        currentBalance = currentBalance - price
                    end
                end
            end
            
            for gearName, isSelected in pairs(TargetGears) do
                if isSelected then
                    local price = GearPrices[gearName] or 0
                    if currentBalance >= price then
                        buyGear(gearName)
                        buyCrate(gearName)
                        currentBalance = currentBalance - price
                    end
                end
            end
            
            task.wait(0.1)
        else
            task.wait(0.2)
        end
    end
end)

player.Idled:Connect(function()
    pcall(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new(0, 0))
    end)
end)
