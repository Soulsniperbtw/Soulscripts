--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

--// VARIABLES
local Flying = false
local Noclipping = false
local FlySpeed = 50
local BodyGyro, BodyVelocity

--// GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyNoclipGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.3,0,0.3,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,12)
UICorner.Parent = MainFrame

-- TITLE BAR
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundColor3 = Color3.fromRGB(40,40,40)
Title.Text = "Fly & Noclip GUI"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,35,0,35)
CloseBtn.Position = UDim2.new(1,-40,0,2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0,35,0,35)
MinimizeBtn.Position = UDim2.new(1,-80,0,2)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(100,100,255)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 20
MinimizeBtn.Parent = MainFrame

-- CONTAINERS
local FlyFrame = Instance.new("Frame")
FlyFrame.Size = UDim2.new(1,-20,0,120)
FlyFrame.Position = UDim2.new(0,10,0,50)
FlyFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
FlyFrame.Parent = MainFrame

local NoclipFrame = Instance.new("Frame")
NoclipFrame.Size = UDim2.new(1,-20,0,60)
NoclipFrame.Position = UDim2.new(0,10,0,180)
NoclipFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
NoclipFrame.Parent = MainFrame

-- FLY BUTTONS
local FlyToggle = Instance.new("TextButton")
FlyToggle.Size = UDim2.new(0,80,0,40)
FlyToggle.Position = UDim2.new(0,10,0,10)
FlyToggle.BackgroundColor3 = Color3.fromRGB(120,0,255)
FlyToggle.Text = "Fly OFF"
FlyToggle.TextColor3 = Color3.fromRGB(255,255,255)
FlyToggle.Font = Enum.Font.GothamBold
FlyToggle.TextSize = 18
FlyToggle.Parent = FlyFrame

local UpBtn = Instance.new("TextButton")
UpBtn.Size = UDim2.new(0,60,0,30)
UpBtn.Position = UDim2.new(0,100,0,10)
UpBtn.BackgroundColor3 = Color3.fromRGB(0,255,150)
UpBtn.Text = "UP"
UpBtn.TextColor3 = Color3.fromRGB(0,0,0)
UpBtn.Parent = FlyFrame

local DownBtn = Instance.new("TextButton")
DownBtn.Size = UDim2.new(0,60,0,30)
DownBtn.Position = UDim2.new(0,170,0,10)
DownBtn.BackgroundColor3 = Color3.fromRGB(255,200,0)
DownBtn.Text = "DOWN"
DownBtn.TextColor3 = Color3.fromRGB(0,0,0)
DownBtn.Parent = FlyFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0,50,0,30)
SpeedLabel.Position = UDim2.new(0,240,0,10)
SpeedLabel.BackgroundColor3 = Color3.fromRGB(50,50,50)
SpeedLabel.Text = tostring(FlySpeed)
SpeedLabel.TextColor3 = Color3.fromRGB(255,255,255)
SpeedLabel.Parent = FlyFrame

local PlusBtn = Instance.new("TextButton")
PlusBtn.Size = UDim2.new(0,30,0,30)
PlusBtn.Position = UDim2.new(0,295,0,10)
PlusBtn.BackgroundColor3 = Color3.fromRGB(0,255,255)
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(0,0,0)
PlusBtn.Parent = FlyFrame

local MinusBtn = Instance.new("TextButton")
MinusBtn.Size = UDim2.new(0,30,0,30)
MinusBtn.Position = UDim2.new(0,330,0,10)
MinusBtn.BackgroundColor3 = Color3.fromRGB(255,100,100)
MinusBtn.Text = "-"
MinusBtn.TextColor3 = Color3.fromRGB(0,0,0)
MinusBtn.Parent = FlyFrame

-- NOCLIP BUTTON
local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(0,120,0,40)
NoclipToggle.Position = UDim2.new(0,10,0,10)
NoclipToggle.BackgroundColor3 = Color3.fromRGB(0,255,100)
NoclipToggle.Text = "Noclip OFF"
NoclipToggle.TextColor3 = Color3.fromRGB(0,0,0)
NoclipToggle.Font = Enum.Font.GothamBold
NoclipToggle.TextSize = 18
NoclipToggle.Parent = NoclipFrame

--// FLY FUNCTIONS
local function StartFlying()
    if Flying then return end
    Flying = true
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(1e6,1e6,1e6)
    BodyGyro.CFrame = RootPart.CFrame
    BodyGyro.P = 9e4
    BodyGyro.Parent = RootPart

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(1e6,1e6,1e6)
    BodyVelocity.Velocity = Vector3.new()
    BodyVelocity.Parent = RootPart
end

local function StopFlying()
    Flying = false
    if BodyGyro then BodyGyro:Destroy() BodyGyro=nil end
    if BodyVelocity then BodyVelocity:Destroy() BodyVelocity=nil end
end

FlyToggle.MouseButton1Click:Connect(function()
    if Flying then
        StopFlying()
        FlyToggle.Text = "Fly OFF"
    else
        StartFlying()
        FlyToggle.Text = "Fly ON"
    end
end)

PlusBtn.MouseButton1Click:Connect(function()
    FlySpeed = FlySpeed + 10
    SpeedLabel.Text = tostring(FlySpeed)
end)
MinusBtn.MouseButton1Click:Connect(function()
    FlySpeed = math.max(10, FlySpeed - 10)
    SpeedLabel.Text = tostring(FlySpeed)
end)

-- UP/DOWN
UpBtn.MouseButton1Click:Connect(function()
    if Flying then
        RootPart.CFrame = RootPart.CFrame + Vector3.new(0,10,0)
    end
end)
DownBtn.MouseButton1Click:Connect(function()
    if Flying then
        RootPart.CFrame = RootPart.CFrame - Vector3.new(0,10,0)
    end
end)

-- FLY MOVEMENT
RunService.Heartbeat:Connect(function()
    if Flying and BodyVelocity and BodyGyro then
        local MoveVector = Vector3.new(
            (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
            0,
            (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
        )
        if MoveVector.Magnitude > 0 then
            BodyVelocity.Velocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(MoveVector.Unit * FlySpeed)
        else
            BodyVelocity.Velocity = Vector3.new()
        end
        BodyGyro.CFrame = workspace.CurrentCamera.CFrame
    end
end)

--// NOCLIP FUNCTIONS
NoclipToggle.MouseButton1Click:Connect(function()
    Noclipping = not Noclipping
    if Noclipping then
        NoclipToggle.Text = "Noclip ON"
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
    else
        NoclipToggle.Text = "Noclip OFF"
    end
end)

RunService.Stepped:Connect(function()
    if Noclipping then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
    end
end)
