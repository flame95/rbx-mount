local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "SCRIPTS AUTO SUMMIT V3 || By Trzzhub",
    Icon = 0,
    LoadingTitle = "Loading...",
    LoadingSubtitle = "By Trzzhub",
     -- === PERUBAHAN DI SINI ===
    ShowText = "Sembunyikan/Tampilkan UI",
    Theme = "DarkBlue",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "TrzzHub"
    },
    KeySystem = true,
    KeySettings = {
        Title = "TrzzHub",
        Subtitle = "Key System",
        Note = "Key ada di saluran: @TrzzHub",
        FileName = "Key",
        SaveKey = true,
        Key = {"Trzzhub7"}
    }
})

-- ====================================
-- FUNGSI NAVIGASI
-- ====================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer

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

    local delay = 3 -- Default delay untuk mode normal
    if mode == "hardmode" then
        delay = 10 -- Delay lebih besar untuk hardmode
    end

    for _, pos in ipairs(route) do
        teleportTo(pos)
        print("[AutoGrind] Teleport ke checkpoint")
        task.wait(delay)
    end
    print("[AutoGrind] Rute selesai!")
end


-- ====================================
-- MEMBUAT UI DENGAN RAYFIELD
-- ====================================
local MainTab = Window:CreateTab("Main", 0)
local FeaturesSection = MainTab:CreateSection("Grinding")

FeaturesSection:CreateButton({
    Name = "Start Normal Mode",
    Callback = function()
        spawn(function()
            climbRoute("normal")
        end)
    end,
})

FeaturesSection:CreateButton({
    Name = "Start Hardmode",
    Callback = function()
        spawn(function()
            climbRoute("hardmode")
        end)
    end,
})

local OtherSection = MainTab:CreateSection("Teleports")

OtherSection:CreateButton({
    Name = "Teleport to Basecamp",
    Callback = function()
        spawn(function()
            teleportTo(checkpoints.basecamp)
        end)
    end,
})

OtherSection:CreateLabel("Script by Trzzhub")

print("UI dan script utama siap digunakan!")
