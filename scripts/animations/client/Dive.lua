class "Dive"

function Dive:__init()
	Events:Subscribe("KeyDown", self, self.DiveOn)
	Events:Subscribe("KeyUp", self, self.DiveOff)
	self.divekey = string.byte("6")
	self.diveinitiate = {[38] = true, [189] = true, [47] = true, [191] = true}
	self.shout = true
	self.Shouton = true -- Set to false to stop Rico shouting when he dives.
	print("Version 1.0 loaded, written by tally.")
end

function Dive:DiveOn(args)
	if args.key == self.divekey then
		if self.diveinitiate[LocalPlayer:GetBaseState()] then
			LocalPlayer:SetBaseState(189)
			local randomvar = math.random()
			if self.Shouton == true then
				if self.shout == true and randomvar > 0.5 then
					Game:FireEvent("ply.valkyrie.awesomeness")
				elseif self.shout == true and randomvar <= 0.5 then
					Game:FireEvent("ply.predator.awesomeness")
				end
			end
			self.shout = false
			if LocalPlayer:GetPosition().y <= 205 then
				Game:FireEvent("ply.makeinvulnerable")
			end
		end
	end
end

function Dive:DiveOff(args)
	if args.key == self.divekey then
		if LocalPlayer:GetBaseState() == 189 then
			Game:FireEvent("ply.makevulnerable")
			LocalPlayer:SetBaseState(6)
			self.shout = true
		end
	end
end

Dive = Dive()