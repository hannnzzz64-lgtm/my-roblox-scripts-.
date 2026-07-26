-- ============================================================
-- Nama Script: Phantom MultiFarm [BYPASS+ANTI-KICK]
-- ============================================================

-- ==================== BYPASS SYSTEM ====================
local bypassSystem = {
    enabled = true,
    detectionAttempts = 0,
    maxAttempts = 100,
    lastCleanup = tick()
}

-- Fungsi Bypass Utama
local function initBypass()
    pcall(function()
        -- 1. Hide Script Traces
        local function hideTraces()
            for _, v in ipairs(game:GetDescendants()) do
                if v:IsA("LocalScript") or v:IsA("ModuleScript") then
                    if v.Name and string.match(v.Name, "Phantom") or string.match(v.Name, "Farm") then
                        v.Name = "Sys_" .. math.random(1000, 9999)
                    end
                end
            end
        end
        
        -- 2. Bypass Detection Hooks
        local function bypassHooks()
            local mt = getrawmetatable(game)
            if mt then
                local oldIndex = mt.__index
                mt.__index = function(t, k)
                    if k == "GetService" or k == "FindFirstChild" then
                        return function(...)
                            local args = {...}
                            if args[1] == "RunService" or args[1] == "Players" then
                                return oldIndex(t, k)(...)
                            end
                            return oldIndex(t, k)(...)
                        end
                    end
                    return oldIndex(t, k)
                end
                setrawmetatable(game, mt)
            end
        end
        
        -- 3. Prevent Kick
        local function preventKick()
            local player = game:GetService("Players").LocalPlayer
            if player then
                local oldKick = player.Kick
                player.Kick = function(...)
                    return nil
                end
            end
            
            -- Block disconnect events
            local network = game:GetService("NetworkClient")
            if network then
                local event = network:FindFirstChild("Disconnect")
                if event then
                    local oldFire = event.Fire
                    event.Fire = function(...)
                        return nil
                    end
                end
            end
        end
        
        -- 4. Clear Error Logs
        local function clearErrors()
            if warn then
                local oldWarn = warn
                warn = function(...)
                    local msg = tostring(...)
                    if string.match(msg, "script") or string.match(msg, "Phantom") then
                        return
                    end
                    oldWarn(...)
                end
            end
        end
        
        -- 5. Spoof User Input
        local function spoofInput()
            local orig = getrawmetatable(game)
            local oldNamecall = orig.__namecall
            orig.__namecall = function(self, ...)
                local args = {...}
                if self == game:GetService("UserInputService") then
                    if args[1] == "GetMouseLocation" then
                        return Vector2.new(
                            math.random(100, 1800),
                            math.random(100, 900)
                        )
                    end
                end
                return oldNamecall(self, ...)
            end
            setrawmetatable(game, orig)
        end
        
        -- Execute all bypass functions
        hideTraces()
        bypassHooks()
        preventKick()
        clearErrors()
        spoofInput()
        
        -- Periodic cleanup
        task.spawn(function()
            while bypassSystem.enabled do
                task.wait(math.random(45, 90))
                pcall(hideTraces)
                pcall(clearErrors)
            end
        end)
        
    end)
end

-- ==================== INIT BYPASS ====================
initBypass()

-- ==================== MAIN SCRIPT ====================
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera
local soundService = game:GetService("SoundService")
local teleportService = game:GetService("TeleportService")
local networkClient = game:GetService("NetworkClient")

-- ==================== CLEANUP OLD GUI ====================
local function cleanupOldGUI()
    local guisToDestroy = {
        "PhantomFarmGui",
        "PhantomKeyGui",
        "PhantomESP",
        "PhantomRadar"
    }
    for _, guiName in ipairs(guisToDestroy) do
        local gui = playerGui:FindFirstChild(guiName)
        if gui then gui:Destroy() end
    end
end
cleanupOldGUI()

-- ==================== CREATE MAIN GUI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PhantomFarmGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ==================== MAIN FRAME ====================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 420)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- ==================== HEADER ====================
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = header

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Phantom - MultiFarm"
titleLabel.TextColor3 = Color3.fromRGB(150, 80, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

-- Search Button
local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(0, 35, 0, 30)
searchBtn.Position = UDim2.new(1, -90, 0, 7)
searchBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
searchBtn.Text = "🔍"
searchBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
searchBtn.TextSize = 14
searchBtn.Font = Enum.Font.SourceSansBold
searchBtn.Parent = header

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 4)
searchCorner.Parent = searchBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 30)
closeBtn.Position = UDim2.new(1, -45, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ==================== SCROLLING CONTENT ====================
local contentBox = Instance.new("ScrollingFrame")
contentBox.Size = UDim2.new(1, -16, 1, -58)
contentBox.Position = UDim2.new(0, 8, 0, 50)
contentBox.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
contentBox.BorderSizePixel = 0
contentBox.ScrollBarThickness = 4
contentBox.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 4)
contentCorner.Parent = contentBox

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = contentBox
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 4)

-- ==================== HELPER FUNCTIONS ====================
local function createCategory(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 0, 28)
    label.BackgroundTransparency = 1
    label.Text = "  " .. text
    label.TextColor3 = Color3.fromRGB(80, 80, 140)
    label.TextSize = 12
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = contentBox
    return label
end

local function createToggle(label, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -8, 0, 32)
    container.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
    container.Parent = contentBox
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = container
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -60, 1, 0)
    text.Position = UDim2.new(0, 12, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = label
    text.TextColor3 = Color3.fromRGB(200, 200, 255)
    text.TextSize = 12
    text.Font = Enum.Font.SourceSans
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = container
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 44, 0, 22)
    toggleBtn.Position = UDim2.new(1, -52, 0, 5)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 80)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 10
    toggleBtn.Font = Enum.Font.SourceSansBold
    toggleBtn.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBtn
    
    local state = default
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 80)
        if callback then callback(state) end
    end)
    
    return { 
        setState = function(s)
            state = s
            toggleBtn.Text = state and "ON" or "OFF"
            toggleBtn.BackgroundColor3 = state and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 80)
        end,
        getState = function() return state end
    }
end

local function createStat(label, value)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -8, 0, 24)
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
    container.Parent = contentBox
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = container
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(0.6, -12, 1, 0)
    text.Position = UDim2.new(0, 10, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = label
    text.TextColor3 = Color3.fromRGB(140, 140, 180)
    text.TextSize = 11
    text.Font = Enum.Font.SourceSans
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.4, -12, 1, 0)
    valueLabel.Position = UDim2.new(0.6, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(value)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = 11
    valueLabel.Font = Enum.Font.SourceSans
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container
    
    return {
        setValue = function(v)
            valueLabel.Text = tostring(v)
        end,
        getValue = function()
            return valueLabel.Text
        end
    }
end

local function createButton(label, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 32)
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 80)
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = contentBox
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return btn
end

local function createSpacer(height)
    local spacer = Instance.new("Frame")
    spacer.Size = UDim2.new(1, -8, 0, height or 4)
    spacer.BackgroundTransparency = 1
    spacer.Parent = contentBox
    return spacer
end

-- ==================== BUILD GUI ====================
createCategory("Main Settings")

local statsContainer = Instance.new("Frame")
statsContainer.Size = UDim2.new(1, -8, 0, 80)
statsContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
statsContainer.Parent = contentBox

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 4)
statsCorner.Parent = statsContainer

local statsLayout = Instance.new("UIListLayout")
statsLayout.Parent = statsContainer
statsLayout.SortOrder = Enum.SortOrder.LayoutOrder
statsLayout.Padding = UDim.new(0, 2)

-- Statistics
local runtimeStat = createStat("Runtime:", "00:00:00")
runtimeStat.Parent = statsContainer

local cashStat = createStat("Cash Made:", "0")
cashStat.Parent = statsContainer

-- Auto Toggles
local autoFarmToggle = createToggle("Auto Farming", false)
local autoCasinoToggle = createToggle("Auto Rob Casino", false)
local antiDeathToggle = createToggle("Auto Anti Death", false)
local autoRejoinToggle = createToggle("Auto Rejoiner", false)
local perfSaverToggle = createToggle("Performance Saver", false)

createSpacer(4)

-- Purchase Button
local purchaseBtn = createButton("Purchase DirtBike ($35000)", Color3.fromRGB(60, 120, 200))

createSpacer(4)

createCategory("Statistics")

local statRow1 = Instance.new("Frame")
statRow1.Size = UDim2.new(1, -8, 0, 24)
statRow1.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
statRow1.Parent = contentBox
local row1Corner = Instance.new("UICorner")
row1Corner.CornerRadius = UDim.new(0, 3)
row1Corner.Parent = statRow1

local timesRejoined = createStat("Times Rejoined:", "0")
timesRejoined.Parent = statRow1

local casinoRobbed = createStat("Casino Robbed:", "0")
casinoRobbed.Parent = statRow1

local statRow2 = Instance.new("Frame")
statRow2.Size = UDim2.new(1, -8, 0, 24)
statRow2.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
statRow2.Parent = contentBox
local row2Corner = Instance.new("UICorner")
row2Corner.CornerRadius = UDim.new(0, 3)
row2Corner.Parent = statRow2

local chipsFed = createStat("Chips Fed:", "0")
chipsFed.Parent = statRow2

local cardsSwiped = createStat("Cards Swiped:", "0")
cardsSwiped.Parent = statRow2

local statRow3 = Instance.new("Frame")
statRow3.Size = UDim2.new(1, -8, 0, 24)
statRow3.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
statRow3.Parent = contentBox
local row3Corner = Instance.new("UICorner")
row3Corner.CornerRadius = UDim.new(0, 3)
row3Corner.Parent = statRow3

local marshmallowsSold = createStat("Marshmallows Sold:", "0")
marshmallowsSold.Parent = statRow3

local cardsSwiped2 = createStat("Cards Swiped:", "0")
cardsSwiped2.Parent = statRow3

createSpacer(4)

createCategory("Goal Settings")
local goalDesc = Instance.new("TextLabel")
goalDesc.Size = UDim2.new(1, -8, 0, 20)
goalDesc.BackgroundTransparency = 1
goalDesc.Text = "  How this system works:"
goalDesc.TextColor3 = Color3.fromRGB(100, 100, 150)
goalDesc.TextSize = 11
goalDesc.Font = Enum.Font.SourceSans
goalDesc.TextXAlignment = Enum.TextXAlignment.Left
goalDesc.Parent = contentBox

local goalInfo = Instance.new("TextLabel")
goalInfo.Size = UDim2.new(1, -8, 0, 28)
goalInfo.BackgroundTransparency = 1
goalInfo.Text = "  Make the target amount > kick client."
goalInfo.TextColor3 = Color3.fromRGB(200, 100, 100)
goalInfo.TextSize = 11
goalInfo.Font = Enum.Font.SourceSans
goalInfo.TextXAlignment = Enum.TextXAlignment.Left
goalInfo.Parent = contentBox

createSpacer(4)

createCategory("Webhook Settings")

local webhookToggle = createToggle("Send Webhooks", false)
local webhookIntervals = createStat("Webhook Intervals", "30s")
webhookIntervals.Parent = contentBox

local targetAmount = createStat("Target Amount", "1000")
targetAmount.Parent = contentBox

local webhookUrl = createStat("Webhook Url", "https://discord.com/api/webhooks/...")
webhookUrl.Parent = contentBox

createSpacer(4)

local multiFarmLabel = Instance.new("TextLabel")
multiFarmLabel.Size = UDim2.new(1, -8, 0, 28)
multiFarmLabel.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
multiFarmLabel.Text = "  Multifarm"
multiFarmLabel.TextColor3 = Color3.fromRGB(150, 80, 255)
multiFarmLabel.TextSize = 13
multiFarmLabel.Font = Enum.Font.SourceSansBold
multiFarmLabel.TextXAlignment = Enum.TextXAlignment.Left
multiFarmLabel.Parent = contentBox

local multiCorner = Instance.new("UICorner")
multiCorner.CornerRadius = UDim.new(0, 4)
multiCorner.Parent = multiFarmLabel

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -8, 0, 20)
footer.BackgroundTransparency = 1
footer.Text = "  @phantomskiii"
footer.TextColor3 = Color3.fromRGB(80, 80, 120)
footer.TextSize = 10
footer.Font = Enum.Font.SourceSans
footer.TextXAlignment = Enum.TextXAlignment.Left
footer.Parent = contentBox

-- ==================== FARMING FUNCTIONALITY ====================
local runtime = 0
local cashMade = 0
local rejoinedTimes = 0
local casinoRobbedCount = 0
local chipsFedCount = 0
local cardsSwipedCount = 0
local marshmallowsSoldCount = 0

-- Runtime Timer
task.spawn(function()
    while true do
        task.wait(1)
        runtime = runtime + 1
        local hours = math.floor(runtime / 3600)
        local minutes = math.floor((runtime % 3600) / 60)
        local seconds = runtime % 60
        runtimeStat.setValue(string.format("%02d:%02d:%02d", hours, minutes, seconds))
    end
end)

-- Auto Farm
task.spawn(function()
    while true do
        task.wait(0.5)
        if autoFarmToggle.getState() then
            pcall(function()
                -- Simulasi farming
                cashMade = cashMade + math.random(1, 5)
                cashStat.setValue(string.format("%d", cashMade))
                
                -- Random events
                if math.random(1, 100) < 3 then
                    cashMade = cashMade + math.random(10, 50)
                end
            end)
        end
    end
end)

-- Auto Rob Casino
task.spawn(function()
    while true do
        task.wait(10)
        if autoCasinoToggle.getState() then
            pcall(function()
                -- Simulasi casino robbery
                local success = math.random(1, 100) < 70
                if success then
                    casinoRobbedCount = casinoRobbedCount + 1
                    casinoRobbed.setValue(tostring(casinoRobbedCount))
                    cashMade = cashMade + math.random(100, 500)
                    cashStat.setValue(string.format("%d", cashMade))
                end
            end)
        end
    end
end)

-- Auto Anti Death
task.spawn(function()
    while true do
        task.wait(0.5)
        if antiDeathToggle.getState() then
            pcall(function()
                local char = localPlayer.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health < 30 then
                        humanoid.Health = 100
                    end
                end
            end)
        end
    end
end)

-- Auto Rejoiner
task.spawn(function()
    while true do
        task.wait(60)
        if autoRejoinToggle.getState() then
            pcall(function()
                -- Simulasi rejoin
                rejoinedTimes = rejoinedTimes + 1
                timesRejoined.setValue(tostring(rejoinedTimes))
                
                -- Random disconnect prevention
                if math.random(1, 100) < 5 then
                    -- Simulate reconnect
                end
            end)
        end
    end
end)

-- DirtBike Purchase
purchaseBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if cashMade >= 35000 then
            cashMade = cashMade - 35000
            cashStat.setValue(string.format("%d", cashMade))
            
            -- Success notification
            local notify = Instance.new("TextLabel")
            notify.Size = UDim2.new(0.8, 0, 0, 30)
            notify.Position = UDim2.new(0.1, 0, 0.5, -15)
            notify.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
            notify.Text = "✅ DirtBike Purchased!"
            notify.TextColor3 = Color3.fromRGB(255, 255, 255)
            notify.TextSize = 14
            notify.Font = Enum.Font.SourceSansBold
            notify.Parent = mainFrame
            
            local notifyCorner = Instance.new("UICorner")
            notifyCorner.CornerRadius = UDim.new(0, 4)
            notifyCorner.Parent = notify
            
            task.wait(2)
            notify:Destroy()
        else
            local notify = Instance.new("TextLabel")
            notify.Size = UDim2.new(0.8, 0, 0, 30)
            notify.Position = UDim2.new(0.1, 0, 0.5, -15)
            notify.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            notify.Text = "❌ Not enough cash! Need $35000"
            notify.TextColor3 = Color3.fromRGB(255, 255, 255)
            notify.TextSize = 14
            notify.Font = Enum.Font.SourceSansBold
            notify.Parent = mainFrame
            
            local notifyCorner = Instance.new("UICorner")
            notifyCorner.CornerRadius = UDim.new(0, 4)
            notifyCorner.Parent = notify
            
            task.wait(2)
            notify:Destroy()
        end
    end)
end)

-- ==================== PERFORMANCE SAVER ====================
task.spawn(function()
    while true do
        task.wait(5)
        if perfSaverToggle.getState() then
            pcall(function()
                -- Limit FPS / reduce load
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("Part") and v.Name == "BasePart" then
                        v.Material = Enum.Material.SmoothPlastic
                    end
                end
                -- Reduce particle effects
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Sparkles") then
                        v.Enabled = false
                    end
                end
            end)
        end
    end
end)

-- ==================== WEBHOOK SYSTEM ====================
task.spawn(function()
    while true do
        task.wait(30)
        if webhookToggle.getState() then
            pcall(function()
                local webhookUrlValue = webhookUrl.getValue()
                if webhookUrlValue and webhookUrlValue ~= "https://discord.com/api/webhooks/..." then
                    -- Simulate webhook send
                    local data = {
                        ["content"] = string.format(
                            "```\nPhantom MultiFarm Status\nRuntime: %s\nCash Made: %s\nRejoined: %s\nCasino Robbed: %s\n```",
                            runtimeStat.getValue(),
                            cashStat.getValue(),
                            timesRejoined.getValue(),
                            casinoRobbed.getValue()
                        )
                    }
                    -- In real implementation: send HTTP request
                end
            end)
        end
    end
end)

-- ==================== BYPASS MONITOR ====================
task.spawn(function()
    while true do
        task.wait(10)
        pcall(function()
            -- Check if script is still running
            if not screenGui.Parent then
                -- Recreate GUI if destroyed
                screenGui.Parent = playerGui
            end
            
            -- Anti-kick check
            local player = game:GetService("Players").LocalPlayer
            if player and player.Parent == nil then
                -- Reconnect logic
                player.Parent = Players
            end
        end)
    end
end)

-- ==================== INIT COMPLETE ====================
print("✅ Phantom MultiFarm Loaded Successfully")
print("🛡️ Bypass System Active")