--[[
    ======================================
    ||         PS SCRIPT AUTO WALK      ||
    ======================================
    Versi Final: Gerakan Normal dengan Kamera Bebas
--]]

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variables for recording and replay
local isRecording = false
local currentRecordedPath = {}
local savedReplays = {}
local pathUpdateConnection = nil
local lastRecordedPosition = nil
local isPlaying = false

-- Create the main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoWalkGUI"
screenGui.Parent = localPlayer.PlayerGui

-- Main frame properties
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.Text = "PS SCRIPT AUTO WALK V2"
titleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
titleLabel.Font = Enum.Font.SourceSans
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(235, 64, 52)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = titleBar

-- Draggable logic
local dragging
local dragStart
local startPosition
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Main content frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Top buttons
local topButtonsFrame = Instance.new("Frame")
topButtonsFrame.Size = UDim2.new(1, -20, 0, 40)
topButtonsFrame.Position = UDim2.new(0, 10, 0, 10)
topButtonsFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
topButtonsFrame.BorderSizePixel = 0
topButtonsFrame.Parent = contentFrame

local recordButton = Instance.new("TextButton")
recordButton.Name = "RecordButton"
recordButton.Size = UDim2.new(0.5, -5, 1, 0)
recordButton.Position = UDim2.new(0, 0, 0, 0)
recordButton.Text = "Record"
recordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
recordButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
recordButton.Font = Enum.Font.SourceSansSemibold
recordButton.TextSize = 16
recordButton.Parent = topButtonsFrame

local saveReplayButton = Instance.new("TextButton")
saveReplayButton.Name = "SaveReplayButton"
saveReplayButton.Size = UDim2.new(0.5, -5, 1, 0)
saveReplayButton.Position = UDim2.new(0.5, 5, 0, 0)
saveReplayButton.Text = "Save Replay"
saveReplayButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveReplayButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
saveReplayButton.Font = Enum.Font.SourceSansSemibold
saveReplayButton.TextSize = 16
saveReplayButton.Parent = topButtonsFrame

-- Middle buttons
local middleButtonsFrame = Instance.new("Frame")
middleButtonsFrame.Size = UDim2.new(1, -20, 0, 40)
middleButtonsFrame.Position = UDim2.new(0, 10, 0, 60)
middleButtonsFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
middleButtonsFrame.BorderSizePixel = 0
middleButtonsFrame.Parent = contentFrame

local loadPathButton = Instance.new("TextButton")
loadPathButton.Name = "LoadPathButton"
loadPathButton.Size = UDim2.new(0.5, -5, 1, 0)
loadPathButton.Position = UDim2.new(0, 0, 0, 0)
loadPathButton.Text = "Load Path"
loadPathButton.TextColor3 = Color3.fromRGB(255, 255, 255)
loadPathButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
loadPathButton.Font = Enum.Font.SourceSansSemibold
loadPathButton.TextSize = 16
loadPathButton.Parent = middleButtonsFrame

local mergePlayButton = Instance.new("TextButton")
mergePlayButton.Name = "MergePlayButton"
mergePlayButton.Size = UDim2.new(0.5, -5, 1, 0)
mergePlayButton.Position = UDim2.new(0.5, 5, 0, 0)
mergePlayButton.Text = "Merge & Play"
mergePlayButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mergePlayButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
mergePlayButton.Font = Enum.Font.SourceSansSemibold
mergePlayButton.TextSize = 16
mergePlayButton.Parent = middleButtonsFrame

-- Speed input
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, -20, 0, 30)
speedFrame.Position = UDim2.new(0, 10, 0, 110)
speedFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
speedFrame.BorderSizePixel = 0
speedFrame.Parent = contentFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(0.3, 0, 1, 0)
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.Text = "Speed:"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.SourceSansSemibold
speedLabel.TextSize = 16
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedFrame

local speedTextBox = Instance.new("TextBox")
speedTextBox.Name = "SpeedTextBox"
speedTextBox.Size = UDim2.new(0.7, 0, 1, 0)
speedTextBox.Position = UDim2.new(0.3, 0, 0, 0)
speedTextBox.Text = "16"
speedTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedTextBox.Font = Enum.Font.SourceSansSemibold
speedTextBox.TextSize = 16
speedTextBox.Parent = speedFrame

-- Replay list
local replayListFrame = Instance.new("ScrollingFrame")
replayListFrame.Name = "ReplayListFrame"
replayListFrame.Size = UDim2.new(1, -20, 1, -160)
replayListFrame.Position = UDim2.new(0, 10, 0, 150)
replayListFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
replayListFrame.BorderSizePixel = 0
replayListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
replayListFrame.ScrollBarThickness = 6
replayListFrame.Parent = contentFrame

-- UI List Layout
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Name = "ReplayListLayout"
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.FillDirection = Enum.FillDirection.Vertical
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = replayListFrame

-- Functions

local function addReplayItem(path, name)
    local replayItem = Instance.new("Frame")
    replayItem.Size = UDim2.new(1, 0, 0, 30)
    replayItem.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    replayItem.BorderSizePixel = 0
    replayItem.Parent = replayListFrame

    local replayLabel = Instance.new("TextLabel")
    replayLabel.Size = UDim2.new(0, 120, 1, 0)
    replayLabel.Position = UDim2.new(0, 5, 0, 0)
    replayLabel.Text = name
    replayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    replayLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    replayLabel.BackgroundTransparency = 1
    replayLabel.Font = Enum.Font.SourceSansSemibold
    replayLabel.TextSize = 14
    replayLabel.TextXAlignment = Enum.TextXAlignment.Left
    replayLabel.Parent = replayItem

    local playButton = Instance.new("TextButton")
    playButton.Size = UDim2.new(0, 30, 1, -5)
    playButton.Position = UDim2.new(1, -95, 0, 2)
    playButton.Text = "▶"
    playButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    playButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    playButton.Parent = replayItem
    
    playButton.MouseButton1Click:Connect(function()
        if isPlaying then
            print("Playback is already running.")
            return
        end
        isPlaying = true
        print("Playing: " .. name)
        
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not rootPart or #path == 0 then
            print("Failed to find Humanoid/RootPart or path is empty.")
            isPlaying = false
            return
        end
        
        -- Teleport to the starting position
        rootPart.CFrame = CFrame.new(path[1].Position)
        
        -- Start playing the path
        task.spawn(function()
            for i, frameData in ipairs(path) do
                if not isPlaying then break end -- Stop playback if the flag is set to false

                if frameData.Type == "Jump" then
                    humanoid.Jump = true
                    task.wait(0.2) 
                else
                    humanoid:MoveTo(frameData.Position)
                    local moved = humanoid.MoveToFinished:Wait(2)
                    if not moved then
                         task.wait(0.1)
                    end
                end
            end
            humanoid.WalkSpeed = 16
            isPlaying = false
            print("Finished playing: " .. name)
        end)
    end)
    
    replayItem:SetAttribute("Path", path)
    replayListFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
end

-- Button functionality

-- Record Button
recordButton.MouseButton1Click:Connect(function()
    if isPlaying then
        print("Cannot record while a replay is playing.")
        return
    end

    isRecording = not isRecording
    if isRecording then
        print("Recording started...")
        currentRecordedPath = {}
        recordButton.Text = "Stop"
        
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not rootPart then
            warn("Character is not ready.")
            isRecording = false
            return
        end

        -- Record the starting position
        table.insert(currentRecordedPath, {
            Type = "Move",
            Position = rootPart.Position
        })
        lastRecordedPosition = rootPart.Position

        -- Detect jump events
        local jumpConnection = humanoid.StateChanged:Connect(function(oldState, newState)
            if newState == Enum.HumanoidStateType.Jumping then
                table.insert(currentRecordedPath, {
                    Type = "Jump"
                })
            end
        end)
        
        -- Record keyframes when position changes significantly
        pathUpdateConnection = RunService.Heartbeat:Connect(function()
            local currentPosition = rootPart.Position
            -- Record a new point if character has moved more than 1 stud
            if (currentPosition - lastRecordedPosition).Magnitude > 1 then
                table.insert(currentRecordedPath, {
                    Type = "Move",
                    Position = currentPosition
                })
                lastRecordedPosition = currentPosition
            end
        end)

    else
        print("Recording stopped. Path saved temporarily.")
        if pathUpdateConnection then
            pathUpdateConnection:Disconnect()
            pathUpdateConnection = nil
        end
        
        recordButton.Text = "Record"
    end
end)


-- Save Replay Button
saveReplayButton.MouseButton1Click:Connect(function()
    if isRecording then
        print("Please stop recording first before saving.")
        return
    end

    if #currentRecordedPath > 0 then
        local jsonString = HttpService:JSONEncode(currentRecordedPath)
        setclipboard(jsonString)
        print("Path saved to clipboard!")
        
        local replayCount = #savedReplays + 1
        local replayName = "Replay " .. replayCount
        table.insert(savedReplays, {name = replayName, path = currentRecordedPath})
        
        addReplayItem(currentRecordedPath, replayName)

        currentRecordedPath = {}
    else
        print("No path to save. Please record a path first.")
    end
end)


-- Load Path Button (from clipboard)
loadPathButton.MouseButton1Click:Connect(function()
    local jsonString = getclipboard()
    
    if jsonString and jsonString ~= "" then
        local loadedPath
        local success, err = pcall(function()
            loadedPath = HttpService:JSONDecode(jsonString)
        end)
        
        if success and type(loadedPath) == "table" and loadedPath[1] and type(loadedPath[1]) == "table" then
            local replayCount = #savedReplays + 1
            local replayName = "Loaded Path " .. replayCount
            table.insert(savedReplays, {name = replayName, path = loadedPath})
            
            addReplayItem(loadedPath, replayName)

            print("Path loaded from clipboard!")
        else
            print("Failed to load path. Clipboard content is not a valid path string.")
            print("Error: " .. tostring(err))
        end
    else
        print("Clipboard is empty.")
    end
end)
