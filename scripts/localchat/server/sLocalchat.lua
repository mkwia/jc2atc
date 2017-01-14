class "localchat"

function localchat:__init()

	Network:Subscribe("localchat", self, self.LocalChat)

end

function localchat:LocalChat(args)

	for player in Server:GetPlayers() do

		if Vector3.Distance(args.sender:GetPosition(), player:GetPosition()) < 100 then

			Chat:Send(player, "[Local] "..tostring(args.sender)..": "..tostring(args.message), Color.Pink)

		end

	end

end

localchat = localchat()