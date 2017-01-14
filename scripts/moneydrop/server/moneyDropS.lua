class "MoneyDrop"
function MoneyDrop:__init(id, pos, object)
	self.id = id
	self.pos = pos
	self.time = Timer()
	self.sendMessageTimer = Timer()
	self.object = object
end	

class "Money"
function Money:__init()
	self.player = {}
	
	self.timeBetweenMoneyDrops = 6 --In Minutes
	self.dropLength = 5 --In Minutes
	self.min = 100
	self.max = 1000
	
	self.moneyDrops = {}
	self.nextMoneyDrop = Timer()
	
	--Events
	Events:Subscribe("PostTick", self, self.Update)
	Events:Subscribe("PlayerChat", self, self.PlayerChat)
	
	Network:Subscribe("Money_SetTerrainHeight", self, self.AddMoneyDrop)
end

function Money:AddMoneyDrop(pos)
	local id = #self.moneyDrops+1
	Chat:Broadcast("A MoneyDrop appeared and will disappear in "..self.dropLength.." minutes. RUN!", Color.Cyan)
	Network:Broadcast("Money_Moneydrop", {id = id, pos = pos})
	
	spawnArgs = {}
	spawnArgs.position = pos + Vector3(0,0,0)
	spawnArgs.angle = Angle()
	spawnArgs.model = "geo.cdd.eez/go151-a.lod"
	local object = StaticObject.Create(spawnArgs)
	
	self.moneyDrops[id] = MoneyDrop(id, pos, object)
end

function Money:RemoveMoneyDrop(id)
	if self.moneyDrops[id]~=nil and IsValid(self.moneyDrops[id].object) then self.moneyDrops[id].object:Remove() end
	self.moneyDrops[id] = nil 
	Network:Broadcast("Money_Moneydrop", {id = id, pos = nil})
end

function Money:Update()
	--new moneydrop
	if self.nextMoneyDrop:GetMinutes()>self.timeBetweenMoneyDrops then
		for player in Server:GetPlayers() do
			Network:Send(player, "Money_GetTerrainHeight", Vector2(math.random(-15000,15000),math.random(-15000,15000)))
			break
		end
		self.nextMoneyDrop:Restart()
	end
	
	--moneydrop logic
	for key, moneyDrop in pairs(self.moneyDrops) do
		local id = moneyDrop.id
		local pos = moneyDrop.pos
		local timer = moneyDrop.time
		local countPlayerInArea = 0
		for player in Server:GetPlayers() do 
			if player:GetPosition():Distance(pos)<500 then 
				countPlayerInArea = countPlayerInArea + 1
				player:SetNetworkValue("Util_GodMode", false)
			end 
		end
		
		--Iterate over all people
		for player in Server:GetPlayers() do
			--Is Player near?
			if player:GetPosition():Distance(pos)<10 then
				--[[And the only one nearby?
				if countPlayerInArea > 1 then 
					if moneyDrop.sendMessageTimer:GetSeconds()>=2 then
						player:SendChatMessage("There are still "..countPlayerInArea.." Player left in the area. Kill them all!", Color.Cyan )
					end
				else]]
					local timePercentage = 1 - (timer:GetSeconds() / (self.dropLength * 60))
					local money = (self.max - self.min) * timePercentage + self.min
					local timeLeft = self.dropLength - timer:GetMinutes()
					local minsLeft = math.floor(timeLeft)
					local secsLeft = 60 * (timeLeft - minsLeft)
					
					--Give money to player
					--local moneyPlayer = self.player[player:GetId()]
					local mult = 1
					--if moneyPlayer.group == "vip" then mult = 1.2 end --CHANGE DONATOR THING
					money = round(money * mult, 0)
					local newMoney = player:GetMoney() + money
					--player:SetMoney(newMoney)
					if minsLeft == 1 then
						Chat:Broadcast(""..player:GetName().." found the MoneyDrop with "..minsLeft.." minute "..math.ceil(secsLeft).." seconds left and received $"..money.."!", Color.Cyan )
					else
						Chat:Broadcast(""..player:GetName().." found the MoneyDrop with "..minsLeft.." minutes "..math.ceil(secsLeft).." seconds left and received $"..money.."!", Color.Cyan )
					end
					
					self:RemoveMoneyDrop(key)
				--end
			end
		end
		
		--Sendmessage timer to send people they have to kill people nearby
		if moneyDrop.sendMessageTimer:GetSeconds()>=2 then moneyDrop.sendMessageTimer:Restart() end
		
		--Dont let moneydrop disappear if player is near
		if timer:GetMinutes()>=self.dropLength then 
			local inRange = false
			for player in Server:GetPlayers() do
				if player:GetPosition():Distance(moneyDrop.pos)<500 then
					inRange = true
					break
				end
			end
			if not inRange then
				self:RemoveMoneyDrop(key)
				Chat:Broadcast("A MoneyDrop disappeared!", Color.Cyan )
			end
		end
	end
end

function Money:PlayerChat(args) -- Chat
	if args.text == "/moneydrop" then
		for player in Server:GetPlayers() do
			Network:Send(player, "Money_GetTerrainHeight", Vector2(math.random(-15000,15000),math.random(-15000,15000)))
			break
		end
	end
end

function round(val, decimal)
	local exp = decimal and 10^decimal or 1
	local nex = math.ceil(val * exp - 0.5) / exp
	if nex == -0 then
		return 0
	else
		return nex
	end
end

function Money:IsAdmin(player)
	local group = self.player[player:GetId()].group:lower()
	return group == "admin" or group == "superadmin"
end

Money = Money()