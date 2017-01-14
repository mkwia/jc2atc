class "localchat"

function localchat:__init()

	self.active = false

	Events:Subscribe("LocalPlayerChat", self, self.LocalPlayerChat)

end

function localchat:LocalPlayerChat(args)

	if string.lower(args.text) == "/local" then

		self.active = not self.active

		if self.active then

			Chat:Print("Localchat enabled.", Color.Silver)

		elseif not self.active then

			Chat:Print("Localchat disabled.", Color.Silver)

		end

		return false

	end

	if self.active and string.match(args.text, "/") == nil then

		args2 = {}
		args2.sender = LocalPlayer
		args2.message = args.text

		Network:Send("localchat", args2)
	
		return false

	end

end

localchat = localchat()