-- Esperar a que el juego cargue completamente
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
repeat task.wait() until LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")

-- Contenedor seguro de interfaz (CoreGui con respaldo en PlayerGui)
local success, targetParent = pcall(function() return game:GetService("CoreGui") end)
if not success or not targetParent then
	targetParent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Limpiar versiones anteriores para evitar duplicados
if targetParent:FindFirstChild("TouchFlingGui") then
	targetParent.TouchFlingGui:Destroy()
end

-- Sistema de detección único para ejecutores
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
	local detection = Instance.new("Decal")
	detection.Name = "juisdfj0i32i0eidsuf0iok"
	detection.Parent = ReplicatedStorage
end

-- Creación de la Interfaz Gráfica Universal (PC y Móvil)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Name = "TouchFlingGui"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.388, 0, 0.427, 0)
MainFrame.Size = UDim2.new(0, 160, 0, 115)
MainFrame.Active = true
MainFrame.Draggable = true -- Permite arrastrar el menú por la pantalla

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(0, 160, 0, 28)

TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1.000
TitleLabel.Position = UDim2.new(0.05, 0, 0, 0)
TitleLabel.Size = UDim2.new(0.9, 0, 1, 0)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "TOUCH FLING PRO"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14

ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 45)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 18

-- LÓGICA DE FLING DE ALTA PRECISIÓN
local hiddenFling = false
local flingThread = nil

local function runFling()
	local c, hrp, vel, movel = nil, nil, nil, 0.1
	
	while hiddenFling do
		RunService.Heartbeat:Wait()
		c = LocalPlayer.Character
		hrp = c and c:FindFirstChild("HumanoidRootPart")
		
		if hrp then
			vel = hrp.Velocity
			-- Multiplicador de velocidad de impacto instantáneo
			hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
			RunService.RenderStepped:Wait()
			hrp.Velocity = vel
			RunService.Stepped:Wait()
			hrp.Velocity = vel + Vector3.new(0, movel, 0)
			movel = -movel
		end
	end
end

ToggleBtn.Activated:Connect(function()
	hiddenFling = not hiddenFling
	
	if hiddenFling then
		ToggleBtn.Text = "ON"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 70)
		flingThread = coroutine.create(runFling)
		coroutine.resume(flingThread)
	else
		ToggleBtn.Text = "OFF"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
		hiddenFling = false
	end
end)
