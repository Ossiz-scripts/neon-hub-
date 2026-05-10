-- NEON HUB ULTIMATE - MOBILE & PC
-- FEATURES: V11 FLY LOGIC IN NEON GUI, NOCLIP, FULLBRIGHT, PLAYER TP LIST, WAYPOINTS, ESP

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- =========================================================
-- ================= 1. HELPER FUNCTIONS ===================
-- =========================================================

local function Drag(g)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    g.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragInput = input
            dragStart = input.Position
            startPos = g.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            g.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    g.InputEnded:Connect(function(input)
        if input == dragInput then
            dragging = false
            dragInput = nil
        end
    end)
end

local function MobileBtn(txt, pos, size, color, parent)
    local b = Instance.new("TextButton", parent)
    b.Text = txt
    b.Position = pos
    b.Size = size
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end

-- =========================================================
-- ================= NEON FLY GUI W/ V11 LOGIC =============
-- =========================================================

local flyGui = Instance.new("ScreenGui", game.CoreGui)
flyGui.Name = "FlyControlPanel"
flyGui.Enabled = false

local FFrame = Instance.new("Frame", flyGui)
FFrame.Size = UDim2.new(0, 200, 0, 110)
FFrame.Position = UDim2.new(0.1, 0, 0.5, 0)
FFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FFrame.Active = true

Instance.new("UICorner", FFrame)

local stroke = Instance.new("UIStroke", FFrame)
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.Thickness = 2

Drag(FFrame)

local function FlyBtn(txt, pos, size, color, parent)
    local b = Instance.new("TextButton", parent)
    b.Text = txt
    b.Position = pos
    b.Size = size
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 16
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end

local flyToggle = FlyBtn("FLY: OFF", UDim2.new(0.05, 0, 0.25, 0), UDim2.new(0.6, 0, 0, 30), Color3.fromRGB(40, 40, 40), FFrame)
local speedShow = Instance.new("TextLabel", FFrame)
speedShow.Text = "SPD: 1"
speedShow.Size = UDim2.new(0.3, 0, 0, 30)
speedShow.Position = UDim2.new(0.65, 0, 0.25, 0)
speedShow.TextColor3 = Color3.fromRGB(0, 170, 255)
speedShow.BackgroundTransparency = 1
speedShow.Font = Enum.Font.SourceSansBold
speedShow.TextSize = 16

local upBtn = FlyBtn("▲", UDim2.new(0.05, 0, 0.6, 0), UDim2.new(0.2, 0, 0, 30), Color3.fromRGB(30, 30, 30), FFrame)
local downBtn = FlyBtn("▼", UDim2.new(0.28, 0, 0.6, 0), UDim2.new(0.2, 0, 0, 30), Color3.fromRGB(30, 30, 30), FFrame)
local addBtn = FlyBtn("+", UDim2.new(0.51, 0, 0.6, 0), UDim2.new(0.2, 0, 0, 30), Color3.fromRGB(30, 30, 30), FFrame)
local subBtn = FlyBtn("-", UDim2.new(0.74, 0, 0.6, 0), UDim2.new(0.2, 0, 0, 30), Color3.fromRGB(30, 30, 30), FFrame)
local closeF = FlyBtn("X", UDim2.new(0.8,0,-0.3,0), UDim2.new(0,30,0,30), Color3.fromRGB(200, 0, 0), FFrame)

-- V11 Variables
local nowe = false
local speeds = 1
local tpwalking = false
local speaker = lp

flyToggle.Activated:Connect(function() 
    if nowe == true then
        nowe = false 
        flyToggle.Text = "FLY: OFF"
        flyToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        
        local chr = lp.Character
        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Running,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
            hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        end
    else 
        nowe = true
        flyToggle.Text = "FLY: ON"
        flyToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

        for i = 1, speeds do
            task.spawn(function() 
                local hb = game:GetService("RunService").Heartbeat
                tpwalking = true
                local chr = lp.Character
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                    if hum.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(hum.MoveDirection)
                    end
                end 
            end)
        end
        
        local Char = lp.Character
        local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController") 
        local Animate = Char:FindFirstChild("Animate")
        if Animate then Animate.Disabled = true end
        
        if Hum then
            for i,v in next, Hum:GetPlayingAnimationTracks() do
                v:AdjustSpeed(0)
            end
            Hum:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.Running,false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
            Hum:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
            Hum:ChangeState(Enum.HumanoidStateType.Swimming)
        end

        task.spawn(function()
            local plr = lp
            local isR6 = plr.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6
            local torso = isR6 and plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("UpperTorso")
            
            if not torso then return end
            
            local ctrl = {f = 0, b = 0, l = 0, r = 0}
            local lastctrl = {f = 0, b = 0, l = 0, r = 0}
            local maxspeed = 50
            local speed = 0

            local bg = Instance.new("BodyGyro", torso)
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.cframe = torso.CFrame
            local bv = Instance.new("BodyVelocity", torso)
            bv.velocity = Vector3.new(0,0.1,0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            
            if nowe == true then
                plr.Character.Humanoid.PlatformStand = true
            end
            
            while nowe == true or plr.Character.Humanoid.Health == 0 do
                game:GetService("RunService").RenderStepped:Wait() 
                if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                    speed = speed+.5+(speed/maxspeed)
                    if speed > maxspeed then speed = maxspeed end
                elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                    speed = speed-1
                    if speed < 0 then speed = 0 end
                end
                
                if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                    bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - workspace.CurrentCamera.CoordinateFrame.p))*speed
                    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                    bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - workspace.CurrentCamera.CoordinateFrame.p))*speed
                else
                    bv.velocity = Vector3.new(0,0,0)
                end
                
                bg.cframe = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
            end
            
            bg:Destroy()
            bv:Destroy()
            plr.Character.Humanoid.PlatformStand = false
            if plr.Character:FindFirstChild("Animate") then
                plr.Character.Animate.Disabled = false
            end
            tpwalking = false
        end)
    end
end)

-- V11 Mobile/PC friendly Up & Down loops
local isUp, isDown = false, false

upBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isUp = true
        while isUp do
            task.wait()
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
            end
        end
    end
end)
upBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isUp = false
    end
end)

downBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDown = true
        while isDown do
            task.wait()
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
            end
        end
    end
end)
downBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDown = false
    end
end)

-- V11 Speeds System
addBtn.Activated:Connect(function()
    speeds = speeds + 1
    speedShow.Text = "SPD: " .. speeds
    if nowe == true then
        tpwalking = false
        for i = 1, speeds do
            task.spawn(function() 
                local hb = game:GetService("RunService").Heartbeat
                tpwalking = true
                local chr = lp.Character
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                    if hum.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(hum.MoveDirection)
                    end
                end 
            end)
        end
    end
end)

subBtn.Activated:Connect(function()
    if speeds == 1 then
        speedShow.Text = 'Min 1'
        task.wait(1)
        speedShow.Text = "SPD: " .. speeds
    else
        speeds = speeds - 1
        speedShow.Text = "SPD: " .. speeds
        if nowe == true then
            tpwalking = false
            for i = 1, speeds do
                task.spawn(function() 
                    local hb = game:GetService("RunService").Heartbeat
                    tpwalking = true
                    local chr = lp.Character
                    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                    while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                        if hum.MoveDirection.Magnitude > 0 then
                            chr:TranslateBy(hum.MoveDirection)
                        end
                    end 
                end)
            end
        end
    end
end)

closeF.Activated:Connect(function() flyGui.Enabled = false end)

lp.CharacterAdded:Connect(function(char)
    task.wait(0.7)
    local hum = char:WaitForChild("Humanoid", 3)
    if hum then hum.PlatformStand = false end
    local anim = char:WaitForChild("Animate", 3)
    if anim then anim.Disabled = false end
end)


-- =========================================================
-- ================= MAIN MENU HUB =========================
-- =========================================================

local neonGui = Instance.new("ScreenGui", game.CoreGui)

local MFrame = Instance.new("Frame", neonGui)
MFrame.Size = UDim2.new(0, 260, 0, 330)
MFrame.Position = UDim2.new(0.5, -130, 0.5, -165)
MFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MFrame.Active = true
Instance.new("UICorner", MFrame)
Drag(MFrame)

local mStroke = Instance.new("UIStroke", MFrame)
mStroke.Color = Color3.fromRGB(0, 170, 255)
mStroke.Thickness = 1

local MainTab = Instance.new("ScrollingFrame", MFrame)
MainTab.Size = UDim2.new(1,0,1,-70)
MainTab.Position = UDim2.new(0,0,0,70)
MainTab.BackgroundTransparency = 1
MainTab.ScrollBarThickness = 2
MainTab.AutomaticCanvasSize = Enum.AutomaticSize.Y

local function HubBtn(name, parent, pos, callback)
    local b = MobileBtn(
        name,
        UDim2.new(0.05, 0, 0, pos),
        UDim2.new(0.9, 0, 0, 35),
        Color3.fromRGB(30, 30, 30),
        parent
    )
    b.Activated:Connect(function() callback(b) end)
    return b
end

-- =========================================================
-- ================= PLAYER LIST & WAYPOINTS ===============
-- =========================================================

local listFrame = Instance.new("Frame", neonGui)
listFrame.Size = UDim2.new(0, 160, 0, 230)
listFrame.Position = UDim2.new(0.5, 140, 0.5, -115)
listFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
listFrame.Visible = false
listFrame.Active = true
Instance.new("UICorner", listFrame)
Drag(listFrame)
Instance.new("UIStroke", listFrame).Color = Color3.fromRGB(0, 170, 255)

local listScroll = Instance.new("ScrollingFrame", listFrame)
listScroll.Size = UDim2.new(1, -10, 1, -40)
listScroll.Position = UDim2.new(0, 5, 0, 10)
listScroll.BackgroundTransparency = 1
listScroll.ScrollBarThickness = 2
listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local function updatePlayerList()
    for _, child in pairs(listScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            local pBtn = MobileBtn(p.DisplayName, UDim2.new(0, 0, 0, count * 35), UDim2.new(1, 0, 0, 30), Color3.fromRGB(30, 30, 30), listScroll)
            pBtn.Activated:Connect(function()
                if p.Character and lp.Character then
                    lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end)
            count = count + 1
        end
    end
end

Players.PlayerAdded:Connect(function()
    if listFrame.Visible then updatePlayerList() end
end)
Players.PlayerRemoving:Connect(function()
    if listFrame.Visible then updatePlayerList() end
end)

local waypoints = {}
local posFrame = Instance.new("Frame", neonGui)
posFrame.Size = UDim2.new(0, 160, 0, 230)
posFrame.Position = UDim2.new(0.5, -310, 0.5, -115)
posFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
posFrame.Visible = false
posFrame.Active = true
Instance.new("UICorner", posFrame)
Drag(posFrame)
Instance.new("UIStroke", posFrame).Color = Color3.fromRGB(0, 170, 255)

local posScroll = Instance.new("ScrollingFrame", posFrame)
posScroll.Size = UDim2.new(1, -10, 1, -85)
posScroll.Position = UDim2.new(0, 5, 0, 10)
posScroll.BackgroundTransparency = 1
posScroll.ScrollBarThickness = 2
posScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local posInput = Instance.new("TextBox", posFrame)
posInput.Size = UDim2.new(0.9, 0, 0, 30)
posInput.Position = UDim2.new(0.05, 0, 1, -75)
posInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
posInput.TextColor3 = Color3.new(1,1,1)
posInput.PlaceholderText = "Name..."
posInput.Font = Enum.Font.SourceSansBold
posInput.TextSize = 12
Instance.new("UICorner", posInput)

local function updatePosList()
    for _, child in pairs(posScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local count = 0
    for name, cf in pairs(waypoints) do
        local pBtn = MobileBtn(name, UDim2.new(0, 0, 0, count * 35), UDim2.new(1, 0, 0, 30), Color3.fromRGB(30, 30, 30), posScroll)
        pBtn.Activated:Connect(function()
            if lp.Character then lp.Character.HumanoidRootPart.CFrame = cf end
        end)
        count = count + 1
    end
end

local saveBtn = MobileBtn("Save Current Pos", UDim2.new(0.05, 0, 1, -40), UDim2.new(0.9, 0, 0, 30), Color3.fromRGB(0, 170, 255), posFrame)
saveBtn.Activated:Connect(function()
    local name = posInput.Text ~= "" and posInput.Text or "Pos "..tostring(#waypoints + 1)
    if lp.Character then
        waypoints[name] = lp.Character.HumanoidRootPart.CFrame
        posInput.Text = ""
        updatePosList()
    end
end)

-- =========================================================
-- ================= MAIN HUB BUTTONS & LOGIC ==============
-- =========================================================

local originalLighting = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd
}

HubBtn("Open Fly Panel", MainTab, 10, function() flyGui.Enabled = true end)

HubBtn("Noclip: OFF", MainTab, 55, function(b)
    _G.noclip = not _G.noclip
    b.Text = _G.noclip and "Noclip: ON" or "Noclip: OFF"
    b.TextColor3 = _G.noclip and Color3.new(0,1,0) or Color3.new(1,1,1)
end)

HubBtn("Fullbright: OFF", MainTab, 100, function(b)
    _G.fb = not _G.fb
    b.Text = _G.fb and "Fullbright: ON" or "Fullbright: OFF"
    b.TextColor3 = _G.fb and Color3.new(0,1,0) or Color3.new(1,1,1)

    if _G.fb then
        originalLighting.Ambient = Lighting.Ambient
        originalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
        originalLighting.Brightness = Lighting.Brightness
        originalLighting.ClockTime = Lighting.ClockTime
        originalLighting.GlobalShadows = Lighting.GlobalShadows
        originalLighting.FogEnd = Lighting.FogEnd
    else
        Lighting.Ambient = originalLighting.Ambient
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        Lighting.Brightness = originalLighting.Brightness
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.GlobalShadows = originalLighting.GlobalShadows
        Lighting.FogEnd = originalLighting.FogEnd
    end
end)

HubBtn("ESP: OFF", MainTab, 145, function(b)
    _G.esp = not _G.esp
    b.Text = _G.esp and "ESP: ON" or "ESP: OFF"
    b.TextColor3 = _G.esp and Color3.new(0,1,0) or Color3.new(1,1,1)
end)

HubBtn("Teleport Menu", MainTab, 190, function()
    listFrame.Visible = not listFrame.Visible
    if listFrame.Visible then updatePlayerList() end
end)

HubBtn("Saved Positions", MainTab, 235, function()
    posFrame.Visible = not posFrame.Visible
    if posFrame.Visible then updatePosList() end
end)

-- =========================================================
-- ================= TOGGLE CONTROLS =======================
-- =========================================================

if UserInputService.TouchEnabled then
    local ToggleBtn = MobileBtn("H", UDim2.new(0, 10, 0.4, 0), UDim2.new(0, 50, 0, 50), Color3.fromRGB(0, 170, 255), neonGui)
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1,0)
    Drag(ToggleBtn)
    ToggleBtn.Activated:Connect(function() MFrame.Visible = not MFrame.Visible end)
end

UserInputService.InputBegan:Connect(function(input, chat)
    if not chat and input.KeyCode == Enum.KeyCode.K then
        MFrame.Visible = not MFrame.Visible
    end
end)


