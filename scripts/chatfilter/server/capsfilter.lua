Events:Subscribe("PlayerChat", function(args)

	local string = args.text
	local charcount = 0
	local capscount = 0

	for letter in string.gmatch(string, "%a") do

		charcount = charcount + 1

		if string.find(letter, "%L") then

			capscount = capscount + 1

		end

	end

	if capscount > charcount/2 then

		Chat:Send(args.player, "You really don't need to use that many caps! Message not sent.", Color.Red)

		return false

	end

end)