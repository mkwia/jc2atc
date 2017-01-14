Network:Subscribe("AddMoney", function(money, sender)

	sender:SetMoney(sender:GetMoney() + money)

end)

Network:Subscribe("TakeMoney", function(money, sender)

	sender:SetMoney(sender:GetMoney() - money)

end)

Network:Subscribe("Transaction", function(args, sender)

	sender:SetMoney(sender:GetMoney() - args.money)

	args.player:SetMoney(args.player:GetMoney() + args.money)

	Chat:Send(args.player, tostring(sender), Color.Lime, " sent you ", Color.White, "£"..args.money, Color.Lime, " for ", Color.White, args.reason, Color.Lime, ".", Color.White)

	Chat:Send(sender, "£"..args.money, Color.Lime, " sent to ", Color.White, tostring(args.player), Color.Lime, " for ", Color.White, args.reason, Color.Lime, ".", Color.White)

end)