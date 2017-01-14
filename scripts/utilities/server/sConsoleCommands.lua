class "consolecommands"

function consolecommands:__init()

	tps = 0

	Console:Subscribe("help", self, self.help)
	Console:Subscribe("playercount", self, self.playercount)
	Console:Subscribe("playerlist", self, self.playerlist)
	Console:Subscribe("tps", self, self.tickspersecond)
	Events:Subscribe("ConsoleReturnTick", self, self.tpsreturn)

end

function consolecommands:help()

	print("\nplayercount -- Print playercount\n"..
		"playerlist -- Print a list of online players\n"..
		"tps -- Print current ticks per second\n"..
		"warn -- Same as the 'warn' function.")

end

function consolecommands:playercount()

	print("Player count: "..Server:GetPlayerCount()..".")

end

function consolecommands:playerlist()

	for player in Server:GetPlayers() do
		local name = player:GetName()
		print(name)
	end

end

function consolecommands:tickspersecond()

	print("TPS: "..tostring(tps))

end

function consolecommands:tpsreturn(ticks)

	tps = ticks	

end

--function consolecommands:warn()
--Located in GAR-warn
--end

console = consolecommands()