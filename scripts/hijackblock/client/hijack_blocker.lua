-- The actions we check for
local actions = { 37, 38, 45, 82, 121, 147, 148, 150 }
-- Don't let them hijack *at all* in these animation states
local always_drop_states = { 207, 208, 324, 221, 222, 270, 272, 273, 440, 50 }

function CheckVehicle( target )
	-- If there is no vehicle, or there's nobody driving it, we have nothing
	-- to worry about
	return target == nil or not IsValid( target ) or not IsValid( target:GetDriver() )
end

function LocalPlayerInput( args )
	-- If the input isn't one of the ones we're checking for, bail out
	if table.find( actions, args.input ) == nil then return true end

	-- Get the player's animation base state, which we can use to determine
	-- if they're in a position to hijack other players
	local base_state = LocalPlayer:GetBaseState()

	-- If it turns out we're in a state and action that's clearly naughty,
	-- drop it and stop them!
	if table.find( always_drop_states, base_state ) ~= nil then return false end

	local state = LocalPlayer:GetState()

	-- Get the local player's current vehicle 
	-- (i.e. the one they're attached/clinging to)
	local vehicle = LocalPlayer:GetVehicle()
	local target = LocalPlayer:GetAimTarget().vehicle

	if CheckVehicle( vehicle ) and CheckVehicle( target ) then return true end

	-- If they're in stunt-pos, or in a certain range of states,
	-- we don't let the local player enter vehicles
	if 	LocalPlayer:GetState() == PlayerState.StuntPos or
		(base_state >= 84 and base_state <= 110) or
		(base_state >= 318 and base_state <= 327) or
		(base_state == 88 or base_state == 327) or
		(base_state == 270 or base_state == 273) or
		(base_state == 207 or base_state == 208) or
		(base_state == 272 or base_state == 222) or 
		(base_state == 273 or base_state == 221) then

		return false
	end

	return true
end

Events:Subscribe("LocalPlayerInput", LocalPlayerInput)