alphatimer = Timer()

Events:Subscribe("Render", function()

	if alphatimer:GetSeconds() >= 4 then alphatimer:Restart() end

	local bounty = LocalPlayer:GetValue("Bounty")
	local rs = Render.Size

	if bounty ~= nil then

		local string = "Bounty: £"..tostring(bounty)
		local fontsize = 20
		local textsize = Render:GetTextSize(string, fontsize)
		if alphatimer:GetSeconds() < 2 then
			alpha = alphatimer:GetMilliseconds() * 0.085
		else
			alpha = (4000 - alphatimer:GetMilliseconds()) * 0.085
		end
		alpha = alpha + 85
		local colour = Color(255, 0, 0, alpha)

		Render:DrawText((Vector2(rs.x * 0.1, rs.y * 0.5) - textsize/2), string, colour, fontsize)

	end

end)

Network:Subscribe("wanted_level", function(heat)

	Game:SetHeat(heat, heat * 100 / 3)

end)