airports = {}
--Add admins by adding SteamId(<steamid in quotes>)
staffmembers = {}

local query = SQL:Query("SELECT * FROM acl_members")
local result = query:Execute()
if #result > 0 then
	for _, member in ipairs(result) do
		table.insert(staffmembers, member.steamID)
	end
end

groups = {}

--INTERNATIONAL AIRPORT
	airports.ap1 = {}
	airports.ap1.Runways = {}
	airports.ap1.Runways.r1 = {}
	airports.ap1.Runways.r2 = {}

	airports.ap1.Name = "Panau International Airport"
	airports.ap1.Code = "ap1"
	airports.ap1.Location = Vector3(-6802, 208, -3626)

	--RUNWAY 1
	airports.ap1.Runways.r1.Name = "E - W Runway 1 (09 - 27)"
	airports.ap1.Runways.r1.Location = Vector3(-6256, 209, -3003)
	airports.ap1.Runways.r1.Status = "Open"
	airports.ap1.Runways.r1.UsedBy = nil
	airports.ap1.Runways.r1.Code = "r1"
	airports.ap1.Runways.r1.Enabled = true

	--RUNWAY 2
	airports.ap1.Runways.r2.Name = "SW - NE Runway 2 (04 - 22)"
	airports.ap1.Runways.r2.Location = Vector3(-6205, 209, -3370)
	airports.ap1.Runways.r2.Status = "Open"
	airports.ap1.Runways.r2.UsedBy = nil
	airports.ap1.Runways.r2.Code = "r2"
	airports.ap1.Runways.r2.Enabled = true
--END INTERNATIONAL AIRPORT

--AIRPORT 2
	airports.ap2 = {}
	airports.ap2.Runways = {}
	airports.ap2.Runways.r1 = {}
	airports.ap2.Runways.r2 = {}

	airports.ap2.Name = "Airport 2"
	airports.ap2.Code = "ap2"
	airports.ap2.Location = Vector3(-307, 313, 7098)

	--RUNWAY 1
	airports.ap2.Runways.r1.Name = "WNW - ESE Runway 1"
	airports.ap2.Runways.r1.Location = Vector3(-236, 295, 7139)
	airports.ap2.Runways.r1.Status = "Open"
	airports.ap2.Runways.r1.UsedBy = nil
	airports.ap2.Runways.r1.Code = "r1"
	airports.ap2.Runways.r1.Enabled = true

	--RUNWAY 2
	airports.ap2.Runways.r2.Name = "WNW - ESE Runway 2"
	airports.ap2.Runways.r2.Location = Vector3(-236, 295, 7079)
	airports.ap2.Runways.r2.Status = "Open"
	airports.ap2.Runways.r2.UsedBy = nil
	airports.ap2.Runways.r2.Code = "r2"
	airports.ap2.Runways.r2.Enabled = true
--END AIRPORT 2

--AIRPORT 3
	airports.ap3 = {}
	airports.ap3.Runways = {}
	airports.ap3.Runways.r1 = {}
	airports.ap3.Runways.r2 = {}

	airports.ap3.Name = "Airport 3"
	airports.ap3.Code = "ap3"
	airports.ap3.Location = Vector3(5827, 250, 6988)

	--RUNWAY 1
	airports.ap3.Runways.r1.Name = "N - S Runway"
	airports.ap3.Runways.r1.Location = Vector3(6044, 251, 6713)
	airports.ap3.Runways.r1.Status = "Open"
	airports.ap3.Runways.r1.UsedBy = nil
	airports.ap3.Runways.r1.Code = "r1"
	airports.ap3.Runways.r1.Enabled = true

	--RUNWAY 2
	airports.ap3.Runways.r2.Name = "E - W Runway"
	airports.ap3.Runways.r2.Location = Vector3(5832, 251, 7159)
	airports.ap3.Runways.r2.Status = "Open"
	airports.ap3.Runways.r2.UsedBy = nil
	airports.ap3.Runways.r2.Code = "r2"
	airports.ap3.Runways.r2.Enabled = true
--END AIRPORT 3

--DESERT AIRPORT 1
	airports.dap1 = {}
	airports.dap1.Runways = {}
	airports.dap1.Runways.r1 = {}
	airports.dap1.Runways.r2 = {}
	airports.dap1.Runways.r3 = {}

	airports.dap1.Name = "Desert Airport 1"
	airports.dap1.Code = "dap1"
	airports.dap1.Location = Vector3(-12127, 610, 4638)

	--RUNWAY 1
	airports.dap1.Runways.r1.Name = "NNE - SSW Runway 1 (03R - 21L)"
	airports.dap1.Runways.r1.Location = Vector3(-11970, 611, 4490)
	airports.dap1.Runways.r1.Status = "Open"
	airports.dap1.Runways.r1.UsedBy = nil
	airports.dap1.Runways.r1.Code = "r1"
	airports.dap1.Runways.r1.Enabled = true

	--RUNWAY 2
	airports.dap1.Runways.r2.Name = "NNE - SSW Runway 2 (03L - 21R)"
	airports.dap1.Runways.r2.Location = Vector3(-12106, 611, 4412)
	airports.dap1.Runways.r2.Status = "Open"
	airports.dap1.Runways.r2.UsedBy = nil
	airports.dap1.Runways.r2.Code = "r2"
	airports.dap1.Runways.r2.Enabled = true

	--RUNWAY 3
	airports.dap1.Runways.r3.Name = "WNW - ESE Runway (12 - 30)"
	airports.dap1.Runways.r3.Location = Vector3(-11968, 611, 4996)
	airports.dap1.Runways.r3.Status = "Open"
	airports.dap1.Runways.r3.UsedBy = nil
	airports.dap1.Runways.r3.Code = "r3"
	airports.dap1.Runways.r3.Enabled = true
--END DESERT AIRPORT 1

--DESERT AIRPORT 2
	airports.dap2 = {}
	airports.dap2.Runways = {}
	airports.dap2.Runways.r1 = {}

	airports.dap2.Name = "Desert Airport 2"
	airports.dap2.Code = "dap2"
	airports.dap2.Location = Vector3(-7480, 1131, 11556)

	--RUNWAY 1
	airports.dap2.Runways.r1.Name = "NW - SE Runway"
	airports.dap2.Runways.r1.Location = Vector3(-6894, 1050, 11801)
	airports.dap2.Runways.r1.Status = "Open"
	airports.dap2.Runways.r1.UsedBy = nil
	airports.dap2.Runways.r1.Code = "r1"
	airports.dap2.Runways.r1.Enabled = true
--END DESERT AIRPORT 2

--Teluk Permata Military Airport
	airports.tpma = {}
	airports.tpma.Runways = {}
	airports.tpma.Runways.r1 = {}

	airports.tpma.Name = "Teluk Permata Military Airport"
	airports.tpma.Code = "tpma"
	airports.tpma.Location = Vector3(-6869, 206, -10567)

	--RUNWAY 1
	airports.tpma.Runways.r1.Name = "NW - SE Runway"
	airports.tpma.Runways.r1.Location = Vector3(-6965, 206, -10719)
	airports.tpma.Runways.r1.Status = "Open"
	airports.tpma.Runways.r1.UsedBy = nil
	airports.tpma.Runways.r1.Code = "r1"
	airports.tpma.Runways.r1.Enabled = true
--END Teluk Permata Military Airport

--Banjaran Gundin Military Airport
	airports.bgma = {}
	airports.bgma.Runways = {}
	airports.bgma.Runways.r1 = {}

	airports.bgma.Name = "Banjaran Gundin Military Airport"
	airports.bgma.Code = "bgma"
	airports.bgma.Location = Vector3(-4528, 434, -11471)

	--RUNWAY 1
	airports.bgma.Runways.r1.Name = "SW - NE Runway"
	airports.bgma.Runways.r1.Location = Vector3(-4821, 405, -11439)
	airports.bgma.Runways.r1.Status = "Open"
	airports.bgma.Runways.r1.UsedBy = nil
	airports.bgma.Runways.r1.Code = "r1"
	airports.bgma.Runways.r1.Enabled = true
--END Banjaran Gundin Military Airport

--Sungai Cengkih Besar Military Airport
	airports.scbma = {}
	airports.scbma.Runways = {}
	airports.scbma.Runways.r1 = {}
	airports.scbma.Runways.r2 = {}

	airports.scbma.Name = "Sungai Cengkih Besar Military Airport"
	airports.scbma.Code = "scbma"
	airports.scbma.Location = Vector3(4498.164062, 213.065933, -10625.275391)

	--RUNWAY 1
	airports.scbma.Runways.r1.Name = "WNW - ESE Runway"
	airports.scbma.Runways.r1.Location = Vector3(4404.957520, 208.373535, -10739.606445)
	airports.scbma.Runways.r1.Status = "Open"
	airports.scbma.Runways.r1.UsedBy = nil
	airports.scbma.Runways.r1.Code = "r1"
	airports.scbma.Runways.r1.Enabled = true

	--RUNWAY 2
	airports.scbma.Runways.r2.Name = "NNE - SSW Runway"
	airports.scbma.Runways.r2.Location = Vector3(4592.698730, 208.339966, -10733.783203)
	airports.scbma.Runways.r2.Status = "Open"
	airports.scbma.Runways.r2.UsedBy = nil
	airports.scbma.Runways.r2.Code = "r2"
	airports.scbma.Runways.r2.Enabled = true
--END Sungai Cengkih Besar Military Airport

--Paya Luas Military Airport
	airports.plma = {}
	airports.plma.Runways = {}
	airports.plma.Runways.r1 = {}
	airports.plma.Runways.r2 = {}

	airports.plma.Name = "Paya Luas Military Airport"
	airports.plma.Code = "plma"
	airports.plma.Location = Vector3(12126.319336, 206.576889, -10664.407227)

	--RUNWAY 1
	airports.plma.Runways.r1.Name = "N - S Runway Runway 1"
	airports.plma.Runways.r1.Location = Vector3(12171.366211, 206.881302, -10519.047852)
	airports.plma.Runways.r1.Status = "Open"
	airports.plma.Runways.r1.UsedBy = nil
	airports.plma.Runways.r1.Code = "r1"
	airports.plma.Runways.r1.Enabled = true

	--RUNWAY 2
	airports.plma.Runways.r2.Name = "E - W Runway Runway 2"
	airports.plma.Runways.r2.Location = Vector3(11666.494141, 206.816544, -10713.845703)
	airports.plma.Runways.r2.Status = "Open"
	airports.plma.Runways.r2.UsedBy = nil
	airports.plma.Runways.r2.Code = "r2"
	airports.plma.Runways.r2.Enabled = true
--END Paya Luas Military Airport

--Lembah Delima Military Airport
	airports.ldma = {}
	airports.ldma.Runways = {}
	airports.ldma.Runways.r1 = {}

	airports.ldma.Name = "Lembah Delima Military Airport"
	airports.ldma.Code = "ldma"
	airports.ldma.Location = Vector3(9526.493164, 214.415009, 3786.812988)

	--RUNWAY 1
	airports.ldma.Runways.r1.Name = "NW - SE Runway (14 - 32)"
	airports.ldma.Runways.r1.Location = Vector3(9644.498047, 204.776703, 3818.911865)
	airports.ldma.Runways.r1.Status = "Open"
	airports.ldma.Runways.r1.UsedBy = nil
	airports.ldma.Runways.r1.Code = "r1"
	airports.ldma.Runways.r1.Enabled = true
--END Lembah Delima Military Airport

--Cape Carnival Military Airport
	airports.ccma = {}
	airports.ccma.Runways = {}
	airports.ccma.Runways.r1 = {}
	airports.ccma.Runways.r2 = {}

	airports.ccma.Name = "Cape Carnival Military Airport"
	airports.ccma.Code = "ccma"
	airports.ccma.Location = Vector3(13780.503906, 260.339935, -2320.248047)

	--RUNWAY 1
	airports.ccma.Runways.r1.Name = "SSE - NNW Runway 1"
	airports.ccma.Runways.r1.Location = Vector3(13829.514648, 259.294357, -2417.442871)
	airports.ccma.Runways.r1.Status = "Open"
	airports.ccma.Runways.r1.UsedBy = nil
	airports.ccma.Runways.r1.Code = "r1"
	airports.ccma.Runways.r1.Enabled = true

	--RUNWAY 2
	airports.ccma.Runways.r2.Name = "SSE - NNW Runway 2"
	airports.ccma.Runways.r2.Location = Vector3(13663.984375, 259.294357, -2319.651123)
	airports.ccma.Runways.r2.Status = "Open"
	airports.ccma.Runways.r2.UsedBy = nil
	airports.ccma.Runways.r2.Code = "r2"
	airports.ccma.Runways.r2.Enabled = true
--END Cape Carnival Military Airport

--Kem Sungai Sejuk Military Airport
	airports.kssma = {}
	airports.kssma.Runways = {}
	airports.kssma.Runways.r1 = {}

	airports.kssma.Name = "Kem Sungai Sejuk Military Airport"
	airports.kssma.Code = "kssma"
	airports.kssma.Location = Vector3(827.527161, 303.839569, -4185.982422)

	--RUNWAY 1
	airports.kssma.Runways.r1.Name = "NE - SW Runway"
	airports.kssma.Runways.r1.Location = Vector3(827.527161, 298.839569, -4185.982422)
	airports.kssma.Runways.r1.Status = "Open"
	airports.kssma.Runways.r1.UsedBy = nil
	airports.kssma.Runways.r1.Code = "r1"
	airports.kssma.Runways.r1.Enabled = true
--END Kem Sungai Sejuk Military Airport

function takeoff(sender, id)
	for ak, av in pairs(airports) do
		for rk, rv in pairs(av.Runways) do
			if id == ak .. "." .. rk then
				if airports[ak].Runways[rk].Enabled == false then
					Chat:Send(sender, airports[ak].Runways[rk].Name .. ", " .. airports[ak].Name .. " is closed!", Color(255, 0, 0))
					return
				end
				if Vector3.Distance(sender:GetPosition(), airports[ak].Runways[rk].Location) > 700 then
					Chat:Send(sender, "You need to be within 700 metres to request a takeoff!", Color(0, 255, 255))
					return false
				else
					if airports[ak].Runways[rk].Status == "Open" then
						airports[ak].Runways[rk].Status = "Takeoff"
						airports[ak].Runways[rk].UsedBy = sender
						for p in Server:GetPlayers() do
							if not p:GetValue("blockatcmessages") or sender == p then
								messageData = {}
								messageData.message = tostring(sender) .. " scheduled takeoff," .. airports[ak].Runways[rk].Name .. ", " .. airports[ak].Name
								Network:Send(p, "receiveMessage", messageData)
							end
						end
						return false
					else
						Chat:Send(sender, airports[ak].Runways[rk].Name .. " is in use", Color(0, 255, 255))
						return false
					end
				end
			end
		end
	end
end

function land(sender, id)
	for ak, av in pairs(airports) do
		for rk, rv in pairs(av.Runways) do
			if id == ak .. "." .. rk then
				if airports[ak].Runways[rk].Enabled == false then
					Chat:Send(sender, airports[ak].Runways[rk].Name .. ", " .. airports[ak].Name .. " is closed!", Color(255, 0, 0))
					return
				end
				if airports[ak].Runways[rk].Status == "Open" then
					airports[ak].Runways[rk].Status = "Landing"
					airports[ak].Runways[rk].UsedBy = sender
					for p in Server:GetPlayers() do
						if not p:GetValue("blockatcmessages") or sender == p then
							messageData = {}
							messageData.message = tostring(sender) .. " scheduled landing," .. airports[ak].Runways[rk].Name .. ", " .. airports[ak].Name
							Network:Send(p, "receiveMessage", messageData)
						end
					end
					return false
				else
					Chat:Send(sender, airports.ap1.Runways.r1.Name .. " is in use", Color(0, 255, 255))
					return false
				end
			end
		end
	end
end

function tp(sender, id)
	for ak, av in pairs(airports) do
		if id == ak then
			sender:Teleport(airports[ak].Location, Angle(0, 0, 0))
			return false
		end
		for rk, rv in pairs(av.Runways) do
			if id == ak .. "." .. rk then
				sender:Teleport(airports[ak].Runways[rk].Location, Angle(0, 0, 0))
				return false
			end
		end
	end
end

function openRunway(sender, id)
	for ak, av in pairs(airports) do
		for rk, rv in pairs(av.Runways) do
			if id == ak .. "." .. rk then
				if airports[ak].Runways[rk].Enabled == false then
					Chat:Send(sender, airports[ak].Runways[rk].Name .. ", " .. airports[ak].Name .. " is closed!", Color(255, 0, 0))
					return
				end
				if (airports[ak].Runways[rk].UsedBy == sender or isAdmin(sender)) and airports[ak].Runways[rk].Status ~= "Open" then
					airports[ak].Runways[rk].Status = "Open"
					airports[ak].Runways[rk].UsedBy = nil
					for p in Server:GetPlayers() do
						if not p:GetValue("blockatcmessages") or sender == p then
							messageData = {}
							messageData.message = tostring(sender) .. " opened," .. airports[ak].Runways[rk].Name .. ", " .. airports[ak].Name
							Network:Send(p, "receiveMessage", messageData)
						end
					end
					return false
				else
					if airports[ak].Runways[rk].UsedBy ~= sender then
						Chat:Send(sender, "You do not have permission to open runway " .. id .. "!", Color(0, 255, 255))
						return false
					else
						if airports[ak].Runways[rk].Status == "Open" then
							Chat:Send(sender, "Runway " .. id .. " is already open!", Color(0, 255, 255))
							return false
						end
					end
				end
			end
		end
	end
end

function getRunwayData(sender)
	runways = {}

	runways.ap1 = {}
	runways.ap1.r1 = {}
	runways.ap1.r1.Status = airports.ap1.Runways.r1.Status
	runways.ap1.r1.UsedBy = airports.ap1.Runways.r1.UsedBy
	runways.ap1.r1.Enabled = airports.ap1.Runways.r1.Enabled
	runways.ap1.r2 = {}
	runways.ap1.r2.Status = airports.ap1.Runways.r2.Status
	runways.ap1.r2.UsedBy = airports.ap1.Runways.r2.UsedBy
	runways.ap1.r2.Enabled = airports.ap1.Runways.r2.Enabled

	runways.ap2 = {}
	runways.ap2.r1 = {}
	runways.ap2.r1.Status = airports.ap2.Runways.r1.Status
	runways.ap2.r1.UsedBy = airports.ap2.Runways.r1.UsedBy
	runways.ap2.r1.Enabled = airports.ap2.Runways.r1.Enabled
	runways.ap2.r2 = {}
	runways.ap2.r2.Status = airports.ap2.Runways.r2.Status
	runways.ap2.r2.UsedBy = airports.ap2.Runways.r2.UsedBy
	runways.ap2.r2.Enabled = airports.ap2.Runways.r2.Enabled

	runways.ap3 = {}
	runways.ap3.r1 = {}
	runways.ap3.r1.Status = airports.ap3.Runways.r1.Status
	runways.ap3.r1.UsedBy = airports.ap3.Runways.r1.UsedBy
	runways.ap3.r1.Enabled = airports.ap3.Runways.r1.Enabled
	runways.ap3.r2 = {}
	runways.ap3.r2.Status = airports.ap3.Runways.r2.Status
	runways.ap3.r2.UsedBy = airports.ap3.Runways.r2.UsedBy
	runways.ap3.r2.Enabled = airports.ap3.Runways.r2.Enabled

	runways.dap1 = {}
	runways.dap1.r1 = {}
	runways.dap1.r1.Status = airports.dap1.Runways.r1.Status
	runways.dap1.r1.UsedBy = airports.dap1.Runways.r1.UsedBy
	runways.dap1.r1.Enabled = airports.dap1.Runways.r1.Enabled
	runways.dap1.r2 = {}
	runways.dap1.r2.Status = airports.dap1.Runways.r2.Status
	runways.dap1.r2.UsedBy = airports.dap1.Runways.r2.UsedBy
	runways.dap1.r2.Enabled = airports.dap1.Runways.r2.Enabled
	runways.dap1.r3 = {}
	runways.dap1.r3.Status = airports.dap1.Runways.r3.Status
	runways.dap1.r3.UsedBy = airports.dap1.Runways.r3.UsedBy
	runways.dap1.r3.Enabled = airports.dap1.Runways.r3.Enabled

	runways.dap2 = {}
	runways.dap2.r1 = {}
	runways.dap2.r1.Status = airports.dap2.Runways.r1.Status
	runways.dap2.r1.UsedBy = airports.dap2.Runways.r1.UsedBy
	runways.dap2.r1.Enabled = airports.dap2.Runways.r1.Enabled

	runways.tpma = {}
	runways.tpma.r1 = {}
	runways.tpma.r1.Status = airports.tpma.Runways.r1.Status
	runways.tpma.r1.UsedBy = airports.tpma.Runways.r1.UsedBy
	runways.tpma.r1.Enabled = airports.tpma.Runways.r1.Enabled

	runways.bgma = {}
	runways.bgma.r1 = {}
	runways.bgma.r1.Status = airports.bgma.Runways.r1.Status
	runways.bgma.r1.UsedBy = airports.bgma.Runways.r1.UsedBy
	runways.bgma.r1.Enabled = airports.bgma.Runways.r1.Enabled

	runways.scbma = {}
	runways.scbma.r1 = {}
	runways.scbma.r1.Status = airports.scbma.Runways.r1.Status
	runways.scbma.r1.UsedBy = airports.scbma.Runways.r1.UsedBy
	runways.scbma.r1.Enabled = airports.scbma.Runways.r1.Enabled
	runways.scbma.r2 = {}
	runways.scbma.r2.Status = airports.scbma.Runways.r2.Status
	runways.scbma.r2.UsedBy = airports.scbma.Runways.r2.UsedBy
	runways.scbma.r2.Enabled = airports.scbma.Runways.r2.Enabled

	runways.plma = {}
	runways.plma.r1 = {}
	runways.plma.r1.Status = airports.plma.Runways.r1.Status
	runways.plma.r1.UsedBy = airports.plma.Runways.r1.UsedBy
	runways.plma.r1.Enabled = airports.plma.Runways.r1.Enabled
	runways.plma.r2 = {}
	runways.plma.r2.Status = airports.plma.Runways.r2.Status
	runways.plma.r2.UsedBy = airports.plma.Runways.r2.UsedBy
	runways.plma.r2.Enabled = airports.plma.Runways.r2.Enabled

	runways.ldma = {}
	runways.ldma.r1 = {}
	runways.ldma.r1.Status = airports.ldma.Runways.r1.Status
	runways.ldma.r1.UsedBy = airports.ldma.Runways.r1.UsedBy
	runways.ldma.r1.Enabled = airports.ldma.Runways.r1.Enabled

	runways.ccma = {}
	runways.ccma.r1 = {}
	runways.ccma.r1.Status = airports.ccma.Runways.r1.Status
	runways.ccma.r1.UsedBy = airports.ccma.Runways.r1.UsedBy
	runways.ccma.r1.Enabled = airports.ccma.Runways.r1.Enabled
	runways.ccma.r2 = {}
	runways.ccma.r2.Status = airports.ccma.Runways.r2.Status
	runways.ccma.r2.UsedBy = airports.ccma.Runways.r2.UsedBy
	runways.ccma.r2.Enabled = airports.ccma.Runways.r2.Enabled

	runways.kssma = {}
	runways.kssma.r1 = {}
	runways.kssma.r1.Status = airports.kssma.Runways.r1.Status
	runways.kssma.r1.UsedBy = airports.kssma.Runways.r1.UsedBy
	runways.kssma.r1.Enabled = airports.kssma.Runways.r1.Enabled

	if sender:GetName() ~= nil then
		Network:Send(sender, "recieveRunwayData", runways)
	end
end

function playerQuit(args)
    --AP1
	if airports.ap1.Runways.r1.UsedBy == args.player then
		openRunway(args.player, "ap1.r1")
	end
	if airports.ap1.Runways.r2.UsedBy == args.player then
		openRunway(args.player, "ap1.r2")
	end
	--AP2
	if airports.ap2.Runways.r1.UsedBy == args.player then
		openRunway(args.player, "ap2.r1")
	end
	if airports.ap2.Runways.r2.UsedBy == args.player then
		openRunway(args.player, "ap2.r2")
	end
	--AP3
	if airports.ap3.Runways.r1.UsedBy == args.player then
		openRunway(args.player, "ap3.r1")
	end
	if airports.ap3.Runways.r2.UsedBy == args.player then
		openRunway(args.player, "ap3.r2")
	end
	--DAP1
	if airports.dap1.Runways.r1.UsedBy == args.player then
		openRunway(args.player, "dap1.r1")
	end
	if airports.dap1.Runways.r2.UsedBy == args.player then
		openRunway(args.player, "dap1.r2")
	end
	if airports.dap1.Runways.r3.UsedBy == args.player then
		openRunway(args.player, "dap1.r3")
	end
	--DAP2
	if airports.dap2.Runways.r1.UsedBy == args.player then
		openRunway(args.player, "dap2.r1")
	end
	--TPMA
	if airports.tpma.Runways.r1.UsedBy == args.player then
		openRunway(args.player, "tpma.r1")
	end
    --BGMA
	if airports.bgma.Runways.r1.UsedBy == args.player then
		openRunway(args.player, "bgma.r1")
	end
	--ccma
	if airports.ccma.Runways.r1.UsedBy == args.player then
		openRunway(args.player, "ccma.r1")
	end
	if airports.ccma.Runways.r2.UsedBy == args.player then
		openRunway(args.player, "ccma.r2")
	end
end

function PlayerChat(args)
	if args.text == "/atcmessages" then
		local val = args.player:GetValue("blockatcmessages")
		if val == nil then
			val = true
		elseif val == true then
			val = nil
		end
		args.player:SetValue("blockatcmessages", val)
		if val == nil then
			val = ""
		elseif val == true then
			val = " not"
		end
		Chat:Send(args.player, "You will"..val.." receive ATC messages.", Color.White)
		return false
	end
end

function isAdmin(player)
	local returns = false
    for _, v in pairs(staffmembers) do
		if player:GetSteamId().string == v then
			returns = true
		end
	end
	return returns
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function addPlayer(info)
	for gk, gv in pairs(groups) do
		for pk, pv in pairs(gv.Players) do
			if pv == info.Sender and gk == info.Name then
				Chat:Send(info.Sender, "You are already in this group!", Color(255, 0, 0))
				return
			end
		end
	end
	if groups[info.Name] == nil then
		Chat:Send(info.Sender, "No group with that name!")
	else
		groups[info.Name].Players[tablelength(groups[info.Name].Players)] = info.Sender
	end
end

function deletePlayer(info)
	for pk, pv in pairs(groups[info.Name].Players) do
		if pv == info.Sender then
			groups[info.Name].Players[pk] = nil
		end
	end
end

function openRunwayBuffer(info)
	openRunway(info.player, info.id)
end

function reqTakeoff(args)
	takeoff(args.player, args.id)
end

function reqLanding(args)
	land(args.player, args.id)
end

function reqOpening(args)
	openRunway(args.player, args.id)
end

function reqTP(args)
	tp(args.player, args.id)
end

function kill(player, sender)
	local player = sender
	if player:GetVehicle() ~= nil and player then
		for _, p in pairs(staffmembers) do
			if p == player:GetSteamId().string then return end
		end
    Chat:Send(player, "You do not have clearance for this runway!", Color(255, 0, 0))
    player:SetPosition(player:GetVehicle():GetPosition())
    player:GetVehicle():Remove()
	end
end

function lol(info)
	if info:InVehicle() == true then
		--Enable this for lolz (Just me testing stuff :P)
		--info:GetVehicle():SetAngularVelocity(Vector3(0, 1000, 0))
	end
end

function sendServerGps(info)
	print(tostring(info.player) .. ", " .. tostring(info.location))
	Network:Send(info.player, "sendGps", info.location)
end

Events:Subscribe("PlayerQuit", playerQuit)
Events:Subscribe("PlayerChat", PlayerChat)
Network:Subscribe("getRunwayData", getRunwayData)
Network:Subscribe("lol", lol)
Network:Subscribe("RemoveVehicle", kill)
Network:Subscribe("openRunway", openRunwayBuffer)
Network:Subscribe("reqTakeoff", reqTakeoff)
Network:Subscribe("reqLanding", reqLanding)
Network:Subscribe("reqOpening", reqOpening)
Network:Subscribe("reqTP", reqTP)
Network:Subscribe("sendServerGps", sendServerGps)
Network:Subscribe("addPlayer", addPlayer)
Network:Subscribe("deletePlayer", deletePlayer)
Chat:Broadcast("ATC Reloaded, all requests cancelled", Color(0, 255, 255))