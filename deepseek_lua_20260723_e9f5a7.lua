-- ==========================================
-- JETYXSILENTAIM | PRO + FULL ESP + AUTO FARM
-- ANTI-CHEAT BYPASS | STEALTH TELEPORT
-- ==========================================

local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local Workspace = cloneref(game:GetService("Workspace"))
local VirtualUser = cloneref(game:GetService("VirtualUser"))
local TweenService = cloneref(game:GetService("TweenService"))
local PhysicsService = cloneref(game:GetService("PhysicsService"))

-- ========== AUTO FARM VARIABLES ==========
local AutoFarmEnabled = false
local AutoFarmMode = "Stealth" -- Walk, Teleport, Sit, Fly, Stealth
local AutoFarmDistance = 20
local AutoFarmPart = "HumanoidRootPart"
local AutoFarmDelay = 0.5
local FarmLoop = nil
local TeleportOffset = Vector3.new(0, 2, 0)

-- ========== STEALTH TELEPORT VARIABLES ==========
local TeleportMethod = "Tween" -- Tween, Step, atau Smooth
local TeleportSteps = 10
local TeleportDelay = 0.05
local UseAntiTeleport = true
local AntiTeleportBuffer = 0.3

-- ========== KECEPATAN VARIABLES ==========
local WalkSpeedValue = 16
local JumpPowerValue = 50
local SpeedBoostEnabled = false
local FlyEnabled = false
local FlySpeedValue = 50
local NoclipEnabled = false

-- ========== DETECT GAME ==========
local function IsSouthBronxTrenches()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name:find("South Bronx") or 
           game.PlaceId == 1234567890
end

-- ========== UI PARENT ==========
local ParentGui = (pcall(function() return CoreGui:FindFirstChild("RobloxGui") end) and CoreGui) or LocalPlayer:WaitForChild("PlayerGui", 5)
if not ParentGui then return end

if ParentGui:FindFirstChild("JetyxSilentAimGUI") then
    ParentGui.JetyxSilentAimGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JetyxSilentAimGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = ParentGui
    end
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = ParentGui
end

-- ========== MAIN FRAME ==========
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 620)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -310)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(70, 40, 140)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

local BgGradient = Instance.new("UIGradient")
BgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 18, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 18))
})
BgGradient.Rotation = 45
BgGradient.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "JETYXSILENTAIM\n<font size='10' color='#a29bfe'>Stealth Mode | Anti-Cheat Bypass</font>"
Title.RichText = true
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 80)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.Parent = MainFrame
local CloseCorner = Instance.new("UICorner") CloseCorner.CornerRadius = UDim.new(0, 6) CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 9.5, 0)
Container.ScrollBarThickness = 2
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)
UIList.Parent = Container

-- ========== VARIABEL FITUR ==========
local MasterHitbox = true
local EnableHitboxHead = false
local HitboxSizeValue = 2
local HitboxTransparency = 0.5

local ShowFOVCircle = false
local FOVSizeValue = 250
local FOVModeVal = "PC"
local ShowAimLine = false

local EnableESPBox = false
local EnableESPName = false
local EnableESPHealth = false
local EnableESPDistance = false
local EnableESPLine = false

-- ========== FOV CIRCLE UI ==========
local FOVFrame = Instance.new("Frame")
FOVFrame.Name = "FOVCircleUI"
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = false
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Parent = ScreenGui

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(255, 0, 0)
FOVStroke.Thickness = 1.5
FOVStroke.Parent = FOVFrame

local FOVCurve = Instance.new("UICorner")
FOVCurve.CornerRadius = UDim.new(1, 0)
FOVCurve.Parent = FOVFrame

-- ========== AIM LINE DRAWING ==========
local AimLine = Drawing.new("Line")
AimLine.Visible = false
AimLine.Color = Color3.fromRGB(255, 0, 255)
AimLine.Thickness = 1.5
AimLine.Transparency = 1

-- ========== ESP CACHE ==========
local EspCache = {}

local function RemoveESP(plr)
    if EspCache[plr] then
        if EspCache[plr].Box then EspCache[plr].Box:Remove() end
        if EspCache[plr].NameTag then EspCache[plr].NameTag:Remove() end
        if EspCache[plr].HealthBar then EspCache[plr].HealthBar:Remove() end
        if EspCache[plr].HealthBarBg then EspCache[plr].HealthBarBg:Remove() end
        if EspCache[plr].TracerLine then EspCache[plr].TracerLine:Remove() end
        EspCache[plr] = nil
    end
end

Players.PlayerRemoving:Connect(RemoveESP)

-- ========== GET CLOSEST PLAYER (FOV) ==========
local function GetClosestPlayerInFOV()
    local target = nil
    local shortestDist = FOVSizeValue
    local center = (FOVModeVal == "Mobile") and UserInputService:GetMouseLocation() or (Camera.ViewportSize / 2)

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local part = v.Character:FindFirstChild("Head") or v.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if magnitude < shortestDist then
                        shortestDist = magnitude
                        target = part
                    end
                end
            end
        end
    end
    return target
end

-- ========== STEALTH TELEPORT FUNCTION ==========
local function StealthTeleport(targetPosition)
    local char = LocalPlayer.Character
    if not char then return end
    
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Simpan posisi awal
    local startPos = rootPart.Position
    
    -- Matikan collision sementara untuk menghindari deteksi
    local originalCanCollide = {}
    if UseAntiTeleport then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                originalCanCollide[part] = part.CanCollide
                part.CanCollide = false
            end
        end
    end
    
    -- Pilih metode teleport
    if TeleportMethod == "Tween" then
        -- Metode Tween: Gerakan halus
        local distance = (targetPosition - startPos).Magnitude
        local duration = math.min(distance / 100, 0.5) + AntiTeleportBuffer
        
        local tweenInfo = TweenInfo.new(
            duration,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        )
        
        local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
        tween:Play()
        tween.Completed:Wait()
        
    elseif TeleportMethod == "Step" then
        -- Metode Step: Teleport bertahap
        local steps = TeleportSteps
        local stepSize = (targetPosition - startPos) / steps
        
        for i = 1, steps do
            local newPos = startPos + (stepSize * i)
            rootPart.CFrame = CFrame.new(newPos)
            wait(TeleportDelay)
            
            -- Cek apakah sudah sampai
            if (rootPart.Position - targetPosition).Magnitude < 1 then
                break
            end
        end
        
    elseif TeleportMethod == "Smooth" then
        -- Metode Smooth: Kombinasi Tween + Step
        local distance = (targetPosition - startPos).Magnitude
        local steps = math.max(math.floor(distance / 5), 5)
        local stepSize = (targetPosition - startPos) / steps
        
        for i = 1, steps do
            local newPos = startPos + (stepSize * i)
            local tweenInfo = TweenInfo.new(
                0.05,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out
            )
            local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = CFrame.new(newPos)})
            tween:Play()
            tween.Completed:Wait()
            
            if (rootPart.Position - targetPosition).Magnitude < 1 then
                break
            end
        end
    end
    
    -- Kembalikan collision
    if UseAntiTeleport then
        for part, collide in pairs(originalCanCollide) do
            if part and part.Parent then
                part.CanCollide = collide
            end
        end
    end
    
    -- Tunggu sebentar agar server sinkron
    wait(0.1)
end

-- ========== SPEED FUNCTIONS ==========
local function ApplySpeed()
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if SpeedBoostEnabled then
        humanoid.WalkSpeed = WalkSpeedValue
        humanoid.JumpPower = JumpPowerValue
    else
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
end

local function ApplyFly()
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if FlyEnabled then
        humanoid.PlatformStand = true
        local bodyVelocity = char:FindFirstChild("FlyVelocity")
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "FlyVelocity"
            bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bodyVelocity.Parent = char:FindFirstChild("HumanoidRootPart")
        end
        
        local moveDirection = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Camera.CFrame.LookVector * Vector3.new(1,0,1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - Camera.CFrame.LookVector * Vector3.new(1,0,1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - Camera.CFrame.RightVector * Vector3.new(1,0,1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Camera.CFrame.RightVector * Vector3.new(1,0,1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * FlySpeedValue
        end
        
        bodyVelocity.Velocity = moveDirection
    else
        if humanoid then
            humanoid.PlatformStand = false
        end
        local bodyVelocity = char:FindFirstChild("FlyVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    end
end

local function ApplyNoclip()
    local char = LocalPlayer.Character
    if not char then return end
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not NoclipEnabled
        end
    end
end

-- ========== AUTO FARM FUNCTIONS ==========
local function GetNearestTarget()
    local nearest = nil
    local nearestDist = AutoFarmDistance

    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local isTarget = false
            
            if v:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(v) then
                    isTarget = true
                elseif Players:GetPlayerFromCharacter(v) ~= LocalPlayer then
                    isTarget = true
                end
            end

            if isTarget then
                local rootPart = v:FindFirstChild(AutoFarmPart) or v:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
                                 (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude) or 999
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest = v
                    end
                end
            end
        end
    end

    return nearest
end

local function FarmTarget(target)
    if not target or not LocalPlayer.Character then return end

    local char = LocalPlayer.Character
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    
    if not rootPart or not humanoid then return end

    local targetPart = target:FindFirstChild(AutoFarmPart) or target:FindFirstChild("HumanoidRootPart")
    if not targetPart then return end

    if AutoFarmMode == "Stealth" then
        -- Stealth Teleport ke target
        local targetPos = targetPart.Position + TeleportOffset
        StealthTeleport(targetPos)
        
        wait(0.2)
        
        -- Serang target
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(500, 500))
        
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
        
    elseif AutoFarmMode == "Walk" then
        local targetPos = targetPart.Position
        local walkTo = targetPos + Vector3.new(0, 0, 5)
        
        local tweenInfo = TweenInfo.new(
            0.5,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        )
        local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = CFrame.new(walkTo)})
        tween:Play()
        
        wait(0.3)
        
        local dist = (rootPart.Position - targetPart.Position).Magnitude
        if dist < 10 then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(500, 500))
            
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
        end
        
    elseif AutoFarmMode == "Teleport" then
        -- Teleport biasa (dengan anti-cheat)
        StealthTeleport(targetPart.Position + TeleportOffset)
        wait(0.1)
        
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(500, 500))
        
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
        
    elseif AutoFarmMode == "Sit" then
        local dist = (rootPart.Position - targetPart.Position).Magnitude
        if dist < 10 then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(500, 500))
            
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
        end
        
    elseif AutoFarmMode == "Fly" then
        local targetPos = targetPart.Position + Vector3.new(0, 3, 0)
        local tweenInfo = TweenInfo.new(
            0.3,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        )
        local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = CFrame.new(targetPos)})
        tween:Play()
        
        wait(0.2)
        
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(500, 500))
        
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
    end
end

local function StartAutoFarm()
    if FarmLoop then return end
    
    FarmLoop = RunService.RenderStepped:Connect(function()
        if not AutoFarmEnabled then
            if FarmLoop then FarmLoop:Disconnect() FarmLoop = nil end
            return
        end
        
        local target = GetNearestTarget()
        if target then
            FarmTarget(target)
        end
    end)
end

local function StopAutoFarm()
    if FarmLoop then
        FarmLoop:Disconnect()
        FarmLoop = nil
    end
end

-- ========== UI BUILDER FUNCTIONS ==========
local function CreateSectionHeader(text)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 32)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 18, 38)
    Frame.Parent = Container
    local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6) Corner.Parent = Frame
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0) Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1 Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 11 Label.Font = Enum.Font.GothamBold Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Text = text Label.Parent = Frame
end

local function CreateToggle(text, callback, default)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 28) Btn.BackgroundColor3 = Color3.fromRGB(18, 14, 30)
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200) Btn.TextSize = 11 Btn.Font = Enum.Font.Gotham
    Btn.TextXAlignment = Enum.TextXAlignment.Left Btn.Text = "    [   ]  " .. text Btn.Parent = Container
    local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6) Corner.Parent = Btn

    local state = default or false
    Btn.Text = state and "    [ ✓ ]  " .. text or "    [   ]  " .. text
    Btn.TextColor3 = state and Color3.fromRGB(170, 160, 255) or Color3.fromRGB(200, 200, 200)
    
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.TextColor3 = state and Color3.fromRGB(170, 160, 255) or Color3.fromRGB(200, 200, 200)
        Btn.Text = state and "    [ ✓ ]  " .. text or "    [   ]  " .. text
        pcall(function() callback(state) end)
    end)
    
    return Btn
end

local function CreateDropdown(title, options, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 30) Frame.BackgroundColor3 = Color3.fromRGB(18, 14, 30) Frame.Parent = Container
    local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6) Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 150, 1, 0) Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1 Label.TextColor3 = Color3.fromRGB(170, 170, 170)
    Label.TextSize = 11 Label.Font = Enum.Font.Gotham Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Text = title Label.Parent = Frame

    local DropBtn = Instance.new("TextButton")
    DropBtn.Size = UDim2.new(0, 120, 0, 22) DropBtn.Position = UDim2.new(1, -128, 0.5, -11)
    DropBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 80) DropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropBtn.TextSize = 10 DropBtn.Font = Enum.Font.GothamBold DropBtn.Text = options[1] .. "  v" DropBtn.Parent = Frame
    local DropCorner = Instance.new("UICorner") DropCorner.CornerRadius = UDim.new(0, 4) DropCorner.Parent = DropBtn

    local idx = 1
    DropBtn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        DropBtn.Text = options[idx] .. "  v"
        pcall(function() callback(options[idx]) end)
    end)
end

local function CreateSlider(title, min, max, default, suffix, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 42) Frame.BackgroundColor3 = Color3.fromRGB(18, 14, 30) Frame.Parent = Container
    local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6) Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 18) Label.Position = UDim2.new(0, 10, 0, 3)
    Label.BackgroundTransparency = 1 Label.TextColor3 = Color3.fromRGB(170, 170, 170)
    Label.TextSize = 11 Label.Font = Enum.Font.Gotham Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Text = title Label.Parent = Frame

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.new(1, -20, 0, 18) ValLabel.Position = UDim2.new(0, -10, 0, 3)
    ValLabel.BackgroundTransparency = 1 ValLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ValLabel.TextSize = 11 ValLabel.Font = Enum.Font.GothamBold ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.Text = default .. " " .. suffix ValLabel.Parent = Frame

    local Bar = Instance.new("TextButton")
    Bar.Size = UDim2.new(1, -20, 0, 5) Bar.Position = UDim2.new(0, 10, 0, 26)
    Bar.BackgroundColor3 = Color3.fromRGB(40, 30, 60) Bar.Text = "" Bar.Parent = Frame
    local BCorner = Instance.new("UICorner") BCorner.CornerRadius = UDim.new(1, 0) BCorner.Parent = Bar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(114, 9, 183) Fill.BorderSizePixel = 0 Fill.Parent = Bar
    local FCorner = Instance.new("UICorner") FCorner.CornerRadius = UDim.new(1, 0) FCorner.Parent = Fill

    local dragging = false
    Bar.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local loc = UserInputService:GetMouseLocation()
            local pos = math.clamp((loc.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor((min + (max - min) * pos) * 10) / 10
            ValLabel.Text = val .. " " .. suffix
            pcall(function() callback(val) end)
        end
    end)
end

-- ========== BUILD UI ==========
-- === AUTO FARM SECTION ===
CreateSectionHeader("⚡ AUTO FARM (Stealth Mode)")

CreateToggle("Enable Auto Farm", function(state)
    AutoFarmEnabled = state
    if state then
        StartAutoFarm()
    else
        StopAutoFarm()
    end
end, false)

CreateDropdown("Farm Mode", {"Stealth", "Walk", "Teleport", "Sit", "Fly"}, function(val)
    AutoFarmMode = val
end)

CreateSlider("Farm Distance", 5, 100, 20, "m", function(val)
    AutoFarmDistance = val
end)

CreateDropdown("Target Part", {"HumanoidRootPart", "Head", "Torso"}, function(val)
    AutoFarmPart = val
end)

CreateSlider("Teleport Offset Y", 0, 5, 2, "", function(val)
    TeleportOffset = Vector3.new(0, val, 0)
end)

-- === STEALTH TELEPORT SETTINGS ===
CreateSectionHeader("🛡️ STEALTH TELEPORT SETTINGS")

CreateToggle("Enable Anti-Cheat Bypass", function(state)
    UseAntiTeleport = state
end, true)

CreateDropdown("Teleport Method", {"Tween", "Step", "Smooth"}, function(val)
    TeleportMethod = val
end)

CreateSlider("Teleport Steps", 5, 30, 10, "", function(val)
    TeleportSteps = val
end)

CreateSlider("Step Delay", 0.01, 0.2, 0.05, "s", function(val)
    TeleportDelay = val
end)

CreateSlider("Anti-Cheat Buffer", 0.1, 1, 0.3, "s", function(val)
    AntiTeleportBuffer = val
end)

-- === SPEED SECTION ===
CreateSectionHeader("🏃 SPEED & MOVEMENT")

CreateToggle("Enable Speed Boost", function(state)
    SpeedBoostEnabled = state
    if state then
        ApplySpeed()
    else
        ApplySpeed()
    end
end, false)

CreateSlider("Walk Speed", 16, 120, 16, "", function(val)
    WalkSpeedValue = val
    if SpeedBoostEnabled then
        ApplySpeed()
    end
end)

CreateSlider("Jump Power", 50, 200, 50, "", function(val)
    JumpPowerValue = val
    if SpeedBoostEnabled then
        ApplySpeed()
    end
end)

CreateToggle("Enable Fly", function(state)
    FlyEnabled = state
    if not state then
        ApplyFly()
    end
end, false)

CreateSlider("Fly Speed", 10, 200, 50, "", function(val)
    FlySpeedValue = val
end)

CreateToggle("Enable Noclip", function(state)
    NoclipEnabled = state
    ApplyNoclip()
end, false)

-- === HITBOX SECTION ===
CreateSectionHeader("🎯 Hitbox Expander (Head)")
CreateToggle("Enable Head Expander", function(state) EnableHitboxHead = state end, false)
CreateSlider("Hitbox Size", 1, 5, 2, "x", function(val) HitboxSizeValue = val end)
CreateSlider("Hitbox Transparency", 0, 1, 0.5, "", function(val) HitboxTransparency = val end)

-- === FOV SECTION ===
CreateSectionHeader("🎯 FOV & Aim Line")
CreateToggle("Show FOV Circle", function(state) ShowFOVCircle = state end, false)
CreateSlider("FOV Size", 50, 500, 250, "px", function(val) FOVSizeValue = val end)
CreateDropdown("FOV Mode", {"PC", "Mobile"}, function(val) FOVModeVal = val end)
CreateToggle("Show Aim Line", function(state) ShowAimLine = state end, false)

-- === ESP SECTION ===
CreateSectionHeader("👁️ Full ESP")
CreateToggle("Enable ESP Box", function(state) EnableESPBox = state end, false)
CreateToggle("Enable ESP Name", function(state) EnableESPName = state end, false)
CreateToggle("Enable ESP Health Bar", function(state) EnableESPHealth = state end, false)
CreateToggle("Enable ESP Distance", function(state) EnableESPDistance = state end, false)
CreateToggle("Enable ESP Tracer Line", function(state) EnableESPLine = state end, false)

-- ========== MAIN RENDER LOOP ==========
RunService.RenderStepped:Connect(function()
    -- Speed & Fly Update
    if SpeedBoostEnabled or FlyEnabled or NoclipEnabled then
        local char = LocalPlayer.Character
        if char then
            if SpeedBoostEnabled then ApplySpeed() end
            if FlyEnabled then ApplyFly() end
            if NoclipEnabled then ApplyNoclip() end
        end
    end

    -- Hitbox
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            local head = v.Character:FindFirstChild("Head")
            local humanoid = v.Character:FindFirstChildOfClass("Humanoid")
            if head and humanoid and humanoid.Health > 0 then
                if MasterHitbox and EnableHitboxHead then
                    head.Size = Vector3.new(HitboxSizeValue, HitboxSizeValue, HitboxSizeValue)
                    head.Transparency = HitboxTransparency
                    head.CanCollide = false
                    head.Massless = true
                else
                    head.Size = Vector3.new(2, 1, 1)
                    head.Transparency = 0
                    head.CanCollide = true
                    head.Massless = false
                end
            end
        end
    end

    -- FOV Circle
    if ShowFOVCircle then
        FOVFrame.Visible = true
        FOVFrame.Size = UDim2.new(0, FOVSizeValue * 2, 0, FOVSizeValue * 2)
        if FOVModeVal == "Mobile" then
            local mouseLoc = UserInputService:GetMouseLocation()
            FOVFrame.Position = UDim2.new(0, mouseLoc.X, 0, mouseLoc.Y)
        else
            local viewportCenter = Camera.ViewportSize / 2
            FOVFrame.Position = UDim2.new(0, viewportCenter.X, 0, viewportCenter.Y)
        end
    else
        FOVFrame.Visible = false
    end

    -- Aim Line
    if ShowAimLine then
        local target = GetClosestPlayerInFOV()
        if target then
            local screenPos, onScreen = Camera:WorldToViewportPoint(target.Position)
            if onScreen then
                AimLine.From = Vector2.new(Camera.ViewportSize.X / 