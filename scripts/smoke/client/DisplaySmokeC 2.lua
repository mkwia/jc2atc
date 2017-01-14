--Constants
delayTime = 4 --Time delay between particle generation (In render ticks)
removeTime = 1 --Effect buffer max size, basically how long the trails are in particles
key = "Q" -- Key to toggle smoke and menu
keyHoldTime = 0.2 --Time in seconds until menu shows

effectID = 208
effectIDs = {
	[208] = {
		name = "White Smoke"
	},
	[167] = {
		name = "Black Smoke"
	},
	[109] = {
		name = "Green Smoke"
	},
	[0] = {
		name = "Fire"
	},
	[151] = {
		name = "Fire Trail"
	},
	[455] = {
		name = "Dump and Burn"
	},
	[329] = {
		name = "Fire Rings"
	},
	[342] = {
		name = "Firework Rings"
	},
	[364] = {
		name = "Blue Fire Rings"
	},
	[365] = {
		name = "Blue Firework Rings"
	},
	[44] = {
		name = "Blue Smoke"
	},
	[101] = {
		name = "Pls no use"
	},
}

isEnabled = false --Disable on load
delay = delayTime --Set delay from constant
players = {} --Table to hold players with smoke enabled and the particles
playersToDisable = {} --Init table for holding users that need to have buffers cleared after disabling
holdTimer = nil --Init timer for checking key hold time
lastEffectName = nil --The last trail type that was sent to the server

--Some thing tally added, not sure what it does
blocked_inputs = {
	[3] = true,
	[4] = true,
	[5] = true,
	[6] = true,
	[11] = true,
	[12] = true,
	[13] = true,
	[14] = true,
	[17] = true,
	[18] = true,
	[105] = true,
	[137] = true,
	[138] = true,
	[139] = true
}

--SMOKE SELECTION GUI
window = Window.Create()
window:SetVisible(false)
window:SetTitle("Smoke Menu")
window:SetSize(Vector2(300, 100))
window:SetPositionRel(Vector2(0.2, 0.5) - window.GetSizeRel(window) / 2)
selectionBox = ComboBox.Create(window)
selectionBox:SetDock(GwenPosition.Fill)
for ek, ev in pairs(effectIDs) do
	selectionBox:AddItem(ev.name)
end
selectionBox:SetText("White Smoke")
function selectionChanged()
	text = selectionBox:GetSelectedItem():GetText()
	for ek, ev in pairs(effectIDs) do
		if selectionBox:GetText() == ev.name then
			effectID = ek
		end
	end
	selectionBox:Blur()
end
selectionBox:Subscribe("Selection", selectionChanged)

--Start hey hold timer if key has been pressed
function KeyDown(args)
	if args.key == string.byte(key) and timer == nil then
		timer = Timer()
	end
end

function KeyUp(args)
	if args.key == string.byte(key) and isInPlane(true) then
		--Toggle Menu is in Render so it happens as soon as it passes 0.5 secs
		--Check if timer is nil and time is not over hold time
		if timer ~= nil then
			if timer:GetSeconds() < keyHoldTime then
				--Check if user is in steam group
				if LocalPlayer:GetValue("SteamGroupMember") ~= true then
					Chat:Print("You must be part of the JC2ATC steam group to use smoke!", Color(255, 0, 0))
					return
				end
				--If in plane toggle smoke
				if isInPlane(true) then
					isEnabled = not isEnabled
					--If disabling, make sure other players clear this player's buffer
					if not isEnabled then
						data = LocalPlayer:GetId()
						Network:Send("endEffect", data)
						playersToDisable[data] = data
					else
						data = {}
						data.playerID = LocalPlayer:GetId()
						data.effectID = effectID
						Network:Send("startEffect", data)
						if players[data.playerID] ~= nil and players[data.playerID].effects[1] ~= nil then
							for ek, effect in pairs(players[data.playerID].effects) do
								effect:Remove()
							end
						end
						players[data.playerID] = {}
						players[data.playerID].effectID = data.effectID
						players[data.playerID].effects = {}
						playersToDisable[data.playerID] = nil
						lastEffectName = selectionBox:GetText()
					end
				end
			else
				if window:GetVisible() then
					window:Hide()
					Mouse:SetVisible(false)
				else
					window:Show()
					Mouse:SetVisible(true)
				end
			end
			--Clear timer
			timer = nil
		end
	end
end

--Function to check if in plane
--If checkPassenger is true, it will return false if they are not the driver
 function isInPlane(checkPassenger)
	if LocalPlayer:GetVehicle() ~= nil then
		if LocalPlayer:GetVehicle():GetDriver() ~= LocalPlayer and checkPassenger == true then
			return false
		end
		if LocalPlayer:GetVehicle():GetName() == "Peek Airhawk 225" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Pell Silverbolt 6" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Cassius 192" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Si-47 Leopard" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "G9 Eclipse" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Aeroliner 474" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Bering I-86DP" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "F-33 DragonFly" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Rowlinson K22" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Mullen Skeeter Eagle" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Mullen Skeeter Hawk" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Sivirkin 15 Havoc" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "AH-33 Topachula" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "H-62 Quapaw" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "UH-10 Chippewa" then
			return true
		end
	end
	return false
end

function _Render()
	--Show text saying smoke enabled
	if isEnabled then
		local rs = Render.Size
		local string = "Smoke Enabled (" .. lastEffectName .. "), Hold Q to change type"
		local fontsize = 16
		local size = Render:GetTextSize ( string, fontsize )
		local pos = Vector2(rs.x / 2 - (size.x / 2), rs.y / 2 + 200)
		Render:DrawText(pos, string, Color(255, 0, 0), fontsize)
	end

	--If delay met, run the particle stuff
	if delay == 0 then
		for playerID, pdata in pairs(players) do
			--If player has smoke off, skip them
			if playersToDisable[playerID] == nil then
				--If buffer limit reached, remove eccess effects
				if #pdata.effects > removeTime then
					for i=1, (#pdata.effects - removeTime) do
						if pdata.effects[1] ~= nil then
							players[playerID].effects[1]:Remove()
						end
						table.remove(players[playerID].effects, 1)
					end
				end

				--Get player
				curPlayer = nil
				if playerID == LocalPlayer:GetId() then
					curPlayer = LocalPlayer
				else
					for player in Client:GetPlayers() do
						if player:GetId() == playerID then
							curPlayer = player
						end
					end
				end

				--Check if player is in vehicle
				if curPlayer ~= nil and curPlayer:GetVehicle() ~= nil then
					--Get if player is higher than 2m
					local dist = Physics:Raycast(curPlayer:GetVehicle():GetPosition(), Vector3.Down, 0, 10).distance >= 5

					--If high enough, add effect locally and broadcast to server
					if dist and Vector3.Distance(curPlayer:GetPosition(), LocalPlayer:GetPosition()) < 600 then
						--Init effect data
						data = {}
						spawnargs = {
							position = curPlayer:GetVehicle():GetPosition(),
							angle = curPlayer:GetVehicle():GetAngle(),
							effect_id = pdata.effectID
						}

						--Show effect
						local effect = ClientEffect.Create(AssetLocation.Game, spawnargs)
						table.insert(players[playerID].effects, effect)
					end
				end
			end
			--Removing particles from disabled players
			for ID, playerID in pairs(playersToDisable) do
				if players[playerID] ~= nil then
					if players[playerID].effects[1] ~= nil then
						players[playerID].effects[1]:Remove()
					else
						playersToDisable[playerID] = nil
						players[playerID] = nil
						return
					end
					table.remove(players[playerID].effects, 1)
				else
					playersToDisable[ID] = nil
				end
			end
		end
	end
	--Increase delay number
	delay = delay - 1
	--If delay number past 0, set to delay time
	if delay == -1 then
		delay = delayTime
	end
end

--When someone enables smoke, add to players
function addEffect(data)
	if data.playerID == LocalPlayer:GetId() then
		return
	end
	if players[data.playerID] ~= nil and players[data.playerID].effects[1] ~= nil then
		for ek, effect in pairs(players[data.playerID].effects) do
			effect:Remove()
		end
	end
	--Initialise player and trail info
	players[data.playerID] = {}
	players[data.playerID].effectID = data.effectID
	players[data.playerID].effects = {}
	playersToDisable[data.playerID] = nil
end

--When someone disables smoke, signal buffer clearing
function endEffect(data)
	if data == LocalPlayer:GetId() then
		return
	end
	playersToDisable[data] = data
end

--Tally's....whatever this does
function blockinput(args)
	if window:GetVisible() then
		if blocked_inputs[args.input] then
			return false
		end
	end
end

--When player exits plane, hide smoke menu and disable smoke
function exit()
	if window:GetVisible() then
		window:Hide()
		Mouse:SetVisible(false)
	end
	if isEnabled then
		isEnabled = false
		data = LocalPlayer:GetId()
		Network:Send("endEffect", data)
		playersToDisable[data] = data
	end
end

--Show mouse when menu closed
function windowClosed()
	Mouse:SetVisible(false)
end

--On module unload, clear effect buffers
function unload()
	for playerID, pdata in pairs(players) do
		for ek, ev  in pairs(pdata.effects) do
			if players[playerID].effects[ek] ~= nil then
				players[playerID].effects[ek]:Remove()
			end
			table.remove(players[playerID].effects, ek)
		end
	end
end

--Subscribing stuff
Events:Subscribe("KeyDown", KeyDown)
Events:Subscribe("KeyUp", KeyUp)
Events:Subscribe("ModuleUnload", unload)
Events:Subscribe("Render", _Render)
Events:Subscribe("Render", _Render)
Events:Subscribe("LocalPlayerInput", blockinput)
Events:Subscribe("LocalPlayerExitVehicle", exit)
Events:Subscribe("LocalPlayerDeath", exit)
Network:Subscribe("startEffect", addEffect)
Network:Subscribe("endEffect", endEffect)
window:Subscribe("WindowClosed", windowClosed)
