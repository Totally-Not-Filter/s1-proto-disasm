; ---------------------------------------------------------------------------
; Object pointers
; ---------------------------------------------------------------------------
ptr_SonicPlayer:	dc.l SonicPlayer	; 01
ptr_Obj02:	dc.l Obj02	; 02
ptr_Obj03:	dc.l Obj03	; 03
ptr_Obj04:	dc.l Obj04	; 04
ptr_Obj05:	dc.l Obj05	; 05
ptr_Obj06:	dc.l Obj06	; 06
ptr_Obj07:	dc.l Obj07	; 07
ptr_Obj08:	dc.l NullObject	; 08
ptr_SonicSpecial:	dc.l SonicSpecial	; 09
ptr_Obj0A:	dc.l NullObject	; 0A
ptr_Obj0B:	dc.l NullObject	; 0B
ptr_Obj0C:	dc.l NullObject	; 0C
ptr_Signpost:	dc.l Signpost	; 0D
ptr_TitleSonic:	dc.l TitleSonic	; 0E
ptr_PSBTM:	dc.l TitleText	; 0F
ptr_Obj10:	dc.l Obj10	; 10
ptr_Bridge:	dc.l Bridge	; 11
ptr_SpinningLight:	dc.l ObjSceneryLamp	; 12
ptr_LavaMaker:	dc.l ObjLavaMaker	; 13
ptr_LavaBall:	dc.l ObjLavaball	; 14
ptr_SwingingPlatform:	dc.l ObjSwingPtfm	; 15
ptr_Obj16:	dc.l NullObject	; 16
ptr_Helix:	dc.l ObjSpikeLogs	; 17
ptr_BasicPlatform:	dc.l ObjPlatform	; 18
ptr_GBall:	dc.l ObjRollingBall	; 19
ptr_CollapseLedge:	dc.l ObjCollapsePtfm	; 1A
ptr_Obj1B:	dc.l Obj1B	; 1B
ptr_Scenery:	dc.l ObjScenery	; 1C
ptr_MagicSwitch:	dc.l ObjUnkSwitch	; 1D
ptr_BallHog:	dc.l ObjBallhog	; 1E
ptr_Crabmeat:	dc.l ObjCrabmeat	; 1F
ptr_Cannonball:	dc.l ObjCannonball	; 20
ptr_HUD:	dc.l ObjHUD	; 21
ptr_BuzzBomber:	dc.l ObjBuzzbomber	; 22
ptr_Missile:	dc.l ObjBuzzMissile	; 23
ptr_MissileDissolve:	dc.l ObjCannonballExplode	; 24
ptr_Rings:	dc.l ObjRings	; 25
ptr_Monitor:	dc.l ObjMonitor	; 26
ptr_ExplosionItem:	dc.l ObjExplode	; 27
ptr_Animals:	dc.l ObjAnimals	; 28
ptr_Points:	dc.l ObjPoints	; 29
ptr_Obj2A:	dc.l Obj2A	; 2A
ptr_Chopper:	dc.l ObjChopper	; 2B
ptr_Jaws:	dc.l ObjJaws	; 2C
ptr_Burrobot:	dc.l ObjBurrobot	; 2D
ptr_PowerUp:	dc.l ObjMonitorItem	; 2E
ptr_LargeGrass:	dc.l ObjMZPlatforms	; 2F
ptr_GlassBlock:	dc.l ObjGlassBlock	; 30
ptr_ChainStomp:	dc.l ObjChainPtfm	; 31
ptr_Button:	dc.l ObjSwitch	; 32
ptr_PushBlock:	dc.l ObjPushBlock	; 33
ptr_TitleCard:	dc.l ObjTitleCard	; 34
ptr_GrassFire:	dc.l ObjFloorLavaball	; 35
ptr_Spikes:	dc.l ObjSpikes	; 36
ptr_RingLoss:	dc.l ObjRingLoss	; 37
ptr_ShieldItem:	dc.l ObjShield	; 38
ptr_GameOverCard:	dc.l ObjGameOver	; 39
ptr_GotThroughCard:	dc.l ObjLevelResults	; 3A
ptr_PurpleRock:	dc.l ObjPurpleRock	; 3B
ptr_SmashWall:	dc.l ObjSmashWall	; 3C
ptr_BossGreenHill:	dc.l ObjGHZBoss	; 3D
ptr_Prison:	dc.l ObjCapsule	; 3E
ptr_ExplosionBomb:	dc.l ObjBombExplode	; 3F
ptr_MotoBug:	dc.l ObjMotobug	; 40
ptr_Springs:	dc.l ObjSpring	; 41
ptr_Newtron:	dc.l ObjNewtron	; 42
ptr_Roller:	dc.l ObjRoller	; 43
ptr_EdgeWalls:	dc.l ObjWall	; 44
ptr_SideStomp:	dc.l Obj45	; 45
ptr_MarbleBrick:	dc.l ObjMZBlocks	; 46
ptr_Bumper:	dc.l ObjBumper	; 47
ptr_BossBall:	dc.l ObjGHZBossBall	; 48
ptr_WaterSound:	dc.l ObjWaterfallSnd	; 49
ptr_VanishSonic:	dc.l ObjEntryRingBeta	; 4A
ptr_GiantRing:	dc.l Obj4B	; 4B
ptr_GeyserMaker:	dc.l ObjLavafallMaker	; 4C
ptr_LavaGeyser:	dc.l ObjLavafall	; 4D
ptr_LavaWall:	dc.l ObjLavaChase	; 4E
ptr_Splats:	dc.l Obj4F	; 4F
ptr_Yadrin:	dc.l ObjYadrin	; 50
ptr_SmashBlock:	dc.l ObjSmashBlock	; 51
ptr_MovingBlock:	dc.l ObjMovingPtfm	; 52
ptr_CollapseFloor:	dc.l ObjCollapseFloor	; 53
ptr_LavaTag:	dc.l ObjLavaHurt	; 54
ptr_Basaran:	dc.l ObjBasaran	; 55
ptr_FloatingBlock:	dc.l ObjMovingBlocks	; 56
ptr_SpikeBall:	dc.l ObjSpikedBalls	; 57
ptr_BigSpikeBall:	dc.l ObjGiantSpikedBalls	; 58
ptr_Elevator:	dc.l ObjSLZMovingPtfm	; 59
ptr_CirclingPlatform:	dc.l ObjCirclePtfm	; 5A
ptr_Staircase:	dc.l ObjStaircasePtfm	; 5B
ptr_Pylon:	dc.l ObjSLZGirder	; 5C
ptr_Fan:	dc.l ObjFan	; 5D
ptr_Seesaw:	dc.l ObjSeeSaw	; 5E

NullObject:
		;bra.w	DeleteObject	; It would be safer to have this instruction here, but instead it just falls through to ObjectFall

id_SonicPlayer:	equ ((ptr_SonicPlayer-Obj_Index)/4)+1 ; $01
id_Obj02:	equ ((ptr_Obj02-Obj_Index)/4)+1
id_Obj03:	equ ((ptr_Obj03-Obj_Index)/4)+1
id_Obj04:	equ ((ptr_Obj04-Obj_Index)/4)+1
id_Obj05:	equ ((ptr_Obj05-Obj_Index)/4)+1
id_Obj06:	equ ((ptr_Obj06-Obj_Index)/4)+1
id_Obj07:	equ ((ptr_Obj07-Obj_Index)/4)+1
id_Obj08:	equ ((ptr_Obj08-Obj_Index)/4)+1	; $08
id_SonicSpecial:	equ ((ptr_SonicSpecial-Obj_Index)/4)+1
id_Obj0A:	equ ((ptr_Obj0A-Obj_Index)/4)+1
id_Obj0B:	equ ((ptr_Obj0B-Obj_Index)/4)+1
id_Obj0C:	equ ((ptr_Obj0C-Obj_Index)/4)+1
id_Signpost:	equ ((ptr_Signpost-Obj_Index)/4)+1
id_TitleSonic:	equ ((ptr_TitleSonic-Obj_Index)/4)+1
id_PSBTM:	equ ((ptr_PSBTM-Obj_Index)/4)+1
id_Obj10:	equ ((ptr_Obj10-Obj_Index)/4)+1	; $10
id_Bridge:	equ ((ptr_Bridge-Obj_Index)/4)+1
id_SpinningLight:	equ ((ptr_SpinningLight-Obj_Index)/4)+1
id_LavaMaker:	equ ((ptr_LavaMaker-Obj_Index)/4)+1
id_LavaBall:	equ ((ptr_LavaBall-Obj_Index)/4)+1
id_SwingingPlatform:	equ ((ptr_SwingingPlatform-Obj_Index)/4)+1
id_Obj16:	equ ((ptr_Obj16-Obj_Index)/4)+1
id_Helix:	equ ((ptr_Helix-Obj_Index)/4)+1
id_BasicPlatform:	equ ((ptr_BasicPlatform-Obj_Index)/4)+1 ; $18
id_GBall:	equ ((ptr_GBall-Obj_Index)/4)+1
id_CollapseLedge:	equ ((ptr_CollapseLedge-Obj_Index)/4)+1
id_Obj1B:	equ ((ptr_Obj1B-Obj_Index)/4)+1
id_Scenery:	equ ((ptr_Scenery-Obj_Index)/4)+1
id_MagicSwitch:	equ ((ptr_MagicSwitch-Obj_Index)/4)+1
id_BallHog:	equ ((ptr_BallHog-Obj_Index)/4)+1
id_Crabmeat:	equ ((ptr_Crabmeat-Obj_Index)/4)+1
id_Cannonball:	equ ((ptr_Cannonball-Obj_Index)/4)+1 ; $20
id_HUD:	equ ((ptr_HUD-Obj_Index)/4)+1
id_BuzzBomber:	equ ((ptr_BuzzBomber-Obj_Index)/4)+1
id_Missile:	equ ((ptr_Missile-Obj_Index)/4)+1
id_MissileDissolve:	equ ((ptr_MissileDissolve-Obj_Index)/4)+1
id_Rings:	equ ((ptr_Rings-Obj_Index)/4)+1
id_Monitor:	equ ((ptr_Monitor-Obj_Index)/4)+1
id_ExplosionItem:	equ ((ptr_ExplosionItem-Obj_Index)/4)+1
id_Animals:	equ ((ptr_Animals-Obj_Index)/4)+1 ; $28
id_Points:	equ ((ptr_Points-Obj_Index)/4)+1
id_Obj2A:	equ ((ptr_Obj2A-Obj_Index)/4)+1
id_Chopper:	equ ((ptr_Chopper-Obj_Index)/4)+1
id_Jaws:	equ ((ptr_Jaws-Obj_Index)/4)+1
id_Burrobot:	equ ((ptr_Burrobot-Obj_Index)/4)+1
id_PowerUp:	equ ((ptr_PowerUp-Obj_Index)/4)+1
id_LargeGrass:	equ ((ptr_LargeGrass-Obj_Index)/4)+1
id_GlassBlock:	equ ((ptr_GlassBlock-Obj_Index)/4)+1 ; $30
id_ChainStomp:	equ ((ptr_ChainStomp-Obj_Index)/4)+1
id_Button:	equ ((ptr_Button-Obj_Index)/4)+1
id_PushBlock:	equ ((ptr_PushBlock-Obj_Index)/4)+1
id_TitleCard:	equ ((ptr_TitleCard-Obj_Index)/4)+1
id_GrassFire:	equ ((ptr_GrassFire-Obj_Index)/4)+1
id_Spikes:	equ ((ptr_Spikes-Obj_Index)/4)+1
id_RingLoss:	equ ((ptr_RingLoss-Obj_Index)/4)+1
id_ShieldItem:	equ ((ptr_ShieldItem-Obj_Index)/4)+1 ; $38
id_GameOverCard:	equ ((ptr_GameOverCard-Obj_Index)/4)+1
id_GotThroughCard:	equ ((ptr_GotThroughCard-Obj_Index)/4)+1
id_PurpleRock:	equ ((ptr_PurpleRock-Obj_Index)/4)+1
id_SmashWall:	equ ((ptr_SmashWall-Obj_Index)/4)+1
id_BossGreenHill:	equ ((ptr_BossGreenHill-Obj_Index)/4)+1
id_Prison:	equ ((ptr_Prison-Obj_Index)/4)+1
id_ExplosionBomb:	equ ((ptr_ExplosionBomb-Obj_Index)/4)+1
id_MotoBug:	equ ((ptr_MotoBug-Obj_Index)/4)+1 ; $40
id_Springs:	equ ((ptr_Springs-Obj_Index)/4)+1
id_Newtron:	equ ((ptr_Newtron-Obj_Index)/4)+1
id_Roller:	equ ((ptr_Roller-Obj_Index)/4)+1
id_EdgeWalls:	equ ((ptr_EdgeWalls-Obj_Index)/4)+1
id_SideStomp:	equ ((ptr_SideStomp-Obj_Index)/4)+1
id_MarbleBrick:	equ ((ptr_MarbleBrick-Obj_Index)/4)+1
id_Bumper:	equ ((ptr_Bumper-Obj_Index)/4)+1
id_BossBall:	equ ((ptr_BossBall-Obj_Index)/4)+1 ; $48
id_WaterSound:	equ ((ptr_WaterSound-Obj_Index)/4)+1
id_VanishSonic:	equ ((ptr_VanishSonic-Obj_Index)/4)+1
id_GiantRing:	equ ((ptr_GiantRing-Obj_Index)/4)+1
id_GeyserMaker:	equ ((ptr_GeyserMaker-Obj_Index)/4)+1
id_LavaGeyser:	equ ((ptr_LavaGeyser-Obj_Index)/4)+1
id_LavaWall:	equ ((ptr_LavaWall-Obj_Index)/4)+1
id_Splats:	equ ((ptr_Splats-Obj_Index)/4)+1
id_Yadrin:	equ ((ptr_Yadrin-Obj_Index)/4)+1 ; $50
id_SmashBlock:	equ ((ptr_SmashBlock-Obj_Index)/4)+1
id_MovingBlock:	equ ((ptr_MovingBlock-Obj_Index)/4)+1
id_CollapseFloor:	equ ((ptr_CollapseFloor-Obj_Index)/4)+1
id_LavaTag:	equ ((ptr_LavaTag-Obj_Index)/4)+1
id_Basaran:	equ ((ptr_Basaran-Obj_Index)/4)+1
id_FloatingBlock:	equ ((ptr_FloatingBlock-Obj_Index)/4)+1
id_SpikeBall:	equ ((ptr_SpikeBall-Obj_Index)/4)+1
id_BigSpikeBall:	equ ((ptr_BigSpikeBall-Obj_Index)/4)+1 ; $58
id_Elevator:	equ ((ptr_Elevator-Obj_Index)/4)+1
id_CirclingPlatform:	equ ((ptr_CirclingPlatform-Obj_Index)/4)+1
id_Staircase:	equ ((ptr_Staircase-Obj_Index)/4)+1
id_Pylon:	equ ((ptr_Pylon-Obj_Index)/4)+1
id_Fan:	equ ((ptr_Fan-Obj_Index)/4)+1
id_Seesaw:	equ ((ptr_Seesaw-Obj_Index)/4)+1