--[[ 
    Souls Gui Key System (Educational Debug Version)
    Author: You
    Purpose: Test anticheat bypasses in your own game
    Features:
    - Smaller centered key screen
    - Movable GUI (draggable by title / anywhere)
    - Fly & Noclip using CFrame-based movement
--]]

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

--// Config
local CorrectKey = "Soulsniperbtw"

--// Variables
local Flying = false
local Noclipping = false

--// GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SoulsGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Background (Key Screen)
local Background = Instance.new("Frame")
Background.Size = UDim2.new(0,400,0,250)
Background.AnchorPoint = Vector2.new(0.5,0.5)
Background.Position = UDim2.new(0.5,0,0.5,0)
Background.BackgroundColor3 = Color3.fromRGB(200,0,0)
Background.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.Position = UDim2.new(0,0,0,0)
Title.Text = "Souls Gui"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundColor3 = Color3.fromRGB(120,0,0)
Title.Parent = Background

-- Key Box
local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0,250,0,40)
KeyBox.Position = UDim2.new(0.5,-125,0.5,-20)
KeyBox.PlaceholderText = "Enter Key..."
KeyBox.Text = ""
KeyBox.Font = Enum.Font.GothamBold
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
KeyBox.TextScaled = true
KeyBox.BackgroundColor3 = Color3.fromRGB(50,0,50)
KeyBox.Parent = Background

-- Submit Button
local Submit = Instance.new("TextButton")
Submit.Size = UDim2.new(0,180,0,40)
Submit.Position = UDim2.new(0.5,-90,1,-50)
Submit.Text = "Submit"
Submit.Font = Enum.Font.GothamBold
Submit.TextSize = 20
Submit.TextColor3 = Color3.fromRGB(255,255,255)
Submit.BackgroundColor3 = Color3.fromRGB(100,0,100)
Submit.Parent = Background

-- Menu (hidden until key is correct)
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0,250,0,160)
MenuFrame.AnchorPoint = Vector2.new(0.5,0.5)
MenuFrame.Position = UDim2.new(0.5,0,0.5,0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
MenuFrame.Visible = false
MenuFrame.Parent = ScreenGui

local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(1,0,0,50)
FlyButton.Text = "Toggle Fly"
FlyButton.Font = Enum.Font.GothamSemibold
FlyButton.TextSize = 18
FlyButton.TextColor3 = Color3.fromRGB(255,255,255)
FlyButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
FlyButton.Parent = MenuFrame

local NoclipButton = Instance.new("TextButton")
NoclipButton.Size = UDim2.new(1,0,0,50)
NoclipButton.Position = UDim2.new(0,0,0,60)
NoclipButton.Text = "Toggle Noclip"
NoclipButton.Font = Enum.Font.GothamSemibold
NoclipButton.TextSize = 18
NoclipButton.TextColor3 = Color3.fromRGB(255,255,255)
NoclipButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
NoclipButton.Parent = MenuFrame

--// Make GUI draggable
local function MakeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle = dragHandle or frame

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

MakeDraggable(Background, Title) -- drag key screen by title
MakeDraggable(MenuFrame) -- drag menu anywhere

--// Fly movement loop
RunService.Heartbeat:Connect(function()
    if Flying then
        local camCF = workspace.CurrentCamera.CFrame
        local moveDir = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.yAxis end

        if moveDir.Magnitude > 0 then
            RootPart.CFrame = RootPart.CFrame + (moveDir.Unit * 2) -- smooth step
        end
    end
end)

--// Noclip handler
RunService.Stepped:Connect(function()
    if Noclipping then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        RootPart.Velocity = Vector3.zero
    end
end)

--// Button Connections
FlyButton.MouseButton1Click:Connect(function()
    Flying = not Flying
    FlyButton.Text = Flying and "Toggle Fly (ON)" or "Toggle Fly (OFF)"
end)

NoclipButton.MouseButton1Click:Connect(function()
    Noclipping = not Noclipping
    NoclipButton.Text = Noclipping and "Toggle Noclip (ON)" or "Toggle Noclip (OFF)"
end)

--// Key System
Submit.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then
        Background.Visible = false
        MenuFrame.Visible = true
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Wrong Key!"
    end
end)
