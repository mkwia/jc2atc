afk = false
afktimer = Timer()
afktime = 90

Events:Subscribe("LocalPlayerInput", function()
	afktimer:Restart()
end)

Events:Subscribe("PostTick", function()
	if afktimer:GetSeconds() >= afktime and not afk then
		local inveh = LocalPlayer:GetVehicle()
		if (inveh ~= nil and inveh:GetDriver() == LocalPlayer) or not inveh then
			afk = true
			on = true
		end
	elseif afktimer:GetSeconds() < afktime and afk then
		afk = false
		on = true
	end
	if afk and on then
		Game:FireEvent("ply.pause")
		args = {}
		args.player = LocalPlayer
		args.afk = true
		Network:Send("afk", args)
		on = false
	elseif not afk and on then
		Game:FireEvent("ply.unpause")
		args = {}
		args.player = LocalPlayer
		args.afk = false
		Network:Send("afk", args)
		on = false
	end
end)


Events:Subscribe("Render", function()
	local message = "You're AFK!"
	local FontSize = 50
	local EffectiveFontSize = FontSize * Render.Size.x / 1000
	local textlength = Render:GetTextSize(message, EffectiveFontSize)
	if afk then
		Render:DrawText(Vector2((Render.Size.x / 2) - (textlength.x / 2.75) + 2, (Render.Size.y / 2) - (textlength.y / 2.75) + 2), message, Color(0, 0, 0, 200), FontSize)
		Render:DrawText(Vector2((Render.Size.x / 2) - (textlength.x / 2.75), (Render.Size.y / 2) - (textlength.y / 2.75)), message, Color.Magenta, FontSize)
	end
end)