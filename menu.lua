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

-- ====================================
-- SEKSI BARU: MENU DUMMY
-- ====================================

-- Buat Tab baru di dalam jendela
local MainTab = Window:CreateTab("Main", 0)

-- Buat bagian baru dengan nama "Fitur"
local FeaturesSection = MainTab:CreateSection("Grinding Features")

-- Tambahkan tombol dummy untuk mode Normal
FeaturesSection:CreateButton({
    Name = "Normal Mode (Dummy)",
    Callback = function()
        -- Kode ini masih kosong, belum ada fungsinya
        print("Tombol Normal Mode diklik (Dummy)")
    end,
})

-- Tambahkan tombol dummy untuk mode Hard
FeaturesSection:CreateButton({
    Name = "Hardmode (Dummy)",
    Callback = function()
        -- Kode ini masih kosong, belum ada fungsinya
        print("Tombol Hardmode diklik (Dummy)")
    end,
})

-- Buat bagian baru dengan nama "Lainnya"
local OtherSection = MainTab:CreateSection("Other")

-- Tambahkan tombol dummy untuk fitur lainnya
OtherSection:CreateButton({
    Name = "Teleport Basecamp (Dummy)",
    Callback = function()
        -- Kode ini masih kosong, belum ada fungsinya
        print("Tombol Teleport Basecamp diklik (Dummy)")
    end,
})

-- Tambahkan label dummy untuk informasi
OtherSection:CreateLabel("Script by Trzzhub")
