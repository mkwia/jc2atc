class "god"

function god:__init ( )

	self.active = false
	self.godTimer = Timer ( )
	self.godlist = { }

end

function god:enable ( )

	Game:FireEvent ( "ply.makeinvulnerable" )
	self.active = true
	if LocalPlayer:InVehicle ( ) then
		Network:Send("GodVehicle", LocalPlayer)
	end
	Network:Send ( "godmodeon", LocalPlayer:GetSteamId ( ).string )

end

function god:disable ( )

	Game:FireEvent ( "ply.makevulnerable" )
	self.active = false
	if LocalPlayer:InVehicle ( ) then
		Network:Send("UnGodVehicle", LocalPlayer)
	end
	Network:Send ( "godmodeoff", LocalPlayer:GetSteamId ( ).string )

end

function god:updategodlist ( list )

	self.godlist = list

end

function god:requestlist ( )

	return self.godlist

end

function god:godtimer ( )

	if not IsValid ( self.godTimer ) then return false end

	local r = self.godTimer:GetSeconds ( ) > 10

	if r then self.godTimer:Restart ( ) end

	return r

end