-- RAMZ UI Menu Template dengan Keybind (Tekan 'L' untuk Toggle)
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local AutoFarmBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Background putih biru
MainFrame.Name = "JetyxFram"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(240, 248, 255)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.Size = UDim2.new(0, 450, 0, 300)

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 100, 255)
UIStroke.Thickness = 2

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.00
Title.Position = UDim2.new(0, 16, 0, 16)
Title.Size = UDim2.new(0, 200, 0, 20)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "JetyxFram"
Title.TextColor3 = Color3.fromRGB(0, 80, 200)
Title.TextSize = 16.00
Title.TextXAlignment = Enum.TextXAlignment.Left

AutoFarmBtn.Name = "AutoFarmBtn"
AutoFarmBtn.Parent = MainFrame
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmBtn.Position = UDim2.new(0, 16, 0, 50)
AutoFarmBtn.Size = UDim2.new(0, 150, 0, 35)
AutoFarmBtn.Font = Enum.Font.SourceSansBold
AutoFarmBtn.Text = "Start AutoFarm"
AutoFarmBtn.TextColor3 = Color3.fromRGB(0, 80, 200)
AutoFarmBtn.TextSize = 14
AutoFarmBtn.BorderColor3 = Color3.fromRGB(0, 100, 255)
AutoFarmBtn.BorderSizePixel = 2

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = AutoFarmBtn

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 16, 0, 100)
StatusLabel.Size = UDim2.new(0, 200, 0, 20)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(0, 60, 150)
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Variables
local autoFarmActive = false
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Function to find NPCs
local function findNPCs()
    local npcs = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():match("npc|enemy|zombie|bandit|gang|thug") then
            local humanoid = v:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local rootPart = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Torso")
                if rootPart then
                    table.insert(npcs, v)
                end
            end
        end
    end
    return npcs
end

-- OPTIMIZED TELEPORT: Lebih lambat & natural untuk hindari deteksi
local function smoothTeleport(targetPart)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local rootPart = character.HumanoidRootPart
    local targetPos = targetPart.Position
    local currentPos = rootPart.Position

    -- Offset lebih acak untuk simulasi gerakan manusia
    local offset = Vector3.new(
        math.random(-3, 3),
        math.random(-1, 1),
        math.random(-3, 3)
    )
    targetPos = targetPos + offset

    local distance = (targetPos - currentPos).Magnitude
    if distance < 5 then return end -- Hindari teleport jarak dekat

    -- KECEPATAN LEBIH RENDAH & NATURAL
    local baseSpeed = 20 -- Kecepatan dasar lebih rendah
    local speed = baseSpeed

    -- Variasi kecepatan berdasarkan jarak (semakin jauh semakin cepat, tapi tetap aman)
    if distance < 30 then
        speed = 16 + math.random(0, 6) -- 16-22
    elseif distance < 80 then
        speed = 25 + math.random(0, 10) -- 25-35
    else
        speed = 35 + math.random(0, 15) -- 35-50 (lebih lambat dari sebelumnya)
    end

    -- Tambahkan delay acak sebelum mulai gerak
    wait(math.random(5, 20) / 100)

    local timeToMove = distance / speed
    local startTime = tick()
    local startPos = currentPos

    -- GERAKAN BERTAHAP DENGAN EASING (Simulasi akselerasi)
    while (tick() - startTime) < timeToMove do
        local elapsed = tick() - startTime
        local alpha = elapsed / timeToMove

        -- Easing function untuk gerakan lebih natural (ease-in-out)
        local easedAlpha = alpha * alpha * (3 - 2 * alpha) -- Smoothstep
        local newPos = startPos:Lerp(targetPos, easedAlpha)

        -- Tambahkan sedikit getaran acak pada posisi (simulasi gerakan tidak sempurna)
        local jitter = Vector3.new(
            math.random(-2, 2) * 0.1,
            math.random(-1, 1) * 0.1,
            math.random(-2, 2) * 0.1
        )
        rootPart.CFrame = CFrame.new(newPos + jitter)

        -- Delay lebih lama antar frame untuk memperlambat gerakan
        wait(0.03 + math.random(0, 2) / 100) -- 30-50ms
    end

    -- Finalisasi dengan delay acak dan sedikit offset
    wait(math.random(10, 30) / 100)
    local finalOffset = Vector3.new(
        math.random(-1, 1) * 0.5,
        0,
        math.random(-1, 1) * 0.5
    )
    rootPart.CFrame = CFrame.new(targetPos + finalOffset)

    -- Tunggu sebentar sebelum aksi berikutnya
    wait(math.random(20, 40) / 100)
end

-- AutoFarm function
local function startAutoFarm()
    autoFarmActive = true
    StatusLabel.Text = "Status: Farming..."
    StatusLabel.TextColor3 = Color3.fromRGB(0, 150, 50)
    AutoFarmBtn.Text = "Stop AutoFarm"
    AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 200)
    AutoFarmBtn.TextColor3 = Color3.fromRGB(200, 0, 0)

    while autoFarmActive do
        local npcs = findNPCs()
        local nearestNPC = nil
        local nearestDist = math.huge

        if not character or not character:FindFirstChild("HumanoidRootPart") then
            wait(1)
            continue
        end

        local rootPart = character.HumanoidRootPart

        for _, npc in pairs(npcs) do
            local npcRoot = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Torso")
            if npcRoot then
                local dist = (npcRoot.Position - rootPart.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestNPC = npc
                end
            end
        end

        if nearestNPC then
            local npcRoot = nearestNPC:FindFirstChild("HumanoidRootPart") or nearestNPC:FindFirstChild("Torso")
            if npcRoot then
                smoothTeleport(npcRoot)

                local humanoid = nearestNPC:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    humanoid.Health = humanoid.Health - math.random(5, 15)
                    StatusLabel.Text = "Status: Attacking " .. nearestNPC.Name

                    -- Delay lebih lama antar serangan (2-4 detik)
                    wait(math.random(20, 40) / 10)
                else
                    wait(0.8)
                end
            end
        else
            StatusLabel.Text = "Status: Searching for NPCs..."
            wait(1.5)
        end

        -- Jeda lebih sering untuk menghindari pola terdeteksi
        if math.random(1, 100) > 70 then
            wait(math.random(3, 8))
        end
    end
end

-- Stop AutoFarm
local function stopAutoFarm()
    autoFarmActive = false
    StatusLabel.Text = "Status: Stopped"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 60, 150)
    AutoFarmBtn.Text = "Start AutoFarm"
    AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    AutoFarmBtn.TextColor3 = Color3.fromRGB(0, 80, 200)
end

-- Button Click
AutoFarmBtn.MouseButton1Click:Connect(function()
    if not autoFarmActive then
        startAutoFarm()
    else
        stopAutoFarm()
    end
end)

-- Keybind Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.L then
            MainFrame.Visible = not MainFrame.Visible
        end
    end
end)

-- Cleanup
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    if autoFarmActive then
        stopAutoFarm()
    end
end)