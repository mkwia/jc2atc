enabled = true

Events:Subscribe("LocalPlayerChat", function(args)

	if args.text == "/atis" then

		enabled = not enabled

		return false

	end

end)

Network:Subscribe("WeatherUpdate", function(args)

	Events:Fire("WeatherChange", args.new)

	if not enabled then return end

	local prev = args.prev

	local new = args.new

	local climate = LocalPlayer:GetClimateZone()

	if new == 0 then

		Chat:Print("The weather passes...", Color.White)

	elseif new == 1 and prev == 0 then

		if climate == 1 then

			Chat:Print("It begins to snow...", Color.White)

		elseif climate == 2 then

			Chat:Print("Clouds begin to cover the sky...", Color.White)

		else

			Chat:Print("It starts to shower...", Color.White)

		end

	elseif new == 1 and prev == 2 then

		if climate == 1 then

			Chat:Print("The snow falls less frequently...", Color.White)

		elseif climate == 2 then

			Chat:Print("The clouds begin to part...", Color.White)

		else

			Chat:Print("The storm eases off...", Color.White)

		end

	elseif new == 2 then

		if climate == 1 then

			Chat:Print("A flurry of snow blows around you...", Color.White)

		elseif climate == 2 then

			Chat:Print("The clouds become dark and brooding...", Color.White)

		else

			Chat:Print("A deluge of rain falls...", Color.White)

		end

	end

end)