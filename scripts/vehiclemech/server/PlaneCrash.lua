class "Planecrash"

function Planecrash:__init()
	HeliVehicles = {[3] = true, [14] = true, [37] = true, [57] = true, [62] = true, [64] = true, [65] = true, [67] = true}
	PlaneVehicles =	{[24] = true, [30] = true, [34] = true, [39] = true, [51] = true, [59] = true, [81] = true, [85] = true}
	AirVehicles = {[3] = true, [14] = true, [37] = true, [57] = true, [62] = true, [64] = true, [65] = true, [67] = true, [24] = true, [30] = true, [34] = true, [39] = true, [51] = true, [59] = true, [81] = true, [85] = true}
	planehealth = 0.1
	helihealth = 0.01
	Events:Subscribe("PlayerChat", PlayerChat)
	math.random()
end

function PlayerChat(args, player)
	local words = args.text:split(" ")
 
	local Weather = DefaultWorld:GetWeatherSeverity()
	local Positionx = string.format("%i", args.player:GetPosition().x + 16384)
	local Positionz = string.format("%i", args.player:GetPosition().z + 16384)
 
	if args.text == "/mayday" and not args.player:InVehicle() then
		Chat:Send(args.player, "You need to be in a plane or helicopter to do that!", Color(255, 255, 255))
		return false
	elseif args.text == "/mayday" and PlaneVehicles[args.player:GetVehicle():GetModelId()] then
		if Weather == 2 then
			args.player:GetVehicle():SetHealth(planehealth)
			args.player:GetVehicle():SetDeathRemove(true)
			if math.random() <= 0.5 then
				Chat:Broadcast(tostring(args.player).. "'s plane couldn't handle the turbulence!", Color(255, 255, 255))
			elseif math.random() > 0.5 then
				Chat:Broadcast(tostring(args.player).. "'s plane was struck by lightning!", Color(255, 255, 255))
			else
				Chat:Broadcast(tostring(args.player).. "'s plane's wing was ripped off!", Color(255, 255, 255))
			end
			Chat:Broadcast("Last blackbox broadcast puts " ..tostring(args.player) .." at " ..tostring(Positionx).. ", " ..tostring(Positionz).. ".", Color(255, 255, 255))
		return false
		else
			args.player:GetVehicle():SetHealth(planehealth)
			args.player:GetVehicle():SetDeathRemove(true)
			if math.random() <= 0.5 then
				Chat:Broadcast(tostring(args.player).. "'s plane's engines have failed!", Color(255, 255, 255))
			elseif math.random() > 0.5 then
				Chat:Broadcast(tostring(args.player).. "'s plane had no left phalange!", Color(255, 255, 255))
			else
				Chat:Broadcast(tostring(args.player).. "'s plane had a fuel leak!", Color(255, 255, 255))
			end
			Chat:Broadcast("Last blackbox broadcast puts " ..tostring(args.player) .." at " ..tostring(Positionx).. ", " ..tostring(Positionz).. ".", Color(255, 255, 255))
		return false
		end
	elseif args.text == "/mayday" and HeliVehicles[args.player:GetVehicle():GetModelId()] then
		if Weather == 2 then
			args.player:GetVehicle():SetHealth(helihealth)
			args.player:GetVehicle():SetDeathRemove(true)
			if math.random() <= 0.5 then
				Chat:Broadcast(tostring(args.player).. "'s helicopter was struck by lightning!", Color(255, 255, 255))
			elseif math.random() > 0.5 then
				Chat:Broadcast(tostring(args.player).. "'s helicopter got caught in a tornado!", Color(255, 255, 255))
			else
				Chat:Broadcast(tostring(args.player).. "'s helicopter was lost in the Bermuda Triangle!", Color(255, 255, 255))
			end
			Chat:Broadcast("Last blackbox broadcast puts " ..tostring(args.player) .." at " ..tostring(Positionx).. ", " ..tostring(Positionz).. ".", Color(255, 255, 255))
		return false
		else
			args.player:GetVehicle():SetHealth(helihealth)
			args.player:GetVehicle():SetDeathRemove(true)
			if math.random() <= 0.5 then
				Chat:Broadcast(tostring(args.player).. "'s helicopter's engines have failed!", Color(255, 255, 255))
			elseif math.random() > 0.5 then
				Chat:Broadcast(tostring(args.player).. "'s helicopter's rotors fell off!", Color(255, 255, 255))
			else
				Chat:Broadcast(tostring(args.player).. "'s helicopter has a fuel leak!", Color(255, 255, 255))
			end
			Chat:Broadcast("Last blackbox broadcast puts " ..tostring(args.player) .." at " ..tostring(Positionx).. ", " ..tostring(Positionz).. ".", Color(255, 255, 255))
		return false
		end
	elseif args.text == "/mayday" and not AirVehicles[args.player:GetVehicle():GetModelId()] then
		Chat:Send(args.player, "You need to be in a plane or helicopter to do that!", Color(255, 255, 255))
		return false
	else return true
	end
end

Planecrash = Planecrash()