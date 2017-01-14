class "passive"

--Chat:Print("Reloaded...", Color.Cyan)

function passive:__init()

	self.active = true

	self.key = nil

	passiveplayers = {}

	Events:Subscribe("LocalPlayerChat", self, self.Enable)

	Events:Subscribe("InputPoll", self, self.OnPassive)

	Events:Subscribe("LocalPlayerBulletHit", self, self.BlockBullet)
	Events:Subscribe("LocalPlayerExplosionHit", self, self.BlockExplosion)
	Events:Subscribe("LocalPlayerForcePulseHit", self, self.BlockForce)

	Events:Subscribe("LocalPlayerEnterVehicle", self, self.EnterVehicle)
	Events:Subscribe("LocalPlayerExitVehicle", self, self.EnterVehicle)

	--Events:Subscribe("VehicleCollide", self, self.OnVehicleHit)

	Network:Subscribe("passiveplayers", self, self.List)

	Events:Subscribe("Render", self, self.Render)
	Events:Subscribe("Render", self, self.TwoDRender)

	Events:Subscribe("KeyDown", self, self.KeyCheck)
	Network:Subscribe("CheckPlayerRam", self, self.CheckPlayerRam)
	Network:Subscribe("ConfirmedPlayerRam", self, self.OnConfirmedRam)

end

function passive:Enable(args)

	if args.text == "/pvp" and LocalPlayer:GetValue("Bounty") == nil then

		self.active = not self.active

		if self.active then

			Network:Send("Passive", LocalPlayer)

			Chat:Print("PVP", Color.White, " OFF", Color.Red)

		else

			Network:Send("NotPassive", LocalPlayer)

			Chat:Print("PVP", Color.White, " ON", Color.Lime)

		end

	end

end

function passive:OnPassive(args)

	if self.active then

		if Input:GetValue(11) > 0 then

			Input:SetValue(11, 0)

		end

		if Input:GetValue(12) > 0 then

			Input:SetValue(12, 0)

		end

		if Input:GetValue(13) > 0 then

			Input:SetValue(13, 0)

		end

		if Input:GetValue(14) > 0 then

			Input:SetValue(14, 0)

		end

		if Input:GetValue(137) > 0 then

			Input:SetValue(137, 0)

		end

		if Input:GetValue(138) > 0 then

			Input:SetValue(138, 0)

		end

		if Input:GetValue(139) > 0 then

			Input:SetValue(139, 0)

		end

	end

end

function passive:BlockBullet()

	if self.active then return false end

end

function passive:BlockExplosion()

	if self.active then return false end

end

function passive:BlockForce()

	if self.active then return false end

end

function passive:EnterVehicle(args)

	if self.active then

		Network:Send("VehicleInvulnerable", args.vehicle)

	end

end

function passive:ExitVehicle(args)

	if self.active then

		Network:Send("VehicleVulnerable", args.vehicle)

	end

end

function passive:OnVehicleHit(args)

	if args.player == LocalPlayer and self.active then

		if LocalPlayer:GetBaseState() == 250 or
		LocalPlayer:GetBaseState() == 251 or
		LocalPlayer:GetBaseState() == 253 then

			LocalPlayer:SetBaseState(6)

		end

	end

	if args.attacker:GetDriver() == LocalPlayer and self.active and args.player ~= nil and LocalPlayer:GetLinearVelocity():Length() > 2 and not args.player:GetValue("Passive") then

		if args.player:GetVehicle() == nil then

			if args.player:GetBaseState() ~= (43 or 80 or 81 or 82 or 83 or 88 or 151 or 152 or 270 or 271 or 273 or 274 or 275 or 457 or 459 or 460 or 461 or 464 or 467) then

				Network:Send("CheckPlayerRam", args.player)

			end

		else self:OnConfirmedRam() end

	end

end

function passive:OnConfirmedRam()

	if timer == nil then timer = Timer() end

	if timer:GetSeconds() < 3 then return end

	if count == nil or count == 0 then

		count = 1

		Chat:Print("Don't ram players whilst in passive!", Color.Red)

		timer:Restart()

	elseif count == 1 then

		self.active = false

		Chat:Print("Passive OFF", Color.Red)
		Network:Send("NotPassive", LocalPlayer)

		timer:Restart()

	elseif count >= 2 then

		count = 0
		self.active = false

		Chat:Print("Passive OFF", Color.Red)
		Network:Send("NotPassive", LocalPlayer)
		Network:Send("Kill", LocalPlayer)

		timer:Restart()

	end

end


function passive:Render()

	if self.active and LocalPlayer:GetValue("Bounty") ~= nil then

		self.active = false
		Network:Send("NotPassive", LocalPlayer)

	end

	if Game:GetState() ~= GUIState.Game then return end

	for _,v in pairs(passiveplayers) do

		for p in Client:GetStreamedPlayers() do

			if not IsValid(v) then return end

			if p ~= v then

				local pos2d, success = Render:WorldToScreen(v:GetBonePosition( "ragdoll_Head" ) + (v:GetAngle() * Vector3(0, 0.25, 0)))

				if success then

					print(tostring(p))

					local dist = LocalPlayer:GetPosition():Distance(p:GetPosition())

					local c = Color.Magenta

					local limit = 500

					local bias = 50

					local max = 750

					local scale = self:CalculateAlpha(dist, bias, max, limit)

					if scale == nil then return end

					local text = "[Hostile]"

					local s = Render:GetTextSize(text, TextSize.Default, scale)

					local pos2d = pos2d - Vector2(s.x/2, s.y) - Vector2(0, 10)

					c.a = scale * 255
					
					Render:DrawText(pos2d + Vector2(2, 2), text, Color(20, 20, 20, c.a * 0.3), TextSize.Default, scale)
					Render:DrawText(pos2d + Vector2(1, 1), text, Color(20, 20, 20, c.a * 0.6), TextSize.Default, scale)

    				Render:DrawText(pos2d, text, Color(c.r, c.g, c.b, c.a), TextSize.Default, scale)

    			end

			end

		break

		end

	end

end

function passive:TwoDRender()

	if not self.active then return end

	local s = Render:GetTextSize("Passive", 30)

	Render:DrawText(Vector2(Render.Size.x * 0.95 - s.x + 2, Render.Size.y * 0.1 - s.y + 2), "Passive", Color(20, 20, 20, 55), 30)
	Render:DrawText(Vector2(Render.Size.x * 0.95 - s.x + 1, Render.Size.y * 0.1 - s.y + 1), "Passive", Color(20, 20, 20, 155), 30)
	Render:DrawText(Vector2(Render.Size.x * 0.95 - s.x, Render.Size.y * 0.1 - s.y), "Passive", Color.Magenta, 30)
	
end

function passive:List(list)

	passiveplayers = list

end

function passive:CalculateAlpha( dist, bias, max, limit )

    if dist > limit then return nil end

    local alpha = 1

    if dist > bias then
        alpha =  1.0 - ( dist - bias ) /
                       ( max  - bias )
    end

    return alpha

end

function passive:KeyCheck(args)

	self.key = args.key

end

function passive:CheckPlayerRam(attacker, sender)

	if self.key ~= nil and self.key ~= VirtualKey.Space then

		Network:Send("ConfirmedPlayerRam", attacker)

	end

end

passive = passive()