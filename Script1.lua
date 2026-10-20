-- Esperar a que el juego cargue
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
repeat task.wait() until LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")

-- Obtener contenedor seguro de interfaz
local success, targetParent = pcall(function() return game:GetService("CoreGui") end)
if not success or not targetParent then
	targetParent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Limpiar versiones anteriores
if targetParent:FindFirstChild("BackburnerGui") then
	targetParent.BackburnerGui:Destroy()
end

-- Interfaz gráfica
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local TextBox = Instance.new("TextBox")
local ConnectBtn = Instance.new("TextButton")
local DisconnectBtn = Instance.new("TextButton")

ScreenGui.Name = "BackburnerGui"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 160)
MainFrame.Active = true
MainFrame.Draggable = true 

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "PEGADOR TRASERO v14 (Distancia Extra)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 12

TextBox.Parent = MainFrame
TextBox.PlaceholderText = "Nombre del jugador..."
TextBox.Position = UDim2.new(0.05, 0, 0.25, 0)
TextBox.Size = UDim2.new(0.9, 0, 0, 35)
TextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Font = Enum.Font.SourceSans
TextBox.TextSize = 16
TextBox.Text = ""

ConnectBtn.Parent = MainFrame
ConnectBtn.Text = "Pegarse y Atacar"
ConnectBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
ConnectBtn.Size = UDim2.new(0.9, 0, 0, 30)
ConnectBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 70)
ConnectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ConnectBtn.Font = Enum.Font.SourceSansBold
ConnectBtn.TextSize = 16

DisconnectBtn.Parent = MainFrame
DisconnectBtn.Text = "Despegarse"
DisconnectBtn.Position = UDim2.new(0.05, 0, 0.78, 0)
DisconnectBtn.Size = UDim2.new(0.9, 0, 0, 30)
DisconnectBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
DisconnectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DisconnectBtn.Font = Enum.Font.SourceSansBold
DisconnectBtn.TextSize = 16

-- LÓGICA CON DISTANCIA AMPLIADA ADICIONAL
local connection = nil
local targetCharacter = nil
local DISTANCIA_ATRAS = 3.0 -- Subido a 3.0 para darte un margen todavía más holgado y evitar daños enemigos
local OFFSET_ALTURA = 0.35  

local function findPlayer(name)
	name = name:lower()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and (p.Name:lower():sub(1, #name) == name or p.DisplayName:lower():sub(1, #name) == name) then
			return p
		end
	end
	return nil
end

local function stopSticking()
	if connection then
		connection:Disconnect()
		connection = nil
	end
	targetCharacter = nil
end

ConnectBtn.Activated:Connect(function()
	stopSticking() 
	if TextBox.Text == "" then return end
	
	local targetPlayer = findPlayer(TextBox.Text)
	if targetPlayer and targetPlayer.Character then
		targetCharacter = targetPlayer.Character
		TextBox.Text = targetPlayer.Name 
		
		connection = RunService.Heartbeat:Connect(function()
			local myCharacter = LocalPlayer.Character
			local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
			local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
			
			if myRoot and targetRoot then
				local lookVector = targetRoot.CFrame.LookVector
				local flatLook = Vector3.new(lookVector.X, 0, lookVector.Unit.Z)
				
				if flatLook.Magnitude > 0 then
					local cleanCF = CFrame.new(targetRoot.Position, targetRoot.Position + flatLook)
					myRoot.CFrame = cleanCF * CFrame.new(0, OFFSET_ALTURA, DISTANCIA_ATRAS)
				else
					myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, OFFSET_ALTURA, DISTANCIA_ATRAS)
				end
			else
				stopSticking()
			end
		end)
	else
		TextBox.Text = ""
		TextBox.PlaceholderText = "¡No encontrado!"
	end
end)

DisconnectBtn.Activated:Connect(function()
	stopSticking()
	TextBox.PlaceholderText = "Nombre del jugador..."
	TextBox.Text = ""
end)
