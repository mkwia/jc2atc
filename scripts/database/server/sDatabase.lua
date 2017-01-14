class 'Database'

function Database:__init()
	
	self.commands = {}
	self.queries = {}
	
	self.timer = Timer()
	self.delay = 1000
	
	SQL:Execute("CREATE TABLE IF NOT EXISTS players (steam_id VARCHAR UNIQUE, name VARCHAR, money INTEGER, kills INTEGER, deaths INTEGER, playtime INTEGER)")
	
	Events:Subscribe("PlayerJoin", self, self.OnPlayerJoin)
	Events:Subscribe("PlayerQuit", self, self.OnPlayerQuit)
	Events:Subscribe("PreTick", self, self.OnPreTick)
	Events:Subscribe("PlayerChat", self, self.OnPlayerChat)
	Events:Subscribe("PlayerDeath", self, self.OnPlayerDeath)
	
	Events:Subscribe("SQLCommand", self, self.AddCommand)
	Events:Subscribe("SQLQuery", self, self.AddQuery)
	
	Network:Subscribe("PlaytimeUpdate", self, self.UpdatePlaytime)

end

function Database:OnPreTick()

	if (#self.commands > 0 or #self.queries > 0) and self.timer:GetMilliseconds() > self.delay then
	
		self.timer:Restart()

		local transaction = SQL:Transaction()

		while #self.commands > 0 do
			table.remove(self.commands, 1):Execute()
		end
		
		while #self.queries > 0 do
			table.remove(self.queries, 1)()
		end

		transaction:Commit()
		
	end

end

function Database:AddCommand(command)
	table.insert(self.commands, command)
end

function Database:AddQuery(query)
	table.insert(self.queries, query)
end

function Database:OnPlayerJoin(args)

	local id = args.player:GetSteamId().string
	local name = args.player:GetName()
	
	local command = SQL:Command("INSERT OR IGNORE INTO players (steam_id, name, money, kills, deaths, playtime) VALUES (?, ?, ?, ?, ?, ?)")
	command:Bind(1, id)
	command:Bind(2, name)
	command:Bind(3, 0)
	command:Bind(4, 0)
	command:Bind(5, 0)
	command:Bind(6, 0)
	self:AddCommand(command)
	
	self:AddQuery(function()
		local query = SQL:Query("SELECT money, kills, deaths, playtime FROM players WHERE steam_id = ? LIMIT 1")
		query:Bind(1, id)
		local result = query:Execute()
		args.player:SetMoney(tonumber(result[1].money))
		args.player:SetValue("kills", tonumber(result[1].kills))
		args.player:SetValue("deaths", tonumber(result[1].deaths))
		args.player:SetValue("playtime", tonumber(result[1].playtime))
	end)
	
end

function Database:UpdatePlaytime(update, sender)

	sender:SetValue("playtime", sender:GetValue("playtime") + 1)

end

function Database:OnPlayerDeath(args)

	if IsValid(args.player) and args.player:GetValue("deaths") then
		args.player:SetValue("deaths", args.player:GetValue("deaths") + 1)
	end
	
	if IsValid(args.killer) and args.killer:GetValue("kills") then
		args.killer:SetValue("kills", args.killer:GetValue("kills") + 1)
	end

end

function Database:OnPlayerChat(args)

	if args.text == "/stats" then
	
		local hours = math.modf(args.player:GetValue("playtime") / 60)
		local minutes = math.modf(args.player:GetValue("playtime") - hours * 60)
		Chat:Send(args.player, string.format("~ Statistics for %s", args.player:GetName()), Color.DodgerBlue)
		Chat:Send(args.player, string.format("~ Kills: %s ~ Deaths: %s ~ Playtime: %s hours, %s minutes", args.player:GetValue("kills"), args.player:GetValue("deaths"), hours, minutes), Color.DodgerBlue)
		return false
	end

end

function Database:OnPlayerQuit(args)

	local command = SQL:Command("UPDATE players SET money = ?, kills = ?, deaths = ?, playtime = ?, name = ? WHERE steam_id = ?")
	command:Bind(1, args.player:GetMoney())
	command:Bind(2, args.player:GetValue("kills"))
	command:Bind(3, args.player:GetValue("deaths"))
	command:Bind(4, args.player:GetValue("playtime"))
	command:Bind(5, args.player:GetName())
	command:Bind(6, args.player:GetSteamId().string)
	self:AddCommand(command)

end

Database = Database()