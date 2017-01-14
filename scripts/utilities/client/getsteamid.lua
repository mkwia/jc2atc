function PlayerChat(args) -- Open the function (be careful to put args if you plan to use them).

	words = args.text:split(" ") -- Defines words to be the characters between spaces.

	if string.lower(words[1]) == "/getsteamid" then -- If the 1st word is /getsteamid then... (string.lower() allows any letter to be capitalised and it'll read it)

		if words[2] == nil or findPly(words[2]) == nil then -- If the name specified isn't found then...

			Chat:Print("You must specify a player that is online.", Color.Silver) -- steamid to chat.

		else -- If the player is found then...

			open = true

			window = GUI:Window(tostring(findPly(words[2])).. "'s SteamID is:", Vector2(0.0, 0.0), Vector2(0.25, 0.1))
			window:SetVisible(true)
			Mouse:SetVisible(true)
			GUI:Center(window)
			window.message = GUI:TextBox(tostring(findPly(words[2]):GetSteamId()), Vector2 ( 0.0, 0.01 ), Vector2 ( 0.24, 0.05 ), "text", window)
			window:Subscribe("WindowClosed", WindowClosed)
			--window.close = GUI:Button("Close", Vector2(0.0, 0.085), Vector2(0.24, 0.04), window)
			--window.close:Subscribe("Press", closebox)

		end -- End of if statement.

		return false -- Don't send the message in chat.

	else -- If the 1st word isn't /getsteamid then...

		return true -- Send the message in chat.

	end -- End of if statement.

end -- End of function.

function findPly(str) return Player.Match(str)[1] end -- Function to match the playername (string.match())

function WindowClosed()

	open = false
	Mouse:SetVisible(false)

end

function DisableFire()

	if	Input:GetValue(Action.FireLeft) > 0 or
		Input:GetValue(Action.FireRight) > 0 or
		Input:GetValue(Action.VehicleFireLeft) > 0 or
		Input:GetValue(Action.VehicleFireRight) > 0 or
		Input:GetValue(Action.McFire) > 0 then

		if open then

			Input:SetValue(Action.FireLeft, 0)
			Input:SetValue(Action.FireRight, 0)
			Input:SetValue(Action.VehicleFireLeft, 0)
			Input:SetValue(Action.VehicleFireRight, 0)
			Input:SetValue(Action.McFire, 0)

		end

	end

end

Events:Subscribe("LocalPlayerChat", PlayerChat) -- Runs the playerchat function everytime local chat is sent.
Events:Subscribe("InputPoll", DisableFire)