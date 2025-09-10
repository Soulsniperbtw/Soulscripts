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
local MarkedPosition
local currentTool

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
KeyBox.PlaceholderText = "Type Key Here"
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

--// TOOL PRESERVATION
local function PreserveTool()
    -- Keep tool attached properly while moving
    currentTool = Humanoid:FindFirstChildOfClass("Tool")
    if currentTool then
        currentTool.Parent = Character
        local handle = currentTool:FindFirstChild("Handle")
        if handle then
            local weld = handle:FindFirstChild("StealWeld") or Instance.new("Weld")
            weld.Name = "StealWeld"
            weld.Part0 = Character:FindFirstChild("RightHand")
            weld.Part1 = handle
            weld.C0 = CFrame.new()
            weld.C1 = CFrame.new()
            weld.Parent = handle
        end
    end
end

--// GUI FUNCTION
local function CreateMainGUI()
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

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- CONTAINERS
    local FlyFrame = Instance.new("Frame")
    FlyFrame.Size = UDim2.new(1,-20,0,60)
    FlyFrame.Position = UDim2.new(0,10,0,50)
    FlyFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    FlyFrame.Parent = MainFrame

    local NoclipFrame = Instance.new("Frame")
    NoclipFrame.Size = UDim2.new(1,-20,0,60)
    NoclipFrame.Position = UDim2.new(0,10,0,120)
    NoclipFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    NoclipFrame.Parent = MainFrame

    local StealFrame = Instance.new("Frame")
    StealFrame.Size = UDim2.new(1,-20,0,60)
    StealFrame.Position = UDim2.new(0,10,0,190)
    StealFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    StealFrame.Parent = MainFrame

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

    -- STEAL BUTTONS
    local MarkBtn = Instance.new("TextButton")
    MarkBtn.Size = UDim2.new(0,120,0,40)
    MarkBtn.Position = UDim2.new(0,10,0,10)
    MarkBtn.BackgroundColor3 = Color3.fromRGB(255,165,0)
    MarkBtn.Text = "Mark Location"
    MarkBtn.TextColor3 = Color3.fromRGB(0,0,0)
    MarkBtn.Font = Enum.Font.GothamBold
    MarkBtn.TextSize = 18
    MarkBtn.Parent = StealFrame

    local StealBtn = Instance.new("TextButton")
    StealBtn.Size = UDim2.new(0,120,0,40)
    StealBtn.Position = UDim2.new(0,150,0,10)
    StealBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    StealBtn.Text = "Instant Steal"
    StealBtn.TextColor3 = Color3.fromRGB(255,255,255)
    StealBtn.Font = Enum.Font.GothamBold
    StealBtn.TextSize = 18
    StealBtn.Parent = StealFrame

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
        end
    end)

    --// FLY MOVEMENT & TOOL PRESERVATION
    RunService.Heartbeat:Connect(function()
        PreserveTool()

        if Flying and BodyVelocity and BodyGyro then
            local moveVector = Vector3.new(
                (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
                0,
                (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
            )

            if moveVector.Magnitude > 0 then
                local targetVelocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(moveVector.Unit * FlySpeed)
                BodyVelocity.Velocity = BodyVelocity.Velocity:Lerp(targetVelocity, 0.15)
            else
                BodyVelocity.Velocity = BodyVelocity.Velocity:Lerp(Vector3.new(), 0.15)
            end

            BodyGyro.CFrame = BodyGyro.CFrame:Lerp(workspace.CurrentCamera.CFrame, 0.1)
        end
    end)

    --// MARK & INSTANT STEAL
    MarkBtn.MouseButton1Click:Connect(function()
        MarkedPosition = RootPart.Position
    end)

    StealBtn.MouseButton1Click:Connect(function()
        if not MarkedPosition then return end

        local bv = Instance.new("BodyVelocity")
        bv.Name = "StealVelocity"
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bv.Velocity = Vector3.new()
        bv.Parent = RootPart

        local bg = Instance.new("BodyGyro")
        bg.Name = "StealGyro"
        bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        bg.CFrame = RootPart.CFrame
        bg.Parent = RootPart

        local connection
        connection = RunService.Heartbeat:Connect(function()
            PreserveTool()

            local direction = (MarkedPosition - RootPart.Position)
            local distance = direction.Magnitude
            if distance < 1 then
                bv:Destroy()
                bg:Destroy()
                connection:Disconnect()
                RootPart.CFrame = CFrame.new(MarkedPosition)
            else
                local frictionFactor = math.clamp(distance / 20, 0.2, 1)
                local baseSpeed = math.clamp(distance * 2, 5, 40)
                local speed = baseSpeed * frictionFactor
                bv.Velocity = bv.Velocity:Lerp(direction.Unit * speed, 0.1)

                local tiltAngle = math.rad(-30 * frictionFactor)
                local lookCFrame = CFrame.new(RootPart.Position, RootPart.Position + direction)
                bg.CFrame = lookCFrame * CFrame.Angles(tiltAngle, 0, 0)
            end
        end)
    end)
end

--// KEY SUBMISSION
SubmitBtn.MouseButton1Click:Connect(function()
    local inputKey = KeyBox.Text:upper()
    if inputKey == CorrectKey then
        KeyGui:Destroy()
        CreateMainGUI()
    else
        InfoLabel.Text = "Wrong key! Try again."
    end
end)
