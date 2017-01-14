godlist = { }

Network:Subscribe ( "godmodeon", function ( ply ) 
	
	godlist [ ply ] = true

	updatelist ( )

end )

Network:Subscribe ( "godmodeoff", function ( ply )

	godlist [ ply ] = nil

	updatelist ( )

end )

Network:Subscribe ( "godHeal", function ( ply )

	ply:SetHealth ( 1 ) 

end )

Network:Subscribe ( "GodVehicle", function ( ply )

	ply:GetVehicle ( ):SetInvulnerable ( true )

end )

Network:Subscribe ( "UnGodVehicle", function ( ply )

	ply:GetVehicle ( ):SetInvulnerable ( false )

end )

Events:Subscribe ( "PlayerJoin", function ( ) 

	updatelist ( )

end )

Events:Subscribe ( "PlayerQuit", function ( ply ) 

	godlist [ ply ] = nil

	updatelist ( )

end )

function updatelist ( )

	Network:Broadcast ( "updategodlist", godlist )

end