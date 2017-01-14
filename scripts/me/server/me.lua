class "me"

function me:__init()
	self.star = false
	Events:Subscribe("PlayerChat", self, self.PlayerChat)
end

function me:PlayerChat(args)
	local words = args.text:split(" ")
	local text = args.text
	text = text:gsub("^%s*(.-)%s*$", "%1")
	mystring, spaces = string.gsub(text, " ", " ")
	local wordcount = spaces
	
	if words[1] == "/toggleme" then
		if tostring(args.player:GetSteamId()) == "STEAM_0:0:58744266" or --Kiwi
		tostring(args.player:GetSteamId()) == "STEAM_0:0:48305789" or --Walrus
		tostring(args.player:GetSteamId()) == "STEAM_0:1:45324628" then --Tally
			Chat:Send(args.player, "'/me' command syntax switched.", Color.Silver)
			self.star = not self.star
			return false
		end
	end
	
	if words[1] == "/me" then
		if wordcount == 10 and self.star then
			Chat:Broadcast("*" ..tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. " " ..tostring(words[5]).. " " ..tostring(words[6]).. " " ..tostring(words[7]).. " " ..tostring(words[8]).. " " ..tostring(words[9]).. " " ..tostring(words[10]).. " " ..tostring(words[11]).. "*", Color(186, 117, 239))
			return false
		elseif wordcount == 9 and self.star then
			Chat:Broadcast("*" ..tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. " " ..tostring(words[5]).. " " ..tostring(words[6]).. " " ..tostring(words[7]).. " " ..tostring(words[8]).. " " ..tostring(words[9]).. " " ..tostring(words[10]).. "*", Color(186, 117, 239))
			return false
		elseif wordcount == 8 and self.star then
			Chat:Broadcast("*" ..tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. " " ..tostring(words[5]).. " " ..tostring(words[6]).. " " ..tostring(words[7]).. " " ..tostring(words[8]).. " " ..tostring(words[9]).. "*", Color(186, 117, 239))
			return false
		elseif wordcount == 7 and self.star then
			Chat:Broadcast("*" ..tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. " " ..tostring(words[5]).. " " ..tostring(words[6]).. " " ..tostring(words[7]).. " " ..tostring(words[8]).. "*", Color(186, 117, 239))
			return false
		elseif wordcount == 6 and self.star then
			Chat:Broadcast("*" ..tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. " " ..tostring(words[5]).. " " ..tostring(words[6]).. " " ..tostring(words[7]).. "*", Color(186, 117, 239))
			return false
		elseif wordcount == 5 and self.star then
			Chat:Broadcast("*" ..tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. " " ..tostring(words[5]).. " " ..tostring(words[6]).. "*", Color(186, 117, 239))
			return false
		elseif wordcount == 4 and self.star then
			Chat:Broadcast("*" ..tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. " " ..tostring(words[5]).. "*", Color(186, 117, 239))
			return false
		elseif wordcount == 3 and self.star then
			Chat:Broadcast("*" ..tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. "*", Color(186, 117, 239))
			return false
		elseif wordcount == 2 and self.star then
			Chat:Broadcast("*" ..tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. "*", Color(186, 117, 239))
			return false
		elseif wordcount == 1 and self.star then
			Chat:Broadcast("*" ..tostring(args.player).. " " ..tostring(words[2]).. "*", Color(186, 117, 239))
			return false
		elseif wordcount == 0 then
			Chat:Send(args.player, "To use, write '/me' and then a string of 1 - 10 words.", Color(240, 1, 1))
			return false
		elseif wordcount == 10 and not self.star then
			Chat:Broadcast(tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. " " ..tostring(words[5]).. " " ..tostring(words[6]).. " " ..tostring(words[7]).. " " ..tostring(words[8]).. " " ..tostring(words[9]).. " " ..tostring(words[10]).. " " ..tostring(words[11]).. ".", Color(186, 117, 239))
			return false
		elseif wordcount == 9 and not self.star then
			Chat:Broadcast(tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. " " ..tostring(words[5]).. " " ..tostring(words[6]).. " " ..tostring(words[7]).. " " ..tostring(words[8]).. " " ..tostring(words[9]).. " " ..tostring(words[10]).. ".", Color(186, 117, 239))
			return false
		elseif wordcount == 8 and not self.star then
			Chat:Broadcast(tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. " " ..tostring(words[5]).. " " ..tostring(words[6]).. " " ..tostring(words[7]).. " " ..tostring(words[8]).. " " ..tostring(words[9]).. ".", Color(186, 117, 239))
			return false
		elseif wordcount == 7 and not self.star then
			Chat:Broadcast(tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. " " ..tostring(words[5]).. " " ..tostring(words[6]).. " " ..tostring(words[7]).. " " ..tostring(words[8]).. ".", Color(186, 117, 239))
			return false
		elseif wordcount == 6 and not self.star then
			Chat:Broadcast(tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. " " ..tostring(words[5]).. " " ..tostring(words[6]).. " " ..tostring(words[7]).. ".", Color(186, 117, 239))
			return false
		elseif wordcount == 5 and not self.star then
			Chat:Broadcast(tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. " " ..tostring(words[5]).. " " ..tostring(words[6]).. ".", Color(186, 117, 239))
			return false
		elseif wordcount == 4 and not self.star then
			Chat:Broadcast(tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. " " ..tostring(words[5]).. ".", Color(186, 117, 239))
			return false
		elseif wordcount == 3 and not self.star then
			Chat:Broadcast(tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. " " ..tostring(words[4]).. ".", Color(186, 117, 239))
			return false
		elseif wordcount == 2 and not self.star then
			Chat:Broadcast(tostring(args.player).. " " ..tostring(words[2]).. " " ..tostring(words[3]).. ".", Color(186, 117, 239))
			return false
		elseif wordcount == 1 and not self.star then
			Chat:Broadcast(tostring(args.player).. " " ..tostring(words[2]).. ".", Color(186, 117, 239))
			return false
		end
	else
		return true
		
	end
end

me = me()