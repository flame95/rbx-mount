-- Teleport GUI (Basecamp -> Summit)
-- By ChatGPT

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- cari root part
local function getRoot()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:FindFirstChild("HumanoidRootPart") 
        or char:FindFirstChild("Torso") 
        or char:FindFirstChild("UpperTorso") 
        or nil
end

-- daftar lokasi teleport
local points = {
    Basecamp = Vector3.new(260.24, -43.03, 6.99),
    ["CP 1"] = Vector3.new(-73.18, -87.26, -123.71),
    ["CP 2"] = Vector3.new(-67.54, -76.75, 107.31),
    ["CP 3"] = Vector3.new(-65.13, -27.03, 232.51),
    ["CP 4"] = Vector3.new(-34.23, -147.25, 464.10),
    Summit = Vector3.new(59.59, -235.03, 220.99),
}

-- setting teleport
local mode = "Instant" -- bisa "Instant" atau "Smooth"
local smoothSpeed = 50 -- studs per detik
local looping = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 400)
frame.Position = UDim2.new(0, 20, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Teleport Menu"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- fungsi teleport
local function teleportTo(pos)
    local root = getRoot()
    if not root then return end

    if mode == "Instant" then
        root.CFrame = CFrame.new(pos)
    elseif mode == "Smooth" then
        local start = root.Position
        local distance = (pos - start).Magnitude
        local timeNeeded = distance / smoothSpeed
        local steps = math.floor(timeNeeded * 30) -- 30 fps
        for i = 1, steps do
            root.CFrame = CFrame.new(start:Lerp(pos, i/steps))
            task.wait(1/30)
        end
    end
end

-- fungsi buat tombol
local function makeBtn(name, posY, point)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16

    btn.MouseButton1Click:Connect(function()
        teleportTo(point)
    end)
end

-- tombol mode
local modeBtn = Instance.new("TextButton", frame)
modeBtn.Size = UDim2.new(1, -20, 0, 30)
modeBtn.Position = UDim2.new(0, 10, 0, 40)
modeBtn.Text = "Mode: " .. mode
modeBtn.BackgroundColor3 = Color3.fromRGB(100,60,60)
modeBtn.TextColor3 = Color3.new(1,1,1)

modeBtn.MouseButton1Click:Connect(function()
    mode = (mode == "Instant") and "Smooth" or "Instant"
    modeBtn.Text = "Mode: " .. mode
end)

-- slider kecepatan smooth (pakai tombol ganti angka sederhana)
local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(1, -20, 0, 30)
speedBtn.Position = UDim2.new(0, 10, 0, 80)
speedBtn.Text = "Smooth Speed: " .. smoothSpeed
speedBtn.BackgroundColor3 = Color3.fromRGB(60,100,60)
speedBtn.TextColor3 = Color3.new(1,1,1)

speedBtn.MouseButton1Click:Connect(function()
    smoothSpeed = smoothSpeed + 25
    if smoothSpeed > 200 then smoothSpeed = 25 end
    speedBtn.Text = "Smooth Speed: " .. smoothSpeed
end)

-- generate tombol lokasi
local i = 0
for name, pos in pairs(points) do
    makeBtn(name, 120 + (i*35), pos)
    i += 1
end

-- tombol auto loop
local loopBtn = Instance.new("TextButton", frame)
loopBtn.Size = UDim2.new(1, -20, 0, 30)
loopBtn.Position = UDim2.new(0, 10, 0, 120 + (i*35))
loopBtn.Text = "Auto Loop OFF"
loopBtn.BackgroundColor3 = Color3.fromRGB(100,100,20)
loopBtn.TextColor3 = Color3.new(1,1,1)

loopBtn.MouseButton1Click:Connect(function()
    looping = not looping
    loopBtn.Text = looping and "Auto Loop ON" or "Auto Loop OFF"

    while looping do
        teleportTo(points.Basecamp)
        task.wait(2)
        teleportTo(points.Summit)
        task.wait(2)
    end
end)
