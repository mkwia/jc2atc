class "Peaceful"
function Peaceful:__init()

	self.collision_timer = Timer()
	
	self.PVPlocations = {}
	--Define the areas where PvP is NOT allowed here
	self.PVPlocations.ap1 = { --This entry is named "ap1"
		position = Vector3(-6419.79, 208.98, -3339.26), --center of the PvP zone
		distanceSqr = 1000^2 --radius squared (in metres) (this one is 2km)
	}
    --self.PVPlocations.faces = { --This entry is named "dap1"
	--	position = Vector3(14140.381836, 0, 14335.505859), --center of the PvP zone
	--	distanceSqr = 12800 --radius squared (in metres) (this one is 2km)
	--}

	self.bs = {[80] = false,
				[81] = false,
				[82] = false,
				[83] = false,
				}

	self.key = nil
	
	self.prevallowed = false

	Events:Subscribe("InputPoll", self, self.OnInputPoll)
	Events:Subscribe("Render", self, self.OnRender)
	Events:Subscribe("VehicleCollide", self, self.OnVehicleCollide)
	Network:Subscribe("CheckPlayerState", self, self.CheckPlayerState)
	Events:Subscribe("KeyDown", self, self.KeyCheck)
	
end

function Peaceful:OnInputPoll()

	if	Input:GetValue(Action.FireLeft) > 0 or
		Input:GetValue(Action.FireRight) > 0 or
		Input:GetValue(Action.VehicleFireLeft) > 0 or
		Input:GetValue(Action.VehicleFireRight) > 0 or
		Input:GetValue(Action.McFire) > 0 then
		if self:InNonPvpZone() then
			Input:SetValue(Action.FireLeft, 0)
			Input:SetValue(Action.FireRight, 0)
			Input:SetValue(Action.VehicleFireLeft, 0)
			Input:SetValue(Action.VehicleFireRight, 0)
			Input:SetValue(Action.McFire, 0)
			self.blockmessagetimer = Timer()
		end
	end

end

function Peaceful:OnRender()

	-- local transform = Transform3()
	-- transform:Translate(self.PVPlocations.ap1.position)
	-- transform:Rotate(Angle(0, 0.5 * math.pi, 0))
	-- Render:SetTransform(transform)
	-- Render:DrawCircle(Vector3.Zero, math.sqrt(self.PVPlocations.ap1.distanceSqr), Color.Red)
	-- Render:ResetTransform()

	--message when trying to PvP while not in a PvP area
	if self.blockmessagetimer ~= nil and self.enterareatimer == nil then
		if self.blockmessagetimer:GetSeconds() < 5 then
			local text = "You are in a peaceful zone." --this is the actual message
			LocalPlayer:SetValue("Peaceful", true)
			local fontsize = 20
			local pos = Vector2(
				(Render.Width - Render:GetTextWidth(text, fontsize))/2,
				Render:GetTextHeight(text, fontsize)*2.2
			)
			local color = Color(255, 0, 0) --color of the text message (you can set the alpha value here too)
			color.a = math.lerp(0, color.a, math.clamp(5 - self.blockmessagetimer:GetSeconds(), 0, 1)) --this line is for the fade out effect, just remove it if you don't like it
			Render:DrawText(pos, text, color, fontsize)
		else
			self.blockmessagetimer = nil
		end
	end
	
	--detecting if entering PvP area
	if not self:InNonPvpZone() then
		if self.prevallowed == false then
			self.enterareatimer = Timer()
		end
		self.prevallowed = true
	else
		self.prevallowed = false
	end
	
	--message when entering a PvP area
	if self.enterareatimer ~= nil then
		if self.enterareatimer:GetSeconds() < 5 then
			local text = "You entered a PvP zone." --this is the actual message
			LocalPlayer:SetValue("Peaceful", false)
			local fontsize = 20
			local pos = Vector2(
				(Render.Width - Render:GetTextWidth(text, fontsize))/2,
				Render:GetTextHeight(text, fontsize)*2.2
			)
			local color = Color(255, 0, 0) --color of the text message (you can set the alpha value here too)
			color.a = math.lerp(0, color.a, math.clamp(5 - self.enterareatimer:GetSeconds(), 0, 1)) --this line is for the fade out effect, just remove it if you don't like it
			Render:DrawText(pos, text, color, fontsize)
		else
			self.enterareatimer = nil
		end
	end

end

function Peaceful:OnVehicleCollide(args)
	
	if args.attacker:GetDriver() == LocalPlayer then
	
		if self:InNonPvpZone() then
		
			if self.collision_timer:GetSeconds() > 10 then
		
				local target
				if args.vehicle then 
					if args.vehicle:GetDriver() then
						target = args.vehicle
						local vehicle
					else
						return
					end
				else
					target = args.player
				end
				
				local speed = args.attacker:GetLinearVelocity():Length()
			
				if speed > 10 and speed > target:GetLinearVelocity():Length() then
	
					Network:Send("Warning", target)
					self.collision_timer:Restart()
				
				end
				
			end
			
		end

	end
	
end

function Peaceful:CheckPlayerState(attacker)

	local bs = LocalPlayer:GetBaseState()

	if self.key ~= nil and (self.key ~= VirtualKey.Space or self.bs[bs]) then

		print(tostring(self.key))

		Network:Send("Check", attacker)

	end

end

function Peaceful:KeyCheck(args)

	self.key = args.key

end

-------------------------

function Peaceful:InNonPvpZone()

	local pos = LocalPlayer:GetPosition()
	local allowed = false
	for i, v in pairs(self.PVPlocations) do
		allowed = allowed or Vector3.DistanceSqr2D(pos, v.position) <= v.distanceSqr
	end
	return allowed

end

script = Peaceful()