-- Written by [GK7]Nakroma

class 'GK7Motd'
function GK7Motd:__init()
	-- Config
	self.onjoin = true -- Displays everytime someone joins
	self.player = nil

	Events:Subscribe( "PlayerJoin", self, self.PlayerJoin )
	Network:Subscribe( "ClientLoaded", self, self.Send )
	Events:Subscribe( "PlayerChat", self, self.PlayerChat )
end

function GK7Motd:PlayerJoin( args )
	if self.onjoin then
		self.player = args.player
	end
end

function GK7Motd:Send()
	if IsValid(self.player) then
		Network:Send( self.player, "MOTDActive", true )
	end
end

function GK7Motd:PlayerChat( args )
    local cmd_args = args.text:split( " " )

    if cmd_args[1] == "/motd" then -- Change if you want another command

		Network:Send( args.player, "MOTDActive", false)
	
        return false
    end

    return true
end

local gk7_motd = GK7Motd()