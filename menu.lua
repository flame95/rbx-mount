-- ========================
-- LOAD RAYFIELD UI
-- ========================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "SCRIPTS AUTO SUMMIT V3 || By Trzzhub",
    Icon = 0,
    LoadingTitle = "Loading...",
    LoadingSubtitle = "By Trzzhub",
    ShowText = "Scripts",
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

-- ========================
-- TABS
-- ========================
local TabAuto   = Window:CreateTab("AUTO SUMMIT", 4483362458)
local TabTp     = Window:CreateTab("PUNCAK", 4483362458)
local TabMisc   = Window:CreateTab("SCRIPT", 4483362458)
local TabHub    = Window:CreateTab("ANIMASI", 4483362458)
local TabCre    = Window:CreateTab("TITLE", 4483362458)

-- Fungsi animasi kosong
function startAnimation(name, list)
    -- Tidak melakukan apapun
    -- Bisa ditambahkan print supaya tau kalau fungsi dipanggil
    print("Animasi '" .. name .. "' dijalankan (kosong).")
end

-- Variabel global untuk simpan mode & thread animasi
local currentMode = nil
local animating = false

-- Fungsi untuk kasih sparkles ke bagian tubuh
local function applySparkles(character)
    local parts = {
        "HumanoidRootPart", "Head",
        "LeftHand", "RightHand",
        "LeftFoot", "RightFoot"
    }

    local sparklesList = {}
    for _, partName in ipairs(parts) do
        local part = character:FindFirstChild(partName)
        if part then
            local spark = part:FindFirstChild("Sparkles")
            if not spark then
                spark = Instance.new("Sparkles")
                spark.Parent = part
            end
            table.insert(sparklesList, spark)
        end
    end
    return sparklesList
end

-- Fungsi animasi
local function startAnimation(mode, sparklesList)
    currentMode = mode
    animating = true

    task.spawn(function()
        local t = 0
        while animating and currentMode == mode and #sparklesList > 0 do
            t += 0.1

            for _, s in ipairs(sparklesList) do
                if mode == "DISCO" then
                    local style = math.random(1,4)

                    if style == 1 then
                        -- 🌈 Rainbow cycle
                        local r = math.sin(t) * 127 + 128
                        local g = math.sin(t + 2) * 127 + 128
                        local b = math.sin(t + 4) * 127 + 128
                        s.SparkleColor = Color3.fromRGB(r,g,b)

                    elseif style == 2 then
                        -- ⚡ Random Disco
                        s.SparkleColor = Color3.fromRGB(
                            math.random(0,255),
                            math.random(0,255),
                            math.random(0,255)
                        )

                    elseif style == 3 then
                        -- ❤️ Pulse merah → putih
                        local value = (math.sin(t*4) + 1) * 127
                        s.SparkleColor = Color3.fromRGB(255, value, value)

                    elseif style == 4 then
                        -- 🌟 Gradient shift (biru → ungu → pink)
                        local r = (math.sin(t*2) + 1) * 127
                        local g = (math.sin(t*2 + 2) + 1) * 50
                        local b = 200
                        s.SparkleColor = Color3.fromRGB(r,g,b)
                    end

                elseif mode == "PURPLE" then
                    s.SparkleColor = Color3.fromRGB(160, 32, 240)

                elseif mode == "CYAN" then
                    s.SparkleColor = Color3.fromRGB(0, 200, 255)
                end
            end

            task.wait(0.15)
        end
    end)
end

-- Tombol DISCO
TabHub:CreateButton({
    Name = "DISCO",
    Callback = function()
        animating = false -- stop animasi lama
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local sparklesList = applySparkles(character)
        startAnimation("DISCO", sparklesList)
    end
})

-- Tombol PURPLE
TabHub:CreateButton({
    Name = "PURPLE",
    Callback = function()
        animating = false
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local sparklesList = applySparkles(character)
        startAnimation("PURPLE", sparklesList)
    end
})

-- Tombol CYAN
TabHub:CreateButton({
    Name = "CYAN",
    Callback = function()
        animating = false
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local sparklesList = applySparkles(character)
        startAnimation("CYAN", sparklesList)
    end
})

-- Auto re-apply saat respawn
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function(char)
    if currentMode then
        task.wait(1) -- tunggu karakter selesai spawn
        local sparklesList = applySparkles(char)
        startAnimation(currentMode, sparklesList)
    end
end)

-- ========================
-- TITLE BUTTON FUNCTION
-- ========================
local function createTitleButton(name, textContent)
    TabCre:CreateButton({
        Name = name,
        Callback = function()
            local player = game.Players.LocalPlayer
            local char   = player.Character or player.CharacterAdded:Wait()
            local head   = char:WaitForChild("Head")

            if head:FindFirstChild("AdminTag") then
                head.AdminTag:Destroy()
            end

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "AdminTag"
            billboard.Parent = head
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
            billboard.AlwaysOnTop = true
            billboard.LightInfluence = 0

            local text = Instance.new("TextLabel")
            text.Parent = billboard
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.Text = textContent
            text.TextColor3 = Color3.fromRGB(0, 255, 255)
            text.TextStrokeTransparency = 0
            text.Font = Enum.Font.SourceSansBold
            text.TextSize = 25
        end,
    })
end

-- TITLE LIST
createTitleButton("👑 OWNER 👑", "👑 OWNER 👑")
createTitleButton("🛡️ HeadAdmin 🛡️", "🛡️ HeadAdmin 🛡️")
createTitleButton("👑 ADMIN 👑", "👑 ADMIN 👑")
createTitleButton("💎 VIP 💎", "💎 VIP 💎")
createTitleButton("🏆 TOP DONATUR 🏆", "🏆 TOP DONATUR 🏆")

-- ========================
-- MISC SCRIPTS
-- ========================
TabMisc:CreateButton({
    Name = "FLY GUI V3",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Gui-Fly-v3-37111"))()
    end,
})

TabMisc:CreateButton({
    Name = "INFINITE YIELD",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end,
})


TabMisc:CreateButton({
    Name = "SPEED COIL",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local speedValue = 23 -- kecepatan saat pakai coil

        local function giveCoil(char)
            local backpack = player:WaitForChild("Backpack")

            if backpack:FindFirstChild("Speed Coil") or char:FindFirstChild("Speed Coil") then
                return
            end

            local tool = Instance.new("Tool")
            tool.Name = "Speed Coil"
            tool.RequiresHandle = false -- hilangkan handle agar tangan tidak animasi
            tool.Parent = backpack

            -- jangan buat Handle atau mesh sama sekali

            tool.Equipped:Connect(function()
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = speedValue
                end
            end)

            tool.Unequipped:Connect(function()
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            end)
        end

        if player.Character then
            giveCoil(player.Character)
        end

        player.CharacterAdded:Connect(function(char)
            task.wait(1)
            giveCoil(char)
        end)
    end,
})



TabMisc:CreateButton({
    Name = "SC AUTO WALK",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/XmFN7UHc"))()
    end,
})

TabMisc:CreateButton({
    Name = "BRING PART",
    Callback = function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/tarz2642008-ship-it/ed8e924b00a9a2b87b57c722498cad9c/raw/f43d555c085bc86a24da8f081b7db4103efc16d9/RingPart"))()
    end,
})

TabMisc:CreateButton({
    Name = "FLING GUI",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fling-Gui-Op-47914"))()
    end,
})

TabMisc:CreateButton({
    Name = "BOOST FPS",
    Callback = function()
        repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
        loadstring(game:HttpGet("https://pastefy.app/08huVciY/raw"))()
    end,
})

TabMisc:CreateButton({
    Name = "TP TOOL",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local mouse = player:GetMouse()

        -- Bikin tool baru
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "TP Tool"
        tool.Parent = player.Backpack

        tool.Activated:Connect(function()
            if mouse.Hit then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0,3,0))
                end
            end
        end)
    end,
})

TabMisc:CreateSlider({
   Name = "WalkSpeed",
   Range = {10, 500},
   Increment = 1,
   CurrentValue = 15,
   Suffix = "Speed",
   Callback = function(Value)
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.WalkSpeed = Value
      end
   end,
})

TabMisc:CreateSlider({
    Name = "Jump Height",
    Range = {10, 500},
    Increment = 1,
    CurrentValue = 50,
    Suffix = "Height",
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = Value
        end
    end,
})

-- ========================
-- AUTO SUMMIT FUNCTION (FIXED)
-- ========================
local Players = game:GetService("Players")
local player  = Players.LocalPlayer

local function createAutoSummit(name, positions, respawnDelay, stepDelay, options)
    local enabled     = false
    local cancelToken = nil
    respawnDelay      = respawnDelay or 3
    stepDelay         = stepDelay or 4
    options           = options or {}
    local autoRespawn = (options.autoRespawn ~= false) -- default true

    local function start(char)
        if cancelToken then cancelToken.cancelled = true end
        local token = {cancelled = false}
        cancelToken = token

        task.spawn(function()
            local hrp = char:WaitForChild("HumanoidRootPart", 10)
            if not hrp then return end

            while enabled and not token.cancelled and char.Parent do
                for _, pos in ipairs(positions) do
                    if not enabled or token.cancelled then break end
                    hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        pcall(function()
                            hrp.CFrame = pos
                        end)
                    end
                    task.wait(stepDelay)
                end

                -- Hanya respawn kalau autoRespawn = true
                if autoRespawn and enabled and not token.cancelled and char:FindFirstChild("Humanoid") then
                    task.wait(respawnDelay)
                    pcall(function()
                        char:BreakJoints()
                    end)
                end

                task.wait(0.5)
            end
        end)
    end

    player.CharacterAdded:Connect(function(char)
        if enabled then
            task.wait(1)
            local hrp = char:WaitForChild("HumanoidRootPart", 10)
            if hrp then
                hrp.CFrame = positions[#positions]
            end
            start(char)
        end
    end)

    -- Toggle di tab AUTO SUMMIT
    TabAuto:CreateToggle({
        Name = name,
        CurrentValue = false,
        Callback = function(value)
            enabled = value
            if enabled and player.Character then
                start(player.Character)
            elseif cancelToken then
                cancelToken.cancelled = true
                cancelToken = nil
            end
        end,
    })

    -- Button teleport ke puncak di tab TELEPORT PUNCAK
    TabTp:CreateButton({
        Name = "PUNCAK " .. name,
        Callback = function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = positions[#positions]
            end
        end,
    })
end

-- ========================
-- DAFTAR GUNUNG
-- ========================

-- MOUNT ATIN
createAutoSummit("MOUNT ATIN", {
    CFrame.new(624.79, 1801.43, 3432.24),
    CFrame.new(781.23, 2166.03, 3921.29),
}, 3, 4)

-- Auto Rejoin setelah sampai di CFrame terakhir
local TeleportService = game:GetService("TeleportService")
task.spawn(function()
    while task.wait(1) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local lastCFrame = CFrame.new(781.23, 2166.03, 3921.29) -- CFrame terakhir

            if (hrp.Position - lastCFrame.Position).Magnitude < 10 then
                task.wait(2) -- delay 2 detik
                TeleportService:Teleport(game.PlaceId, player)
                break
            end
        end
    end
end)

-- MOUNT CING
createAutoSummit("MOUNT CING", {
    CFrame.new(331.84, 139.41, 829.17),
    CFrame.new(137.58, 79.41, 355.69),
    CFrame.new(53.14, 79.41, 28.00),
    CFrame.new(747.08, 127.41, 356.06),
    CFrame.new(676.80, 131.41, -764.56),
    CFrame.new(241.03, 251.41, -469.02),
    CFrame.new(-504.51, 437.00, -399.26),
    CFrame.new(-1336.50, 423.41, -444.37),
    CFrame.new(-1837.70, 493.00, -111.90),
    CFrame.new(-2196.33, 783.41, 985.90),
    CFrame.new(-1491.83, 1288.89, 1066.64),
}, 3, 4)

-- MOUNT SUMBING
createAutoSummit("MOUNT SUMBING", {
    CFrame.new(-225.54, 441.00, 2142.43),
    CFrame.new(-427.57, 849.00, 3204.18),
    CFrame.new(41.93, 1269.00, 4044.11),
    CFrame.new(-1142.34, 1553.00, 4899.95),
    CFrame.new(-896.04, 1948.29, 5352.81),
}, 3, 4)

-- MOUNT HANAMI
createAutoSummit("MOUNT HANAMI", {
    CFrame.new(515.81, 141.34, -121.60),
    CFrame.new(359.75, 195.70, -613.76),
    CFrame.new(-93.18, 169.79, -490.25),
    CFrame.new(-933.26, 345.41, -512.65),
    CFrame.new(-1277.02, 477.72, -329.48),
    CFrame.new(-1975.74, 609.55, 131.92),
    CFrame.new(-2765.88, 669.34, 44.07),
    CFrame.new(-2601.37, 848.96, -323.42),
}, 1, 3)

-- MOUNT ADUH (langsung teleport + auto rejoin)
do
    local TeleportService = game:GetService("TeleportService")

    TabAuto:CreateToggle({
        Name = "MOUNT ADUH",
        CurrentValue = false,
        Callback = function(value)
            if value then
                task.spawn(function()
                    local char = player.Character or player.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart", 10)
                    if hrp then
                        -- teleport ke posisi puncak
                        hrp.CFrame = CFrame.new(-805.00, 2744.41, 1248.00)
                        -- delay 3 detik lalu rejoin
                        task.wait(3)
                        pcall(function()
                            TeleportService:Teleport(game.PlaceId, player)
                        end)
                    end
                end)
            end
        end,
    })

    -- Button teleport manual ke puncak
    TabTp:CreateButton({
        Name = "PUNCAK MOUNT ADUH",
        Callback = function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(-805.00, 2744.41, 1248.00)
            end
        end,
    })
end

-- MOUNT GAMPIL (NO AUTORESPAWN + TELEPORT SECEPAT MUNGKIN)
createAutoSummit("MOUNT GAMPIL", {
    CFrame.new(570.05, 372.38, 144.33),
    CFrame.new(364.00, 432.40, -1245.00),
}, 1, 0, {
    autoRespawn = false
})

-- MOUNT YAHAYUK (NO AUTORESPAWN + TELEPORT SECEPAT MUNGKIN)
createAutoSummit("MOUNT YAHAYUK", {
    CFrame.new(-420.05, 249.64, 769.69),
    CFrame.new(-347.92, 388.64, 522.19),
    CFrame.new(288.00, 429.64, 504.00),
    CFrame.new(333.85, 490.64, 348.98),
    CFrame.new(212.54, 314.64, -146.42),
    CFrame.new(-616.00, 905.38, -510.00),
}, 1, 1, {
    autoRespawn = false
})

createAutoSummit("MOUNT OWASHU", {
    CFrame.new(-310.63, 70.94, 631.32),      -- CP 1
    CFrame.new(7.17, 73.05, 1096.95),        -- CP 2
    CFrame.new(-606.59, 253.05, 1226.75),    -- CP 3
    CFrame.new(-1077.02, 328.65, 1416.00),   -- CP 4
    CFrame.new(-1187.75, 488.64, 1787.63),   -- CP 5
    CFrame.new(-1576.99, 670.25, 2322.01)    -- SUM
}, 2, 1, {   -- delay antar posisi = 2 detik
    autoRespawn = true
})

createAutoSummit("MOUNT PASANG SIGMA", {
    CFrame.new(-54.26, 611.33, -487.00),      -- CP 1
    CFrame.new(580.76, 846.81, 2852.67),      -- CP 2
    CFrame.new(1799.04, 1083.41, 6131.96),    -- CP 3
    CFrame.new(3707.07, 1572.18, 9050.33),    -- CP 4
    CFrame.new(1136.15, 1671.33, 9455.95),    -- CP 5
    CFrame.new(-566.15, 2050.75, 9498.65)     -- SUM
}, 2, 2, {   -- delay antar posisi = 2 detik, delay respawn = 3 detik
    autoRespawn = true
})

createAutoSummit("MOUNT LABIRIN", {
    CFrame.new(-994.22, 124.47, -253.71),   -- CP 1
    CFrame.new(7.72, 97.16, -372.16),       -- CP 2
    CFrame.new(-66.56, 96.99, 44.85),       -- CP 3
    CFrame.new(183.43, 96.18, 42.60),       -- CP 4
    CFrame.new(772.51, 276.62, 512.32),     -- CP 5
    CFrame.new(1123.88, 368.82, 480.56),    -- CP 6
    CFrame.new(1502.94, 427.30, -366.49),   -- CP 7
    CFrame.new(1169.64, 453.27, -497.46),   -- CP 8
    CFrame.new(712.28, 433.41, -400.81),    -- CP 9
    CFrame.new(934.43, 530.11, -84.31),     -- CP 10
    CFrame.new(1170.98, 545.27, -38.62),    -- CP 11
    CFrame.new(1218.25, 631.96, -79.29),    -- CP 12
    CFrame.new(1158.22, 642.92, -282.00),   -- CP 13
    CFrame.new(900.05, 669.27, -47.27),     -- CP 14
    CFrame.new(1174.73, 805.02, -100.76),   -- CP 15
    CFrame.new(1177.31, 800.85, -181.09)    -- CP 16 / Summit
}, 1, 1, {   -- delay antar posisi = 2 detik, delay respawn = 3 detik
    autoRespawn = true
})
