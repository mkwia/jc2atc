class 'WarpGui'

function WarpGui:__init()
	-- Variables
	self.textColor = Color(200, 50, 200)
	self.admins = {}
	self.rows = {}
	self.acceptButtons = {}
	self.whitelistButtons = {}
	self.whitelist = {}
	self.whitelistAll = false
	self.warpRequests = {}
	self.windowShown = false
	
	-- Admins
	self:AddAdmin("STEAM_0:0:58744266")
	
	-- Create GUI
	self.window = Window.Create()
	self.window:SetVisible(self.windowShown)
	self.window:SetTitle("Warp GUI")
	self.window:SetSizeRel(Vector2(0.4, 0.7))
	self.window:SetMinimumSize(Vector2(400, 200))
	self.window:SetPositionRel( Vector2(0.75, 0.5) - self.window:GetSizeRel()/2)
    self.window:Subscribe("WindowClosed", self, function (args) self:SetWindowVisible(false) end)
	
	-- Tabs
	local tabControl = TabControl.Create(self.window)
	tabControl:SetDock(GwenPosition.Fill)
	tabControl:SetSizeRel(Vector2(0.98, 1))
	
	-- Pages
	local playersPage = tabControl:AddPage("Players"):GetPage()
	--local warpsPage = tabControl:AddPage("Warps"):GetPage()
	
	-- Player list
	self.playerList = SortedList.Create(playersPage)
	self.playerList:SetDock(GwenPosition.Fill)
	self.playerList:SetMargin(Vector2(0, 0), Vector2(0, 4))
	self.playerList:AddColumn("Name")
	self.playerList:AddColumn("Warp To", 90)
	self.playerList:AddColumn("Accept Warp", 90)
	self.playerList:AddColumn("Whitelist", 90)
	self.playerList:SetButtonsVisible(true)
	
	-- Player search box
	self.filter = TextBox.Create(playersPage)
	self.filter:SetDock(GwenPosition.Bottom)
	self.filter:SetSize(Vector2(self.window:GetSize().x, 32))
	self.filter:Subscribe("TextChanged", self, self.TextChanged)
	
	-- Whitelist all
	local whitelistAllCheckbox = LabeledCheckBox.Create(playersPage)
    whitelistAllCheckbox:SetSize(Vector2(300, 20))
    whitelistAllCheckbox:SetDock(GwenPosition.Top)
    whitelistAllCheckbox:GetLabel():SetText("Whitelist all")
    whitelistAllCheckbox:GetCheckBox():Subscribe("CheckChanged",
		function() self.whitelistAll = whitelistAllCheckbox:GetCheckBox():GetChecked() end)
	
	-- Add players
	for player in Client:GetPlayers() do
		self:AddPlayer(player)
	end
	--self:AddPlayer(LocalPlayer)
	
	-- Subscribe to events
	Events:Subscribe("LocalPlayerChat", self, self.LocalPlayerChat)
    Events:Subscribe("LocalPlayerInput", self, self.LocalPlayerInput)
	Events:Subscribe("PlayerJoin", self, self.PlayerJoin)
	Events:Subscribe("PlayerQuit", self, self.PlayerQuit)
    Events:Subscribe("KeyUp", self, self.KeyUp)
	Network:Subscribe("WarpRequestToTarget", self, self.WarpRequest)
	Network:Subscribe("WarpReturnWhitelists", self, self.WarpReturnWhitelists)
	Network:Subscribe("WarpDoPoof", self, self.WarpDoPoof)
	
	-- Load whitelists from server
	Network:Send("WarpGetWhitelists", LocalPlayer)
	
	-- Debug
	--self:SetWindowVisible(true)
	--self:AddPlayer(LocalPlayer)
end

-- ========================= Admin check =========================
function WarpGui:AddAdmin(steamId)
	self.admins[steamId] = true
end

function WarpGui:IsAdmin(player)
	return self.admins[player:GetSteamId().string] ~= nil
end

-- ========================= Player adding =========================
function WarpGui:CreateListButton(text, enabled, listItem)
    local buttonBackground = Rectangle.Create(listItem)
    buttonBackground:SetSizeRel(Vector2(0.5, 1.0))
    buttonBackground:SetDock(GwenPosition.Fill)
    buttonBackground:SetColor(Color(0, 0, 0, 100))
	
	local button = Button.Create(listItem)
	button:SetText(text)
	button:SetDock(GwenPosition.Fill)
	button:SetEnabled(enabled)
	
	return button
end

function WarpGui:AddPlayer(player)
	local playerId = tostring(player:GetSteamId().id)
	local playerName = player:GetName()
	
	local item = self.playerList:AddItem(playerId)
	
	-- Warp to button
	local warpToButton = self:CreateListButton("Warp to", true, item)
	warpToButton:Subscribe("Press", function() self:WarpToPlayerClick(player) end)
	
	-- Accept 
	local acceptButton = self:CreateListButton("Accept", false, item)
	acceptButton:Subscribe("Press", function() self:AcceptWarpClick(player) end)
	self.acceptButtons[playerId] = acceptButton
	
	-- Whitelist
	local whitelist = self.whitelist[playerId]
	local whitelistButtonText = "None"
	if whitelist ~= nil then
		if whitelist == 1 then whitelistButtonText = "Whitelisted"
		elseif whitelist == 2 then whitelistButtonText = "Blacklisted"
		end
	end
	local whitelistButton = self:CreateListButton(whitelistButtonText, true, item)
	whitelistButton:Subscribe("Press", function() self:WhitelistClick(playerId, whitelistButton) end)
	self.whitelistButtons[playerId] = whitelistButton
	
	-- List item
	item:SetCellText(0, playerName)
	item:SetCellContents(1, warpToButton)
	item:SetCellContents(2, acceptButton)
	item:SetCellContents(3, whitelistButton)
	
	self.rows[playerId] = item
	
	-- Add is serch filter matches
	local filter = self.filter:GetText():lower()
	if filter:len() > 0 then
		item:SetVisible(true)
	end
end

-- ========================= Player search =========================
function WarpGui:TextChanged()
	local filter = self.filter:GetText()

	if filter:len() > 0 then
		for k, v in pairs(self.rows) do
			v:SetVisible(self:PlayerNameContains(v:GetCellText(0), filter))
		end
	else
		for k, v in pairs(self.rows) do
			v:SetVisible(true)
		end
	end
end

function WarpGui:PlayerNameContains(name, filter)
	return string.match(name:lower(), filter:lower()) ~= nil
end

-- ========================= Warp to/Warp accept =========================
function WarpGui:WarpToPlayerClick(player)
	Network:Send("WarpRequestToServer", {requester = LocalPlayer, target = player})
	self:SetWindowVisible(false)
end

function WarpGui:AcceptWarpClick(player)
	local playerId = tostring(player:GetSteamId().id)
	
	if self.warpRequests[playerId] == nil then
		Chat:Print(player:GetName() .. " has not requested to warp to you.", self.textColor)
		return
	else
		local acceptButton = self.acceptButtons[playerId]
		if acceptButton == nil then return end
		self.warpRequests[playerId] = nil
		acceptButton:SetEnabled(false)
		
		Network:Send("WarpTo", {requester = player, target = LocalPlayer})
		self:SetWindowVisible(false)
	end
end

-- ========================= Warp request =========================
function WarpGui:WarpRequest(args)
	local requestingPlayer = args
	local playerId = tostring(requestingPlayer:GetSteamId().id)
	local whitelist = self.whitelist[playerId]
	
	if whitelist == 1 or self.whitelistAll or self:IsAdmin(requestingPlayer) then -- In whitelist and not in blacklist, OR admin
		Network:Send("WarpTo", {requester = requestingPlayer, target = LocalPlayer})
	elseif whitelist == 0 or whitelist == nil then -- Not in whitelist
		local acceptButton = self.acceptButtons[playerId]
		if acceptButton == nil then return end
		
		acceptButton:SetEnabled(true)
		self.warpRequests[playerId] = true
		Network:Send("WarpMessageTo", {target = requestingPlayer, message = "Please wait for " .. LocalPlayer:GetName() .. " to accept."})
		Chat:Print(requestingPlayer:GetName() .. " would like to warp to you. Type /warp or press V to accept.", self.textColor)
	end -- Blacklist
end

-- ========================= White/black -list click =========================
function WarpGui:WhitelistClick(playerId, button)
	local currentWhiteList = self.whitelist[playerId]
	
	if currentWhiteList == 0 or currentWhiteList == nil then -- Currently none, set whitelisted
		self:SetWhitelist(playerId, 1, true)
	elseif currentWhiteList == 1 then -- Currently whitelisted, blacklisted
		self:SetWhitelist(playerId, 2, true)
	elseif currentWhiteList == 2 then -- Currently blacklisted, set none
		self:SetWhitelist(playerId, 0, true)
	end
end

function WarpGui:SetWhitelist(playerId, whitelisted, sendToServer)
	if self.whitelist[playerId] ~= whitelisted then self.whitelist[playerId] = whitelisted end
	
	local whitelistButton = self.whitelistButtons[playerId]
	if whitelistButton == nil then return end
	
	if whitelisted == 0 then -- none
		whitelistButton:SetText("None")
	elseif whitelisted == 1 then -- whitelist
		whitelistButton:SetText("Whitelisted")
	elseif whitelisted == 2 then -- blacklist
		whitelistButton:SetText("Blacklisted")
	end
	
	if sendToServer then
		Network:Send("WarpSetWhitelist", {playerSteamId = LocalPlayer:GetSteamId().id, targetSteamId = playerId, whitelist = whitelisted})
	end
end

function WarpGui:WarpReturnWhitelists(whitelists)
	for i = 1, #whitelists do
		local targetSteamId = whitelists[i].target_steam_id
		local whitelisted = whitelists[i].whitelist
		self:SetWhitelist(targetSteamId, tonumber(whitelisted), false)
	end
end

-- ========================= Chat command =========================
function WarpGui:LocalPlayerChat(args)
	local message = args.text
	
	local commands = {}
	for command in string.gmatch(message, "[^%s]+") do
		table.insert(commands, command)
	end
	
	if commands[1] ~= "/warp" then return true end
	
	if #commands == 1 then -- No extra commands, show window and return
		self:SetWindowVisible(not self.windowShown)
		return false
	end
	
	local warpNameSearch = table.concat(commands, " ", 2)
	
	for player in Client:GetPlayers() do
		if (self:PlayerNameContains(player:GetName(), warpNameSearch)) then
			self:WarpToPlayerClick(player)
			return false
		end
	end
	
	return false
end

-- ========================= Effect =========================
function WarpGui:WarpDoPoof(position)
	Console:Print("asd")
    ClientEffect.Play(AssetLocation.Game, {effect_id = 250, position = position, angle = Angle()})
end

-- ========================= Window management =========================
function WarpGui:LocalPlayerInput(args) -- Prevent mouse from moving & buttons being pressed
    return not (self.windowShown and Game:GetState() == GUIState.Game)
end

function WarpGui:KeyUp( args )
    if args.key == string.byte('V') then
        self:SetWindowVisible(not self.windowShown)
    end
end

function WarpGui:PlayerJoin(args)
	local player = args.player
	
	self:AddPlayer(player)
end

function WarpGui:PlayerQuit(args)
	local player = args.player
	local playerId = tostring(player:GetSteamId().id)
	
	if self.rows[playerId] == nil then return end

	self.playerList:RemoveItem(self.rows[playerId])
	self.rows[playerId] = nil
end

function WarpGui:SetWindowVisible(visible)
	self.windowShown = visible
	self.window:SetVisible(visible)
	Mouse:SetVisible(visible)
end

warpGui = WarpGui()