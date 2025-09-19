-- Skrip Auto-Grind Sederhana
-- Checkpoint terbaru, tanpa interaksi GUI
-- Menghilangkan Anti-Cheat dan Speedhack

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ====================================
-- FUNGSI NAVIGASI
-- ====================================
local function getRoot()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("UpperTorso")
end

local function teleportTo(vec)
    local root = getRoot()
    if not root then return false end
    root.CFrame = CFrame.new(vec + Vector3.new(0, 8, 0))
    task.wait(0.25)
    root.CFrame = root.CFrame * CFrame.new(0, 0, -1)
    return true
end

-- ====================================
-- DAFTAR CHECKPOINT
-- ====================================
local checkpoints = {
    basecamp = Vector3.new(260.24, -43.03, 6.99),
    cp1 = Vector3.new(-73.18, -87.26, -123.71),
    cp2 = Vector3.new(-67.54, -76.75, 107.31),
    cp3 = Vector3.new(-65.13, -27.03, 232.51),
    cp4 = Vector3.new(312.75, 12.97, 374.00),
    cp5 = Vector3.new(394.27, 44.87, 858.97),
    cp6 = Vector3.new(53.18, 44.66, 792.69),
    cp7 = Vector3.new(144.25, 44.97, 1087.78),
    cp8 = Vector3.new(-95.65, 108.97, 689.98),
    cp9 = Vector3.new(-68.08, 136.85, 1048.13),
    cp10 = Vector3.new(-285.37, 64.97, 1111.81),
    cp11 = Vector3.new(-381.86, 80.97, 668.50),
    cp12 = Vector3.new(-56.00, -87.03, 250.00),
    cp13 = Vector3.new(210.72, -103.04, 116.76),
    cp14 = Vector3.new(-125.73, -179.03, 30.23),
    hard = Vector3.new(-34.23, -147.25, 464.10),
    cp16 = Vector3.new(-14.44, -147.03, 440.21),
    cp17 = Vector3.new(297.93, -135.03, 402.18),
    cp18 = Vector3.new(217.58, -155.03, 27.22),
    cp19 = Vector3.new(575.14, -147.37, -226.84),
    cp20 = Vector3.new(441.58, -115.03, -276.01),
    cp21 = Vector3.new(-0.22, -175.01, -197.36),
    cp22 = Vector3.new(-47.84, -175.03, 211.90),
    cp23 = Vector3.new(101.35, -311.03, 614.37),
    cp24 = Vector3.new(383.35, -276.69, 604.66),
    cp25 = Vector3.new(388.45, -210.52, 287.19),
    cp26 = Vector3.new(320.00, -215.03, 244.25),
    cp27 = Vector3.new(279.85, -219.03, 183.87),
    cp28 = Vector3.new(219.41, -211.03, 111.90),
    summit = Vector3.new(59.59, -235.03, 220.99)
}

-- Definisi rute untuk setiap mode
local routes = {
    normal = {
        checkpoints.basecamp, checkpoints.cp1, checkpoints.cp2, checkpoints.cp3, checkpoints.cp4,
        checkpoints.cp5, checkpoints.cp6, checkpoints.cp7, checkpoints.cp8, checkpoints.cp9,
        checkpoints.cp10, checkpoints.cp11, checkpoints.cp12, checkpoints.cp13, checkpoints.cp14,
        checkpoints.cp16, checkpoints.cp17, checkpoints.cp18, checkpoints.cp19, checkpoints.cp20,
        checkpoints.cp21, checkpoints.cp22, checkpoints.cp23, checkpoints.cp24, checkpoints.cp25,
        checkpoints.cp26, checkpoints.cp27, checkpoints.cp28, checkpoints.summit
    },
    hardmode = {
        checkpoints.basecamp,
        checkpoints.hard,
        checkpoints.summit
    }
}

-- Fungsi utama untuk menyelesaikan rute
local function climbRoute(mode)
    local route = routes[mode]
    if not route then return end
    print("[AutoGrind] Memulai mode: " .. mode)

    for _, pos in ipairs(route) do
        teleportTo(pos)
        print("[AutoGrind] Teleport ke checkpoint")
        task.wait(3) -- Jeda 3 detik di setiap checkpoint
    end
    print("[AutoGrind] Rute selesai!")
end

-- ====================================
-- GUI
-- ====================================
local gui = Instance.new("ScreenGui")
gui.Name = "AutoSummitMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0, 20, 0, 120)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "AutoGrind Mount"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- status label
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 24)
statusLabel.Position = UDim2.new(0, 10, 0, 35)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255,255,0)
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextSize = 16
statusLabel.Text = "Pilih mode"

-- tombol Normal Mode
local normalBtn = Instance.new("TextButton", frame)
normalBtn.Size = UDim2.new(1, -20, 0, 34)
normalBtn.Position = UDim2.new(0, 10, 0, 70)
normalBtn.Text = "Start Normal Mode"
normalBtn.BackgroundColor3 = Color3.fromRGB(0,120,0)
normalBtn.TextColor3 = Color3.new(1,1,1)
normalBtn.Font = Enum.Font.SourceSansBold
normalBtn.TextSize = 16
normalBtn.MouseButton1Click:Connect(function()
    spawn(function()
        statusLabel.Text = "Running: Normal Mode"
        climbRoute("normal")
        statusLabel.Text = "Pilih mode"
    end)
end)

-- tombol Hardmode
local hardBtn = Instance.new("TextButton", frame)
hardBtn.Size = UDim2.new(1, -20, 0, 34)
hardBtn.Position = UDim2.new(0, 10, 0, 110)
hardBtn.Text = "Start Hardmode"
hardBtn.BackgroundColor3 = Color3.fromRGB(160,40,40)
hardBtn.TextColor3 = Color3.new(1,1,1)
hardBtn.Font = Enum.Font.SourceSansBold
hardBtn.TextSize = 16
hardBtn.MouseButton1Click:Connect(function()
    spawn(function()
        statusLabel.Text = "Running: Hardmode"
        climbRoute("hardmode")
        statusLabel.Text = "Pilih mode"
    end)
end)
