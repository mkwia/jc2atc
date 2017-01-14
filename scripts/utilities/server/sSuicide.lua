Events:Subscribe("PlayerChat", function(args)
	if string.lower(args.text) == "/suicide" then
		args.player:SetHealth(0)
		return false
	end
end)