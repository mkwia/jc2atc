class "log"

function log:__init()

	self.filename = tostring(os.date("%d.%m.%Y")..".txt")

	Events:Subscribe("PlayerChat", self, self.AddEntry)
	Events:Subscribe("PreTick", self, self.NewFile)

end

function log:NewFile()

	if tostring(os.date("%d.%m.%Y")..".txt") ~= self.filename then

		self.filename = tostring(os.date("%d.%m.%Y")..".txt")
		local newfile = io.open(self.filename, "w")
		newfile:close()

	end

end

function log:AddEntry(args)

	if string.sub(args.text, 1, 1) == "/" then return end

	local file = io.open(self.filename, "a+")
	local str = "[ "..os.date("%X").." ] - "..args.player:GetName()..": "..args.text.."\n"
	file:write(str)
	file:close()

end

chatlog = log()