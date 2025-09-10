--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--// VARIABLES
local Flying = false
local Noclipping = false
local FlySpeed = 50
local StealSpeedMultiplier = 1.0
local BodyGyro, BodyVelocity
local MarkedPosition

local Character
local Humanoid
local RootPart

--// UPDATE CHARACTER ON RESPAWN
local function UpdateCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
end
UpdateCharacter()
LocalPlayer.CharacterAdded:Connect(UpdateCharacter)

--// KEY SYSTEM
local CorrectKey = "SOULS"

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "KeyGui"
KeyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
KeyGui.ResetOnSpawn = false

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 150)
KeyFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = KeyGui
KeyFrame.Active = true
KeyFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,12)
UICorner.Parent = KeyFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundColor3 = Color3.fromRGB(30,30,30)
Title.Text = "Enter The Key"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(0, 0, 139)
Title.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0,200,0,40)
KeyBox.Position = UDim2.new(0.5,-100,0,50)
KeyBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 20
KeyBox.ClearTextOnFocus = false
KeyBox.PlaceholderText = "Enter Key Here"
KeyBox.Parent = KeyFrame

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0,120,0,40)
SubmitBtn.Position = UDim2.new(0.5,-60,0,100)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(120,0,255)
SubmitBtn.Text = "Submit"
SubmitBtn.TextColor3 = Color3.fromRGB(255,255,255)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 18
SubmitBtn.Parent = KeyFrame

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1,0,0,30)
InfoLabel.Position = UDim2.new(0,0,0,135)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = ""
InfoLabel.TextColor3 = Color3.fromRGB(255,0,0)
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextSize = 16
InfoLabel.Parent = KeyFrame

--// MAIN GUI
local function CreateMainGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FlyNoclipGui"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.Position = UDim2.new(0.3,0,0.3,0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.Active = true
    MainFrame.Draggable = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0,12)
    UICorner.Parent = MainFrame

    -- TITLE
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
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- FLY
    local FlyFrame = Instance.new("Frame")
    FlyFrame.Size = UDim2.new(1,-20,0,60)
    FlyFrame.Position = UDim2.new(0,10,0,50)
    FlyFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    FlyFrame.Parent = MainFrame

    local FlyToggle = Instance.new("TextButton")
    FlyToggle.Size = UDim2.new(0,80,0,40)
    FlyToggle.Position = UDim2.new(0,10,0,10)
    FlyToggle.BackgroundColor3 = Color3.fromRGB(120,0,255)
    FlyToggle.Text = "Fly OFF"
    FlyToggle.TextColor3 = Color3.fromRGB(255,255,255)
    FlyToggle.Font = Enum.Font.GothamBold
    FlyToggle.TextSize = 18
    FlyToggle.Parent = FlyFrame

    local PlusBtn = Instance.new("TextButton")
    PlusBtn.Size = UDim2.new(0,30,0,30)
    PlusBtn.Position = UDim2.new(0,100,0,10)
    PlusBtn.BackgroundColor3 = Color3.fromRGB(0,255,255)
    PlusBtn.Text = "+"
    PlusBtn.TextColor3 = Color3.fromRGB(0,0,0)
    PlusBtn.Parent = FlyFrame

    local MinusBtn = Instance.new("TextButton")
    MinusBtn.Size = UDim2.new(0,30,0,30)
    MinusBtn.Position = UDim2.new(0,140,0,10)
    MinusBtn.BackgroundColor3 = Color3.fromRGB(255,100,100)
    MinusBtn.Text = "-"
    MinusBtn.TextColor3 = Color3.fromRGB(0,0,0)
    MinusBtn.Parent = FlyFrame

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(0,50,0,30)
    SpeedLabel.Position = UDim2.new(0,180,0,10)
    SpeedLabel.BackgroundColor3 = Color3.fromRGB(50,50,50)
    SpeedLabel.Text = tostring(FlySpeed)
    SpeedLabel.TextColor3 = Color3.fromRGB(255,255,255)
    SpeedLabel.Parent = FlyFrame

    -- NOCLIP
    local NoclipFrame = Instance.new("Frame")
    NoclipFrame.Size = UDim2.new(1,-20,0,60)
    NoclipFrame.Position = UDim2.new(0,10,0,120)
    NoclipFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    NoclipFrame.Parent = MainFrame

    local NoclipToggle = Instance.new("TextButton")
    NoclipToggle.Size = UDim2.new(0,120,0,40)
    NoclipToggle.Position = UDim2.new(0,10,0,10)
    NoclipToggle.BackgroundColor3 = Color3.fromRGB(0,255,100)
    NoclipToggle.Text = "Noclip OFF"
    NoclipToggle.TextColor3 = Color3.fromRGB(0,0,0)
    NoclipToggle.Font = Enum.Font.GothamBold
    NoclipToggle.TextSize = 18
    NoclipToggle.Parent = NoclipFrame
