-- ///////////////////////////////////////////////////////////////////////
-- //							Player Footsteps						//
-- //							by daunknownman2010						//
-- ///////////////////////////////////////////////////////////////////////

AddCSLuaFile()

-- Client CVARS
if ( CLIENT ) then

	if !ConVarExists( "cl_player_footsteps" ) then
	
		local cl_player_footsteps = CreateConVar( "cl_player_footsteps", "default", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "What kind of footsteps to play. Default, Rebel, Combine and MetroPolice." )
		local cl_player_footsteps_combination = CreateConVar( "cl_player_footsteps_combination", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "Plays the normal footsteps even if it's not on default. Only for Combine and MetroPolice!" )
	
	end

end

-- Shared CVARS



-- Some tables..
local NPC_Citizen_RunFootstepLeft = {

	"npc/footsteps/hardboot_generic1.wav",
	"npc/footsteps/hardboot_generic3.wav",
	"npc/footsteps/hardboot_generic5.wav"

}

local NPC_Citizen_RunFootstepRight = {

	"npc/footsteps/hardboot_generic2.wav",
	"npc/footsteps/hardboot_generic4.wav",
	"npc/footsteps/hardboot_generic6.wav"

}

local NPC_CombineS_RunFootstepLeft = {

	"npc/combine_soldier/gear1.wav",
	"npc/combine_soldier/gear3.wav",
	"npc/combine_soldier/gear5.wav"

}

local NPC_CombineS_RunFootstepRight = {

	"npc/combine_soldier/gear2.wav",
	"npc/combine_soldier/gear4.wav",
	"npc/combine_soldier/gear6.wav"

}

local NPC_MetroPolice_RunFootstepLeft = {

	"npc/metropolice/gear1.wav",
	"npc/metropolice/gear3.wav",
	"npc/metropolice/gear5.wav"

}

local NPC_MetroPolice_RunFootstepRight = {

	"npc/metropolice/gear2.wav",
	"npc/metropolice/gear4.wav",
	"npc/metropolice/gear6.wav"

}


function PLAYERFOOTSTEPS_Initialize()

	-- Show that the addon is ready to go (working/enabled).
	timer.Simple( 5, function() if ( SERVER ) then PrintMessage( HUD_PRINTTALK, "Player Footsteps is ready to go!" ) end end )

end
hook.Add( "Initialize", "PLAYERFOOTSTEPS_Initialize", PLAYERFOOTSTEPS_Initialize )


function PLAYERFOOTSTEPS_PlayerInitialSpawn( ply )

	-- Garry's Mod doesn't seem to precache the footstep sounds properly so I'm emitting the sound instead.
	for k, v in pairs( NPC_Citizen_RunFootstepLeft ) do
	
		ply:EmitSound( v, 75, 100, 0, CHAN_BODY )
	
	end

	for k, v in pairs( NPC_Citizen_RunFootstepRight ) do
	
		ply:EmitSound( v, 75, 100, 0, CHAN_BODY )
	
	end

	for k, v in pairs( NPC_CombineS_RunFootstepLeft ) do
	
		ply:EmitSound( v, 75, 100, 0, CHAN_BODY )
	
	end

	for k, v in pairs( NPC_CombineS_RunFootstepRight ) do
	
		ply:EmitSound( v, 75, 100, 0, CHAN_BODY )
	
	end

	for k, v in pairs( NPC_MetroPolice_RunFootstepLeft ) do
	
		ply:EmitSound( v, 75, 100, 0, CHAN_BODY )
	
	end

	for k, v in pairs( NPC_MetroPolice_RunFootstepRight ) do
	
		ply:EmitSound( v, 75, 100, 0, CHAN_BODY )
	
	end

end
hook.Add( "PlayerInitialSpawn", "PLAYERFOOTSTEPS_PlayerInitialSpawn", PLAYERFOOTSTEPS_PlayerInitialSpawn )


function PLAYERFOOTSTEPS_Think()

	if ( SERVER ) then
	
		for _, ply in pairs( player.GetHumans() ) do
		
			if ( ply:IsValid() && ( ply:GetNWString( "PLAYERFOOTSTEPS_FootstepType" ) != ply:GetInfo( "cl_player_footsteps" ) ) ) then
			
				ply:SetNWString( "PLAYERFOOTSTEPS_FootstepType", ply:GetInfo( "cl_player_footsteps" ) )
			
			end
		
		end
	
	end

end
hook.Add( "Think", "PLAYERFOOTSTEPS_Think", PLAYERFOOTSTEPS_Think )


function PLAYERFOOTSTEPS_PlayerFootstep( ply, pos, foot, sound, volume, filter )

	-- We're checking to see if the game is singleplayer or not singleplayer so prediction is properly done.
	if ( game.SinglePlayer() && CLIENT ) then return end
	if ( !game.SinglePlayer() && SERVER ) then return end
	if ( ply:IsBot() ) then return end

	if ( ply:GetNWString( "PLAYERFOOTSTEPS_FootstepType" ) == "default" ) then
	
		-- It's the default footsteps!
		return false
	
	elseif ( ply:GetNWString( "PLAYERFOOTSTEPS_FootstepType" ) == "rebel" ) then
	
		-- Ladder and water footstep override
		if tobool( ply:GetInfo( "cl_player_footsteps_combination" ) ) && ( ( ply:WaterLevel() > 0 && ply:WaterLevel() < 3 ) || ply:GetMoveType() == MOVETYPE_LADDER ) then return false end
	
		if ( foot == 0 ) then
		
			EmitSound( table.Random( NPC_Citizen_RunFootstepLeft ), pos, ply:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		elseif ( foot == 1 ) then
		
			EmitSound( table.Random( NPC_Citizen_RunFootstepRight ), pos, ply:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		end
		return true
	
	elseif ( ply:GetNWString( "PLAYERFOOTSTEPS_FootstepType" ) == "combine" ) then
	
		if ( tobool( ply:GetInfo( "cl_player_footsteps_combination" ) ) ) then
		
			volume = volume * 0.4
		
		end
	
		if ( foot == 0 ) then
		
			EmitSound( table.Random( NPC_CombineS_RunFootstepLeft ), pos, ply:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		elseif ( foot == 1 ) then
		
			EmitSound( table.Random( NPC_CombineS_RunFootstepRight ), pos, ply:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		end
	
		if ( !tobool( ply:GetInfo( "cl_player_footsteps_combination" ) ) ) then
		
			return true
		
		end
	
	elseif ( ply:GetNWString( "PLAYERFOOTSTEPS_FootstepType" ) == "metropolice" ) then
	
		if ( tobool( ply:GetInfo( "cl_player_footsteps_combination" ) ) ) then
		
			volume = volume * 0.4
		
		end
	
		if ( foot == 0 ) then
		
			EmitSound( table.Random( NPC_MetroPolice_RunFootstepLeft ), pos, ply:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		elseif ( foot == 1 ) then
		
			EmitSound( table.Random( NPC_MetroPolice_RunFootstepRight ), pos, ply:EntIndex(), CHAN_BODY, volume, 75, 0, math.random( 95, 105 ) )
		
		end
	
		if ( !tobool( ply:GetInfo( "cl_player_footsteps_combination" ) ) ) then
		
			return true
		
		end
	
	else
	
		-- Mute footsteps, undefined.
		ply:PrintMessage( HUD_PRINTCONSOLE, "Footsteps undefined!\n" )
		return true
	
	end

end
hook.Add( "PlayerFootstep", "PLAYERFOOTSTEPS_PlayerFootstep", PLAYERFOOTSTEPS_PlayerFootstep )


if ( CLIENT ) then

list.Set( "DesktopWindows", "PlayerFootsteps", {

	title		= "Player Footsteps",
	icon		= "icon64/tool.png",
	width		= 256,
	height		= 321,
	onewindow	= true,
	init		= function( icon, window )
	
		local DImageButton = window:Add( "DImageButton" )
		DImageButton:SetPos( 0, 25 )
		DImageButton:SetTooltip( "Default" )
		DImageButton:SetSize( 128, 128 )
		DImageButton:SetImage( "player_footsteps/footstep_player" )
		DImageButton.DoClick = function()
		
			RunConsoleCommand( "cl_player_footsteps", "default" )
		
		end
	
		local DImageButton = window:Add( "DImageButton" )
		DImageButton:SetPos( 128, 25 )
		DImageButton:SetTooltip( "Rebel" )
		DImageButton:SetSize( 128, 128 )
		DImageButton:SetImage( "player_footsteps/footstep_rebel" )
		DImageButton.DoClick = function()
		
			RunConsoleCommand( "cl_player_footsteps", "rebel" )
		
		end
	
		local DImageButton = window:Add( "DImageButton" )
		DImageButton:SetPos( 0, 153 )
		DImageButton:SetTooltip( "Combine" )
		DImageButton:SetSize( 128, 128 )
		DImageButton:SetImage( "player_footsteps/footstep_combine" )
		DImageButton.DoClick = function()
		
			RunConsoleCommand( "cl_player_footsteps", "combine" )
		
		end
	
		local DImageButton = window:Add( "DImageButton" )
		DImageButton:SetPos( 128, 153 )
		DImageButton:SetTooltip( "Metro-Police" )
		DImageButton:SetSize( 128, 128 )
		DImageButton:SetImage( "player_footsteps/footstep_cop" )
		DImageButton.DoClick = function()
		
			RunConsoleCommand( "cl_player_footsteps", "metropolice" )
		
		end
	
		local DButton = window:Add( "DButton" )
		DButton:SetPos( 0, 281 )
		DButton:SetText( "Combination" )
		DButton:SetSize( 256, 40 )
		DButton.DoClick = function()
		
			if ( GetConVar( "cl_player_footsteps_combination" ):GetBool() ) then
			
				RunConsoleCommand( "cl_player_footsteps_combination", "0" )
			
			else
			
				RunConsoleCommand( "cl_player_footsteps_combination", "1" )
			
			end
		
		end
	
	end

} )

end
