ann_timer = Timer()

function ann_1()

	--[[Chat:Print(" ", Color.Lime)
		Chat:Print(" ", Color.White)
		Chat:Print(" ", Color.White)
		Chat:Print(" ", Color.White)]]
		Chat:Print(" ", Color.White)
		Chat:Print("We invite you to ", Color.White, "donate", Color.Cyan, " at ", Color.White, "jc2atc.ovh/donate,", Color.Cyan, " perks to those who do!", Color.White)
		Chat:Print("                   ~~~ ", Color.Lime, "(Minimum donation £5/$7.50/€7.10)", Color.Red, " ~~~", Color.Lime)
		Chat:Print(" ", Color.White)
		--[[Chat:Print(" ", Color.White)
		Chat:Print(" ", Color.White)
		Chat:Print(" ", Color.Lime)]]

end

function ann_2()

	Chat:Print("We are moving ", Color.White, "server host", Color.Cyan, " on ", Color.White, "December 13th ", Color.Cyan, "so expect some downtime!", Color.White)

end

Events:Subscribe("PreTick", function()

	if ann_timer:GetMinutes() == 8 then

		ann_1()

	--elseif ann_timer:GetMinutes() >= 10 then

		--ann_2()

		ann_timer:Restart()

	end

end)

Events:Subscribe("LocalPlayerChat", function(args)

	if args.text == "/ann_1" then

		ann_1()

		ann_timer:Restart()

	return false

	end

	if args.text == "/ann_2" then

		ann_2()

		ann_timer:Restart()

	return false

	end

end)
