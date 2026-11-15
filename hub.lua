-- ==========================================
-- CHARLESXZZ HUB V1.0 - ULTIMATE EDITION (GITHUB REMOTE SYNC)
-- Tema: La Casa de Papel | Roblox Executores
-- ==========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- WEBHOOK DO DISCORD (Logs de acesso)
local WEBHOOK_URL = "https://discord.com/api/webhooks/1571448384785752135/vtmI6zEs_PXQks-TVUps4SC7GQPNUSelqJC38YD48nYvxkrYWPQh47-c7xf7rlzfXn47"

-- ==========================================
-- SISTEMA DE CRIADOR E VERSÃO
-- ==========================================
local CREATOR_NAME = "Charlesxzz" -- Seu nick exato no Roblox (Acesso livre e eterno)
local CURRENT_HUB_VERSION = "1.0" -- Versão atual rodando neste script

local function isCreator()
	return player.Name == CREATOR_NAME
end

-- 1. CONFIGURAÇÕES E SEGURANÇA DA KEY
local HubConfig = (function()
	local _key = "Charlesxzz157GOAT"
	return {
		ValidateKey = function(enteredKey)
			return enteredKey == _key
		end,
		Theme = {
			PrimaryRed = Color3.fromRGB(219, 48, 34),
			DarkRed = Color3.fromRGB(120, 15, 15),
			Black = Color3.fromRGB(18, 18, 18),
			DarkGray = Color3.fromRGB(28, 28, 28),
			White = Color3.fromRGB(255, 255, 255),
			Gray = Color3.fromRGB(150, 150, 150),
			Green = Color3.fromRGB(46, 204, 113),
			Gold = Color3.fromRGB(241, 196, 15)
		}
	}
end)()

-- Criando a ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CharlesxzzHubGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Música de Fundo da Abertura
local bgMusic = Instance.new("Sound")
bgMusic.SoundId = "rbxassetid://1837840135"
bgMusic.Volume = 0.5
bgMusic.Looped = true
bgMusic.Parent = SoundService
pcall(function() bgMusic:Play() end)

-- Função de áudio SFX
local function playUiSound(soundId, vol)
	pcall(function()
		local sound = Instance.new("Sound")
		sound.SoundId = soundId or "rbxassetid://6032214950"
		sound.Volume = vol or 0.4
		sound.Parent = workspace
		sound:Play()
		task.delay(2, function() sound:Destroy() end)
	end)
end

-- FUNÇÃO DE LOG NO DISCORD
local function sendDiscordNotification(statusType)
	local titleText = statusType == "UPDATE_BLOCK" and "⚠️ **Usuário Bloqueado por Versão Desatualizada**" or "🚨 **Alguém destravou o Charlesxzz Hub!**"
	local embedColor = statusType == "UPDATE_BLOCK" and 16711680 or 14362658

	local data = {
		["content"] = "",
		["embeds"] = {{
			["title"] = titleText,
			["color"] = embedColor,
			["fields"] = {
				{
					["name"] = "👤 Nick do Roblox:",
					["value"] = "```" .. player.Name .. "```",
					["inline"] = true
				},
				{
					["name"] = "🏷️ Display Name:",
					["value"] = "```" .. player.DisplayName .. "```",
					["inline"] = true
				},
				{
					["name"] = "🆔 User ID:",
					["value"] = "```" .. tostring(player.UserId) .. "```",
					["inline"] = true
				},
				{
					["name"] = "👑 É o Criador (Charlesxzz)?",
					["value"] = "```" .. tostring(isCreator()) .. "```",
					["inline"] = true
				},
				{
					["name"] = "🎮 Game ID (PlaceId):",
					["value"] = "```" .. tostring(game.PlaceId) .. "```",
					["inline"] = false
				}
			},
			["footer"] = {
				["text"] = "Charlesxzz Hub Security & GitHub Sync • " .. os.date("%d/%m/%Y - %H:%M:%S")
			}
		}}
	}

	pcall(function()
		local jsonBody = HttpService:JSONEncode(data)
		local httpRequest = (syn and syn.request) or request or (http and http.request) or http_request
		
		if httpRequest then
			httpRequest({
				Url = WEBHOOK_URL,
				Method = "POST",
				Headers = {["Content-Type"] = "application/json"},
				Body = jsonBody
			})
		else
			HttpService:PostAsync(WEBHOOK_URL, jsonBody, Enum.HttpContentType.ApplicationJson)
		end
	end)
end

-- SISTEMA DE NOTIFICAÇÃO TOAST
local function showToast(message, isSuccess)
	playUiSound("rbxassetid://6895057134", 0.4)
	local toast = Instance.new("Frame")
	toast.Size = UDim2.new(0, 310, 0, 50)
	toast.Position = UDim2.new(1, 20, 0.85, 0)
	toast.BackgroundColor3 = HubConfig.Theme.DarkGray
	toast.ZIndex = 50
	toast.Parent = screenGui
	
	local tCorner = Instance.new("UICorner") tCorner.CornerRadius = UDim.new(0, 8) tCorner.Parent = toast
	local tStroke = Instance.new("UIStroke") tStroke.Color = isSuccess and HubConfig.Theme.Green or HubConfig.Theme.PrimaryRed tStroke.Thickness = 2 tStroke.Parent = toast
	
	local tLabel = Instance.new("TextLabel")
	tLabel.Size = UDim2.new(1, -20, 1, 0)
	tLabel.Position = UDim2.new(0, 10, 0, 0)
	tLabel.BackgroundTransparency = 1
	tLabel.Font = Enum.Font.GothamBold
	tLabel.Text = message
	tLabel.TextColor3 = HubConfig.Theme.White
	tLabel.TextSize = 12
	tLabel.TextWrapped = true
	tLabel.TextXAlignment = Enum.TextXAlignment.Left
	tLabel.TextYAlignment = Enum.TextYAlignment.Center
	tLabel.ZIndex = 51
	tLabel.Parent = toast
	
	TweenService:Create(toast, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -330, 0.85, 0)}):Play()
	
	task.delay(2.5, function()
		TweenService:Create(toast, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0.85, 0)}):Play()
		task.wait(0.4)
		toast:Destroy()
	end)
end

-- ==========================================
-- TELA DE ATUALIZAÇÃO OBRIGATÓRIA (BLOQUEIO)
-- ==========================================
local function showUpdateRequiredScreen()
	task.spawn(function() sendDiscordNotification("UPDATE_BLOCK") end)

	local updateFrame = Instance.new("Frame")
	updateFrame.Size = UDim2.new(1, 0, 1, 0)
	updateFrame.BackgroundColor3 = HubConfig.Theme.Black
	updateFrame.BackgroundTransparency = 0.2
	updateFrame.ZIndex = 100
	updateFrame.Parent = screenGui

	local box = Instance.new("Frame")
	box.Size = UDim2.new(0, 440, 0, 280)
	box.AnchorPoint = Vector2.new(0.5, 0.5)
	box.Position = UDim2.new(0.5, 0, 0.5, 0)
	box.BackgroundColor3 = HubConfig.Theme.DarkGray
	box.ZIndex = 101
	box.Parent = updateFrame

	local bCorner = Instance.new("UICorner") bCorner.CornerRadius = UDim.new(0, 12) bCorner.Parent = box
	local bStroke = Instance.new("UIStroke") bStroke.Color = HubConfig.Theme.PrimaryRed bStroke.Thickness = 2 bStroke.Parent = box

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 50)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.Text = "🚨 ATUALIZAÇÃO OBRIGATÓRIA NECESSÁRIA!"
	title.TextColor3 = HubConfig.Theme.White
	title.TextSize = 16
	title.ZIndex = 101
	title.Parent = box

	local msg = Instance.new("TextLabel")
	msg.Size = UDim2.new(1, -40, 0, 110)
	msg.Position = UDim2.new(0, 20, 0, 55)
	msg.BackgroundTransparency = 1
	msg.Font = Enum.Font.Gotham
	msg.Text = "O criador Charlesxzz lançou uma nova versão oficial do Hub!\n\nAs versões antigas foram desativadas por segurança e para evitar bugs nas partidas. Entre no nosso Discord oficial para copiar o novo script atualizado."
	msg.TextColor3 = HubConfig.Theme.Gray
	msg.TextSize = 13
	msg.TextWrapped = true
	msg.TextXAlignment = Enum.TextXAlignment.Center
	msg.TextYAlignment = Enum.TextYAlignment.Top
	msg.ZIndex = 101
	msg.Parent = box

	local discordBtn = Instance.new("TextButton")
	discordBtn.Size = UDim2.new(0, 360, 0, 45)
	discordBtn.Position = UDim2.new(0.5, -180, 0, 185)
	discordBtn.BackgroundColor3 = HubConfig.Theme.PrimaryRed
	discordBtn.Font = Enum.Font.GothamBold
	discordBtn.Text = "COPIAR LINK DO DISCORD 💬"
	discordBtn.TextColor3 = HubConfig.Theme.White
	discordBtn.TextSize = 14
	discordBtn.ZIndex = 101
	discordBtn.Parent = box

	local dCorner = Instance.new("UICorner") dCorner.CornerRadius = UDim.new(0, 8) dCorner.Parent = discordBtn

	discordBtn.MouseButton1Click:Connect(function()
		playUiSound("rbxassetid://6032214950", 0.3)
		setclipboard("https://discord.gg/nWN35mxDK")
		showToast("Link do Discord copiado!", true)
	end)
end

-- ==========================================
-- SISTEMA DE VERIFICAÇÃO REMOTA VIA GITHUB
-- ==========================================
local REMOTE_CONFIG_URL = "https://gist.githubusercontent.com/Charlesxzz-ui/ce10dd4e2cdefd3c8d0c44099c6ce1ec/raw/gistfile1.txt?nocache=" .. tostring(tick())

local function checkRemoteStatus()
	local success, result = pcall(function()
		return HttpService:JSONDecode(game:HttpGet(REMOTE_CONFIG_URL))
	end)
	
	if success and result then
		return result
	else
		-- Segurança caso o GitHub falhe temporariamente
		return { LatestVersion = "1.0", Maintenance = false }
	end
end

local remoteData = checkRemoteStatus()

-- Se não for você (Charlesxzz) e a versão online for diferente da atual, bloqueia!
if not isCreator() and remoteData.LatestVersion ~= CURRENT_HUB_VERSION then
	showUpdateRequiredScreen()
	return
end

-- ==========================================
-- 3. TELA DE KEY (AUTENTICAÇÃO)
-- ==========================================
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(1, 0, 1, 0)
keyFrame.BackgroundColor3 = HubConfig.Theme.Black
keyFrame.BackgroundTransparency = 0.3
keyFrame.Visible = false
keyFrame.ZIndex = 5
keyFrame.Parent = screenGui

local keyBoxContainer = Instance.new("Frame")
keyBoxContainer.Size = UDim2.new(0, 420, 0, 260)
keyBoxContainer.AnchorPoint = Vector2.new(0.5, 0.5)
keyBoxContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
keyBoxContainer.BackgroundColor3 = HubConfig.Theme.DarkGray
keyBoxContainer.ZIndex = 6
keyBoxContainer.Parent = keyFrame

local keyCorner = Instance.new("UICorner") keyCorner.CornerRadius = UDim.new(0, 12) keyCorner.Parent = keyBoxContainer
local keyStroke = Instance.new("UIStroke") keyStroke.Color = HubConfig.Theme.PrimaryRed keyStroke.Thickness = 2 keyStroke.Parent = keyBoxContainer

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, 0, 0, 50)
keyTitle.BackgroundTransparency = 1
keyTitle.Font = Enum.Font.GothamBold
keyTitle.Text = "CHARLESXZZ HUB - AUTH"
keyTitle.TextColor3 = HubConfig.Theme.White
keyTitle.TextSize = 20
keyTitle.ZIndex = 6
keyTitle.Parent = keyBoxContainer

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0, 360, 0, 45)
keyInput.Position = UDim2.new(0.5, -180, 0, 70)
keyInput.BackgroundColor3 = HubConfig.Theme.Black
keyInput.Font = Enum.Font.Gotham
keyInput.PlaceholderText = "Insira sua Key aqui..."
keyInput.PlaceholderColor3 = HubConfig.Theme.Gray
keyInput.Text = ""
keyInput.TextColor3 = HubConfig.Theme.White
keyInput.TextSize = 14
keyInput.ZIndex = 6
keyInput.ClearTextOnFocus = false
keyInput.Parent = keyBoxContainer

local inputCorner = Instance.new("UICorner") inputCorner.CornerRadius = UDim.new(0, 8) inputCorner.Parent = keyInput

local unlockBtn = Instance.new("TextButton")
unlockBtn.Size = UDim2.new(0, 360, 0, 45)
unlockBtn.Position = UDim2.new(0.5, -180, 0, 135)
unlockBtn.BackgroundColor3 = HubConfig.Theme.PrimaryRed
unlockBtn.Font = Enum.Font.GothamBold
unlockBtn.Text = "UNLOCK HUB"
unlockBtn.TextColor3 = HubConfig.Theme.White
unlockBtn.TextSize = 15
unlockBtn.ZIndex = 6
unlockBtn.Parent = keyBoxContainer

local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(0, 8) btnCorner.Parent = unlockBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 190)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = ""
statusLabel.TextColor3 = HubConfig.Theme.PrimaryRed
statusLabel.TextSize = 13
statusLabel.ZIndex = 6
statusLabel.Parent = keyBoxContainer

-- ==========================================
-- 2. TELA DE INTRODUÇÃO
-- ==========================================
local introFrame = Instance.new("Frame")
introFrame.Size = UDim2.new(1, 0, 1, 0)
introFrame.BackgroundColor3 = HubConfig.Theme.Black
introFrame.BackgroundTransparency = 1
introFrame.ZIndex = 20
introFrame.Parent = screenGui

local introGradient = Instance.new("UIGradient")
introGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, HubConfig.Theme.Black),
	ColorSequenceKeypoint.new(1, HubConfig.Theme.DarkRed)
})
introGradient.Rotation = 45
introGradient.Parent = introFrame

local introBox = Instance.new("Frame")
introBox.Size = UDim2.new(0, 520, 0, 420)
introBox.AnchorPoint = Vector2.new(0.5, 0.5)
introBox.Position = UDim2.new(0.5, 0, 0.5, 0)
introBox.BackgroundColor3 = HubConfig.Theme.DarkGray
introBox.BackgroundTransparency = 1
introBox.ZIndex = 21
introBox.Parent = introFrame

local introBoxCorner = Instance.new("UICorner") introBoxCorner.CornerRadius = UDim.new(0, 12) introBoxCorner.Parent = introBox
local introBoxStroke = Instance.new("UIStroke") introBoxStroke.Color = HubConfig.Theme.PrimaryRed introBoxStroke.Thickness = 2 introBoxStroke.Transparency = 1 introBoxStroke.Parent = introBox

local introTitle = Instance.new("TextLabel")
introTitle.Size = UDim2.new(1, -20, 0, 50)
introTitle.Position = UDim2.new(0, 10, 0, 15)
introTitle.BackgroundTransparency = 1
introTitle.Font = Enum.Font.GothamBold
introTitle.Text = "CHARLESXZZ HUB - BEM VINDO 🇧🇷"
introTitle.TextColor3 = HubConfig.Theme.White
introTitle.TextSize = 18
introTitle.TextTransparency = 1
introTitle.ZIndex = 21
introTitle.Parent = introBox

local introScroll = Instance.new("ScrollingFrame")
introScroll.Size = UDim2.new(1, -20, 1, -150)
introScroll.Position = UDim2.new(0, 10, 0, 70)
introScroll.BackgroundTransparency = 1
introScroll.BorderSizePixel = 0
introScroll.CanvasSize = UDim2.new(0, 0, 0, 260)
introScroll.ScrollBarThickness = 3
introScroll.ZIndex = 21
introScroll.Parent = introBox

local creatorLabel = Instance.new("TextLabel")
creatorLabel.Size = UDim2.new(1, 0, 0, 160)
creatorLabel.BackgroundTransparency = 1
creatorLabel.Font = Enum.Font.Gotham
creatorLabel.Text = "Palavras do Criador 📢:\n\nPronto para ser um dos mais xitados do RP? Com esse script vc vai poder virar craque da CBBM/CBB ou de qualquer outra FIFA rapidinho, além de que se vc quiser da pra disfarçar usando os scripts mais básicos para poder obter vantagens acima de qualquer Mobile/PC/Console! Ta esperando oque? COLOQUE A KEY 🔑 E SEJA O REAL GOAT!!!"
creatorLabel.TextColor3 = HubConfig.Theme.Gray
creatorLabel.TextSize = 13
creatorLabel.TextWrapped = true
creatorLabel.TextXAlignment = Enum.TextXAlignment.Left
creatorLabel.TextYAlignment = Enum.TextYAlignment.Top
creatorLabel.TextTransparency = 1
creatorLabel.ZIndex = 21
creatorLabel.Parent = introScroll

local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(1, 0, 0, 70)
discordLabel.Position = UDim2.new(0, 0, 0, 170)
discordLabel.BackgroundTransparency = 1
discordLabel.Font = Enum.Font.GothamBold
discordLabel.Text = "ENTRE NO NOSSO DISCORD ABAIXO:\nhttps://discord.gg/nWN35mxDK"
discordLabel.TextColor3 = HubConfig.Theme.PrimaryRed
discordLabel.TextSize = 13
discordLabel.TextWrapped = true
discordLabel.TextXAlignment = Enum.TextXAlignment.Left
discordLabel.TextYAlignment = Enum.TextYAlignment.Top
discordLabel.TextTransparency = 1
discordLabel.ZIndex = 21
discordLabel.Parent = introScroll

local skipBtn = Instance.new("TextButton")
skipBtn.Size = UDim2.new(0, 230, 0, 42)
skipBtn.AnchorPoint = Vector2.new(0.5, 1)
skipBtn.Position = UDim2.new(0.5, 0, 1, -15)
skipBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
skipBtn.Font = Enum.Font.GothamBold
skipBtn.Text = "CLIQUE PARA INICIAR"
skipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
skipBtn.TextSize = 14
skipBtn.TextTransparency = 1
skipBtn.BackgroundTransparency = 1
skipBtn.ZIndex = 22
skipBtn.Parent = introBox

local skipCorner = Instance.new("UICorner") skipCorner.CornerRadius = UDim.new(0, 8) skipCorner.Parent = skipBtn
local skipStroke = Instance.new("UIStroke") skipStroke.Color = Color3.fromRGB(255, 255, 255) skipStroke.Thickness = 3 skipStroke.Transparency = 1 skipStroke.Parent = skipBtn

local skipGradient = Instance.new("UIGradient")
skipGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
	ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 0)),
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 0)),
	ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
})
skipGradient.Parent = skipStroke

local introActive = true
local function closeIntro()
	if not introActive then return end
	introActive = false
	playUiSound("rbxassetid://4590657391", 0.5)
	
	TweenService:Create(introFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
	TweenService:Create(introBox, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
	TweenService:Create(introBoxStroke, TweenInfo.new(0.8), {Transparency = 1}):Play()
	TweenService:Create(introTitle, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
	TweenService:Create(creatorLabel, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
	TweenService:Create(discordLabel, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
	TweenService:Create(skipBtn, TweenInfo.new(0.8), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
	TweenService:Create(skipStroke, TweenInfo.new(0.8), {Transparency = 1}):Play()
	
	task.wait(0.8)
	introFrame:Destroy()
	keyFrame.Visible = true
end

skipBtn.MouseButton1Click:Connect(closeIntro)

task.spawn(function()
	local rot = 0
	while introActive do
		rot = (rot + 3) % 360
		skipGradient.Rotation = rot
		RunService.RenderStepped:Wait()
	end
end)

task.spawn(function()
	playUiSound("rbxassetid://6032214950", 0.4)
	TweenService:Create(introFrame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.1}):Play()
	TweenService:Create(introBox, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.1}):Play()
	TweenService:Create(introBoxStroke, TweenInfo.new(1), {Transparency = 0}):Play()
	TweenService:Create(introTitle, TweenInfo.new(1), {TextTransparency = 0}):Play()
	TweenService:Create(creatorLabel, TweenInfo.new(1), {TextTransparency = 0}):Play()
	TweenService:Create(discordLabel, TweenInfo.new(1), {TextTransparency = 0}):Play()
	TweenService:Create(skipBtn, TweenInfo.new(1), {TextTransparency = 0, BackgroundTransparency = 0}):Play()
	TweenService:Create(skipStroke, TweenInfo.new(1), {Transparency = 0}):Play()
	
	local elapsed = 0
	while elapsed < 15 and introActive do
		task.wait(0.5)
		elapsed = elapsed + 0.5
	end
	closeIntro()
end)

-- ==========================================
-- 4. BOTÃO FLUTUANTE CIRCULAR
-- ==========================================
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 60, 0, 60)
floatBtn.Position = UDim2.new(0, 30, 0, 200)
floatBtn.BackgroundColor3 = HubConfig.Theme.PrimaryRed
floatBtn.Text = "🎭"
floatBtn.TextSize = 28
floatBtn.Visible = false
floatBtn.ZIndex = 10
floatBtn.Parent = screenGui

local floatCorner = Instance.new("UICorner") floatCorner.CornerRadius = UDim.new(1, 0) floatCorner.Parent = floatBtn
local floatStroke = Instance.new("UIStroke") floatStroke.Color = HubConfig.Theme.White floatStroke.Thickness = 2 floatStroke.Parent = floatBtn

local dragging, dragStart, startPos
floatBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = floatBtn.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		floatBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- ==========================================
-- 5. PAINEL PRINCIPAL COM HUD E INTERATIVIDADE
-- ==========================================
local mainPanel = Instance.new("Frame")
mainPanel.Size = UDim2.new(0, 670, 0, 420)
mainPanel.AnchorPoint = Vector2.new(0.5, 0.5)
mainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
mainPanel.BackgroundColor3 = HubConfig.Theme.Black
mainPanel.Visible = false
mainPanel.ZIndex = 8
mainPanel.Parent = screenGui

local panelCorner = Instance.new("UICorner") panelCorner.CornerRadius = UDim.new(0, 10) panelCorner.Parent = mainPanel
local panelStroke = Instance.new("UIStroke") panelStroke.Color = HubConfig.Theme.PrimaryRed panelStroke.Thickness = 2 panelStroke.Parent = mainPanel

-- Cabeçalho
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = HubConfig.Theme.DarkRed
header.ZIndex = 9
header.Parent = mainPanel

local headerCorner = Instance.new("UICorner") headerCorner.CornerRadius = UDim.new(0, 10) headerCorner.Parent = header

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(1, -260, 1, 0)
headerTitle.Position = UDim2.new(0, 15, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Font = Enum.Font.GothamBold
headerTitle.Text = "CHARLESXZZ HUB"
headerTitle.TextColor3 = HubConfig.Theme.White
headerTitle.TextSize = 16
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.ZIndex = 9
headerTitle.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.TextColor3 = HubConfig.Theme.White
closeBtn.TextSize = 16
closeBtn.ZIndex = 9
closeBtn.Parent = header

closeBtn.MouseButton1Click:Connect(function()
	mainPanel.Visible = false
end)

-- Barra de Pesquisa
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0, 200, 0, 30)
searchBox.Position = UDim2.new(1, -250, 0, 7)
searchBox.BackgroundColor3 = HubConfig.Theme.Black
searchBox.Font = Enum.Font.Gotham
searchBox.PlaceholderText = "🔍 Pesquisar script..."
searchBox.PlaceholderColor3 = HubConfig.Theme.Gray
searchBox.Text = ""
searchBox.TextColor3 = HubConfig.Theme.White
searchBox.TextSize = 12
searchBox.ZIndex = 10
searchBox.Parent = header

local searchCorner = Instance.new("UICorner") searchCorner.CornerRadius = UDim.new(0, 6) searchCorner.Parent = searchBox
local searchStroke = Instance.new("UIStroke") searchStroke.Color = HubConfig.Theme.PrimaryRed searchStroke.Thickness = 1 searchStroke.Parent = searchBox

-- Rodapé HUD (FPS, Ping, Horário)
local hudFooter = Instance.new("Frame")
hudFooter.Size = UDim2.new(1, -175, 0, 25)
hudFooter.Position = UDim2.new(0, 170, 1, -28)
hudFooter.BackgroundTransparency = 1
hudFooter.ZIndex = 10
hudFooter.Parent = mainPanel

local hudLabel = Instance.new("TextLabel")
hudLabel.Size = UDim2.new(1, -10, 1, 0)
hudLabel.Position = UDim2.new(0, 10, 0, 0)
hudLabel.BackgroundTransparency = 1
hudLabel.Font = Enum.Font.GothamBold
hudLabel.Text = "FPS: 60 | PING: 0ms | 00:00:00"
hudLabel.TextColor3 = HubConfig.Theme.Gray
hudLabel.TextSize = 11
hudLabel.TextXAlignment = Enum.TextXAlignment.Left
hudLabel.ZIndex = 10
hudLabel.Parent = hudFooter

-- Atualizador do HUD em tempo real
local lastFrames = 0
local lastUpdate = tick()
local currentFps = 60
RunService.RenderStepped:Connect(function(dt)
	lastFrames = lastFrames + 1
	if tick() - lastUpdate >= 1 then
		currentFps = lastFrames
		lastFrames = 0
		lastUpdate = tick()
	end
	pcall(function()
		local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		local timeStr = os.date("%H:%M:%S")
		hudLabel.Text = string.format("FPS: %d | PING: %dms | %s", currentFps, ping, timeStr)
	end)
end)

-- Sidebar e Abas
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 165, 1, -75)
sidebar.Position = UDim2.new(0, 0, 0, 45)
sidebar.BackgroundColor3 = HubConfig.Theme.DarkGray
sidebar.ZIndex = 9
sidebar.Parent = mainPanel

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -180, 1, -85)
contentArea.Position = UDim2.new(0, 175, 0, 55)
contentArea.BackgroundTransparency = 1
contentArea.ZIndex = 9
contentArea.Parent = mainPanel

-- Tooltip Dinâmico ao passar o mouse
local tooltip = Instance.new("TextLabel")
tooltip.Size = UDim2.new(0, 200, 0, 30)
tooltip.BackgroundColor3 = HubConfig.Theme.DarkGray
tooltip.TextColor3 = HubConfig.Theme.White
tooltip.Font = Enum.Font.Gotham
tooltip.TextSize = 11
tooltip.Visible = false
tooltip.ZIndex = 100
tooltip.Parent = screenGui
local tTipCorner = Instance.new("UICorner") tTipCorner.CornerRadius = UDim.new(0, 6) tTipCorner.Parent = tooltip
local tTipStroke = Instance.new("UIStroke") tTipStroke.Color = HubConfig.Theme.PrimaryRed tTipStroke.Parent = tooltip

-- Banco de Dados de Scripts Completo
local scriptsDatabase = {
	{Category = "AVISOS E ATUALIZAÇÕES ❗", Name = "📢 BEM-VINDO ÀS ATUALIZAÇÕES DIÁRIAS!", Url = "https://pastebin.com/raw/MCTcaHZq", Badge = "🔥 NOVO", Desc = "Fique de olho aqui para ver todas as novidades diárias do Hub!"},

	{Category = "SCRIPTS ALTERNATIVOS 👾", Name = "1. FLY - VOAR ✈️", Url = "https://raw.githubusercontent.com/lol-nashedi/VAELOR-FLY-UI/main/V%C3%86LOR%20FLY%20UI", Badge = "🔥 NOVO", Desc = "Permite voar livremente pelo mapa com controle total."},
	
	-- ANT PULOS 🚷
	{Category = "ANT PULOS 🚷", Name = "1. IPHONE HUB 📱", Url = "https://pastebin.com/raw/6tEX6gj8", Desc = "Anti pulo via iPhone Hub."},
	{Category = "ANT PULOS 🚷", Name = "2. LOUIS HUB", Url = "https://pastebin.com/raw/Wi0eecQv", Desc = "Anti pulo do Louis Hub."},
	{Category = "ANT PULOS 🚷", Name = "3. ANT PULO LC PJL", Url = "https://pastebin.com/raw/MCTcaHZq", Desc = "Anti pulo LC PJL."},
	{Category = "ANT PULOS 🚷", Name = "4. ELIAS ANT PULO", Url = "https://pastebin.com/raw/mgzrnsbr", Desc = "Anti pulo desenvolvido por Elias."},
	{Category = "ANT PULOS 🚷", Name = "5. ANT PULO LOVED FILHO", Url = "https://raw.githubusercontent.com/774404/V56f-/refs/heads/main/Script%20ofc", Desc = "Anti pulo Loved Filho."},
	{Category = "ANT PULOS 🚷", Name = "6. ANT PULO ZYCK", Url = "https://pastebin.com/raw/MCTcaHZq", Desc = "Anti pulo Zyck."},
	{Category = "ANT PULOS 🚷", Name = "7. ANT PULO MORETI", Url = "https://pastebin.com/raw/MCTcaHZq", Desc = "Anti pulo e otimizador Moreti."},
	{Category = "ANT PULOS 🚷", Name = "8. JAY HUB ANT PULO", Url = "https://pastebin.com/raw/1MmUWYnP", Desc = "Anti pulo Jay Hub."},
	{Category = "ANT PULOS 🚷", Name = "9. CHARLESXZZ ANT PULO ESPECIAL 🚫", Url = "https://pastefy.app/sIhEJFAz/raw", Badge = "👑 VIP", Desc = "Anti pulo especial oficial do Charlesxzz."},
	{Category = "ANT PULOS 🚷", Name = "10. ANT LUKE JR ⭐", Url = "https://pastefy.app/d0yvvV78/raw", Badge = "🔥 NOVO", Desc = "Anti pulo Luke Jr."},

	-- ANT PEDRA 🪨
	{Category = "ANT PEDRA 🪨", Name = "1. ANT BALL PEDRA ATRAVESSADORA 🛡️", Url = "https://pastebin.com/raw/Z7eZDEj8", Desc = "Anti pedra travessadora para bola."},
	{Category = "ANT PEDRA 🪨", Name = "2. ANT PEDRA EFICIENTE 🧱", Url = "https://pastefy.app/59dDHHfr/raw", Desc = "Anti pedra eficiente e rápido."},
	{Category = "ANT PEDRA 🪨", Name = "3. ANT PEDRA DO CHARLESXZZ 👑", Url = "https://pastefy.app/shBZ8LTN/raw", Badge = "👑 VIP", Desc = "Anti pedra exclusivo do Charlesxzz."},

	{Category = "OTIMIZAÇÕES 🚀", Name = "1. MASTER HUB 🔥", Url = "https://pastefy.app/dbhX7SOA/raw", Badge = "👑 VIP", Desc = "Painel completo de otimização e melhoria de desempenho."},
	{Category = "OTIMIZAÇÕES 🚀", Name = "2. ANT LAG 🧟‍♀️", Url = "https://pastebin.com/raw/kbHL8MZ5", Desc = "Remove efeitos pesados para travar menos."},
	{Category = "OTIMIZAÇÕES 🚀", Name = "3. FPS BOOST PHAMTOM ♾️", Url = "https://rawscripts.net/raw/Universal-Script-PHANTOM-FPS-BOOSTER-136220", Desc = "Aumenta consideravelmente a taxa de quadros por segundo."},
	{Category = "OTIMIZAÇÕES 🚀", Name = "4. ANT LAG MAX POTATO 🥔", Url = "https://raw.githubusercontent.com/ashmehra852-lab/AshishAntiLag.Luaa/refs/heads/main/AshishAntialag.LUA", Desc = "Modo batata máximo para dispositivos fracos."},
	{Category = "OTIMIZAÇÕES 🚀", Name = "5. SILVAXX HUB ⚽", Url = "https://pastefy.app/SgBX3S6J/raw", Desc = "Otimizador focado em ligas e campeonatos."},
	{Category = "OTIMIZAÇÕES 🚀", Name = "6. ANGOLANO OTIMIZAÇÃO 🇦🇴", Url = "https://pastebin.com/raw/T6kRs3Fw", Desc = "Script leve para redução de travamentos."},
	{Category = "OTIMIZAÇÕES 🚀", Name = "7. ASTRO OTIMIZAÇÃO 🥷", Url = "https://pastebin.com/raw/MVUsQvub", Desc = "Boost geral de estabilidade de rede e FPS."},
	{Category = "OTIMIZAÇÕES 🚀", Name = "8. MEGA OTIMIZAÇÃO BROOKHAVEN 🏡", Url = "https://pastebin.com/raw/GzrqQWkx", Desc = "Otimizado especialmente para mapas de RP."},
	{Category = "OTIMIZAÇÕES 🚀", Name = "9. JSHZZ OTIMIZAÇÃO ( OFC CBB ) 👑", Url = "https://raw.githubusercontent.com/JoshzzAlteregooo/JoshzzFpsBoosterVersion3/refs/heads/main/JoshzzNewFpsBooster", Badge = "🔥 NOVO", Desc = "Fps booster oficial da comunidade CBB."},
	{Category = "OTIMIZAÇÕES 🚀", Name = "10. EXIT LAG MELHORADO ⚽", Url = "https://pastefy.app/KEfkfhsr/raw", Desc = "Reduz a latência aparente em partidas."},

	{Category = "PROIBIDOS 🚫", Name = "1. ATRAVESSAR SUPREMO MAX 🥷", Url = "https://pastebin.com/raw/zrDj5DSA", Desc = "Permite ultrapassar paredes e barreiras."},
	{Category = "PROIBIDOS 🚫", Name = "2. ATRAVESSAR DO JVZ 🥵", Url = "https://pastefy.app/cKpzcuHw/raw", Desc = "Noclip alternativo de alta precisão."},
	{Category = "PROIBIDOS 🚫", Name = "3. PAINEL GK MURALHA 🧤", Url = "https://pastebin.com/raw/KmNHLYsb", Badge = "👑 VIP", Desc = "Auxílio avançado para goleiros em campeonatos."},
	{Category = "PROIBIDOS 🚫", Name = "4. SCRIPT DO PIU V5 🔥", Url = "https://pastefy.app/ZTjSqELh/raw", Desc = "Ferramenta multiuso de alta vantagem."},
	{Category = "PROIBIDOS 🚫", Name = "5. SFORZA HUB 🇧🇷", Url = "https://pastebin.com/raw/pdyfSjzK", Desc = "Painel competitivo versátil."},
	{Category = "PROIBIDOS 🚫", Name = "6. CAGA NA ROUPA HUB 💩", Url = "https://pastefy.app/eKFExNPG/raw", Desc = "Funções diversas de trapaça e diversão."},
	{Category = "PROIBIDOS 🚫", Name = "7. ARMANDO JR HUB 🖥️", Url = "https://raw.githubusercontent.com/carlosedut11/ArmadinhoJrPorCantonaJr/refs/heads/main/ArmadinhoJrPorCantonaJr.lua", Desc = "Painel de recursos avançados para PC/Mobile."},
	{Category = "PROIBIDOS 🚫", Name = "8. REACH DO FOLDEN 🥷", Url = "https://pastefy.app/F8vi6l45/raw", Desc = "Aumenta o alcance de interação."},
	{Category = "PROIBIDOS 🚫", Name = "9. REACH MORALES 👟", Url = "https://pastebin.com/raw/ckJb1cXM", Desc = "Alcance estendido para partidas."},
	{Category = "PROIBIDOS 🚫", Name = "10. TIZIL HUB 🧨 - KEY: TIZILCV", Url = "https://pastefy.app/qAI4jFAP/raw", Desc = "Painel com chave integrada (TIZILCV)."}
}

local tabsList = {
	"AVISOS E ATUALIZAÇÕES ❗",
	"⭐ FAVORITOS",
	"SCRIPTS ALTERNATIVOS 👾",
	"ANT PULOS 🚷",
	"ANT PEDRA 🪨",
	"PROIBIDOS 🚫",
	"OTIMIZAÇÕES 🚀"
}

local contentFrames = {}
local favoriteItems = {}
local activeTabName = tabsList[1]
local sidebarButtons = {}

local function getCategoryCount(catName)
	if catName == "⭐ FAVORITOS" then
		return #favoriteItems
	end
	local count = 0
	for _, s in ipairs(scriptsDatabase) do
		if s.Category == catName then count = count + 1 end
	end
	return count
end

local function updateSidebarCounts()
	for tName, btn in pairs(sidebarButtons) do
		local count = getCategoryCount(tName)
		btn.Text = tName .. (" ("..count..")")
	end
end

for i, tabName in ipairs(tabsList) do
	local count = getCategoryCount(tabName)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, -16, 0, 35)
	tabBtn.Position = UDim2.new(0, 8, 0, 8 + (i - 1) * 40)
	tabBtn.BackgroundColor3 = (i == 1) and HubConfig.Theme.PrimaryRed or HubConfig.Theme.Black
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.Text = tabName .. (" ("..count..")")
	tabBtn.TextColor3 = HubConfig.Theme.White
	tabBtn.TextSize = 8
	tabBtn.TextWrapped = true
	tabBtn.ZIndex = 9
	tabBtn.Parent = sidebar
	
	sidebarButtons[tabName] = tabBtn
	
	local tabCorner = Instance.new("UICorner") tabCorner.CornerRadius = UDim.new(0, 6) tabCorner.Parent = tabBtn
	
	local activeIndicator = Instance.new("Frame")
	activeIndicator.Size = UDim2.new(0, 4, 1, -10)
	activeIndicator.Position = UDim2.new(0, 0, 0, 5)
	activeIndicator.BackgroundColor3 = HubConfig.Theme.White
	activeIndicator.BackgroundTransparency = (i == 1) and 0 or 1
	activeIndicator.ZIndex = 10
	activeIndicator.Parent = tabBtn
	
	local indCorner = Instance.new("UICorner") indCorner.CornerRadius = UDim.new(1, 0) indCorner.Parent = activeIndicator
	
	local cFrame = Instance.new("ScrollingFrame")
	cFrame.Size = UDim2.new(1, 0, 1, 0)
	cFrame.BackgroundTransparency = 1
	cFrame.Visible = (i == 1)
	cFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
	cFrame.ScrollBarThickness = 4
	cFrame.ZIndex = 9
	cFrame.Parent = contentArea
	contentFrames[tabName] = cFrame
	
	local watermark = Instance.new("TextLabel")
	watermark.Size = UDim2.new(1, 0, 1, 0)
	watermark.BackgroundTransparency = 1
	watermark.Font = Enum.Font.GothamBold
	watermark.Text = "🎭"
	watermark.TextTransparency = 0.96
	watermark.TextColor3 = HubConfig.Theme.PrimaryRed
	watermark.TextSize = 130
	watermark.ZIndex = 8
	watermark.Parent = cFrame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 40)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = "Painel " .. tabName .. " - Charlesxzz Hub"
	label.TextColor3 = HubConfig.Theme.White
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 9
	label.Parent = cFrame
end

local function renderScripts(targetTabName, scriptsArray)
	local cFrame = contentFrames[targetTabName]
	if not cFrame then return end
	
	for _, child in ipairs(cFrame:GetChildren()) do
		if child.Name == "ScriptRow" then child:Destroy() end
	end
	
	for idx, scriptInfo in ipairs(scriptsArray) do
		local scriptRow = Instance.new("Frame")
		scriptRow.Name = "ScriptRow"
		scriptRow.Size = UDim2.new(1, -10, 0, 45)
		scriptRow.Position = UDim2.new(0, 0, 0, 45 + (idx - 1) * 52)
		scriptRow.BackgroundColor3 = HubConfig.Theme.DarkGray
		scriptRow.ZIndex = 9
		scriptRow.Parent = cFrame
		
		local rowCorner = Instance.new("UICorner") rowCorner.CornerRadius = UDim.new(0, 6) rowCorner.Parent = scriptRow
		
		scriptRow.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				TweenService:Create(scriptRow, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(38, 38, 38)}):Play()
				if scriptInfo.Desc then
					tooltip.Text = " " .. scriptInfo.Desc .. " "
					tooltip.Size = UDim2.new(0, scriptInfo.Desc:len() * 6 + 20, 0, 26)
					tooltip.Visible = true
				end
			end
		end)
		scriptRow.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				tooltip.Position = UDim2.new(0, input.Position.X + 15, 0, input.Position.Y - 25)
			end
		end)
		scriptRow.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				TweenService:Create(scriptRow, TweenInfo.new(0.2), {BackgroundColor3 = HubConfig.Theme.DarkGray}):Play()
				tooltip.Visible = false
			end
		end)
		
		local scriptNameLabel = Instance.new("TextLabel")
		scriptNameLabel.Size = UDim2.new(1, -170, 1, 0)
		scriptNameLabel.Position = UDim2.new(0, 12, 0, 0)
		scriptNameLabel.BackgroundTransparency = 1
		scriptNameLabel.Font = Enum.Font.GothamBold
		scriptNameLabel.Text = scriptInfo.Name
		scriptNameLabel.TextColor3 = HubConfig.Theme.White
		scriptNameLabel.TextSize = 12
		scriptNameLabel.TextXAlignment = Enum.TextXAlignment.Left
		scriptNameLabel.ZIndex = 9
		scriptNameLabel.Parent = scriptRow
		
		local favBtn = Instance.new("TextButton")
		favBtn.Size = UDim2.new(0, 30, 0, 30)
		favBtn.AnchorPoint = Vector2.new(1, 0.5)
		favBtn.Position = UDim2.new(1, -60, 0.5, 0)
		favBtn.BackgroundColor3 = HubConfig.Theme.Black
		favBtn.Font = Enum.Font.GothamBold
		favBtn.Text = table.find(favoriteItems, scriptInfo) and "⭐" or "☆"
		favBtn.TextColor3 = HubConfig.Theme.Gold
		favBtn.TextSize = 14
		favBtn.ZIndex = 9
		favBtn.Parent = scriptRow
		local favCorner = Instance.new("UICorner") favCorner.CornerRadius = UDim.new(0, 6) favCorner.Parent = favBtn
		
		favBtn.MouseButton1Click:Connect(function()
			playUiSound("rbxassetid://6032214950", 0.3)
			local pos = table.find(favoriteItems, scriptInfo)
			if pos then
				table.remove(favoriteItems, pos)
				favBtn.Text = "☆"
				showToast("Removido dos favoritos", false)
			else
				table.insert(favoriteItems, scriptInfo)
				favBtn.Text = "⭐"
				showToast("Adicionado aos favoritos!", true)
			end
			renderScripts("⭐ FAVORITOS", favoriteItems)
			updateSidebarCounts()
		end)
		
		if scriptInfo.Badge then
			local badgeLabel = Instance.new("TextLabel")
			badgeLabel.Size = UDim2.new(0, 55, 0, 20)
			badgeLabel.Position = UDim2.new(1, -185, 0.5, -10)
			badgeLabel.BackgroundColor3 = HubConfig.Theme.DarkRed
			badgeLabel.Font = Enum.Font.GothamBold
			badgeLabel.Text = scriptInfo.Badge
			badgeLabel.TextColor3 = HubConfig.Theme.White
			badgeLabel.TextSize = 9
			badgeLabel.ZIndex = 9
			badgeLabel.Parent = scriptRow
			local bCorner = Instance.new("UICorner") bCorner.CornerRadius = UDim.new(0, 4) bCorner.Parent = badgeLabel
		end
		
		local playBtn = Instance.new("TextButton")
		playBtn.Size = UDim2.new(0, 40, 0, 30)
		playBtn.AnchorPoint = Vector2.new(1, 0.5)
		playBtn.Position = UDim2.new(1, -8, 0.5, 0)
		playBtn.BackgroundColor3 = HubConfig.Theme.PrimaryRed
		playBtn.Font = Enum.Font.GothamBold
		playBtn.Text = "▶"
		playBtn.TextColor3 = HubConfig.Theme.White
		playBtn.TextSize = 14
		playBtn.ZIndex = 9
		playBtn.Parent = scriptRow
		local playCorner = Instance.new("UICorner") playCorner.CornerRadius = UDim.new(0, 6) playCorner.Parent = playBtn
		
		playBtn.MouseButton1Click:Connect(function()
			playUiSound("rbxassetid://6032214950", 0.4)
			showToast("Executando: " .. scriptInfo.Name, true)
			pcall(function() loadstring(game:HttpGet(scriptInfo.Url))() end)
		end)
	end
	cFrame.CanvasSize = UDim2.new(0, 0, 0, 50 + (#scriptsArray * 52) + 20)
end

for _, tabName in ipairs(tabsList) do
	if tabName ~= "⭐ FAVORITOS" then
		local catScripts = {}
		for _, s in ipairs(scriptsDatabase) do
			if s.Category == tabName then table.insert(catScripts, s) end
		end
		renderScripts(tabName, catScripts)
	end
end

local function filterScripts()
	local query = string.lower(searchBox.Text)
	local currentFrame = contentFrames[activeTabName]
	if not currentFrame then return end
	
	local visibleIndex = 0
	for _, child in ipairs(currentFrame:GetChildren()) do
		if child:IsA("Frame") and child.Name == "ScriptRow" then
			local nameLbl = child:FindFirstChildOfClass("TextLabel")
			if nameLbl then
				local matches = (query == "" or string.find(string.lower(nameLbl.Text), query))
				if matches then
					child.Visible = true
					child.Position = UDim2.new(0, 0, 0, 45 + (visibleIndex * 52))
					visibleIndex = visibleIndex + 1
				else
					child.Visible = false
				end
			end
		end
	end
	currentFrame.CanvasSize = UDim2.new(0, 0, 0, 50 + (visibleIndex * 52) + 20)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(filterScripts)

for i, tabName in ipairs(tabsList) do
	local tabBtn = sidebar:GetChildren()[i]
	if tabBtn and tabBtn:IsA("TextButton") then
		tabBtn.MouseButton1Click:Connect(function()
			playUiSound("rbxassetid://6032214950", 0.3)
			activeTabName = tabName
			searchBox.Text = ""
			
			if tabName == "⭐ FAVORITOS" then
				renderScripts("⭐ FAVORITOS", favoriteItems)
			end
			
			for name, frame in pairs(contentFrames) do
				frame.Visible = (name == tabName)
			end
			for _, child in ipairs(sidebar:GetChildren()) do
				if child:IsA("TextButton") then
					child.BackgroundColor3 = (child.Text:find(tabName)) and HubConfig.Theme.PrimaryRed or HubConfig.Theme.Black
					local indicator = child:FindFirstChildOfClass("Frame")
					if indicator then
						indicator.BackgroundTransparency = (child.Text:find(tabName)) and 0 or 1
					end
				end
			end
		end)
	end
end

unlockBtn.MouseButton1Click:Connect(function()
	playUiSound("rbxassetid://6032214950", 0.3)
	local keyEntered = keyInput.Text
	statusLabel.Text = "Verificando..."
	
	if HubConfig.ValidateKey(keyEntered) then
		statusLabel.TextColor3 = HubConfig.Theme.Green
		statusLabel.Text = "Acesso autorizado!"
		showToast("Bem-vindo ao Charlesxzz Hub!", true)
		
		task.spawn(function() sendDiscordNotification("SUCCESS_LOGIN") end)
		
		pcall(function()
			bgMusic:Stop()
			bgMusic:Destroy()
		end)
		
		task.wait(1)
		keyFrame.Visible = false
		floatBtn.Visible = true
		mainPanel.Visible = true
	else
		statusLabel.TextColor3 = HubConfig.Theme.PrimaryRed
		statusLabel.Text = "Key incorreta! Tente novamente."
		showToast("Key incorreta!", false)
	end
end)

local panelOpen = true
floatBtn.MouseButton1Click:Connect(function()
	panelOpen = not panelOpen
	mainPanel.Visible = panelOpen
	playUiSound("rbxassetid://6032214950", 0.3)
end)
