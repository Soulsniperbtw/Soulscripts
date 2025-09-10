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

--// KEY SYSTEM
local Key = "1234" -- change this to your desired key

local function PromptKey(callback)
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "KeyPrompt"
    keyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,250,0,100)
    frame.Position = UDim2.new(0.5,-125,0.5,-50)
    frame.BackgroundColor3 = Color3.fromRGB(200,0,0)
    frame.BorderSizePixel = 0
    frame.Parent = keyGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,25)
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1
    title.Text = "Souls Script"
    title.TextColor3 = Color3.fromRGB(128,0,128)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Parent = frame

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0,150,0,30)
    input.Position = UDim2.new(0.5,-75,0,35)
    input.BackgroundColor3 = Color3.fromRGB(50,50,50)
    input.TextColor3 = Color3.fromRGB(255,255,255)
    input.PlaceholderText = "Enter key..."
    input.Font = Enum.Font.Gotham
    input.TextSize = 16
    input.Parent = frame

    local submit = Instance.new("TextButton")
    submit.Size = UDim2.new(0,80,0,30)
    submit.Position = UDim2.new(0.5,-40,0,70)
    submit.BackgroundColor3 = Color3.fromRGB(0,170,255)
    submit.Text = "Submit"
    submit.TextColor3 = Color3.fromRGB(0,0,0)
    submit.Font = Enum.Font.GothamBold
    submit.TextSize = 16
    submit.Parent = frame

    submit.MouseButton1Click:Connect(function()
        if input.Text == Key then
            keyGui:Destroy()
            if callback then
                callback()
            end
        else
            input.Text = ""
        end
    end)
end

--// MAIN GUI
local function CreateMainGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CompactFlyNoclip"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,300,0,180)
    MainFrame.Position = UDim2.new(0.35,0,0.35,0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.Active = true
    MainFrame.Draggable = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0,12)
    UICorner.Parent = MainFrame

    -- TITLE & BUTTONS
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,35)
    Title.Position = UDim2.new(0,0,0,0)
    Title.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Title.Text = "Fly & Noclip"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(0,255,255)
    Title.Parent = MainFrame

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0,30,0,30)
    CloseBtn.Position = UDim2.new(1,-35,0,2)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 18
    CloseBtn.Parent = MainFrame
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0,30,0,30)
    MinimizeBtn.Position = UDim2.new(1,-70,0,2)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(100,100,255)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 18
    MinimizeBtn.Parent = MainFrame
    MinimizeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- ROW CREATOR
    local function createRow(y)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1,-20,0,40)
        row.Position = UDim2.new(0,10,0,y)
        row.BackgroundColor3 = Color3.fromRGB(30,30,30)
        row.Parent = MainFrame
        return row
    end

    local FlyRow = createRow(40)
    local NoclipRow = createRow(90)
    local StealRow = createRow(140)

    -- FLY
    local FlyToggle = Instance.new("TextButton")
    FlyToggle.Size = UDim2.new(0,80,0,30)
    FlyToggle.Position = UDim2.new(0,0,0,5)
    FlyToggle.BackgroundColor3 = Color3.fromRGB(0,200,255)
    FlyToggle.Text = "Fly OFF"
    FlyToggle.TextColor3 = Color3.fromRGB(0,0,0)
    FlyToggle.Font = Enum.Font.GothamBold
    FlyToggle.TextSize = 16
    FlyToggle.Parent = FlyRow

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(0,50,0,30)
    SpeedLabel.Position = UDim2.new(0,90,0,5)
    SpeedLabel.BackgroundColor3 = Color3.fromRGB(50,50,50)
    SpeedLabel.Text = tostring(FlySpeed)
    SpeedLabel.TextColor3 = Color3.fromRGB(255,255,255)
    SpeedLabel.Font = Enum.Font.Gotham
    SpeedLabel.TextSize = 16
    SpeedLabel.Parent = FlyRow

    local PlusBtn = Instance.new("TextButton")
    PlusBtn.Size = UDim2.new(0,25,0,30)
    PlusBtn.Position = UDim2.new(0,150,0,5)
    PlusBtn.BackgroundColor3 = Color3.fromRGB(0,255,255)
    PlusBtn.Text = "+"
    PlusBtn.TextColor3 = Color3.fromRGB(0,0,0)
    PlusBtn.Font = Enum.Font.GothamBold
    PlusBtn.TextSize = 16
    PlusBtn.Parent = FlyRow

    local MinusBtn = Instance.new("TextButton")
    MinusBtn.Size = UDim2.new(0,25,0,30)
    MinusBtn.Position = UDim2.new(0,180,0,5)
    MinusBtn.BackgroundColor3 = Color3.fromRGB(255,150,0)
    MinusBtn.Text = "-"
    MinusBtn.TextColor3 = Color3.fromRGB(0,0,0)
    MinusBtn.Font = Enum.Font.GothamBold
    MinusBtn.TextSize = 16
    MinusBtn.Parent = FlyRow

    -- NOCLIP
    local NoclipToggle = Instance.new("TextButton")
    NoclipToggle.Size = UDim2.new(0,120,0,30)
    NoclipToggle.Position = UDim2.new(0,0,0,5)
    NoclipToggle.BackgroundColor3 = Color3.fromRGB(255,215,0)
    NoclipToggle.Text = "Noclip OFF"
    NoclipToggle.TextColor3 = Color3.fromRGB(0,0,0)
    NoclipToggle.Font = Enum.Font.GothamBold
    NoclipToggle.TextSize = 16
    NoclipToggle.Parent = NoclipRow

    -- INSTANT STEAL (Teleport to spawn)
    local StealBtn = Instance.new("TextButton")
    StealBtn.Size = UDim2.new(0,120,0,30)
    StealBtn.Position = UDim2.new(0,0,0,5)
    StealBtn.BackgroundColor3 = Color3.fromRGB(255,0,255)
    StealBtn.Text = "Instant Steal"
    StealBtn.TextColor3 = Color3.fromRGB(0,0,0)
    StealBtn.Font = Enum.Font.GothamBold
    StealBtn.TextSize = 16
    StealBtn.Parent = StealRow

    StealBtn.MouseButton1Click:Connect(function()
        local spawnPart = workspace:FindFirstChild("Spawn") -- replace with actual spawn/fish name
        if spawnPart then
            RootPart.CFrame = spawnPart.CFrame + Vector3.new(0,3,0)
        end
    end)

    -- FLY LOGIC
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

    -- Noclip
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
end

-- Launch key system first
PromptKey(CreateMainGUI)
