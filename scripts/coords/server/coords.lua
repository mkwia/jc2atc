function GetCoords(args)
	local splittedText = args.text:split ( " " )
    if ( splittedText ) then
		if(splittedText[1] == "/coords") then
			local coords = string.format("Coords: %s", args.player:GetPosition() )
			print(coords)
		end
	end
end
 
Events:Subscribe("PlayerChat", GetCoords)