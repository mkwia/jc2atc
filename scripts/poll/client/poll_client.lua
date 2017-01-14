--Settings
textsize = 50
color = Color(255, 0, 0, 255)
voted = nil

function Rendering()
	if AlertTimer ~= nil then
		if AlertTimer:GetSeconds() <= 17 then
		
			msg = {}
			msg[0] = AlertMessage
			msg[1] = "Type \"yes\" or \"no\" for your vote to be counted!"
			msg[2] = "["..tostring(17 - math.ceil(AlertTimer:GetSeconds())).."]"
		
			--fadein/out
			if AlertTimer:GetSeconds() <= 1 then
				color.a = 255 * AlertTimer:GetMilliseconds()/1000
			elseif AlertTimer:GetSeconds() >= 16 then
				color.a = 255 * (17 - AlertTimer:GetMilliseconds()/1000)
			end

			--rendering the text
			for i = 0, 2, 1 do Render:DrawText(Render.Size/2 - Render:GetTextSize(msg[i], textsize)/2 + Vector2(0, -75 + 0) + (i * Vector2(0, 75)), msg[i], color, textsize) end
			
		else
			AlertTimer = nil
			AlertMessage = nil
		end
	end
end
Events:Subscribe("PostRender", Rendering)

function answering(args)
	if AlertTimer ~= nil then
		if string.lower(args.text) == "yes" then
			if voted then
				Chat:Print("You've already voted, you cheater!", Color.Red)
			else
				Chat:Print("You voted ", Color.White, "yes", Color.Lime, ", thanks!", Color.White)
				args = {}
				args.sender = LocalPlayer
				Network:Send("yes", args)
				voted = true
			end
			return false
		elseif string.lower(args.text) == "no" then
			if voted then
				Chat:Print("You've already voted, you cheater!", Color.Red)
			else
				Chat:Print("You voted ", Color.White, "no", Color.Lime, ", thanks!", Color.White)
				args = {}
				args.sender = LocalPlayer
				Network:Send("no", args)
				voted = true
			end
			return false
		end
	end
end
Events:Subscribe("LocalPlayerChat", answering)

Network:Subscribe("poll!", function(text) AlertMessage = text AlertTimer = Timer() voted = nil print("Question from the server: "..text) end)