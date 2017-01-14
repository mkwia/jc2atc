class "Money"
function Money:__init()
	self.player = {}
	
	self.moneyDrops = {}
	self.nearest = nil
	self.effect = nil
	
	Events:Subscribe("Render", self, self.Render)
    Events:Subscribe("PostTick", self, self.Update)
    --Events:Subscribe("ModuleUnload", self, self.ModuleUnload)
    --Events:Subscribe("ModuleLoad", self, self.ModuleLoad)
	Events:Subscribe("KeyDown", self, self.KeyDownEvent)
	Events:Subscribe("LocalPlayerChat", self, self.LocalPlayerChat)
	
	Network:Subscribe("Money_GetTerrainHeight", self, self.TerrainHeight)
	Network:Subscribe("Money_Moneydrop", self, self.Money_Moneydrop)
end

function Money:LocalPlayerChat(args)
	local msg = args.text
	
	msg = msg .. " "
	local sep = " "
	fields = {msg:match((msg:gsub("[^"..sep.."]*"..sep, "([^"..sep.."]*)"..sep)))}
	
	--[[
	if fields[1] == "/util" and fields[2] == "tp" and self.assTargetEntity~=nil then
		local target = nil
		if tonumber(fields[3])==nil then
			for player in Client:GetPlayers() do
				if string.match(player:GetName():lower(), fields[3]:lower()) then
					target = player
				end
			end
		else
			target = Player.GetById(tonumber(fields[3]))
		end
		if target:GetId()==self.assTargetEntity:GetId() then
			Chat:Print("[Util] You cant tp to your Assassination Target!", Color.LightBlue)
			return false
		end
	end
	]]
	return true
end

function Money:Money_Moneydrop(args)
	local id = args.id
	local pos = args.pos
	--[[if pos ~= nil then
		print(tostring(pos.x.." "..pos.y.." "..pos.z))
	end]]
	self.moneyDrops[id] = pos
end

function Money:TerrainHeight(pos)
	Network:Send("Money_SetTerrainHeight", Vector3(pos.x, Physics:GetTerrainHeight(pos), pos.y))
end

function Money:Render()
	if self.money==-1 then return end
    if Game:GetState() ~= GUIState.Game then return end
	
	local texts = {}
	local index = 1
	index = 2
	if self.nearest~=-1 then
		local drop = self.moneyDrops[self.nearest]
		local distance = drop:Distance(LocalPlayer:GetPosition())
		if distance>500 then
			texts[index] = "Money Drop Distance: "..round(distance,0).." metres"
		else
			texts[index] = "Money Drop Distance: Jammer active. Find the smoke!"
		end
	
		for key, text in pairs(texts) do
			local text_width = Render:GetTextWidth( text, TextSize.Default )
			local text_height = Render:GetTextHeight( text, TextSize.Default )
			
			local pos = Vector2((Render.Width/2 - (text_width / 2)), 10+text_height*key)
			if distance > 19000 then
				Render:DrawText( pos + Vector2(2, 2), text, Color(20, 20, 20, 85), TextSize.Default )
				Render:DrawText( pos + Vector2(1, 1), text, Color(10, 10, 10, 170), TextSize.Default )
				Render:DrawText( pos, text, Color.Red, TextSize.Default )

			else
				Render:DrawText( pos + Vector2(2, 2), text, Color(20, 20, 20, 85), TextSize.Default )
				Render:DrawText( pos + Vector2(1, 1), text, Color(10, 10, 10, 170), TextSize.Default )
				Render:DrawText( pos, text, Color( (255 * distance / 20000), 0, (255 * distance / 20000) * -1 ), TextSize.Default )
			end
		end
	end
end

function Money:Update()
	local nearest = -1
	for key, pos in pairs(self.moneyDrops) do
		if nearest == -1 or self.moneyDrops[nearest]:Distance(LocalPlayer:GetPosition())>pos:Distance(LocalPlayer:GetPosition()) then
			nearest = key
		end
	end
	self.nearest = nearest
	
	if IsValid(self.effect) then self.effect:Remove() end
	if nearest~=-1 then
		local args = {}
		args.position = self.moneyDrops[nearest]
		args.angle = Angle()
		args.effect_id = 130
		self.effect = ClientEffect.Create(AssetLocation.Game, args)
	end
end

function Money:KeyDownEvent(args)
	local key = args.key
	
end

--[[function Money:ModuleLoad()
	Events:Fire( "HelpAddItem",
        {
            name = "Money",
            text = 
                "Basic Description:\n" ..
				" .\n"..
				"\n"..
				"Commands:\n"..
				"Type \"/ \" .\n"..
				"Type \"/ \" .\n"..
				"Type \"/ \" .\n"..
				"Type \"/ \" .\n"..
				"\n"..
				"Author:\n"..
				"[PA-D]Need\n"..
				"\n"..
				"Idea Author:\n"..
				"[PA-D]Need\n"..
				"\n"..
				"Testers:\n"..
				"- \n"..
				"- \n"..
				"- \n"..
				"- \n"..
				"- \n"..
				"- [PA-D]Need\n"..
				"\n"	..
				"\n"..
				"\"F5\" Help Menu made by: \n"..
				"- [PA-D]Need"
        } )
end

function Money:ModuleUnload()
	Events:Fire( "HelpRemoveItem", {name = "Money"} )
end]]

function round(val, decimal)
	local exp = decimal and 10^decimal or 1
	local nex = math.ceil(val * exp - 0.5) / exp
	if nex == -0 then
		return 0
	else
		return nex
	end
end

function comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end
Money = Money()