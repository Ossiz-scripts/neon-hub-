-- NEON HUB ULTIMATE - MOBILE & PC
-- FEATURES: NEW FLY GUI, NOCLIP, FULLBRIGHT, PLAYER TP LIST, WAYPOINTS

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- --- 1. HELPER FUNCTIONS ---
local function Drag(g)
    local d, s, sp

    g.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch
        or i.UserInputType == Enum.UserInputType.MouseButton1 then
            d = true
            s = i.Position
            sp = g.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if d and (
            i.UserInputType == Enum.UserInputType.Touch
            or i.UserInputType == Enum.UserInputType.MouseMovement
        ) then
            local delta = i.Position - s
            g.Position = UDim2.new(
                sp.X.Scale,
                sp.X.Offset + delta.X,
                sp.Y.Scale,
                sp.Y.Offset + delta.Y
            )
        end
    end)

    g.InputEnded:Connect(function()
        d = false
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
-- ================= NEW FLY GUI ===========================
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

local flyToggle = FlyBtn(
    "FLY: OFF",
    UDim2.new(0.05, 0, 0.25, 0),
    UDim2.new(0.6, 0, 0, 30),
    Color3.fromRGB(40, 40, 40),
    FFrame
)

local speedShow = Instance.new("TextLabel", FFrame)
speedShow.Text = "SPD: 50"
speedShow.Size = UDim2.new(0.3, 0, 0, 30)
speedShow.Position = UDim2.new(0.65, 0, 0.25, 0)
speedShow.TextColor3 = Color3.fromRGB(0, 170, 255)
speedShow.BackgroundTransparency = 1
speedShow.Font = Enum.Font.SourceSansBold
speedShow.TextSize = 16

local up = FlyBtn(
    "▲",
    UDim2.new(0.05, 0, 0.6, 0),
    UDim2.new(0.2, 0, 0, 30),
    Color3.fromRGB(30, 30, 30),
    FFrame
)

local down = FlyBtn(
    "▼",
    UDim2.new(0.28, 0, 0.6, 0),
    UDim2.new(0.2, 0, 0, 30),
    Color3.fromRGB(30, 30, 30),
    FFrame
)

local add = FlyBtn(
    "+",
    UDim2.new(0.51, 0, 0.6, 0),
    UDim2.new(0.2, 0, 0, 30),
    Color3.fromRGB(30, 30, 30),
    FFrame
)

local sub = FlyBtn(
    "-",
    UDim2.new(0.74, 0, 0.6, 0),
    UDim2.new(0.2, 0, 0, 30),
    Color3.fromRGB(30, 30, 30),
    FFrame
)

local closeF = FlyBtn(
    "X",
    UDim2.new(0.8,0,-0.3,0),
    UDim2.new(0,30,0,30),
    Color3.fromRGB(200, 0, 0),
    FFrame
)

-- --- FLY LOGIC ---
local isFlying = false
local flySpeed = 50
local bv, bg = nil, nil

flyToggle.Activated:Connect(function()

    isFlying = not isFlying

    flyToggle.Text = isFlying and "FLY: ON" or "FLY: OFF"

    flyToggle.BackgroundColor3 =
        isFlying
        and Color3.fromRGB(0, 170, 255)
        or Color3.fromRGB(40, 40, 40)

    if isFlying then

        local char = lp.Character or lp.CharacterAdded:Wait()

        bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)

        bg = Instance.new("BodyGyro", char.HumanoidRootPart)
        bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        bg.P = 9000

        task.spawn(function()

            while isFlying and char and char:FindFirstChild("Humanoid") do

                RunService.Heartbeat:Wait()

                local cam = workspace.CurrentCamera
                local moveDir = char.Humanoid.MoveDirection

                if moveDir.Magnitude > 0 then

                    local camLook = cam.CFrame.LookVector
                    local camRight = cam.CFrame.RightVector

                    local flatLook =
                        Vector3.new(camLook.X, 0, camLook.Z).Unit

                    local flatRight =
                        Vector3.new(camRight.X, 0, camRight.Z).Unit

                    if flatLook.Magnitude == 0 then
                        flatLook = Vector3.new(0, 0, -1)
                    end

                    if flatRight.Magnitude == 0 then
                        flatRight = Vector3.new(1, 0, 0)
                    end

                    local fwd = moveDir:Dot(flatLook)
                    local right = moveDir:Dot(flatRight)

                    local finalDir =
                        (camLook * fwd) + (camRight * right)

                    bv.Velocity = finalDir.Unit * flySpeed

                else
                    bv.Velocity = Vector3.new(0,0,0)
                end

                bg.CFrame = cam.CFrame
            end

            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)

    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

up.Activated:Connect(function()
    if bv then
        bv.Velocity = Vector3.new(0, flySpeed, 0)
    end
end)

down.Activated:Connect(function()
    if bv then
        bv.Velocity = Vector3.new(0, -flySpeed, 0)
    end
end)

add.Activated:Connect(function()
    flySpeed = flySpeed + 10
    speedShow.Text = "SPD: "..flySpeed
end)

sub.Activated:Connect(function()
    flySpeed = math.max(10, flySpeed - 10)
    speedShow.Text = "SPD: "..flySpeed
end)

closeF.Activated:Connect(function()
    flyGui.Enabled = false
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

local function HubBtn(name, parent, pos, callback)
    local b = MobileBtn(
        name,
        UDim2.new(0.05, 0, 0, pos),
        UDim2.new(0.9, 0, 0, 35),
        Color3.fromRGB(30, 30, 30),
        parent
    )

    b.Activated:Connect(function()
        callback(b)
    end)

    return b
end

-- =========================================================
-- ================= PLAYER LIST PANEL =====================
-- =========================================================

local listFrame = Instance.new("Frame", neonGui)
listFrame.Size = UDim2.new(0, 160, 0, 230)
listFrame.Position = UDim2.new(0.5, 140, 0.5, -115)
listFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
listFrame.Visible = false
listFrame.Active = true

Instance.new("UICorner", listFrame)

Drag(listFrame)

Instance.new("UIStroke", listFrame).Color =
    Color3.fromRGB(0, 170, 255)

local listScroll = Instance.new("ScrollingFrame", listFrame)
listScroll.Size = UDim2.new(1, -10, 1, -40)
listScroll.Position = UDim2.new(0, 5, 0, 10)
listScroll.BackgroundTransparency = 1
listScroll.ScrollBarThickness = 2

local function updatePlayerList()

    for _, child in pairs(listScroll:GetChildren()) do
        child:Destroy()
    end

    local count = 0

    for _, p in pairs(Players:GetPlayers()) do

        if p ~= lp then

            local pBtn = MobileBtn(
                p.DisplayName,
                UDim2.new(0, 0, 0, count * 35),
                UDim2.new(1, 0, 0, 30),
                Color3.fromRGB(30, 30, 30),
                listScroll
            )

            pBtn.Activated:Connect(function()
                if p.Character then
                    lp.Character.HumanoidRootPart.CFrame =
                        p.Character.HumanoidRootPart.CFrame
                end
            end)

            count = count + 1
        end
    end

    listScroll.CanvasSize = UDim2.new(0, 0, 0, count * 35)
end

-- =========================================================
-- ================= WAYPOINTS PANEL =======================
-- =========================================================

local waypoints = {}

local posFrame = Instance.new("Frame", neonGui)
posFrame.Size = UDim2.new(0, 160, 0, 230)
posFrame.Position = UDim2.new(0.5, -310, 0.5, -115)
posFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
posFrame.Visible = false
posFrame.Active = true

Instance.new("UICorner", posFrame)

Drag(posFrame)

Instance.new("UIStroke", posFrame).Color =
    Color3.fromRGB(0, 170, 255)

local posScroll = Instance.new("ScrollingFrame", posFrame)
posScroll.Size = UDim2.new(1, -10, 1, -85)
posScroll.Position = UDim2.new(0, 5, 0, 10)
posScroll.BackgroundTransparency = 1
posScroll.ScrollBarThickness = 2

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
        child:Destroy()
    end

    local count = 0

    for name, cf in pairs(waypoints) do

        local pBtn = MobileBtn(
            name,
            UDim2.new(0, 0, 0, count * 35),
            UDim2.new(1, 0, 0, 30),
            Color3.fromRGB(30, 30, 30),
            posScroll
        )

        pBtn.Activated:Connect(function()
            if lp.Character then
                lp.Character.HumanoidRootPart.CFrame = cf
            end
        end)

        count = count + 1
    end

    posScroll.CanvasSize = UDim2.new(0, 0, 0, count * 35)
end

-- =========================================================
-- ================= MAIN HUB BUTTONS ======================
-- =========================================================

HubBtn("Open Fly Panel", MainTab, 10, function()
    flyGui.Enabled = true
end)

HubBtn("Noclip: OFF", MainTab, 55, function(b)

    _G.noclip = not _G.noclip

    b.Text = _G.noclip and "Noclip: ON" or "Noclip: OFF"

    b.TextColor3 =
        _G.noclip
        and Color3.new(0,1,0)
        or Color3.new(1,1,1)
end)

HubBtn("Fullbright: OFF", MainTab, 100, function(b)

    _G.fb = not _G.fb

    b.Text = _G.fb and "Fullbright: ON" or "Fullbright: OFF"

    b.TextColor3 =
        _G.fb
        and Color3.new(0,1,0)
        or Color3.new(1,1,1)
end)

HubBtn("Teleport Menu", MainTab, 145, function()

    listFrame.Visible = not listFrame.Visible

    if listFrame.Visible then
        updatePlayerList()
    end
end)

HubBtn("Saved Positions", MainTab, 190, function()

    posFrame.Visible = not posFrame.Visible

    if posFrame.Visible then
        updatePosList()
    end
end)

-- SAVE POSITION BUTTON
local saveBtn = MobileBtn(
    "Save Current Pos",
    UDim2.new(0.05, 0, 1, -40),
    UDim2.new(0.9, 0, 0, 30),
    Color3.fromRGB(0, 170, 255),
    posFrame
)

saveBtn.Activated:Connect(function()

    local name =
        posInput.Text ~= ""
        and posInput.Text
        or "Pos "..tostring(#waypoints + 1)

    if lp.Character then
        waypoints[name] =
            lp.Character.HumanoidRootPart.CFrame

        posInput.Text = ""

        updatePosList()
    end
end)

-- =========================================================
-- ================= TOGGLE CONTROLS =======================
-- =========================================================

if UserInputService.TouchEnabled then

    local ToggleBtn = MobileBtn(
        "H",
        UDim2.new(0, 10, 0.4, 0),
        UDim2.new(0, 50, 0, 50),
        Color3.fromRGB(0, 170, 255),
        neonGui
    )

    Instance.new("UICorner", ToggleBtn).CornerRadius =
        UDim.new(1,0)

    Drag(ToggleBtn)

    ToggleBtn.Activated:Connect(function()
        MFrame.Visible = not MFrame.Visible
    end)
end

UserInputService.InputBegan:Connect(function(input, chat)

    if not chat and input.KeyCode == Enum.KeyCode.K then
        MFrame.Visible = not MFrame.Visible
    end
end)

-- =========================================================
-- ================= LOOPS ================================
-- =========================================================

RunService.RenderStepped:Connect(function()

    if _G.fb then
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
    end
end)

RunService.Stepped:Connect(function()

    if _G.noclip and lp.Character then

        for _, v in pairs(lp.Character:GetDescendants()) do

            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- =========================================================
-- ================= NOTIFICATION ==========================
-- =========================================================

game:GetService("StarterGui"):SetCore(
    "SendNotification",
    {
        Title = "Neon Hub",
        Text = "K to Toggle (PC) | H Button (Mobile)",
        Duration = 5
    }
)

