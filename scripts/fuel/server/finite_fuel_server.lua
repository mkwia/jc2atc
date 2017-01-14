function table.GetValue(targetTable, object, default)
	for key, value in pairs(targetTable) do
		if IsValid(key) and key == object then return targetTable[key] end
	end
	
	-- Nothing matched, return default
	return default
end

function table.SetValue(targetTable, object, newValue)
	for key, value in pairs(targetTable) do
		if IsValid(key) and key == object then targetTable[key] = newValue return end
	end
	
	-- Nothing was set, create new entry
	targetTable[object] = newValue
end

class "FiniteFuel"

function FiniteFuel:__init()
	-- Store all vehicles fuel
	self.vehiclesFuel = {}
	
	-- Cleanup
	self.removedCheckTimer = Timer()
	self.removedCheckTimeout = 60
	
	-- Events
	Events:Subscribe("PostTick", self, self.PostTick)

	-- Custom events
	Events:Subscribe("BuyVehicle", self, self.BuyVehicle)
	
	-- Networked events
	Network:Subscribe("FiniteFuelGetFuel", self, self.GetFuel)
	Network:Subscribe("FiniteFuelGetFuelSiphon", self, self.GetFuelSiphon)
	Network:Subscribe("FiniteFuelSetFuel", self, self.SetFuel)
	Network:Subscribe("RemoveDriver", self, self.RemoveDriver)
	Network:Subscribe("Repair", self, self.Repair)
end

-- ======================== Get/set fuel ========================
function FiniteFuel:GetFuel(vehicle, player)
	if not IsValid(vehicle) then return end
	
	-- Get vehicle fuel. If nothing set, return tank size
	local fuel = table.GetValue(self.vehiclesFuel, vehicle, nil)
	
	-- Network event
	Network:Send(player, "FiniteFuelGetFuel", {vehicle = vehicle, fuel = fuel})
end

function FiniteFuel:SetFuel(args, player)	
	local vehicle = args.vehicle
	local fuel = args.fuel
	
	-- Check if vehicle is valid, and if the fuel is >= 0
	if not IsValid(vehicle) then return end
	if fuel == nil then fuel = 0 end
	if fuel < 0 then fuel = 0 end
	
	-- Set the vehicle's fuel
	table.SetValue(self.vehiclesFuel, vehicle, fuel)
end

function FiniteFuel:BuyVehicle(vehicle)
	table.SetValue(self.vehiclesFuel, vehicle, "buy")
end

-- ======================== Cleanup ========================
function FiniteFuel:PostTick()
	if self.removedCheckTimer:GetSeconds() < self.removedCheckTimeout then return end
	self.removedCheckTimer:Restart()
	
	for vehicle, fuel in pairs(self.vehiclesFuel) do
		if not IsValid(vehicle) then self.vehiclesFuel[vehicle] = nil end
	end
end

-- ======================== Siphoning =========================
function FiniteFuel:GetFuelSiphon(args, player)
	vehicle1 = args.vehicle1
	vehicle2 = args.vehicle2
	if not IsValid(vehicle1) or not IsValid(vehicle2) then return end

	if vehicle1:GetDriver() ~= nil then
		Chat:Send(vehicle1:GetDriver(), "This vehicle is being siphoned!", Color.Red)
		vehicle1:GetDriver():SetPosition(vehicle1:GetPosition() + Vector3(0, 5, 0))
	end
	if vehicle2:GetDriver() ~= nil then
		Chat:Send(vehicle2:GetDriver(), "This vehicle is being siphoned!", Color.Red)
		vehicle2:GetDriver():SetPosition(vehicle2:GetPosition() + Vector3(0, 5, 0))
	end
	
	-- Get vehicle fuel. If nothing set, return tank size
	local fuel1 = table.GetValue(self.vehiclesFuel, vehicle1, nil)
	local fuel2 = table.GetValue(self.vehiclesFuel, vehicle2, nil)
	
	-- Network event
	Network:Send(player, "FiniteFuelReturnFuelSiphon", {vehicle1 = vehicle1, vehicle2 = vehicle2, fuel1 = fuel1, fuel2 = fuel2})
end

function FiniteFuel:RemoveDriver(args)
	if args.vehicle1:GetDriver() ~= nil then
	Chat:Send(args.vehicle1:GetDriver(), "This vehicle is being siphoned!", Color.Red)
	args.vehicle1:GetDriver():SetPosition(args.vehicle1:GetDriver():GetPosition())
	end
	if args.vehicle2:GetDriver() ~= nil then
	Chat:Send(args.vehicle2:GetDriver(), "This vehicle is being siphoned!", Color.Red)
	args.vehicle2:GetDriver():SetPosition(args.vehicle2:GetDriver():GetPosition())
	end
end

function FiniteFuel:Repair(args)
	if args.cost == nil then
		args.vehicle:SetHealth(1)
	else
		if args.player:GetMoney() < args.cost then
			Chat:Send(args.player, "You don't have enough money!", Color.Red)
		else
			args.player:SetMoney(args.player:GetMoney() - args.cost)
			args.vehicle:SetHealth(1)
		end
	end
end

-- ======================== Initialize ========================
FiniteFuel()















