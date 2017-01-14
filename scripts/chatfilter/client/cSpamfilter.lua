class "spamfilter"

function spamfilter:__init()

	--(Settings)--
	self.timebetweenmessages = 1 -- Seconds you must leave between messages else you get a strike
	self.spamcount = 0 -- Spam count on joining server (LEAVE THIS)
	self.spamnumber = 3 -- Offences shown in chat before a mute is incurred
	self.spammax = self.spamnumber + 1 -- Leave this (magical number stuff)
	self.mutetime = 60 -- Time period that the player is muted
	self.mutemessage = true -- Tell everyone that the player has been muted
	self.unmutemessage = false -- Tell everyone that the player has been unmuted
	------------------------
	self.chattimer = Timer()
	self.mutetimer = Timer()
	self.resettimer = Timer()
	self.muted = false

	--print("Written by tally. V1.0")

	Events:Subscribe("LocalPlayerChat", self, self.filter)
	Events:Subscribe("PostTick", self, self.unmute)

end

function spamfilter:filter(args)

	if string.sub(args.text, 1, 1) == "/" then return end

	local words = args.text:split(" ")

	if self.mutetimer:GetSeconds() >= 120 then

		self.spamcount = 0

	end

	if self.chattimer:GetSeconds() < self.timebetweenmessages and not self.muted then

		if words[1]:sub(1, 1) == "/" then end

		self.spamcount = self.spamcount + 1

		self.chattimer:Restart()

		self.mutetimer:Restart()

		--if self.spamcount == 1 then

			Chat:Print("Try not to spam chat please, wait " ..self.timebetweenmessages.. " seconds before sending a new message.", Color.Silver)

		--end

	else

		self.chattimer:Restart()

	end

	if self.muted then

		Chat:Print("You are muted for another "..tonumber(math.floor(self.mutetime - self.mutetimer:GetSeconds())).. " seconds.", Color.Silver)

		return false

	end

	if self.spamcount >= self.spammax then

		self.spamcount = 0

		self.muted = true

		if self.mutemessage then

			args = {}

			args.time = self.mutetime

			args.player = LocalPlayer:GetName()

			Network:Send("Muted", args)

		else

			Chat:Print("You have been muted for "..self.mutetime.." seconds.", Color.Red)

		end

		self.mutetimer:Restart()

		return false

	end

end

function spamfilter:unmute()

	if self.mutetimer:GetSeconds() >= self.mutetime and self.muted then

		self.muted = false

		if self.unmutemessage then

			args = {}

			args.player = LocalPlayer:GetName()

			Network:Send("Unmuted", args)

		else

			Chat:Print("You have been unmuted.", Color(0, 255, 0))

		end

	end

end

spam = spamfilter()