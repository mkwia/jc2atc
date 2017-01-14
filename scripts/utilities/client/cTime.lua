Events:Subscribe("Render", function()

	timecomponent = string.split(tostring(Game:GetTime()), ".")

	hours = tonumber(timecomponent[1])

	if timecomponent[2] then minutes = math.floor((("0."..timecomponent[2]) * 60)) else minutes = 0 end

	if minutes < 10 then

		drawminutes = "0"..minutes

	else

		drawminutes = minutes

	end

	if hours < 10 then

		drawhours = "0"..hours

	else

		drawhours = hours

	end

	time = drawhours..":"..drawminutes

	Render:DrawText(Vector2(Render.Size.x * 0.1, Render.Size.y * 0.2225), time, Color.Gray)

end)