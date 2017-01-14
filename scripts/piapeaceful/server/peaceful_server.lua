class 'Peaceful'

function Peaceful:__init()

	self.warned = {}
	
	Network:Subscribe("Warning", self, self.OnWarning)
	Network:Subscribe("Check", self, self.CheckPlayerState)
	Events:Subscribe("PlayerQuit", self, self.OnPlayerQuit)

end

function Peaceful:OnWarning(victim, sender)

	self.checked = false

	if victim == Player then

		for p in Server:GetPlayers() do

			if victim == p then

				Network:Send(victim, "CheckPlayerState", sender)

			end

		end

	return end

	local id = sender:GetId()
	
	if not self.warned[id] then 
		self.warned[id] = {Timer(), 1}
	else
		if self.warned[id][1]:GetMinutes() < 1 then
			self.warned[id][2] = self.warned[id][2] + 1
		else
			self.warned[id][2] = 1
		end
		self.warned[id][1]:Restart()
	end
	
	if self.warned[id] then
		Chat:Send(sender, "Ramming in PIA is not allowed.", Color.Tomato)
		--[[if self.warned[id][2] > 2 then
			sender:Kick("Ramming in a peaceful zone.")
			Chat:Broadcast(sender:GetName().." was autokicked for ramming in a peaceful zone.", Color.Tomato)
		end]]
	end

end

function Peaceful:CheckPlayerState(attacker, victim)

	print("received")

	local id = attacker:GetId()
	
	if not self.warned[id] then 
		self.warned[id] = {Timer(), 1}
	else
		if self.warned[id][1]:GetMinutes() < 1 then
			self.warned[id][2] = self.warned[id][2] + 1
		else
			self.warned[id][2] = 1
		end
		self.warned[id][1]:Restart()
	end
	
	if self.warned[id] then
		Chat:Send(attacker, "Ramming in PIA is not allowed.", Color.Tomato)
		if self.warned[id][2] > 2 then
			attacker:Kick("Ramming in a peaceful zone.")
			Chat:Broadcast(attacker:GetName().." was autokicked for ramming in a peaceful zone.", Color.Tomato)
		end
	end

end

function Peaceful:OnPlayerQuit(args)

	self.warned[args.player:GetId()] = nil

	args.player:SetValue("Peaceful", false)

end

Peaceful = Peaceful()