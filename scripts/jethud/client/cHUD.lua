
function HUD:__init()
	
	self.isEnabled = false
	self.vehicle = nil
	self.colorHUD = settings.colorHUD
	
	Events:Subscribe("Render" , self , self.Render)
	Events:Subscribe("LocalPlayerChat" , self , self.PlayerChat)
	
end

----------------------------------------------------------------------------------------------------
-- Events.
----------------------------------------------------------------------------------------------------

function HUD:Render()
	
	self.vehicle = LocalPlayer:GetVehicle()
	
	globals.printCount = 0
	
	-- Only draw if we're in a proper vehicle and not paused.
	if
		self.isEnabled and
		self:GetIsInAppropriateVehicle() and
		Game:GetState() == GUIState.Game
	then
		self:DrawHUD()
		-- self:GUpdate()
	end
	
end

function HUD:PlayerChat(args)
	
	if args.text == settings.command then
		self.isEnabled = not self.isEnabled
		if self.isEnabled then
			Chat:Print(settings.name.." enabled" , settings.colorChat)
		else
			Chat:Print(settings.name.." disabled" , settings.colorChat)
		end
	end
	
end

----------------------------------------------------------------------------------------------------
-- Functions
----------------------------------------------------------------------------------------------------

function HUD:GetIsInAppropriateVehicle()
	
	-- If we're not in a vehicle, we don't care.
	if not self.vehicle then
		return
	end
	
	local modelId = self.vehicle:GetModelId()
	
	return settings.supportedVehicles[modelId] ~= nil
	
end

function HUD:GetRoll()
	
	local angle = self.vehicle:GetAngle()
	
	return angle.roll
	
end

function HUD:GetPitch()
	
	local angle = self.vehicle:GetAngle()
	
	local pitch = angle.pitch
	if pitch > settings.clampPitch then pitch = settings.clampPitch end
	if pitch < -settings.clampPitch then pitch = -settings.clampPitch end
	
	return pitch
	
end

function HUD:GetYaw()
	
	return self.vehicle:GetAngle().yaw
	
end
