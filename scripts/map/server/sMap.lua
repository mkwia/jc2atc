-- Written by Sinister Rectus - http://www.jc-mp.com/forums/index.php?action=profile;u=73431

class 'Map'

function Map:__init()
	
	self.players = {}
	
	self.airv = {
		--[3] = true,
		--[14] = true,
		[24] = true,
		[30] = true,
		[34] = true,
		--[37] = true,
		[39] = true,
		[51] = true,
		--[57] = true,
		[59] = true,
		--[62] = true,
		--[64] = true,
		--[65] = true,
		--[67] = true,
		[81] = true,
		[85] = true,
	}
	
	Network:Subscribe("InitialTeleport", self, self.InitialTeleport)
	Network:Subscribe("CorrectedTeleport", self, self.CorrectedTeleport)
	Network:Subscribe("RequestUpdate", self, self.OnRequestUpdate)
	
	Events:Subscribe("PlayerChat", self, self.ToggleMarker)
	Events:Subscribe("ModuleLoad", self, self.OnModuleLoad)
	Events:Subscribe("PlayerSpawn", self, self.AddPlayer)
	Events:Subscribe("PlayerDeath", self, self.RemovePlayer)
	Events:Subscribe("PlayerQuit", self, self.RemovePlayer)

end

function Map:ToggleMarker(args)

	if args.text == "/showonmap" and LocalPlayer:GetValue("Bounty") == nil then
		if self.players[args.player:GetId()] == true then
			self:RemovePlayer(args)
			Network:Send(args.player, "Toggle", false)
			Chat:Send(args.player, "You have disabled your F2 map. Your marker will not be broadcast.", Color.Silver)
		else
			self:AddPlayer(args)
			Network:Send(args.player, "Toggle", true)
			Chat:Send(args.player, "You enabled your F2 map. Your marker will be broadcast.", Color.Silver)
		end
		return false
	end
	
	if args.text == "/map" then

		Network:Send(args.player, "ToggleMap")

	return false
	end
end

function Map:InitialTeleport(args, sender)

	sender:SetPosition(Vector3(args.position.x, math.max(args.position.y + 5, 200), args.position.z))
	
end

function Map:CorrectedTeleport(args, sender)

	sender:SetPosition(Vector3(args.position.x, math.max(args.position.y, 200), args.position.z))

end

function Map:OnRequestUpdate(args, sender)

	local send_args = {}
	
	for id in pairs(self.players) do
	
		local player = Player.GetById(id)
	
		if player ~= sender then
		
			local data = {}
		
			data.name = player:GetName()
			data.position = player:GetPosition()
			data.color = player:GetColor()
			
			if player:InVehicle() then
				local vehicle = player:GetVehicle()
				if self.airv[vehicle:GetModelId()] then
					if player == vehicle:GetDriver() then
						data.vehicle_name = vehicle:GetName()
						data.velocity = vehicle:GetLinearVelocity()
						data.angle = vehicle:GetAngle()
					end
				end
			end
				
			table.insert(send_args, data)

		end
		
	end
	
	Network:Send(sender, "PlayerUpdate", send_args)
	
end

function Map:OnModuleLoad()

	for player in Server:GetPlayers() do
	
		self.players[player:GetId()] = true
		
	end

end

function Map:AddPlayer(args)

	self.players[args.player:GetId()] = true

end

function Map:RemovePlayer(args)

	self.players[args.player:GetId()] = nil
	
end


Map = Map()