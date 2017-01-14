weather_timer = Timer()

time_period = 1

Events:Subscribe("PostTick", function()

	if weather_timer:GetMinutes() >= time_period then

		local prev = DefaultWorld:GetWeatherSeverity()

		local chance = math.random(6)

		if chance > 3 then

			chance = 0

		elseif chance > 1 then

			chance = 1

		else

			chance = 2

		end

		time_period = math.random(5, 20)

		DefaultWorld:SetWeatherSeverity(chance)

		--[[if chance ~= prev then

			for p in Server:GetPlayers() do

				args = {}

				args.previous = prev

				args.new = chance

				Network:Send(p, "WeatherUpdate", args)

			end

			if chance == 0 then

				for p in Server:GetPlayers() do

					Chat:Send(p, "The weather becomes clearer...", Color.White)

				end

			elseif chance == 1 and prev == 0 then

				for p in Server:GetPlayers() do

					Chat:Send(p, "Clouds begin to cover the sky...", Color.White)

				end

			elseif chance == 1 and prev == 2 then

				for p in Server:GetPlayers() do

					Chat:Send(p, "The storm eases off...", Color.White)

				end

			elseif chance == 2 then

				for p in Server:GetPlayers() do

					Chat:Send(p, "It suddenly begins to start raining...", Color.White)

				end

			end

		end]]

		weather_timer:Restart()

	end

end)