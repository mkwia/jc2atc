tps = 100

Network:Subscribe("TPS", function(args)

	tps = args
	
end)

Events:Subscribe("Render", function()

	local display = "TPS: "..tps
	Render:DrawText(Vector2(Render.Width - (Render:GetTextWidth(display) + 5), 33), display, Color.White)
	
end)