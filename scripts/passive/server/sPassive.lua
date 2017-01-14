class "passive"

function passive:__init()

	Network:Subscribe("Passive", self, self.AddtoTable)
	Network:Subscribe("NotPassive", self, self.RemovefromTable)

	Network:Subscribe("VehicleInvulnerable", self, self.VehicleInvulnerable)
	Network:Subscribe("VehicleVulnerable", self, self.VehicleVulnerable)

	Network:Subscribe("Kill", self, self.KillPlayer)

	Network:Subscribe("CheckPlayerRam", self, self.RerouteRequest)
	Network:Subscribe("ConfirmedPlayerRam", self, self.RerouteConfirmation)

	Network:Subscribe("PlayerQuit", self, self.Quit)

	passiveplayers = {}

end

function passive:AddtoTable(args, sender)

	sender:SetNetworkValue("Passive", true)

	table.insert(passiveplayers, sender)

	Network:Broadcast("passiveplayers", passiveplayers)

end

function passive:RemovefromTable(args, sender)

	sender:SetNetworkValue("Passive", false)

	local count = 1

	for _,p in pairs(passiveplayers) do

		if not IsValid(p) then

			table.remove(passiveplayers, count)

		elseif p == sender then

			table.remove(passiveplayers, count)

		end

		count = count + 1

	end

	Network:Broadcast("passiveplayers", passiveplayers)

end

function passive:VehicleInvulnerable(vehicle)

	if not IsValid(vehicle) then return end

	vehicle:SetInvulnerable(true)

end

function passive:VehicleVulnerable(vehicle)

	if not IsValid(vehicle) then return end

	vehicle:SetInvulnerable(false)

end

function passive:KillPlayer(player)

	player:SetHealth(0)

end

function passive:RerouteRequest(player, attacker)

	Network:Send(player, "CheckPlayerRam", attacker)

end

function passive:RerouteConfirmation(attacker, sender)

	Network:Send(attacker, "ConfirmedPlayerRam")

end

function passive:Quit(args)

	Network:Send("NotPassive", args.player)

	args.player:SetNetworkValue("Passive", false)
	
end

passive = passive()