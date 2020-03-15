--[[ events.lua ]]

---------------------------------------------------------------------------
-- Event: Game state change handler
---------------------------------------------------------------------------
function COverthrowGameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	
	CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = self.TEAM_KILLS_TO_WIN } );
	--self._fPreGameStartTime = GameRules:GetGameTime()

	-- NEW 1, from 7.20 rad
	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		EmitAnnouncerSound( 'announcer_ann_custom_mode_15' )
	end

	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		GameRules:GetGameModeEntity():ClearModifyExperienceFilter()
		GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( self.exptable )
		print( "exp table set" )
	end
	
	-- NEW 2, from 7.20 rad
	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		EmitAnnouncerSound( 'announcer_ann_custom_begin' )
	end
	
	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "OnGameRulesStateChange: Game In Progress" )
		self.countdownEnabled = true
		CustomGameEventManager:Send_ServerToAllClients( "show_timer", {} )
		DoEntFire( "center_experience_ring_particles", "Start", "0", 0, self, self  )
	end
end

--------------------------------------------------------------------------------
-- Event: BountyRunePickupFilter
--------------------------------------------------------------------------------
function COverthrowGameMode:BountyRunePickupFilter( filterTable )
      filterTable["gold_bounty"] = 2*filterTable["gold_bounty"]
      return true
end

---------------------------------------------------------------------------
-- Event: OnTeamKillCredit, see if anyone won
---------------------------------------------------------------------------
function COverthrowGameMode:OnTeamKillCredit( event )
--	print( "OnKillCredit" )
--	DeepPrint( event )

	local nKillerID = event.killer_userid
	local nTeamID = event.teamnumber
	local nTeamKills = event.herokills
	local nKillsRemaining = self.TEAM_KILLS_TO_WIN - nTeamKills
	
	local broadcast_kill_event =
	{
		killer_id = event.killer_userid,
		team_id = event.teamnumber,
		team_kills = nTeamKills,
		kills_remaining = nKillsRemaining,
		victory = 0,
		close_to_victory = 0,
		very_close_to_victory = 0,
	}

	if nKillsRemaining <= 0 then
		GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[nTeamID] )
		GameRules:SetGameWinner( nTeamID )
		broadcast_kill_event.victory = 1
	elseif nKillsRemaining == 1 then
		EmitGlobalSound( "ui.npe_objective_complete" )
		broadcast_kill_event.very_close_to_victory = 1
	elseif nKillsRemaining <= self.CLOSE_TO_VICTORY_THRESHOLD then
		EmitGlobalSound( "ui.npe_objective_given" )
		broadcast_kill_event.close_to_victory = 1
	end

	CustomGameEventManager:Send_ServerToAllClients( "kill_event", broadcast_kill_event )
end

---------------------------------------------------------------------------
-- Event: OnEntityKilled
---------------------------------------------------------------------------
function COverthrowGameMode:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local krUnit = EntIndexToHScript( event.entindex_attacker )
	
	if krUnit:IsHero() == true then
		if killedUnit:IsHero() == true then
					krUnit:AddExperience( 150, 0, false, true )
					killedUnit:AddExperience( 50, 0, false, true )
            
			elseif killedUnit:IsAncient() == true then
					krUnit:ModifyGold( 110, true, 13 )
					krUnit:AddExperience( 90, 0, false, true )
            
			elseif killedUnit:IsCreep() == true then
					krUnit:ModifyGold( 80, true, 13 )
					krUnit:AddExperience( 40, 0, false, true )
		end
	elseif krUnit:IsIllusion() == true then
		print("illusions killed something")
		local krOwner = krUnit:GetOwner()
		
		if krOwner:IsHero() == true then
			killedUnit:AddExperience( 50, 0, false, true )
			krOwner:AddExperience( 100, 0, false, true )
		end
	elseif killedUnit:IsHero() == true and krUnit:IsCreep() == true or krUnit:IsAncient() == true then
			killedUnit:SetTimeUntilRespawn( 6.0 )
			
			local krOwner = krUnit:GetOwner()
		
			if krOwner:IsHero() == true then
				killedUnit:AddExperience( 50, 0, false, true )
				krOwner:AddExperience( 190, 0, false, true )
			end
	else
		print("neutrals killed something")
	end
end

--function COverthrowGameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
	--print("Setting time for respawn")
	--if killedTeam == self.leadingTeam and self.isGameTied == false then
		--killedUnit:SetTimeUntilRespawn( 20 )
	--else
		--killedUnit:SetTimeUntilRespawn( 10 )
	--end
--end

--------------------------------------------------------------------------------
-- Event: OnItemPickUp
--------------------------------------------------------------------------------
function COverthrowGameMode:OnItemPickUp( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )
	r = 300
	--r = RandomInt(200, 400)
	if event.itemname == "item_treasure_chest" then
		--print("Special Item Picked Up")
		DoEntFire( "item_spawn_particle_" .. self.itemSpawnIndex, "Stop", "0", 0, self, self )
		COverthrowGameMode:SpecialItemAdd( event )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
end

--------------------------------------------------------------------------------
-- Event: OnNpcGoalReached
--------------------------------------------------------------------------------
function COverthrowGameMode:OnNpcGoalReached( event )
	local npc = EntIndexToHScript( event.npc_entindex )
	if npc:GetUnitName() == "npc_dota_treasure_courier" then
		COverthrowGameMode:TreasureDrop( npc )
	end
end