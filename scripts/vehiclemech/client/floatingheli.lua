class "floatingheli"

function floatingheli:__init()
	floatvehicles = {[65] = true}

	Events:Subscribe("InputPoll", self, self.float)
	Events:Subscribe("KeyUp", self, self.despawn)
end

function floatingheli:float(args)
	if not spawned then
		if LocalPlayer:InVehicle() then
			local vehicle = LocalPlayer:GetVehicle()
			local modelid = vehicle:GetModelId()
			if floatvehicles[modelid] then
				local pos = vehicle:GetPosition()
				if pos.y <= (199.99 + 1.2) then
					if Key:IsDown(162) then
						spawned = true
						local object = ClientStaticObject.Create({
							position = Vector3(pos.x, (pos.y - 4.1), pos.z),
							angle = Angle(0, 0, 0),
							model = "",--"f1t05bomb01.eez/go126-a.lod",
							collision = "f1t05bomb01.eez/go126_lod1-a_col.pfx"
																	})
						table.insert(objects, object)
					end
				else
					spawned = false
				end
			end
		end
	end
end

function floatingheli:despawn(args)
	local vehicle = LocalPlayer:GetVehicle()
	if args.key == VirtualKey.Shift then
		if IsValid(vehicle) then
			local pos = vehicle:GetPosition()
			if pos.y > 201 then
				if spawned then
					spawned = false
					for index, object in ipairs(objects) do
					if IsValid(object) then
						object:Remove()
					end
					end
				end
			end
		end
	end
end

Events:Subscribe("ModuleLoad", function()
	spawned = false
	objects = {}
end)

Events:Subscribe("ModuleUnload", function()
	for index, object in ipairs(objects) do
		object:Remove()
	end
end)

floatingheli = floatingheli()