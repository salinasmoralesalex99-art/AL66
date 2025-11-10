-- Coloca esto en un LocalScript dentro de StarterGui

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

-- GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- Frame contenedor (Menú movible)
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 200, 0, 220) -- Tamaño compacto
menuFrame.Position = UDim2.new(0, 50, 0, 50)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.BorderSizePixel = 0
menuFrame.Parent = screenGui

-- Título del menú
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Fast Steal 66🔥"
titleLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Letras rojas
titleLabel.TextScaled = true
titleLabel.Parent = menuFrame

-- Función para hacer el Frame movible
local dragging = false
local dragInput, mousePos, framePos

titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = menuFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleLabel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

runService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - mousePos
        menuFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X,
                                       framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- Función para crear botones con color específico
local function createButton(text, posY, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Parent = menuFrame
    return btn
end

-- Botones con colores referenciales
local saveButton = createButton("📍 Save Position", 40, Color3.fromRGB(0, 170, 255)) -- Azul
local goButton = createButton("🏃‍♂️ Go to Position", 90, Color3.fromRGB(0, 255, 0)) -- Verde
local noclipButton = createButton("👻 Noclip: OFF", 140, Color3.fromRGB(170, 0, 255)) -- Morado

-- Variables
local savedPosition = nil
local noclipEnabled = false

-- Guardar posición 📍
saveButton.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        savedPosition = player.Character.HumanoidRootPart.Position
        saveButton.Text = "📍 Position Saved!"
        saveButton.TextColor3 = Color3.fromRGB(255,255,255)
    end
end)

-- Ir a posición 🏃‍♂️
goButton.MouseButton1Click:Connect(function()
    if savedPosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local target = savedPosition

        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
        local tween = tweenService:Create(hrp, tweenInfo, {Position = target})
        tween:Play()

        tween.Completed:Connect(function()
            goButton.Text = "🏃‍♂️ Steal Completed"
            goButton.TextColor3 = Color3.fromRGB(0, 255, 0) -- Verde
        end)
    end
end)

-- Noclip 👻
noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipButton.Text = noclipEnabled and "👻 Noclip: ON" or "👻 Noclip: OFF"
    
    if noclipEnabled then
        runService.Stepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState(11) -- 11 = NoClip
            end
        end)
    end
end)
