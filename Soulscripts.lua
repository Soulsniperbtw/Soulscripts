--[[
    Souls Gui Key System
    Author: (You)
    Purpose: Educational use in your own game
    Features:
    - Red background with "Souls Gui" title
    - Key entry (password: Soulsniperbtw)
    - Unlocks menu with Fly and Noclip toggles
]]

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

--// Config
local CorrectKey = "Soulsniperbtw"

--// Variables
local Flying = false
local Noclipping = false
local BodyGyro, BodyVelocity

--// GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SoulsGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Background
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1,0,1,0)
Background.BackgroundColor3 = Color3.fromRGB(200,0,0) -- red
Background.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,60)
Title.Position = UDim2.new(0,0,0,20)
Title.Text = "Souls Gui"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 36
Title.TextColor3 = Color3.fromRGB(128,0,128) -- purple
Title.BackgroundTransparency = 1
Title.Parent = Background

-- Key Box
local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0,300,0,50)
KeyBox.Position = UDim2.new(0.5,-150,0.5,-25)
KeyBox.PlaceholderText = "Enter Key..."
KeyBox.Text = ""
KeyBox.Font = Enum.Font.GothamBold
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
KeyBox.TextScaled = true
KeyBox.BackgroundColor3 = Color3.fromRGB(50,0,50)
KeyBox.Parent = Background

-- Submit Button
local Submit = Instance.new("TextButton")
Submit.Size = UDim2.new(0,200,0,40)
Submit.Position = UDim2.new(0.5,-100,0.5,40)
Submit.Text = "Submit"
Submit.Font = Enum.Font.GothamBold
Submit.TextSize = 20
Submit.TextColor3 = Color3.fromRGB(255,255,255)
Submit.BackgroundColor3 = Color3.fromRGB(100,0,100)
Submit.Parent = Background

-- Menu (hidden until key is correct)
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0,250,0,200)
MenuFrame.Position = UDim2.new(0.5,-125,0.5,-100)
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

--// Flight Functions
local function StartFlying()
    if Flying then return end
    Flying = true

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(1e6,1e6,1e6)
    BodyGyro.CFrame = RootPart.CFrame
    BodyGyro.Parent = RootPart

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(1e6,1e6,1e6)
    BodyVelocity.Velocity = Vector3.new()
    BodyVelocity.Parent = RootPart
end

local function StopFlying()
    Flying = false
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
end

--// Noclip Handler
RunService.Stepped:Connect(function()
    if Noclipping then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

--// Movement Loop
RunService.Heartbeat:Connect(function()
    if Flying and BodyVelocity and BodyGyro then
        local MoveVector = Vector3.new(
            (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
            (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0),
            (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
        )

        if MoveVector.Magnitude > 0 then
            BodyVelocity.Velocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(MoveVector.Unit * 50)
        else
            BodyVelocity.Velocity = Vector3.new()
        end

        BodyGyro.CFrame = workspace.CurrentCamera.CFrame
    end
end)

--// Button Connections
FlyButton.MouseButton1Click:Connect(function()
    if Flying then
        StopFlying()
        FlyButton.Text = "Toggle Fly (OFF)"
    else
        StartFlying()
        FlyButton.Text = "Toggle Fly (ON)"
    end
end)

NoclipButton.MouseButton1Click:Connect(function()
    Noclipping = not Noclipping
    if Noclipping then
        NoclipButton.Text = "Toggle Noclip (ON)"
    else
        NoclipButton.Text = "Toggle Noclip (OFF)"
    end
end)

--// Key System
Submit.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then
        Background.Visible = false
        MenuFrame.Visible = true
    else
        KeyBox.Text = "Wrong Key!"
    end
end)
