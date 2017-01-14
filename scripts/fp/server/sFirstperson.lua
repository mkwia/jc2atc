Network:Subscribe("Invis", function( args, player )
	player:SetModelId( 20 )
end)

Network:Subscribe("NotInvis", function( args, player )
	local qry = SQL:Query( "select model_id from buymenu_players where steamid = (?)" )
    qry:Bind( 1, player:GetSteamId().id )
    local result = qry:Execute()

    if #result > 0 then
        player:SetModelId( tonumber(result[1].model_id) )
    end
end)