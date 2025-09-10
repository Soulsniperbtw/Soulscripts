-- Advanced Developer GUI for Steal a Brainrot (Mobile + PC Friendly)
-- Key: "Soulsniper"

local DeveloperKey = "Soulsniper"
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ===== SCREEN GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevGUI"
ScreenGui.Parent = PlayerGui

-- ===== KEY SYSTEM =====
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromScale(0.8,0.25) -- Mobile-friendly size
KeyFrame.Position = UDim2.fromScale(0.1,0.375)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = ScreenGui
KeyFrame.ZIndex = 10
KeyFrame.Active = true
KeyFrame.Draggable = true

local KeyBox = Instance.new("TextBox")
KeyBox.PlaceholderText = "Enter Developer Key"
KeyBox.Size = UDim2.fromScale(0.9,0.4)
KeyBox.Position = UDim2.fromScale(0.05,0.1)
KeyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.TextScaled = true
KeyBox.Parent = KeyFrame

local SubmitButton = Instance.new("TextButton")
SubmitButton.Text = "Unlock"
SubmitButton.Size = UDim2.fromScale(0.9,0.4)
SubmitButton.Position = UDim2.fromScale(0.05,0.55)
SubmitButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
SubmitButton.TextColor3 = Color3.new(1,1,1)
SubmitButton.TextScaled = true
SubmitButton.Parent = KeyFrame

-- ===== FUNCTION: Add Rainbow Glow =====
local function addRainbowGlow(uiObject)
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = uiObject

    -- Rainbow outline
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 3
    stroke.Parent = uiObject

    -- Hover effect
    uiObject.MouseEnter:Connect(function()
        stroke.Thickness = 5
    end)
    uiObject.MouseLeave:Connect(function()
        stroke.Thickness = 3
    end)

    -- Animate color
    local hue = math.random(0,360)
    RunService.RenderStepped:Connect(function()
        hue = (hue + 1) % 360
        stroke.Color = Color3.fromHSV(hue/360,1,1)
    end)
end

-- Apply rainbow glow to key system
addRainbowGlow(KeyFrame)
addRainbowGlow(KeyBox)
addRainbowGlow(SubmitButton)

-- ===== MAIN FRAME =====
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

-- Gradient background for main frame
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

-- ===== UNLOCK LOGIC =====
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

-- ===== FUNCTION: Create Tab Button =====
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

-- ===== FUNCTION: Create UI Elements =====
local function createButton(text,posY,parent)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.fromScale(0.9,0.1)
    btn.Position = UDim2.fromScale(0.05,posY)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = parent
    addRainbowGlow(btn)
    return btn
end

local function createLabel(text,posY,parent)
    local lbl = Instance.new("TextLabel")
    lbl.Text = text
    lbl.Size = UDim2.fromScale(0.9,0.08)
    lbl.Position = UDim2.fromScale(0.05,posY)
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    lbl.TextScaled = true
    lbl.Parent = parent
    return lbl
end

local function createTextBox(placeholder,posY,parent)
    local tb = Instance.new("TextBox")
    tb.PlaceholderText = placeholder
    tb.Size = UDim2.fromScale(0.6,0.08)
    tb.Position = UDim2.fromScale(0.05,posY)
    tb.BackgroundColor3 = Color3.fromRGB(40,40,40)
    tb.TextColor3 = Color3.new(1,1,1)
    tb.TextScaled = true
    tb.Parent = parent
    addRainbowGlow(tb)
    return tb
end

-- ===== MOVEMENT TAB =====
function createMovementTab()
    local wsBox = createTextBox("WalkSpeed",0.1,ContentFrame)
    createLabel("WalkSpeed",0.03,ContentFrame)
    createButton("Set WalkSpeed",0.22,ContentFrame).MouseButton1Click:Connect(function()
        local speed = tonumber(wsBox.Text)
        if speed then Humanoid.WalkSpeed = speed end
    end)

    local jpBox = createTextBox("JumpPower",0.34,ContentFrame)
    createLabel("JumpPower",0.27,ContentFrame)
    createButton("Set JumpPower",0.46,ContentFrame).MouseButton1Click:Connect(function()
        local jp = tonumber(jpBox.Text)
        if jp then Humanoid.JumpPower = jp end
    end)

    local flying=false
    local flyVel = Instance.new("BodyVelocity")
    flyVel.MaxForce=Vector3.new(0,0,0)
    createButton("Toggle Fly",0.58,ContentFrame).MouseButton1Click:Connect(function()
        flying = not flying
        if flying then
            flyVel.MaxForce = Vector3.new(400000,400000,400000)
            flyVel.Velocity = Vector3.new(0,0,0)
            flyVel.Parent = RootPart
        else flyVel:Destroy() end
    end)

    RunService.RenderStepped:Connect(function()
        if flying then
            local vel = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel += workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel -= workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel -= workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel += workspace.CurrentCamera.CFrame.RightVector end
            if vel.Magnitude > 0 then flyVel.Velocity = vel.Unit * 50 end
        end
    end)

    local noclip = false
    createButton("Toggle Noclip",0.70,ContentFrame).MouseButton1Click:Connect(function()
        noclip = not noclip
        Humanoid.PlatformStand = noclip
    end)

    local spinning=false
    local spinConn
    createButton("Toggle Spin",0.82,ContentFrame).MouseButton1Click:Connect(function()
        spinning = not spinning
        if spinning then
            spinConn = RunService.RenderStepped:Connect(function()
                if RootPart then RootPart.CFrame *= CFrame.Angles(0,math.rad(5),0) end
            end)
        else if spinConn then spinConn:Disconnect() end end
    end)
end

-- ===== BASE TAB =====
function createBaseTab()
    createButton("Go To Base",0.05,ContentFrame).MouseButton1Click:Connect(function()
        local target = Vector3.new(0,5,0)
        local steps=50
        local startPos = RootPart.Position
        for i=1,steps do
            RootPart.CFrame = CFrame.new(startPos:Lerp(target,i/steps))
            wait(0.01)
        end
    end)
    createButton("Collect Money",0.18,ContentFrame).MouseButton1Click:Connect(function()
        print("Money collected (simulated)")
    end)
    local locked=false
    createButton("Lock Base",0.31,ContentFrame).MouseButton1Click:Connect(function()
        locked = not locked
        if locked then print("Base locked (simulated)") else print("Base unlocked") end
    end)
end

-- ===== DEBUG TAB =====
function createDebugTab()
    local espEnabled=false
    local espBoxes={}
    local btn = createButton("Toggle ESP",0.05,ContentFrame)
    btn.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        if not espEnabled then
            for _,b in pairs(espBoxes) do b:Destroy() end
            espBoxes={}
        end
    end)

    RunService.RenderStepped:Connect(function()
        if espEnabled then
            local folder = workspace:FindFirstChild("Brainrots")
            if folder then
                for _, obj in pairs(folder:GetChildren()) do
                    if not espBoxes[obj] then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Adornee = obj
                        box.Size = obj.Size or Vector3.new(2,2,2)
                        box.Color3 = Color3.fromRGB(255,0,0)
                        box.Transparency = 0.5
                        box.AlwaysOnTop = true
                        box.Parent = obj
                        espBoxes[obj] = box
                    end
                end
            end
        end
    end)
end

print("Advanced Developer GUI Loaded! Key: Soulsniper")
