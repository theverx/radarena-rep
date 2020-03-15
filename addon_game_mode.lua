--[[
Overthrow Game Mode
]]

_G.nNEUTRAL_TEAM = 4
_G.nCOUNTDOWNTIMER = 960 --901 standard

RUNE_SPAWN_TIME = 60

XP_PER_LEVEL_TABLE = {
	0,-- 1
	300,-- 2
	320,-- 3
	340,-- 4
	360,-- 5
	380,-- 6
	400,-- 7
	420,-- 8
	440,-- 9
	460,-- 10
	480,-- 11
	500,-- 12
	520,-- 13
	540,-- 14
	560,-- 15
	580,-- 16
	600,-- 17
	620,-- 18
	640,-- 19
	660,-- 20
	680,-- 21
	700,-- 22
	720,-- 23
	740,-- 24
	760 -- 25
}

---------------------------------------------------------------------------
-- COverthrowGameMode class
---------------------------------------------------------------------------
if COverthrowGameMode == nil then
	_G.COverthrowGameMode = class({}) -- put COverthrowGameMode in the global scope
	--refer to: http://stackoverflow.com/questions/6586145/lua-require-with-global-local
end

---------------------------------------------------------------------------
-- Required .lua files
---------------------------------------------------------------------------
require( "events" )
require( "items" )
require( "utility_functions" )
require( "statcollection/init" )

---------------------------------------------------------------------------
-- Precache
---------------------------------------------------------------------------
function Precache( context )

		PrecacheItemByNameSync( "item_treasure_chest", context )
		PrecacheModel( "item_treasure_chest", context )

        PrecacheUnitByNameSync( "npc_dota_treasure_courier", context )
        PrecacheModel( "npc_dota_treasure_courier", context )

    --Cache new particles
       	--PrecacheResource( "particle", "particles/econ/events/nexon_hero_compendium_2014/teleport_end_nexon_hero_cp_2014.vpcf", context )
       	PrecacheResource( "particle", "particles/leader/leader_overhead.vpcf", context )
       	PrecacheResource( "particle", "particles/last_hit/last_hit.vpcf", context )
       	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zeus_taunt_coin.vpcf", context )
       	PrecacheResource( "particle", "particles/addons_gameplay/player_deferred_light.vpcf", context )
       	PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", context )
       	PrecacheResource( "particle", "particles/treasure_courier_death.vpcf", context )
       	PrecacheResource( "particle", "particles/econ/wards/f2p/f2p_ward/f2p_ward_true_sight_ambient.vpcf", context )
       	--PrecacheResource( "particle", "particles/econ/items/lone_druid/lone_druid_cauldron/lone_druid_bear_entangle_dust_cauldron.vpcf", context )
       	PrecacheResource( "particle", "particles/newplayer_fx/npx_landslide_debris.vpcf", context )
    
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_arc_warden.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bane.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_batrider.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_beastmaster.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bloodseeker.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bounty_hunter.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bristleback.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_broodmother.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_chaos_knight.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_chen.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_clinkz.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_rattletrap.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_seer.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_willow.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_disruptor.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_doom_bringer.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_drowranger.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_enchantress.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_grimstroke.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_huskar.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_wisp.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_jakiro.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_legion_commander.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_leshrac.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_life_stealer.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lion.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lone_druid.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_luna.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lycan.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_mars.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_meepo.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_morphling.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_monkey_king.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_naga_siren.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_furion.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_necrolyte.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nightstalker.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_oracle.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_obsidian_destroyer.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pangolier.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_lancer.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_puck.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pudge.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_queenofpain.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_riki.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_rubick.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sandking.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_shadow_demon.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nevermore.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_shadow_shaman.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_silencer.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slardar.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_snapfire.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_spectre.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_spirit_breaker.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_stormspirit.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tidehunter.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_shredder.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_troll_warlord.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abyssal_underlord.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_undying.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ursa.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_vengefulspirit.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_viper.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_visage.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_void_spirit.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_weaver.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_windrunner.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_winter_wyvern.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_witchdoctor.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_skeletonking.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context )
end

function Activate()
	-- Create our game mode and initialize it
	COverthrowGameMode:InitGameMode()
end

---------------------------------------------------------------------------
-- Initializer
---------------------------------------------------------------------------
function COverthrowGameMode:InitGameMode()
	print( "Skillshotsad is loaded." )
	
	self.m_TeamColors = {}

	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 237, 41, 57 }	--      Ruby
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 15, 82, 186 }	--		Sapphire
	self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 80, 220, 100 } --		Emerald
    self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 249, 166, 2 }	--		Gold
	
	for team = 0, (DOTA_TEAM_COUNT-1) do
		color = self.m_TeamColors[ team ]
		if color then
			SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
		end
	end

	self.m_VictoryMessages = {}

	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"

	self.m_GatheredShuffledTeams = {}
	--self.numSpawnCamps = 9
	self.specialItem = ""
	self.spawnTime = 60
	self.nNextSpawnItemNumber = 1
	self.hasWarnedSpawn = false
	self.allSpawned = false
	self.leadingTeam = -1
	self.runnerupTeam = -1
	self.leadingTeamScore = 0
	self.runnerupTeamScore = 0
	self.isGameTied = true
	self.countdownEnabled = false
	self.itemSpawnIndex = 1
	self.itemSpawnLocation = Entities:FindByName( nil, "greevil" )
	self.tier1ItemBucket = {}
	self.tier2ItemBucket = {}
	self.tier3ItemBucket = {}
	self.tier4ItemBucket = {}
	self.pool1SkillBucket = {}
	self.pool2SkillBucket = {}
	self.pool3SkillBucket = {}
	self.pool4SkillBucket = {}
	self.pool5SkillBucket = {}
	self.pool6SkillBucket = {}

	self.TEAM_KILLS_TO_WIN = 20
	self.CLOSE_TO_VICTORY_THRESHOLD = 5

	---------------------------------------------------------------------------

	self:GatherAndRegisterValidTeams()

	GameRules:GetGameModeEntity().COverthrowGameMode = self

	-- Adding Many Players
	if GetMapName() == "skillshotad" then
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 0 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 2 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 2 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_3, 2 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_4, 2 )
		self.m_GoldRadiusMin = 250
		self.m_GoldRadiusMax = 450
		self.m_GoldDropPercent = 0
	end
	
    -- Setting players account record
    --GameRules:GetPlayerCustomGameAccountRecord( int int_1 )
    
	-- Show the ending scoreboard immediately
	GameRules:SetCustomGameEndDelay( 0 )
	GameRules:SetCustomVictoryMessageDuration( 10 )
	GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( 0.0 )
    GameRules:SetShowcaseTime( 0.0 )
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetPreGameTime( 5.0 )
	GameRules:SetHeroSelectionTime( 35.0 )
	GameRules:SetHeroSelectPenaltyTime( 10.0 )
	GameRules:SetStartingGold( 800 )
	GameRules:SetTreeRegrowTime( 30.0 )
	
	--GameRules:SetGoldTickTime( 1.0 )
	--GameRules:SetGoldPerTick( 4 )
	
	--GameRules:GetGameModeEntity():SetUseCustomHeroLevels( true )
	--GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( EXP_PER_LEVEL_TABLE )
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel( 23 )
	GameRules:GetGameModeEntity():SetFixedRespawnTime( 3 )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	GameRules:SetHideKillMessageHeaders( false )
	GameRules:SetUseUniversalShopMode( true )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_DOUBLEDAMAGE , true ) --Double Damage
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_HASTE, true ) --Haste
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ILLUSION, true ) --Illusion
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_INVISIBILITY, false ) --Invis
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_REGENERATION, true ) --Regen
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ARCANE, true ) --Arcane
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_BOUNTY, true ) --Bounty
	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( COverthrowGameMode, "ExecuteOrderFilter" ), self )
	
	if GameRules:GetGameModeEntity():IsBuybackEnabled( ) == true then
		GameRules:GetGameModeEntity():SetBuybackEnabled( false )
	end
	
	if GameRules:GetGameModeEntity():GetGoldSoundDisabled( ) == true then
		GameRules:GetGameModeEntity():GetGoldSoundDisabled( )
	end
	
	--ListenToGameEvent('player_connect_full', Dynamic_Wrap(COverthrowGameMode, 'OnPlayerConnectFull'), self) -- Custom
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( COverthrowGameMode, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent("dota_player_pick_hero", Dynamic_Wrap(COverthrowGameMode, 'OnHeroPicked'), self) -- Custom
	--ListenToGameEvent( "npc_spawned", Dynamic_Wrap( COverthrowGameMode, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_team_kill_credit", Dynamic_Wrap( COverthrowGameMode, 'OnTeamKillCredit' ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( COverthrowGameMode, 'OnEntityKilled' ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( COverthrowGameMode, "OnItemPickUp"), self )
	ListenToGameEvent( "dota_npc_goal_reached", Dynamic_Wrap( COverthrowGameMode, "OnNpcGoalReached" ), self )

	Convars:RegisterCommand( "overthrow_force_item_drop", function(...) self:ForceSpawnItem() end, "Force an item drop.", FCVAR_CHEAT )
	--Convars:RegisterCommand( "overthrow_force_gold_drop", function(...) self:ForceSpawnGold() end, "Force gold drop.", FCVAR_CHEAT )
	Convars:RegisterCommand( "overthrow_set_timer", function(...) return SetTimer( ... ) end, "Set the timer.", FCVAR_CHEAT )
	Convars:RegisterCommand( "overthrow_force_end_game", function(...) return self:EndGame( DOTA_TEAM_CUSTOM_1 ) end, "Force the game to end.", FCVAR_CHEAT )
	Convars:SetInt( "dota_server_side_animation_heroesonly", 0 )

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	--GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 )
end

---------------------------------------------------------------------------
-- Get the color associated with a given teamID
---------------------------------------------------------------------------
function COverthrowGameMode:ColorForTeam( teamID )
	local color = self.m_TeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } -- default to white
	end
	return color
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------
function COverthrowGameMode:EndGame( victoryTeam )
	local overBoss = Entities:FindByName( nil, "@overboss" )
	if overBoss then
		local celebrate = overBoss:FindAbilityByName( 'dota_ability_celebrate' )
		if celebrate then
			overBoss:CastAbilityNoTarget( celebrate, -1 )
		end
	end

	GameRules:SetGameWinner( victoryTeam )
end

---------------------------------------------------------------------------
-- Put a label over a player's hero so people know who is on what team
---------------------------------------------------------------------------
function COverthrowGameMode:UpdatePlayerColor( nPlayerID )
	if not PlayerResource:HasSelectedHero( nPlayerID ) then
		return
	end

	local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hero == nil then
		return
	end

	local teamID = PlayerResource:GetTeam( nPlayerID )
	local color = self:ColorForTeam( teamID )
	PlayerResource:SetCustomPlayerColor( nPlayerID, color[1], color[2], color[3] )
end

---------------------------------------------------------------------------
-- Simple scoreboard using debug text
---------------------------------------------------------------------------
function COverthrowGameMode:UpdateScoreboard()
	local sortedTeams = {}
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
	end

	-- reverse-sort by score
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

	for _, t in pairs( sortedTeams ) do
		local clr = self:ColorForTeam( t.teamID )

		--Scaleform UI Scoreboard
		local score = 
		{
			team_id = t.teamID,
			team_score = t.teamScore
		}
		FireGameEvent( "score_board", score )
	end
	-- Leader effects (moved from OnTeamKillCredit)
	local leader = sortedTeams[1].teamID
	--print("Leader = " .. leader)
	self.leadingTeam = leader
	self.runnerupTeam = sortedTeams[2].teamID
	self.leadingTeamScore = sortedTeams[1].teamScore
	self.runnerupTeamScore = sortedTeams[2].teamScore
	if sortedTeams[1].teamScore == sortedTeams[2].teamScore then
		self.isGameTied = true
	else
		self.isGameTied = false
	end
	
	local allHeroes = HeroList:GetAllHeroes()
	for _,entity in pairs( allHeroes) do
		if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
			if entity:IsAlive() == true then
				-- Attaching a particle to the leading team heroes
				local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
       			if existingParticle == -1 then
       				local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
					ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
					entity:Attribute_SetIntValue( "particleID", particleLeader )
				end
			else
				local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
				if particleLeader ~= -1 then
					ParticleManager:DestroyParticle( particleLeader, true )
					entity:DeleteAttribute( "particleID" )
				end
			end
		else
			local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
			if particleLeader ~= -1 then
				ParticleManager:DestroyParticle( particleLeader, true )
				entity:DeleteAttribute( "particleID" )
			end
		end
	end
end

---------------------------------------------------------------------------
-- Update player labels and the scoreboard
---------------------------------------------------------------------------
function COverthrowGameMode:OnThink()
	for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
		self:UpdatePlayerColor( nPlayerID )
	end
	
	self:UpdateScoreboard()
	-- Stop thinking if game is paused
	if GameRules:IsGamePaused() == true then
        return 1
    end
	
	if self.countdownEnabled == true then
		CountdownTimer()
		-- HALF TIME ANNOUNCER
		if nCOUNTDOWNTIMER == 600 then
			EmitAnnouncerSound( 'announcer_ann_custom_time_division_03' )
		end
		-- SET FOG OF WAR OFF IF 1 MIN REMAINING
		--if nCOUNTDOWNTIMER == 60 then
			--EmitAnnouncerSound( 'announcer_ann_custom_overtime' )
			--GameRules:GetGameModeEntity():SetFogOfWarDisabled( true ) -- FOG ABOVE RESET!
		--end
	end

	if self.countdownEnabled == true then
		CountdownTimer()
		if nCOUNTDOWNTIMER == 30 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
		end
		if nCOUNTDOWNTIMER <= 0 then
			--Check to see if there's a tie
			if self.isGameTied == false then
				GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[self.leadingTeam] )
				COverthrowGameMode:EndGame( self.leadingTeam )
				self.countdownEnabled = false
			else
				self.TEAM_KILLS_TO_WIN = self.leadingTeamScore + 2
				local broadcast_killcount = 
				{
					killcount = self.TEAM_KILLS_TO_WIN
				}
				CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", broadcast_killcount )
			end
       	end
	end
	
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--Spawn Gold Bags
		COverthrowGameMode:ThinkSpecialItemDrop()
	end

--local numberOfPlayers = PlayerResource:GetPlayerCount()
		--if numberOfPlayers > 6 then
			--nCOUNTDOWNTIMER = 901
		--elseif numberOfPlayers > 2 and numberOfPlayers <= 6 then
			--nCOUNTDOWNTIMER = 721
		--else
			--nCOUNTDOWNTIMER = 601
	--end
	
	return 1
end

---------------------------------------------------------------------------
-- Scan the map to see which teams have spawn points
---------------------------------------------------------------------------
function COverthrowGameMode:GatherAndRegisterValidTeams()
--	print( "GatherValidTeams:" )

	local foundTeams = {}
	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
		foundTeams[  playerStart:GetTeam() ] = true
	end

	local numTeams = TableCount(foundTeams)
	print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
	
	local foundTeamsList = {}
	for t, _ in pairs( foundTeams ) do
		table.insert( foundTeamsList, t )
	end

	if numTeams == 0 then
		print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
		table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
		table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
		numTeams = 2
	end

	local maxPlayersPerValidTeam = math.floor( 10 / numTeams )

	self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

	print( "Final shuffled team list:" )
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
	end

	print( "Setting up teams:" )
	for team = 0, (DOTA_TEAM_COUNT-1) do
		local maxPlayers = 0
		if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
			maxPlayers = maxPlayersPerValidTeam
		end
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
		GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
	end
end

---------------------------------------------------------------------------
-- Eevent: Pick the selected hero and teach random abilities
---------------------------------------------------------------------------

function COverthrowGameMode:OnHeroPicked(event)
		local hero = EntIndexToHScript(event.heroindex)
		print(hero)
		
		local tableindex = 1
			-- Point/Unit Target
			local pool1 =
			{	
				"axe_battle_hunger",
				"bounty_hunter_shuriken_toss",
				"broodmother_spawn_spiderlings",
				"centaur_double_edge",
				"chaos_knight_reality_rift",
				"chen_holy_persuasion",
				"ogre_magi_fireblast",
				"crystal_maiden_frostbite",
				"storm_spirit_electric_vortex",
				"sven_storm_bolt",
				"dark_willow_cursed_crown",
				"dazzle_poison_touch",
				"kunkka_x_marks_the_spot",
				"skeleton_king_hellfire_blast",
				"chaos_knight_chaos_bolt",
				"tiny_toss",
				"sandking_burrowstrike",
				"rubick_telekinesis",
				"undying_soul_rip",
				"snapfire_firesnap_cookie",
				"disruptor_thunder_strike",
				"rubick_fade_bolt",
				"winter_wyvern_splinter_blast",
				"night_stalker_void",
				"lion_impale",
				"doom_bringer_infernal_blade",
				"leshrac_lightning_storm",
				"dragon_knight_breathe_fire",
				"lich_frost_nova",
				"warlock_fatal_bonds",
				"dragon_knight_dragon_tail",
				"earth_spirit_boulder_smash",
				"enigma_malefice",
				"abaddon_death_coil"
			}
			-- Skillshot 1
			local pool2 = 
			{
				"nyx_assassin_impale",
				"puck_illusory_orb",
				"mars_spear",
				"phantom_lancer_doppelwalk",
				"tidehunter_anchor_smash",
				"enigma_midnight_pulse",
				"death_prophet_silence",
				"nevermore_shadowraze2",
				"rattletrap_rocket_flare",
				"riki_tricks_of_the_trade",
				"batrider_sticky_napalm",
				"nevermore_shadowraze1",
				"silencer_curse_of_the_silent",
				"dark_willow_bramble_maze",
				"brewmaster_cinder_brew",
				"mars_gods_rebuke",
				"skywrath_mage_concussive_shot",
				"slardar_slithereen_crush",
				"pudge_meat_hook",
				"grimstroke_dark_artistry",
				"dark_willow_shadow_realm",
				"drow_ranger_wave_of_silence",
				"tiny_avalanche",
				"pangolier_shield_crash",
				"mirana_starfall",
				"tusk_ice_shards",
				"slark_dark_pact",
				"vengefulspirit_wave_of_terror",
				"undying_decay",
				"weaver_the_swarm",
				"windrunner_powershot",
				"grimstroke_dark_artistry",
				"razor_plasma_field",
				"void_spirit_aether_remnant",
				"storm_spirit_static_remnant",
				"techies_land_mines",
				"viper_nethertoxin",
				"legion_commander_overwhelming_odds",
				"pangolier_swashbuckle",
				"witch_doctor_maledict",
				"snapfire_scatterblast",
				"crystal_maiden_crystal_nova"
			}
			-- Skillshot 2
			local pool3 = 
			{
				"bloodseeker_blood_bath",
				"batrider_flamebreak",
				"beastmaster_wild_axes",
				"death_prophet_carrion_swarm",
				"pudge_rot",
				"drow_ranger_multishot",
				"puck_waning_rift",
				"shadow_demon_soul_catcher",
				"ember_spirit_sleight_of_fist",
				"earthshaker_enchant_totem",
				"shredder_whirling_death",
				"arc_warden_spark_wraith",
				"riki_smoke_screen",
				"sniper_shrapnel",
				"necrolyte_death_pulse",
				"abyssal_underlord_pit_of_malice",
				"leshrac_diabolic_edict",
				"doom_bringer_scorched_earth",
				"ursa_earthshock",
				"brewmaster_thunder_clap",
				"abyssal_underlord_firestorm",
				"earthshaker_fissure",
				"lina_light_strike_array",
				"pugna_nether_blast",
				"jakiro_dual_breath",
				"juggernaut_blade_fury",
				"kunkka_torrent",
				"earth_spirit_rolling_boulder",
				"leshrac_split_earth",
				"tinker_march_of_the_machines",
				"queenofpain_scream_of_pain",
				"faceless_void_time_dilation",
				"dark_seer_vacuum",
				"ancient_apparition_ice_vortex",
				"alchemist_acid_spray",
				"jakiro_ice_path",
				"lina_dragon_slave",
				"centaur_hoof_stomp",
				"magnataur_shockwave",
				"meepo_earthbind",
				"mirana_arrow",
				"gyrocopter_rocket_barrage",
				"monkey_king_boundless_strike"
			}
			-- Utility
			local pool4 =
			{
				"terrorblade_reflection",
				"slark_pounce",
				"disruptor_kinetic_field",
				"faceless_void_time_walk",
				"magnataur_skewer",
				"rattletrap_power_cogs",
				"beastmaster_call_of_the_wild_boar",
				"templar_assassin_refraction",
				"naga_siren_mirror_image",
				"obsidian_destroyer_equilibrium",
				"lycan_howl",
				"brewmaster_drunken_brawler",
				"treant_leech_seed",
				"ember_spirit_flame_guard",
				"terrorblade_conjure_image",
				"shredder_timber_chain",
				"arc_warden_magnetic_field",
				"void_spirit_resonant_pulse",
				"nyx_assassin_spiked_carapace",
				"beastmaster_call_of_the_wild_hawk",
				"puck_phase_shift",
				"enchantress_natures_attendants",
				"sven_warcry",
				"tusk_tag_team",
				"juggernaut_healing_ward",
				"huskar_inner_fire",
				"snapfire_lil_shredder"
			}	
			-- Ultimates
			local pool5 =
			{
				"keeper_of_the_light_will_o_wisp",
				"chaos_knight_phantasm",
				"chen_hand_of_god",
				"rattletrap_hookshot",
				"crystal_maiden_freezing_field",
				"dark_willow_terrorize",
				"disruptor_static_storm",
				"elder_titan_earth_splitter",
				"enigma_black_hole",
				"gyrocopter_call_down",
				"antimage_mana_void",
				"jakiro_macropyre",
				"kunkka_ghostship",
				"sven_gods_strength",
				"abaddon_borrowed_time",
				"batrider_flaming_lasso",
				"leshrac_pulse_nova",
				"magnataur_reverse_polarity",
				"medusa_stone_gaze",
				"monkey_king_wukongs_command",
				"omniknight_guardian_angel",
				"obsidian_destroyer_sanity_eclipse",
				"phantom_assassin_coup_de_grace",
				"phantom_lancer_juxtapose",
				"phoenix_supernova",
				"puck_dream_coil",
				"queenofpain_sonic_wave",
				"razor_eye_of_the_storm",
				"clinkz_burning_army",
				"skywrath_mage_mystic_flare",
				"void_spirit_astral_step",
				"zuus_thundergods_wrath",
				"alchemist_chemical_rage",
				"bristleback_warpath",
				"broodmother_insatiable_hunger",
				"centaur_stampede",
				"sandking_epicenter",
				"tidehunter_ravage",
				"tiny_grow",
				"mars_arena_of_blood",
				"treant_overgrowth",
				"troll_warlord_battle_trance",
				"tusk_walrus_punch",
				"ursa_enrage",
				"venomancer_poison_nova",
				"witch_doctor_death_ward"
			}
			-- Passives
			local pool6 = 
			{
				"antimage_spell_shield",
				"luna_moon_glaive",
				"phantom_lancer_phantom_edge",
				"kunkka_tidebringer",
				"life_stealer_feast",
				"omniknight_degen_aura",
				"huskar_berserkers_blood",
				"broodmother_incapacitating_bite",
				"weaver_geminate_attack",
				"spectre_dispersion",
				"ursa_fury_swipes",
				"spirit_breaker_greater_bash",
				"alchemist_goblins_greed",				
				"lycan_feral_impulse",
				"rubick_arcane_supremacy",		
				"chen_divine_favor",
				"medusa_mana_shield",
				"naga_siren_rip_tide",
				"crystal_maiden_brilliance_aura",
				"earthshaker_aftershock",
				"nevermore_necromastery",
				"nevermore_dark_lord",
				"razor_unstable_current",
				"storm_spirit_overload",
				"vengefulspirit_command_aura",
				"tidehunter_kraken_shell",
				"sniper_headshot",
				"beastmaster_inner_beast",
				"venomancer_poison_sting",
				"faceless_void_time_lock",
				"skeleton_king_vampiric_aura",
				"templar_assassin_psi_blades",
				"viper_corrosive_skin",
				"luna_lunar_blessing",
				"centaur_return",
				"medusa_split_shot",
				--"abaddon_frostmourne",
				"elder_titan_natural_order",
				"skeleton_king_mortal_strike"
			}
			
			local s1 = PickRandomShuffle( pool1, self.pool1SkillBucket )
			local s2 = PickRandomShuffle( pool2, self.pool2SkillBucket )
			local s3 = PickRandomShuffle( pool3, self.pool3SkillBucket )
			local s4 = PickRandomShuffle( pool4, self.pool4SkillBucket )
			local ult5 = PickRandomShuffle( pool5, self.pool5SkillBucket )
			local sp = PickRandomShuffle( pool6, self.pool6SkillBucket )
			print( s1 )
			print( s2 )
			print( s3 )
			print( s4 )
			print( ult5 )
			print( sp )
			hero:AddAbility( s1 ) -- Unit/Point Target
			hero:AddAbility( s2 ) -- Skillshots
			hero:AddAbility( s3 ) -- Skillshots
			hero:AddAbility( s4 ) -- Utilities
			hero:AddAbility( ult5 ) -- Ultimates			
			hero:AddAbility( sp ) -- Passives
			-- Automatic passive upgrade
			local handlename = hero:GetAbilityByIndex( 6 )
			
			hero:SetAbilityPoints( hero:GetAbilityPoints() + 1 )
			hero:UpgradeAbility( handlename )
			
			local attrh = hero:GetPrimaryAttribute()
			
			if attrh == 2 then
				hero:SetBaseManaRegen( 16.4 )
				print("mana regen set to 4.3")
			else
				hero:SetBaseManaRegen( 17.2 )
				print("mana regen set to 5.2")
			end
			
			if attrh == 0 then
				hero:SetBaseHealthRegen( 2.4 )
				print("health regen set to 2.5")
			else
				hero:SetBaseHealthRegen( 3.1 )
				print("health regen set to 3.1")
			end
			
			hero:AddExperience( 300, 0, false, true)
end

--------------------------------------------------------------------------------
-- Event: Player has randomed hero
--------------------------------------------------------------------------------
function COverthrowGameMode:HasRandomed(event)
		SetGold(player, 800, true)
end

--------------------------------------------------------------------------------
-- Event: Filter for inventory full
--------------------------------------------------------------------------------
function COverthrowGameMode:ExecuteOrderFilter( filterTable )
	--[[
	for k, v in pairs( filterTable ) do
		print("EO: " .. k .. " " .. tostring(v) )
	end
	]]

	local orderType = filterTable["order_type"]
	if ( orderType ~= DOTA_UNIT_ORDER_PICKUP_ITEM or filterTable["issuer_player_id_const"] == -1 ) then
		return true
	else
		local item = EntIndexToHScript( filterTable["entindex_target"] )
		if item == nil then
			return true
		end
		local pickedItem = item:GetContainedItem()
		--print(pickedItem:GetAbilityName())
		if pickedItem == nil then
			return true
		end
		if pickedItem:GetAbilityName() == "item_treasure_chest" then
			local player = PlayerResource:GetPlayer(filterTable["issuer_player_id_const"])
			local hero = player:GetAssignedHero()
			if hero:GetNumItemsInInventory() < 6 then
				--print("inventory has space")
				return true
			else
				--print("Moving to target instead")
				local position = item:GetAbsOrigin()
				filterTable["position_x"] = position.x
				filterTable["position_y"] = position.y
				filterTable["position_z"] = position.z
				filterTable["order_type"] = DOTA_UNIT_ORDER_MOVE_TO_POSITION
				return true
			end
		end
	end
	return true
end
