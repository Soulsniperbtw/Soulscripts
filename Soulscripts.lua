-- ===== CROSS-PLATFORM DEV GUI =====
-- Key: Soulsniper

-- (Setup as before: Services, Character, Humanoid, RootPart, ScreenGui, Rainbow Glow function)

-- ===== KEY SYSTEM (Mobile Friendly) =====
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromScale(0.9,0.35)
KeyFrame.Position = UDim2.fromScale(0.05,0.325)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
KeyFrame.BorderSizePixel = 0
KeyFrame.ZIndex = 20
KeyFrame.Parent = ScreenGui
KeyFrame.Active = true
KeyFrame.Draggable = true
addRainbowGlow(KeyFrame)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Text = "Enter Developer Key"
KeyTitle.Size = UDim2.fromScale(1,0.3)
KeyTitle.Position = UDim2.fromScale(0,0)
KeyTitle.TextScaled = true
KeyTitle.TextColor3 = Color3.new(1,1,1)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Parent = KeyFrame
addRainbowGlow(KeyTitle)

local KeyBox = Instance.new("TextBox")
KeyBox.PlaceholderText = "Enter Key Here"
KeyBox.Size = UDim2.fromScale(0.9,0.25)
KeyBox.Position = UDim2.fromScale(0.05,0.35)
KeyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.TextScaled = true
KeyBox.ClearTextOnFocus = false
KeyBox.ZIndex = 21
KeyBox.Parent = KeyFrame
addRainbowGlow(KeyBox)

local SubmitButton = Instance.new("TextButton")
SubmitButton.Text = "Enter"
SubmitButton.Size = UDim2.fromScale(0.9,0.25)
SubmitButton.Position = UDim2.fromScale(0.05,0.65)
SubmitButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
SubmitButton.TextColor3 = Color3.new(1,1,1)
SubmitButton.TextScaled = true
SubmitButton.ZIndex = 21
SubmitButton.Parent = KeyFrame
addRainbowGlow(SubmitButton)

-- ===== MAIN GUI =====
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromScale(0.9,0.8)
MainFrame.Position = UDim2.fromScale(0.05,0.1)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
MainFrame.Visible = false
MainFrame.ZIndex = 5
addRainbowGlow(MainFrame)

-- Gradient background
local gradient = Instance.new("UIGradient")
gradient.Rotation = 45
gradient.Parent = MainFrame
local hueMain = 0
RunService.RenderStepped:Connect(function()
    hueMain = (hueMain + 0.5) % 360
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromHSV((hueMain/360),1,1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(((hueMain+120)/360)%1,1,1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(((hueMain+240)/360)%1,1,1))
    }
end)

-- Unlock logic
SubmitButton.MouseButton1Click:Connect(function()
    if KeyBox.Text == DeveloperKey then
        KeyFrame:Destroy()
        MainFrame.Visible = true
    else
        KeyBox.Text = "Wrong Key!"
    end
end)

-- ===== TABS =====
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.fromScale(0.2,1)
TabsFrame.Position = UDim2.fromScale(0,0)
TabsFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
TabsFrame.Parent = MainFrame
addRainbowGlow(TabsFrame)

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.fromScale(0.8,1)
ContentFrame.Position = UDim2.fromScale(0.2,0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
ContentFrame.Parent = MainFrame
addRainbowGlow(ContentFrame)

local tabs = {"Movement","Base","Debug"}
local currentTab = nil

local function createTabButton(name,posY)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.fromScale(1,0.15)
    btn.Position = UDim2.fromScale(0,0.05 + (posY*0.17))
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = TabsFrame
    addRainbowGlow(btn)

    btn.MouseButton1Click:Connect(function()
        for _, child in pairs(ContentFrame:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        currentTab = name
        if name == "Movement" then createMovementTab() end
        if name == "Base" then createBaseTab() end
        if name == "Debug" then createDebugTab() end
    end)
end

for i, t in ipairs(tabs) do
    createTabButton(t,i)
end

-- ===== MOBILE TOUCH CONTROLS =====
local MobileControls = Instance.new("Frame")
MobileControls.Size = UDim2.fromScale(1,1)
MobileControls.Position = UDim2.fromScale(0,0)
MobileControls.BackgroundTransparency = 1
MobileControls.ZIndex = 50
MobileControls.Parent = ScreenGui

-- Joystick
local Joystick = Instance.new("ImageButton")
Joystick.Size = UDim2.fromScale(0.25,0.25)
Joystick.Position = UDim2.fromScale(0.05,0.7)
Joystick.BackgroundColor3 = Color3.fromRGB(50,50,50)
Joystick.Image = ""
Joystick.Parent = MobileControls
addRainbowGlow(Joystick)

local moveVector = Vector3.new(0,0,0)
local dragging = false
local startPos

Joystick.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        startPos = input.Position
    end
end)

Joystick.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and dragging then
        local delta = input.Position - startPos
        moveVector = Vector3.new(delta.X/50,0,delta.Y/50)
    end
end)

Joystick.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        moveVector = Vector3.new(0,0,0)
    end
end)

-- Jump / Fly Buttons
local function createMobileButton(text,posX,posY,action)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.fromScale(0.15,0.1)
    btn.Position = UDim2.fromScale(posX,posY)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = MobileControls
    addRainbowGlow(btn)
    btn.MouseButton1Down:Connect(action)
    return btn
end

local JumpBtn = createMobileButton("Jump",0.8,0.8,function() Humanoid.Jump=true end)
local FlyUpBtn = createMobileButton("Fly +",0.65,0.7,function() RootPart.Velocity=Vector3.new(RootPart.Velocity.X,50,RootPart.Velocity.Z) end)
local FlyDownBtn = createMobileButton("Fly -",0.8,0.7,function() RootPart.Velocity=Vector3.new(RootPart.Velocity.X,-50,RootPart.Velocity.Z) end)
local NoclipBtn = createMobileButton("Noclip",0.65,0.8,function() Humanoid.PlatformStand = not Humanoid.PlatformStand end)
local SpinBtn = createMobileButton("Spin",0.5,0.8,function()
    spinning = not spinning
end)
local GoBaseBtn = createMobileButton("Go Base",0.5,0.7,function()
    RootPart.CFrame = CFrame.new(Vector3.new(0,5,0)) -- simple teleport
end)

-- ===== UPDATE MOVEMENT =====
RunService.RenderStepped:Connect(function()
    if moveVector.Magnitude > 0 then
        local cam = workspace.CurrentCamera
        local dir = (cam.CFrame.RightVector * moveVector.X) + (cam.CFrame.LookVector * moveVector.Z)
        dir = Vector3.new(dir.X,0,dir.Z).Unit * Humanoid.WalkSpeed
        Humanoid:Move(dir,true)
    end

    -- Spin effect
    if spinning then
        RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0,math.rad(5),0)
    end
end)

print("Cross-Platform Advanced Developer GUI Loaded! Key: Soulsniper")

