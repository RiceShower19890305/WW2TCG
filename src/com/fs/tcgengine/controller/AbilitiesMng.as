package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSAction;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSEvent;
   import com.fs.tcgengine.view.cards.FSUnit;
   import flash.utils.Dictionary;
   
   public class AbilitiesMng
   {
      
      public static const TRIGGERS_SPECIAL:int = -1;
      
      public static const TRIGGERS_ON_START:int = 0;
      
      public static const TRIGGERS_ON_COMBAT:int = 1;
      
      public static const TRIGGERS_ON_ATTACK:int = 2;
      
      public static const TRIGGERS_ON_DEFENSE:int = 3;
      
      public static const TRIGGERS_ON_END:int = 4;
      
      public static const TRIGGERS_ON_PLAY:int = 5;
      
      public static const TRIGGERS_ON_PROMOTE:int = 6;
      
      public static const TARGET_ALL:int = 0;
      
      public static const TARGET_ALL_FRIENDLY:int = 1;
      
      public static const TARGET_ALL_ENEMY:int = 2;
      
      public static const TARGET_ALL_PLAYERS:int = 3;
      
      public static const TARGET_ALL_CARDS:int = 4;
      
      public static const TARGET_ALL_FRIENDLY_CARDS:int = 5;
      
      public static const TARGET_ALL_ENEMY_CARDS:int = 6;
      
      public static const TARGET_FRIENDLY_PLAYER:int = 7;
      
      public static const TARGET_ENEMY_PLAYER:int = 8;
      
      public static const TARGET_FRIENDLY:int = 9;
      
      public static const TARGET_ENEMY:int = 10;
      
      public static const TARGET_FRIENDLY_CARD:int = 11;
      
      public static const TARGET_ENEMY_CARD:int = 12;
      
      public static const TARGET_SELF_CARD:int = 13;
      
      public static const TARGET_FRIENDLY_ADJACENT_CARD:int = 14;
      
      public static const TARGET_FRIENDLY_ATTACK_CARD:int = 15;
      
      public static const TARGET_ENEMY_OPPOSITE_CARD:int = 16;
      
      public static const TARGET_ENEMY_RANDOM_CARD:int = 17;
      
      public static const TARGET_FRIENDLY_RANDOM_CARD:int = 18;
      
      public static const TARGET_RANDOM_CARD:int = 19;
      
      public static const TARGET_CARD:int = 20;
      
      public static const TARGET_ENEMY_CARD_IN_FRONT:int = 21;
      
      public static const TARGET_ENEMY_CARD_COST_LOWER_THAN:int = 22;
      
      public static const TARGET_ENEMY_CARD_COST_HIGHER_THAN:int = 23;
      
      public static const TARGET_FRIENDLY_CARD_COST_LOWER_THAN:int = 24;
      
      public static const TARGET_FRIENDLY_CARD_COST_HIGHER_THAN:int = 25;
      
      public static const TARGET_RANDOM_CARD_COST_LOWER_THAN:int = 26;
      
      public static const TARGET_RANDOM_CARD_COST_HIGHER_THAN:int = 27;
      
      public static const TARGET_ALL_ENEMY_CARD_COST_LOWER_THAN:int = 28;
      
      public static const TARGET_ALL_ENEMY_CARD_COST_HIGHER_THAN:int = 29;
      
      public static const TARGET_ALL_FRIENDLY_CARD_COST_LOWER_THAN:int = 30;
      
      public static const TARGET_ALL_FRIENDLY_CARD_COST_HIGHER_THAN:int = 31;
      
      public static const TARGET_ALL_CARDS_COST_LOWER_THAN:int = 32;
      
      public static const TARGET_ALL_CARDS_COST_HIGHER_THAN:int = 33;
      
      public static const TARGET_ENEMY_CARD_ATTACK_LOWER_THAN:int = 34;
      
      public static const TARGET_ENEMY_CARD_ATTACK_HIGHER_THAN:int = 35;
      
      public static const TARGET_FRIENDLY_CARD_ATTACK_LOWER_THAN:int = 36;
      
      public static const TARGET_FRIENDLY_CARD_ATTACK_HIGHER_THAN:int = 37;
      
      public static const TARGET_RANDOM_CARD_ATTACK_LOWER_THAN:int = 38;
      
      public static const TARGET_RANDOM_CARD_ATTACK_HIGHER_THAN:int = 39;
      
      public static const TARGET_ALL_ENEMY_CARD_ATTACK_LOWER_THAN:int = 40;
      
      public static const TARGET_ALL_ENEMY_CARD_ATTACK_HIGHER_THAN:int = 41;
      
      public static const TARGET_ALL_FRIENDLY_CARD_ATTACK_LOWER_THAN:int = 42;
      
      public static const TARGET_ALL_FRIENDLY_CARD_ATTACK_HIGHER_THAN:int = 43;
      
      public static const TARGET_ALL_CARDS_ATTACK_LOWER_THAN:int = 44;
      
      public static const TARGET_ALL_CARDS_ATTACK_HIGHER_THAN:int = 45;
      
      public static const TARGET_ENEMY_CARD_DEFENSE_LOWER_THAN:int = 46;
      
      public static const TARGET_ENEMY_CARD_DEFENSE_HIGHER_THAN:int = 47;
      
      public static const TARGET_FRIENDLY_CARD_DEFENSE_LOWER_THAN:int = 48;
      
      public static const TARGET_FRIENDLY_CARD_DEFENSE_HIGHER_THAN:int = 49;
      
      public static const TARGET_RANDOM_CARD_DEFENSE_LOWER_THAN:int = 50;
      
      public static const TARGET_RANDOM_CARD_DEFENSE_HIGHER_THAN:int = 51;
      
      public static const TARGET_ALL_ENEMY_CARD_DEFENSE_LOWER_THAN:int = 52;
      
      public static const TARGET_ALL_ENEMY_CARD_DEFENSE_HIGHER_THAN:int = 53;
      
      public static const TARGET_ALL_FRIENDLY_CARD_DEFENSE_LOWER_THAN:int = 54;
      
      public static const TARGET_ALL_FRIENDLY_CARD_DEFENSE_HIGHER_THAN:int = 55;
      
      public static const TARGET_ALL_CARDS_DEFENSE_LOWER_THAN:int = 56;
      
      public static const TARGET_ALL_CARDS_DEFENSE_HIGHER_THAN:int = 57;
      
      public static const TARGET_ALL_FRIENDLY_CARDS_EXCEPT_ITSELF:int = 58;
      
      public static const TARGET_ALL_FRIENDLY_CARDS_BY_ABILITY:int = 59;
      
      public static const TARGET_ALL_ENEMY_CARDS_BY_ABILITY:int = 60;
      
      public static const TARGET_ALL_CARDS_BY_ABILITY:int = 61;
      
      public static const TARGET_FRIENDLY_CARDS_BY_ABILITY:int = 62;
      
      public static const TARGET_ENEMY_CARDS_BY_ABILITY:int = 63;
      
      public static const TARGET_CARDS_BY_ABILITY:int = 64;
      
      public static const TARGET_ALL_CARDS_DECK:int = 65;
      
      public static const TARGET_ALL_ENEMY_CARDS_DECK:int = 66;
      
      public static const TARGET_ALL_FRIENDLY_CARDS_DECK:int = 67;
      
      public static const TARGET_NEXT_CARD_DECK:int = 68;
      
      public static const TARGET_NEXT_ENEMY_CARD_DECK:int = 69;
      
      public static const TARGET_NEXT_FRIENDLY_CARD_DECK:int = 70;
      
      public static const TARGET_FRIENDLY_CARDS_EXCEPT_ITSELF:int = 71;
      
      public static const TARGET_FRIENDLY_SUPPORT_LANE_CARDS:int = 72;
      
      public static const TARGET_ENEMY_SUPPORT_LANE_CARDS:int = 73;
      
      public static const TARGET_ALL_SUPPORT_LANE_CARDS:int = 74;
      
      public static const TARGET_FRIENDLY_ATTACK_LANE_CARDS:int = 75;
      
      public static const TARGET_ENEMY_ATTACK_LANE_CARDS:int = 76;
      
      public static const TARGET_ALL_ATTACK_LANE_CARDS:int = 77;
      
      public static const TARGET_FRIENDLY_SUPPORT_LANE_CARD:int = 78;
      
      public static const TARGET_ENEMY_SUPPORT_LANE_CARD:int = 79;
      
      public static const TARGET_ALL_SUPPORT_LANE_CARD:int = 80;
      
      public static const TARGET_FRIENDLY_ATTACK_LANE_CARD:int = 81;
      
      public static const TARGET_ENEMY_ATTACK_LANE_CARD:int = 82;
      
      public static const TARGET_ALL_ATTACK_LANE_CARD:int = 83;
      
      public static const TARGET_FRIENDLY_SUPPORT_LANE_CARDS_EXCEPT_ITSELF:int = 84;
      
      public static const TARGET_FRIENDLY_ATTACK_LANE_CARDS_EXCEPT_ITSELF:int = 85;
      
      public static const TARGET_FRIENDLY_SUPPORT_LANE_CARD_EXCEPT_ITSELF:int = 86;
      
      public static const TARGET_FRIENDLY_ATTACK_LANE_CARD_EXCEPT_ITSELF:int = 87;
      
      public static const TARGET_CARD_IN_COMBAT:int = 88;
      
      public static const TARGET_CARD_HIGHER_HEALTH_ALL_CARDS:int = 89;
      
      public static const TARGET_ENEMY_CARD_HIGHER_HEALTH:int = 90;
      
      public static const TARGET_ENEMY_CARD_HIGHER_HEALTH_SUPPORT_LANE:int = 91;
      
      public static const TARGET_ENEMY_CARD_HIGHER_HEALTH_FRONT_LANE:int = 92;
      
      public static const TARGET_FRIENDLY_CARD_HIGHER_HEALTH:int = 93;
      
      public static const TARGET_FRIENDLY_CARD_HIGHER_HEALTH_SUPPORT_LANE:int = 94;
      
      public static const TARGET_FRIENDLY_CARD_HIGHER_HEALTH_FRONT_LANE:int = 95;
      
      public static const TARGET_CARD_LOWER_HEALTH_ALL_CARDS:int = 96;
      
      public static const TARGET_ENEMY_CARD_LOWER_HEALTH:int = 97;
      
      public static const TARGET_ENEMY_CARD_LOWER_HEALTH_SUPPORT_LANE:int = 98;
      
      public static const TARGET_ENEMY_CARD_LOWER_HEALTH_FRONT_LANE:int = 99;
      
      public static const TARGET_FRIENDLY_CARD_LOWER_HEALTH:int = 100;
      
      public static const TARGET_FRIENDLY_CARD_LOWER_HEALTH_SUPPORT_LANE:int = 101;
      
      public static const TARGET_FRIENDLY_CARD_LOWER_HEALTH_FRONT_LANE:int = 102;
      
      public static const TARGET_CARD_HIGHER_ATTACK_ALL_CARDS:int = 103;
      
      public static const TARGET_ENEMY_CARD_HIGHER_ATTACK:int = 104;
      
      public static const TARGET_ENEMY_CARD_HIGHER_ATTACK_SUPPORT_LANE:int = 105;
      
      public static const TARGET_ENEMY_CARD_HIGHER_ATTACK_FRONT_LANE:int = 106;
      
      public static const TARGET_FRIENDLY_CARD_HIGHER_ATTACK:int = 107;
      
      public static const TARGET_FRIENDLY_CARD_HIGHER_ATTACK_SUPPORT_LANE:int = 108;
      
      public static const TARGET_FRIENDLY_CARD_HIGHER_ATTACK_FRONT_LANE:int = 109;
      
      public static const TARGET_CARD_LOWER_ATTACK_ALL_CARDS:int = 110;
      
      public static const TARGET_ENEMY_CARD_LOWER_ATTACK:int = 111;
      
      public static const TARGET_ENEMY_CARD_LOWER_ATTACK_SUPPORT_LANE:int = 112;
      
      public static const TARGET_ENEMY_CARD_LOWER_ATTACK_FRONT_LANE:int = 113;
      
      public static const TARGET_FRIENDLY_CARD_LOWER_ATTACK:int = 114;
      
      public static const TARGET_FRIENDLY_CARD_LOWER_ATTACK_SUPPORT_LANE:int = 115;
      
      public static const TARGET_FRIENDLY_CARD_LOWER_ATTACK_FRONT_LANE:int = 116;
      
      public static const AP_HIGHLIGHT_ANIM:String = "AP_HIGHLIGHT";
      
      public static const BULLETS_MIX_ANIM:String = "BULLETS_MIX";
      
      public static const EXPLOSION_ANIM:String = "EXPLOSION";
      
      public static const EXPLOSION_AIR_ANIM:String = "EXPLOSION_AIR";
      
      public static const EXPLOSION_INFANTRY_ANIM:String = "EXPLOSION_INFANTRY";
      
      public static const EXPLOSION_RUSSIAN_ANIM:String = "EXPLOSION_RUSSIAN";
      
      public static const EXPLOSION_TANK_ANIM:String = "EXPLOSION_TANK";
      
      public static const FLAMETHROWER_ANIM:String = "FLAMETHROWER";
      
      public static const SLEEP_ANIM:String = "SLEEP";
      
      public static const WATER_ANIM:String = "WATER";
      
      public static const WATER_EXPLOSION_ANIM:String = "WATER_EXPLOSION";
      
      public static const CHARM_ANIM:String = "CHARM";
      
      public static const WIND_ANIM:String = "WIND";
      
      public static const STOMP_ANIM:String = "STOMP";
      
      public static const SOLAR_ANIM:String = "SOLAR";
      
      public static const MAGIC_EXPLOSION_ANIM:String = "MAGIC_EXPLOSION";
      
      public static const ICON_ZOOM_ANIM:String = "ICON_ZOOM";
      
      public static const MOVIE_CLIP_ZOOM_ANIM:String = "MC_ZOOM";
      
      public static const ONLY_AUDIO_ANIM:String = "ONLY_AUDIO";
      
      public static const RANZOMIZE_POS_ANIM:String = "RANDOMIZE_POS";
      
      public static const ICON_ROTATE_ANIM:String = "ICON_ROTATE";
      
      public static const SPRITESHEET_ANIM:String = "SPRITESHEET";
      
      public static const BLOOD_SPLASH_ANIM:String = "BLOOD";
      
      public static const POISON_ANIM:String = "POISON";
      
      public static const SMOKE_ANIM:String = "SMOKE";
      
      public static const SMOKE_FIRE_ANIM:String = "SMOKE_FIRE";
      
      public static const ARROW_ANIM:String = "ARROW";
      
      public static const CANNON_ANIM:String = "CANNON";
      
      public static const AXE_ANIM:String = "AXE";
      
      public static const ELEPHANT_ANIM:String = "ELEPHANT";
      
      public static const ELEPHANT_BF_ANIM:String = "ELEPHANT_BF";
      
      public static const BOMBER_BF_ANIM:String = "BOMBER_BF";
      
      public static const ARTILLERY_EXPLOSIONS_ANIM:String = "ARTILLERY_EXPLOSIONS";
      
      public static const JAVELIN_ANIM:String = "JAVELIN";
      
      public static const CARRIAGE_ANIM:String = "CARRIAGE";
      
      public static const SPECIAL_REINFORCED:String = "REINFORCED";
      
      public static const SPECIAL_DEPLOY:String = "DEPLOY";
      
      public static const SPECIAL_ARTILLERY:String = "ARTILLERY";
      
      public static const SPECIAL_DAMAGETAKEN:String = "DAMAGETAKEN";
      
      public static const SPECIAL_BRUTALITY:String = "BRUTALITY";
      
      public static const SPECIAL_FAST:String = "FAST";
      
      public static const SPECIAL_MACHINEGUN:String = "MACHINEGUN";
      
      public static const SPECIAL_MACHINEGUN_PLUS:String = "MACHINEGUNPLUS";
      
      public static const SPECIAL_MACHINEGUN_4:String = "MACHINEGUN4";
      
      public static const SPECIAL_SNIPER:String = "SNIPER";
      
      public static const SPECIAL_SCOUTDIVISION:String = "SCOUTDIVISION";
      
      public static const SPECIAL_FLIGHT:String = "FLIGHT";
      
      public static const SPECIAL_SUBMARINE:String = "SUBMARINE";
      
      public static const SPECIAL_EVASION:String = "EVASION";
      
      public static const SPECIAL_MERCENARY:String = "MERCENARY";
      
      public static const SPECIAL_EQUIP:String = "EQUIP";
      
      public static const SPECIAL_MILITARHONOR:String = "MILITARHONOR";
      
      public static const SPECIAL_AIRDEFENSE:String = "AIRDEFENSE";
      
      public static const SPECIAL_SUBMARINEDEFENSE:String = "SUBMARINEDEFENSE";
      
      public static const SPECIAL_UNTARGETABLE:String = "UNTARGETABLE";
      
      public static const SPECIAL_TAUNT:String = "TAUNT";
      
      public static const SPECIAL_SABOTAGE:String = "SABOTAGE";
      
      public static const SPECIAL_AUTOSABOTAGE:String = "AUTOSABOTAGE";
      
      public static const SPECIAL_CODEINTERCEPTION:String = "CODEINTERCEPTION";
      
      public static const SPECIAL_MASSCODEINTERCEPTION:String = "MASSCODEINTERCEPTION";
      
      public static const SPECIAL_CONFUSION:String = "CONFUSION";
      
      public static const SPECIAL_MASSCONFUSION:String = "MASSCONFUSION";
      
      public static const SPECIAL_CAPTURED:String = "CAPTURED";
      
      public static const SPECIAL_MASSCAPTURED:String = "MASSCAPTURED";
      
      public static const SPECIAL_BETTEREQUIP:String = "BETTEREQUIP";
      
      public static const SPECIAL_FULLPROMOTE:String = "FULLPROMOTE";
      
      public static const SPECIAL_MEDICAL:String = "MEDICAL";
      
      public static const SPECIAL_MASSMEDICAL:String = "MASSMEDICAL";
      
      public static const SPECIAL_SLOW:String = "SLOW";
      
      public static const SPECIAL_SIEGE:String = "SIEGE";
      
      public static const SPECIAL_FORTIFICATION:String = "FORTIFICATION";
      
      public static const SPECIAL_KILL:String = "KILL";
      
      public static const SPECIAL_MASSKILL:String = "MASSKILL";
      
      public static const SPECIAL_WELLEQUIPED:String = "WELLEQUIPED";
      
      public static const SPECIAL_SCORCHED:String = "SCORCHED";
      
      public static const SPECIAL_GREATSCORCHED:String = "GREATSCORCHED";
      
      public static const SPECIAL_DISCIPLINE:String = "DISCIPLINE";
      
      public static const SPECIAL_AFFINITY:String = "AFFINITY";
      
      public static const SPECIAL_POLITICAL:String = "POLITICAL";
      
      public static const SPECIAL_MASSPOLITICAL:String = "MASSPOLITICAL";
      
      public static const SPECIAL_RISING:String = "RISING";
      
      public static const SPECIAL_MASSRISING:String = "MASSRISING";
      
      public static const SPECIAL_SELFRISING:String = "SELFRISING";
      
      public static const SPECIAL_MASSIVERISING:String = "MASSIVERISING";
      
      public static const SPECIAL_UNBLOCKABLE:String = "UNBLOCKABLE";
      
      public static const SPECIAL_MASSUNBLOCKABLE:String = "MASSUNBLOCKABLE";
      
      public static const SPECIAL_PERMANENTUNBLOCKABLE:String = "PERMANENTUNBLOCKABLE";
      
      public static const SPECIAL_SPY:String = "SPY";
      
      public static const SPECIAL_MASSSPY:String = "MASSSPY";
      
      public static const SPECIAL_UNITSPY:String = "UNITSPY";
      
      public static const SPECIAL_TACTICALMASTER:String = "TACTICALMASTER";
      
      public static const SPECIAL_MASSTACTICALMASTER:String = "MASSTACTICALMASTER";
      
      public static const SPECIAL_AMERICANHERO:String = "AMERICANHERO";
      
      public static const SPECIAL_GERMANHERO:String = "GERMANHERO";
      
      public static const SPECIAL_RUSSIANHERO:String = "RUSSIANHERO";
      
      public static const SPECIAL_JAPANESEHERO:String = "JAPANESEHERO";
      
      public static const SPECIAL_SWAPDAMAGEBYDEFENSE:String = "SWAPDAMAGEBYDEFENSE";
      
      public static const SPECIAL_POLYMORPH:String = "POLYMORPH";
      
      public static const SPECIAL_POISON:String = "POISON";
      
      public static const SPECIAL_MASSPOISON:String = "MASSPOISON";
      
      public static const SPECIAL_MULTICAST:String = "MULTICAST";
      
      public static const SPECIAL_SACRIFICE:String = "SACRIFICE";
      
      public static const SPECIAL_DEMOTE:String = "DEMOTE";
      
      public static const SPECIAL_TOTALDEMOTE:String = "TOTALDEMOTE";
      
      public static const SPECIAL_LEECH:String = "LEECH";
      
      public static const SPECIAL_MODIFYCOST:String = "MODIFYCOST";
      
      public static const SPECIAL_FIXEDCOST:String = "FIXEDCOST";
      
      public static const SPECIAL_RECRUIT:String = "RECRUIT";
      
      public static const SPECIAL_APGENERATED:String = "APGENERATED";
      
      public static const SPECIAL_CONDITIONAL:String = "CONDITIONAL";
      
      public static const SPECIAL_LEADER:String = "LEADER";
      
      public static const AFFINITY_BG:String = "strong";
      
      public static const COUNTER_AFFINITY_BG:String = "weak";
      
      public static const MULTIPLIER_BY_CARDS_NONE:int = 0;
      
      public static const MULTIPLIER_BY_CARDS_BATTLEFIELD:int = 1;
      
      public static const MULTIPLIER_BY_CARDS_DECK:int = 2;
      
      public static const TARGET_TYPE_FRIENDLY:int = 0;
      
      public static const TARGET_TYPE_ENEMY:int = 1;
      
      public static const TARGET_TYPE_ALL:int = 2;
      
      private var mBattleEngine:BattleEngine;
      
      private var mBattleScreen:FSBattleScreen;
      
      private var mOwnerBattleInfo:UserBattleInfo;
      
      private var mOpponentBattleInfo:UserBattleInfo;
      
      public function AbilitiesMng()
      {
         super();
      }
      
      public static function getTargetType(param1:Ability) : int
      {
         var _loc2_:int = -1;
         switch(param1.getAbilityDef().getTargetIndex())
         {
            case TARGET_ALL:
            case TARGET_ALL_CARDS:
            case TARGET_ALL_CARDS_ATTACK_HIGHER_THAN:
            case TARGET_ALL_CARDS_ATTACK_LOWER_THAN:
            case TARGET_ALL_CARDS_BY_ABILITY:
            case TARGET_ALL_CARDS_COST_HIGHER_THAN:
            case TARGET_ALL_CARDS_COST_LOWER_THAN:
            case TARGET_ALL_CARDS_DECK:
            case TARGET_ALL_CARDS_DEFENSE_HIGHER_THAN:
            case TARGET_ALL_CARDS_DEFENSE_LOWER_THAN:
               _loc2_ = TARGET_TYPE_ALL;
               break;
            case TARGET_ALL_ENEMY:
            case TARGET_ALL_ENEMY_CARD_ATTACK_HIGHER_THAN:
            case TARGET_ALL_ENEMY_CARD_ATTACK_LOWER_THAN:
            case TARGET_ALL_ENEMY_CARD_COST_HIGHER_THAN:
            case TARGET_ALL_ENEMY_CARD_COST_LOWER_THAN:
            case TARGET_ALL_ENEMY_CARD_DEFENSE_HIGHER_THAN:
            case TARGET_ALL_ENEMY_CARD_DEFENSE_LOWER_THAN:
            case TARGET_ALL_ENEMY_CARDS:
            case TARGET_ALL_ENEMY_CARDS_BY_ABILITY:
            case TARGET_ALL_ENEMY_CARDS_DECK:
               _loc2_ = TARGET_TYPE_ENEMY;
               break;
            case TARGET_ALL_FRIENDLY:
            case TARGET_ALL_FRIENDLY_CARD_ATTACK_HIGHER_THAN:
            case TARGET_ALL_FRIENDLY_CARD_ATTACK_LOWER_THAN:
            case TARGET_ALL_FRIENDLY_CARD_COST_HIGHER_THAN:
            case TARGET_ALL_FRIENDLY_CARD_COST_LOWER_THAN:
            case TARGET_ALL_FRIENDLY_CARD_DEFENSE_HIGHER_THAN:
            case TARGET_ALL_FRIENDLY_CARD_DEFENSE_LOWER_THAN:
            case TARGET_ALL_FRIENDLY_CARDS:
            case TARGET_ALL_FRIENDLY_CARDS_BY_ABILITY:
            case TARGET_ALL_FRIENDLY_CARDS_DECK:
            case TARGET_ALL_FRIENDLY_CARDS_EXCEPT_ITSELF:
               _loc2_ = TARGET_TYPE_FRIENDLY;
         }
         return _loc2_;
      }
      
      public function isAbilityTriggereable(param1:Ability) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc8_:FSCard = null;
         var _loc9_:Boolean = false;
         var _loc10_:FSCard = null;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc3_:Boolean = this.attackerCardAllowsTriggeringAbilities(param1);
         if(!_loc3_)
         {
            return false;
         }
         var _loc4_:int = param1.getAbilityDef().getTriggerIndex();
         this.updateCommonValues();
         var _loc5_:Boolean = this.mBattleEngine.isOwnerTurn();
         var _loc6_:int = this.mBattleEngine.getPlayersStateId();
         var _loc7_:int = this.mBattleEngine.getBattleStateId();
         if(!param1.isAbilityPassive())
         {
            _loc8_ = param1.getParentCard();
            _loc9_ = !_loc8_.isAttacking();
            _loc10_ = _loc8_.getFightingWithCard();
            _loc11_ = _loc8_ is FSEvent;
            if(_loc11_)
            {
               return true;
            }
            _loc12_ = _loc8_ is FSAction;
            if(_loc12_)
            {
               _loc13_ = FSAction(_loc8_).getCardSummonCost();
               _loc14_ = _loc8_.getParentUserBattleInfo() ? _loc8_.getParentUserBattleInfo().getActionPointsLeft() : 0;
               return _loc13_ <= _loc14_;
            }
         }
         switch(_loc4_)
         {
            case TRIGGERS_SPECIAL:
               return false;
            case TRIGGERS_ON_START:
               _loc2_ = _loc5_ ? _loc6_ == BattleEngine.STATE_OWNER_TRIGGER_ON_START_ABILITIES : _loc6_ == BattleEngine.STATE_OPPONENT_TRIGGER_ON_START_ABILITIES;
               break;
            case TRIGGERS_ON_COMBAT:
               _loc15_ = _loc8_.isOnSummonCooldown();
               _loc2_ = _loc7_ == BattleEngine.BATTLE_STATE_ATTACKING && _loc10_ != null && (!_loc15_ || _loc15_ && _loc9_);
               break;
            case TRIGGERS_ON_ATTACK:
               if(param1.isAbilityPassive())
               {
                  if(InstanceMng.getBattleEngine().isOwnerTurn())
                  {
                     _loc2_ = _loc6_ == BattleEngine.STATE_OWNER_ATTACKING;
                  }
                  else
                  {
                     _loc2_ = _loc6_ == BattleEngine.STATE_OPPONENT_ATTACKING;
                  }
               }
               else
               {
                  _loc16_ = _loc8_.getParentUserBattleInfo().isOwnerBattleInfo();
                  if(_loc5_)
                  {
                     if(_loc16_)
                     {
                        _loc2_ = _loc6_ == BattleEngine.STATE_OWNER_ATTACKING && _loc8_.isAttacking();
                     }
                  }
                  else if(!_loc16_)
                  {
                     _loc2_ = _loc6_ == BattleEngine.STATE_OPPONENT_ATTACKING && _loc8_.isAttacking();
                  }
               }
               break;
            case TRIGGERS_ON_DEFENSE:
               _loc2_ = _loc5_ ? _loc6_ == BattleEngine.STATE_OWNER_ATTACKING : _loc6_ == BattleEngine.STATE_OPPONENT_ATTACKING;
               _loc2_ &&= _loc9_;
               break;
            case TRIGGERS_ON_END:
               _loc2_ = _loc5_ ? _loc6_ == BattleEngine.STATE_OWNER_TRIGGER_ON_END_ABILITIES : _loc6_ == BattleEngine.STATE_OPPONENT_TRIGGER_ON_END_ABILITIES;
               break;
            case TRIGGERS_ON_PLAY:
               _loc2_ = _loc5_ ? _loc6_ == BattleEngine.STATE_OWNER_MOVING_CARDS : _loc6_ == BattleEngine.STATE_OPPONENT_MOVING_CARDS;
               break;
            case TRIGGERS_ON_PROMOTE:
               if(param1.isAbilityPassive())
               {
                  _loc2_ = _loc5_ ? this.mBattleEngine.getOwnerBattleInfo().isAnyCardBeingPromoted() : this.mBattleEngine.getOpponentBattleInfo().isAnyCardBeingPromoted();
               }
               else
               {
                  _loc2_ = param1.getParentCard() ? param1.getParentCard().isCardBeingPromoted() : false;
               }
         }
         return _loc2_;
      }
      
      private function attackerCardAllowsTriggeringAbilities(param1:Ability) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:FSCard = null;
         var _loc5_:Boolean = false;
         var _loc6_:FSCard = null;
         var _loc2_:Boolean = true;
         if(param1 != null)
         {
            _loc3_ = param1.getAbilityDef().getTargetIndex();
            if(_loc3_ == TARGET_ENEMY_OPPOSITE_CARD)
            {
               _loc4_ = param1.getParentCard();
               if(_loc4_ != null)
               {
                  _loc5_ = !_loc4_.isAttacking();
                  if(_loc5_)
                  {
                     _loc6_ = _loc4_.getFightingWithCard();
                     if(_loc6_ != null)
                     {
                        if(_loc6_ is FSUnit)
                        {
                           if(FSUnit(_loc6_).isOnSupportLane())
                           {
                              _loc2_ = !FSUnit(_loc6_).isArtillery();
                           }
                        }
                     }
                  }
               }
            }
         }
         return _loc2_;
      }
      
      private function updateCommonValues() : void
      {
         this.mBattleScreen = FSBattleScreen(InstanceMng.getCurrentScreen());
         this.mBattleEngine = this.mBattleScreen.getBattleEngine();
         this.mOwnerBattleInfo = this.mBattleEngine.getOwnerBattleInfo();
         this.mOpponentBattleInfo = this.mBattleEngine.getOpponentBattleInfo();
      }
      
      public function getEligibleTargetsByTargetIndex(param1:AbilityDef, param2:FSCard, param3:int = 0) : Array
      {
         var _loc6_:Array = null;
         var _loc4_:int = param1.getTargetIndex();
         var _loc5_:String = param1.getKeyName();
         this.updateCommonValues();
         switch(_loc4_)
         {
            case TARGET_ALL:
               _loc6_ = this.getTargetAll(param1);
               break;
            case TARGET_ALL_FRIENDLY:
               _loc6_ = this.getTargetAll(param1,false,true);
               break;
            case TARGET_ALL_ENEMY:
               _loc6_ = this.getTargetAll(param1,false,false);
               break;
            case TARGET_ALL_PLAYERS:
               _loc6_ = this.getPlayers();
               break;
            case TARGET_ALL_CARDS:
               _loc6_ = this.getAllCards(param1);
               break;
            case TARGET_ALL_FRIENDLY_CARDS:
               _loc6_ = this.getAllCards(param1,false,true);
               break;
            case TARGET_ALL_ENEMY_CARDS:
               _loc6_ = this.getAllCards(param1,false,false);
               break;
            case TARGET_FRIENDLY_PLAYER:
               _loc6_ = this.getPlayers(false,true);
               break;
            case TARGET_ENEMY_PLAYER:
               _loc6_ = this.getPlayers(false,false);
               break;
            case TARGET_FRIENDLY:
               _loc6_ = this.getTargetAll(param1,false,true);
               break;
            case TARGET_ENEMY:
               _loc6_ = this.getTargetAll(param1,false,false);
               break;
            case TARGET_FRIENDLY_CARD:
               _loc6_ = this.getAllCards(param1,false,true);
               break;
            case TARGET_ENEMY_CARD:
               _loc6_ = this.getAllCards(param1,false,false);
               break;
            case TARGET_SELF_CARD:
               _loc6_ = this.getSelfCard(param2);
               break;
            case TARGET_FRIENDLY_ADJACENT_CARD:
               _loc6_ = this.getFriendlyAdjacentCard(param2);
               break;
            case TARGET_FRIENDLY_ATTACK_CARD:
               _loc6_ = this.getAttackCard(true,param2);
               break;
            case TARGET_ENEMY_OPPOSITE_CARD:
               _loc6_ = this.getAttackCard(false,param2);
               break;
            case TARGET_ENEMY_RANDOM_CARD:
               _loc6_ = this.getAllCards(param1,false,false,true);
               break;
            case TARGET_FRIENDLY_RANDOM_CARD:
               _loc6_ = this.getAllCards(param1,false,true,true);
               break;
            case TARGET_RANDOM_CARD:
               _loc6_ = this.getAllCards(param1,true,false,true);
               break;
            case TARGET_CARD:
               _loc6_ = this.getAllCards(param1);
               break;
            case TARGET_ENEMY_CARD_IN_FRONT:
               _loc6_ = this.getEnemyCardInFront(false,param2);
               break;
            case TARGET_ENEMY_CARD_COST_LOWER_THAN:
               _loc6_ = this.getAllCardsByCost(param1,true,param3,false,false);
               break;
            case TARGET_ENEMY_CARD_COST_HIGHER_THAN:
               _loc6_ = this.getAllCardsByCost(param1,false,param3,false,false);
               break;
            case TARGET_FRIENDLY_CARD_COST_LOWER_THAN:
               _loc6_ = this.getAllCardsByCost(param1,true,param3,false,true);
               break;
            case TARGET_FRIENDLY_CARD_COST_HIGHER_THAN:
               _loc6_ = this.getAllCardsByCost(param1,false,param3,false,true);
               break;
            case TARGET_RANDOM_CARD_COST_LOWER_THAN:
               _loc6_ = this.getAllCardsByCost(param1,true,param3,true,false,true);
               break;
            case TARGET_RANDOM_CARD_COST_HIGHER_THAN:
               _loc6_ = this.getAllCardsByCost(param1,false,param3,true,false,true);
               break;
            case TARGET_ALL_ENEMY_CARD_COST_LOWER_THAN:
               _loc6_ = this.getAllCardsByCost(param1,true,param3,false);
               break;
            case TARGET_ALL_ENEMY_CARD_COST_HIGHER_THAN:
               _loc6_ = this.getAllCardsByCost(param1,false,param3,false);
               break;
            case TARGET_ALL_FRIENDLY_CARD_COST_LOWER_THAN:
               _loc6_ = this.getAllCardsByCost(param1,true,param3,false,true);
               break;
            case TARGET_ALL_FRIENDLY_CARD_COST_HIGHER_THAN:
               _loc6_ = this.getAllCardsByCost(param1,false,param3,false,true);
               break;
            case TARGET_ALL_CARDS_COST_LOWER_THAN:
               _loc6_ = this.getAllCardsByCost(param1,true,param3,true);
               break;
            case TARGET_ALL_CARDS_COST_HIGHER_THAN:
               _loc6_ = this.getAllCardsByCost(param1,false,param3,true);
               break;
            case TARGET_ENEMY_CARD_ATTACK_LOWER_THAN:
               _loc6_ = this.getAllCardsByAttackValue(param1,true,param3,false);
               break;
            case TARGET_ENEMY_CARD_ATTACK_HIGHER_THAN:
               _loc6_ = this.getAllCardsByAttackValue(param1,false,param3,false);
               break;
            case TARGET_FRIENDLY_CARD_ATTACK_LOWER_THAN:
               _loc6_ = this.getAllCardsByAttackValue(param1,true,param3,false,true);
               break;
            case TARGET_FRIENDLY_CARD_ATTACK_HIGHER_THAN:
               _loc6_ = this.getAllCardsByAttackValue(param1,false,param3,false,true);
               break;
            case TARGET_RANDOM_CARD_ATTACK_LOWER_THAN:
               _loc6_ = this.getAllCardsByAttackValue(param1,true,param3,true,false,true);
               break;
            case TARGET_RANDOM_CARD_ATTACK_HIGHER_THAN:
               _loc6_ = this.getAllCardsByAttackValue(param1,false,param3,true,false,true);
               break;
            case TARGET_ALL_ENEMY_CARD_ATTACK_LOWER_THAN:
               _loc6_ = this.getAllCardsByAttackValue(param1,true,param3,false);
               break;
            case TARGET_ALL_ENEMY_CARD_ATTACK_HIGHER_THAN:
               _loc6_ = this.getAllCardsByAttackValue(param1,false,param3,false);
               break;
            case TARGET_ALL_FRIENDLY_CARD_ATTACK_LOWER_THAN:
               _loc6_ = this.getAllCardsByAttackValue(param1,true,param3,false,true);
               break;
            case TARGET_ALL_FRIENDLY_CARD_ATTACK_HIGHER_THAN:
               _loc6_ = this.getAllCardsByAttackValue(param1,false,param3,false,true);
               break;
            case TARGET_ALL_CARDS_ATTACK_LOWER_THAN:
               _loc6_ = this.getAllCardsByAttackValue(param1,true,param3,true);
               break;
            case TARGET_ALL_CARDS_ATTACK_HIGHER_THAN:
               _loc6_ = this.getAllCardsByAttackValue(param1,false,param3,true);
               break;
            case TARGET_ENEMY_CARD_DEFENSE_LOWER_THAN:
               _loc6_ = this.getAllCardsByDefenseValue(param1,true,param3,false);
               break;
            case TARGET_ENEMY_CARD_DEFENSE_HIGHER_THAN:
               _loc6_ = this.getAllCardsByDefenseValue(param1,false,param3,false);
               break;
            case TARGET_FRIENDLY_CARD_DEFENSE_LOWER_THAN:
               _loc6_ = this.getAllCardsByDefenseValue(param1,true,param3,false,true);
               break;
            case TARGET_FRIENDLY_CARD_DEFENSE_HIGHER_THAN:
               _loc6_ = this.getAllCardsByDefenseValue(param1,false,param3,false,true);
               break;
            case TARGET_RANDOM_CARD_DEFENSE_LOWER_THAN:
               _loc6_ = this.getAllCardsByDefenseValue(param1,true,param3,true,false,true);
               break;
            case TARGET_RANDOM_CARD_DEFENSE_HIGHER_THAN:
               _loc6_ = this.getAllCardsByDefenseValue(param1,false,param3,true,false,true);
               break;
            case TARGET_ALL_ENEMY_CARD_DEFENSE_LOWER_THAN:
               _loc6_ = this.getAllCardsByDefenseValue(param1,true,param3,false);
               break;
            case TARGET_ALL_ENEMY_CARD_DEFENSE_HIGHER_THAN:
               _loc6_ = this.getAllCardsByDefenseValue(param1,false,param3,false);
               break;
            case TARGET_ALL_FRIENDLY_CARD_DEFENSE_LOWER_THAN:
               _loc6_ = this.getAllCardsByDefenseValue(param1,true,param3,false,true);
               break;
            case TARGET_ALL_FRIENDLY_CARD_DEFENSE_HIGHER_THAN:
               _loc6_ = this.getAllCardsByDefenseValue(param1,false,param3,false,true);
               break;
            case TARGET_ALL_CARDS_DEFENSE_LOWER_THAN:
               _loc6_ = this.getAllCardsByDefenseValue(param1,true,param3,true);
               break;
            case TARGET_ALL_CARDS_DEFENSE_HIGHER_THAN:
               _loc6_ = this.getAllCardsByDefenseValue(param1,false,param3,true);
               break;
            case TARGET_ALL_FRIENDLY_CARDS_EXCEPT_ITSELF:
               _loc6_ = this.removeCardItself(this.getAllCards(param1,false,true),param2);
               break;
            case TARGET_ALL_FRIENDLY_CARDS_BY_ABILITY:
               _loc6_ = this.getAllCardsByAbilities(param1,param2,false,true);
               break;
            case TARGET_ALL_ENEMY_CARDS_BY_ABILITY:
               _loc6_ = this.getAllCardsByAbilities(param1,param2,false,false);
               break;
            case TARGET_ALL_CARDS_BY_ABILITY:
               _loc6_ = this.getAllCardsByAbilities(param1,param2,true,false);
               break;
            case TARGET_FRIENDLY_CARDS_BY_ABILITY:
               _loc6_ = this.getAllCardsByAbilities(param1,param2,false,true);
               break;
            case TARGET_ENEMY_CARDS_BY_ABILITY:
               _loc6_ = this.getAllCardsByAbilities(param1,param2,false,false);
               break;
            case TARGET_CARDS_BY_ABILITY:
               _loc6_ = this.getAllCardsByAbilities(param1,param2,true,false);
               break;
            case TARGET_ALL_CARDS_DECK:
               _loc6_ = this.getPlayers();
               break;
            case TARGET_ALL_ENEMY_CARDS_DECK:
               _loc6_ = this.getPlayers(false);
               break;
            case TARGET_ALL_FRIENDLY_CARDS_DECK:
               _loc6_ = this.getPlayers(false,true);
               break;
            case TARGET_NEXT_CARD_DECK:
               _loc6_ = this.getPlayers();
               break;
            case TARGET_NEXT_ENEMY_CARD_DECK:
               _loc6_ = this.getPlayers(false);
               break;
            case TARGET_NEXT_FRIENDLY_CARD_DECK:
               _loc6_ = this.getPlayers(false,true);
               break;
            case TARGET_FRIENDLY_CARDS_EXCEPT_ITSELF:
               _loc6_ = this.removeCardItself(this.getAllCards(param1,false,true),param2);
               break;
            case TARGET_FRIENDLY_SUPPORT_LANE_CARDS:
               _loc6_ = this.getAllCards(param1,false,true,false,true,false);
               break;
            case TARGET_ENEMY_SUPPORT_LANE_CARDS:
               _loc6_ = this.getAllCards(param1,false,false,false,true,false);
               break;
            case TARGET_ALL_SUPPORT_LANE_CARDS:
               _loc6_ = this.getAllCards(param1,true,true,false,true,false);
               break;
            case TARGET_FRIENDLY_ATTACK_LANE_CARDS:
               _loc6_ = this.getAllCards(param1,false,true,false,false,true);
               break;
            case TARGET_ENEMY_ATTACK_LANE_CARDS:
               _loc6_ = this.getAllCards(param1,false,false,false,false,true);
               break;
            case TARGET_ALL_ATTACK_LANE_CARDS:
               _loc6_ = this.getAllCards(param1,true,true,false,false,true);
               break;
            case TARGET_FRIENDLY_SUPPORT_LANE_CARD:
               _loc6_ = this.getAllCards(param1,false,true,false,true,false);
               break;
            case TARGET_ENEMY_SUPPORT_LANE_CARD:
               _loc6_ = this.getAllCards(param1,false,false,false,true,false);
               break;
            case TARGET_ALL_SUPPORT_LANE_CARD:
               _loc6_ = this.getAllCards(param1,true,true,false,true,false);
               break;
            case TARGET_FRIENDLY_ATTACK_LANE_CARD:
               _loc6_ = this.getAllCards(param1,false,true,false,false,true);
               break;
            case TARGET_ENEMY_ATTACK_LANE_CARD:
               _loc6_ = this.getAllCards(param1,false,false,false,false,true);
               break;
            case TARGET_ALL_ATTACK_LANE_CARD:
               _loc6_ = this.getAllCards(param1,true,true,false,false,true);
               break;
            case TARGET_FRIENDLY_SUPPORT_LANE_CARDS_EXCEPT_ITSELF:
               _loc6_ = this.removeCardItself(this.getAllCards(param1,false,true,false,true,false),param2);
               break;
            case TARGET_FRIENDLY_ATTACK_LANE_CARDS_EXCEPT_ITSELF:
               _loc6_ = this.removeCardItself(this.getAllCards(param1,false,true,false,false,true),param2);
               break;
            case TARGET_FRIENDLY_SUPPORT_LANE_CARD_EXCEPT_ITSELF:
               _loc6_ = this.removeCardItself(this.getAllCards(param1,false,true,false,true,false),param2);
               break;
            case TARGET_FRIENDLY_ATTACK_LANE_CARD_EXCEPT_ITSELF:
               _loc6_ = this.removeCardItself(this.getAllCards(param1,false,true,false,false,true),param2);
               break;
            case TARGET_CARD_IN_COMBAT:
               return [this.getCardFightingWith(param2)];
            case TARGET_CARD_HIGHER_HEALTH_ALL_CARDS:
               return [this.getCardWithHigherHealth(param1)];
            case TARGET_ENEMY_CARD_HIGHER_HEALTH:
               return [this.getCardWithHigherHealth(param1,false,false)];
            case TARGET_ENEMY_CARD_HIGHER_HEALTH_SUPPORT_LANE:
               return [this.getCardWithHigherHealth(param1,false,false,true,false)];
            case TARGET_ENEMY_CARD_HIGHER_HEALTH_FRONT_LANE:
               return [this.getCardWithHigherHealth(param1,false,false,false)];
            case TARGET_FRIENDLY_CARD_HIGHER_HEALTH:
               return [this.getCardWithHigherHealth(param1,false,true)];
            case TARGET_FRIENDLY_CARD_HIGHER_HEALTH_SUPPORT_LANE:
               return [this.getCardWithHigherHealth(param1,false,true,true,false)];
            case TARGET_FRIENDLY_CARD_HIGHER_HEALTH_FRONT_LANE:
               return [this.getCardWithHigherHealth(param1,false,true,false)];
            case TARGET_CARD_LOWER_HEALTH_ALL_CARDS:
               return [this.getCardWithLowerHealth(param1)];
            case TARGET_ENEMY_CARD_LOWER_HEALTH:
               return [this.getCardWithLowerHealth(param1,false,false)];
            case TARGET_ENEMY_CARD_LOWER_HEALTH_SUPPORT_LANE:
               return [this.getCardWithLowerHealth(param1,false,false,true,false)];
            case TARGET_ENEMY_CARD_LOWER_HEALTH_FRONT_LANE:
               return [this.getCardWithLowerHealth(param1,false,false,false)];
            case TARGET_FRIENDLY_CARD_LOWER_HEALTH:
               return [this.getCardWithLowerHealth(param1,false,true)];
            case TARGET_FRIENDLY_CARD_LOWER_HEALTH_SUPPORT_LANE:
               return [this.getCardWithLowerHealth(param1,false,true,true,false)];
            case TARGET_FRIENDLY_CARD_LOWER_HEALTH_FRONT_LANE:
               return [this.getCardWithLowerHealth(param1,false,true,false)];
            case TARGET_CARD_HIGHER_ATTACK_ALL_CARDS:
               return [this.getCardWithHigherAttack(param1)];
            case TARGET_ENEMY_CARD_HIGHER_ATTACK:
               return [this.getCardWithHigherAttack(param1,false,false)];
            case TARGET_ENEMY_CARD_HIGHER_ATTACK_SUPPORT_LANE:
               return [this.getCardWithHigherAttack(param1,false,false,true,false)];
            case TARGET_ENEMY_CARD_HIGHER_ATTACK_FRONT_LANE:
               return [this.getCardWithHigherAttack(param1,false,false,false,true)];
            case TARGET_FRIENDLY_CARD_HIGHER_ATTACK:
               return [this.getCardWithHigherAttack(param1,false,true)];
            case TARGET_FRIENDLY_CARD_HIGHER_ATTACK_SUPPORT_LANE:
               return [this.getCardWithHigherAttack(param1,false,true,true,false)];
            case TARGET_FRIENDLY_CARD_HIGHER_ATTACK_FRONT_LANE:
               return [this.getCardWithHigherAttack(param1,false,true,false,true)];
            case TARGET_CARD_LOWER_ATTACK_ALL_CARDS:
               return [this.getCardWithLowerAttack(param1)];
            case TARGET_ENEMY_CARD_LOWER_ATTACK:
               return [this.getCardWithLowerAttack(param1,false,false)];
            case TARGET_ENEMY_CARD_LOWER_ATTACK_SUPPORT_LANE:
               return [this.getCardWithLowerAttack(param1,false,false,true,false)];
            case TARGET_ENEMY_CARD_LOWER_ATTACK_FRONT_LANE:
               return [this.getCardWithLowerAttack(param1,false,false,false,true)];
            case TARGET_FRIENDLY_CARD_LOWER_ATTACK:
               return [this.getCardWithLowerAttack(param1,false,true)];
            case TARGET_FRIENDLY_CARD_LOWER_ATTACK_SUPPORT_LANE:
               return [this.getCardWithLowerAttack(param1,false,true,true,false)];
            case TARGET_FRIENDLY_CARD_LOWER_ATTACK_FRONT_LANE:
               return [this.getCardWithLowerAttack(param1,false,true,false,true)];
         }
         return _loc6_;
      }
      
      private function getCardFightingWith(param1:FSCard) : FSCard
      {
         var _loc3_:FSCard = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc2_:FSCard = null;
         if(param1 != null)
         {
            _loc3_ = param1.getFightingWithCard();
            if(_loc3_ != null)
            {
               _loc4_ = _loc3_.isOnSupportLane();
               _loc5_ = _loc3_.isAttacking();
               if(!_loc4_ || _loc4_ && !_loc5_)
               {
                  return _loc3_;
               }
            }
         }
         return _loc2_;
      }
      
      public function isTargetSelectionAbility(param1:AbilityDef) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(param1 != null)
         {
            _loc3_ = param1.getTargetIndex();
            _loc2_ = _loc3_ == TARGET_FRIENDLY || _loc3_ == TARGET_ENEMY || _loc3_ == TARGET_FRIENDLY_CARD || _loc3_ == TARGET_ENEMY_CARD || _loc3_ == TARGET_CARD || _loc3_ == TARGET_ENEMY_CARD_COST_LOWER_THAN || _loc3_ == TARGET_ENEMY_CARD_COST_HIGHER_THAN || _loc3_ == TARGET_FRIENDLY_CARD_COST_LOWER_THAN || _loc3_ == TARGET_FRIENDLY_CARD_COST_HIGHER_THAN || _loc3_ == TARGET_ENEMY_CARD_ATTACK_LOWER_THAN || _loc3_ == TARGET_ENEMY_CARD_ATTACK_HIGHER_THAN || _loc3_ == TARGET_FRIENDLY_CARD_ATTACK_LOWER_THAN || _loc3_ == TARGET_FRIENDLY_CARD_ATTACK_HIGHER_THAN || _loc3_ == TARGET_ENEMY_CARD_DEFENSE_LOWER_THAN || _loc3_ == TARGET_ENEMY_CARD_DEFENSE_HIGHER_THAN || _loc3_ == TARGET_FRIENDLY_CARD_DEFENSE_LOWER_THAN || _loc3_ == TARGET_FRIENDLY_CARD_DEFENSE_HIGHER_THAN || _loc3_ == TARGET_FRIENDLY_CARDS_BY_ABILITY || _loc3_ == TARGET_ENEMY_CARDS_BY_ABILITY || _loc3_ == TARGET_CARDS_BY_ABILITY || _loc3_ == TARGET_FRIENDLY_CARDS_EXCEPT_ITSELF || _loc3_ == TARGET_FRIENDLY_SUPPORT_LANE_CARD || _loc3_ == TARGET_ENEMY_SUPPORT_LANE_CARD || _loc3_ == TARGET_ALL_SUPPORT_LANE_CARD || _loc3_ == TARGET_FRIENDLY_ATTACK_LANE_CARD || _loc3_ == TARGET_ENEMY_ATTACK_LANE_CARD || _loc3_ == TARGET_ALL_ATTACK_LANE_CARD || _loc3_ == TARGET_FRIENDLY_SUPPORT_LANE_CARD_EXCEPT_ITSELF || _loc3_ == TARGET_FRIENDLY_ATTACK_LANE_CARD_EXCEPT_ITSELF;
         }
         return _loc2_;
      }
      
      public function isRandomTargetAbility(param1:AbilityDef) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(param1 != null)
         {
            _loc3_ = param1.getTargetIndex();
            _loc2_ = _loc3_ == TARGET_ENEMY_RANDOM_CARD || _loc3_ == TARGET_FRIENDLY_RANDOM_CARD || _loc3_ == TARGET_RANDOM_CARD || _loc3_ == TARGET_RANDOM_CARD_COST_LOWER_THAN || _loc3_ == TARGET_RANDOM_CARD_COST_HIGHER_THAN || _loc3_ == TARGET_RANDOM_CARD_ATTACK_LOWER_THAN || _loc3_ == TARGET_RANDOM_CARD_ATTACK_HIGHER_THAN || _loc3_ == TARGET_RANDOM_CARD_DEFENSE_LOWER_THAN || _loc3_ == TARGET_RANDOM_CARD_DEFENSE_HIGHER_THAN;
         }
         return _loc2_;
      }
      
      public function isRandomStatsAbility(param1:AbilityDef) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Boolean = false;
         if(param1 != null)
         {
            _loc3_ = param1.getRandomDamageAmount();
            _loc4_ = param1.getRandomDefenseAmount();
            _loc5_ = param1.getRandomHealAmount();
            return _loc3_ != 0 || _loc4_ != 0 || _loc5_ != 0;
         }
         return _loc2_;
      }
      
      private function getTargetAll(param1:AbilityDef, param2:Boolean = true, param3:Boolean = false) : Array
      {
         var _loc4_:Array = null;
         _loc4_ = this.getAllCards(param1,param2,param3);
         return this.getPlayers(param2,param3,_loc4_);
      }
      
      private function removeCardItself(param1:Array, param2:FSCard) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:FSCard = null;
         var _loc3_:int = -1;
         if(Boolean(param1) && param1.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc5_ = FSCard(param1[_loc4_]);
               if((Boolean(_loc5_)) && _loc5_ == param2)
               {
                  _loc3_ = _loc4_;
                  break;
               }
               _loc4_++;
            }
            if(_loc3_ != -1 && _loc3_ < param1.length)
            {
               param1.removeAt(_loc3_);
            }
         }
         return param1;
      }
      
      private function getAllCardsByAbilities(param1:AbilityDef, param2:FSCard, param3:Boolean = true, param4:Boolean = false) : Array
      {
         var _loc7_:Dictionary = null;
         var _loc8_:int = 0;
         var _loc9_:FSCard = null;
         var _loc10_:Array = null;
         var _loc11_:Ability = null;
         var _loc12_:Vector.<Ability> = null;
         var _loc5_:Array = new Array();
         var _loc6_:Boolean = InstanceMng.getBattleEngine().isOwnerTurn();
         _loc10_ = param1 != null ? param1.getAbilityTargetKeynames() : null;
         if(_loc10_ == null && Boolean(param2))
         {
            _loc12_ = param2.getCompositeAbilitiesVector();
            if((Boolean(_loc12_)) && _loc12_.length > 0)
            {
               for each(_loc11_ in _loc12_)
               {
                  if(_loc11_.getAbilityDef().getAbilityTargetKeynames() != null)
                  {
                     _loc10_ = _loc11_.getAbilityDef().getAbilityTargetKeynames();
                     break;
                  }
               }
            }
         }
         if(Boolean(_loc10_) && _loc10_.length > 0)
         {
            if(param3)
            {
               _loc5_ = this.addCardsFromCatalogToVector(param1,this.mOwnerBattleInfo.getFightCardsByAbilities(_loc10_),_loc5_);
               _loc5_ = this.addCardsFromCatalogToVector(param1,this.mOpponentBattleInfo.getFightCardsByAbilities(_loc10_),_loc5_);
            }
            else if(param4)
            {
               if(_loc6_)
               {
                  _loc5_ = this.addCardsFromCatalogToVector(param1,this.mOwnerBattleInfo.getFightCardsByAbilities(_loc10_),_loc5_);
               }
               else
               {
                  _loc5_ = this.addCardsFromCatalogToVector(param1,this.mOpponentBattleInfo.getFightCardsByAbilities(_loc10_),_loc5_);
               }
            }
            else if(_loc6_)
            {
               _loc5_ = this.addCardsFromCatalogToVector(param1,this.mOpponentBattleInfo.getFightCardsByAbilities(_loc10_),_loc5_);
            }
            else
            {
               _loc5_ = this.addCardsFromCatalogToVector(param1,this.mOwnerBattleInfo.getFightCardsByAbilities(_loc10_),_loc5_);
            }
         }
         return _loc5_;
      }
      
      private function getAllCardsDeck(param1:AbilityDef, param2:Boolean = true, param3:Boolean = false, param4:Boolean = false) : Array
      {
         var _loc7_:Dictionary = null;
         var _loc8_:FSCard = null;
         var _loc5_:Array = null;
         var _loc6_:Boolean = InstanceMng.getBattleEngine().isOwnerTurn();
         if(param2)
         {
            _loc5_ = this.addCardsFromCatalogToVector(param1,this.mOwnerBattleInfo.getPlayableCardsCatalog(),_loc5_);
            _loc5_ = this.addCardsFromCatalogToVector(param1,this.mOpponentBattleInfo.getPlayableCardsCatalog(),_loc5_);
         }
         else if(param3)
         {
            if(_loc6_)
            {
               _loc5_ = this.addCardsFromCatalogToVector(param1,this.mOwnerBattleInfo.getPlayableCardsCatalog(),_loc5_);
            }
            else
            {
               _loc5_ = this.addCardsFromCatalogToVector(param1,this.mOpponentBattleInfo.getPlayableCardsCatalog(),_loc5_);
            }
         }
         else if(_loc6_)
         {
            _loc5_ = this.addCardsFromCatalogToVector(param1,this.mOpponentBattleInfo.getPlayableCardsCatalog(),_loc5_);
         }
         else
         {
            _loc5_ = this.addCardsFromCatalogToVector(param1,this.mOwnerBattleInfo.getPlayableCardsCatalog(),_loc5_);
         }
         if(param4 && _loc5_ != null && _loc5_.length > 0)
         {
            _loc8_ = Utils.getRandomItemFromArr(_loc5_);
            _loc5_.length = 0;
            _loc5_.push(_loc8_);
         }
         return _loc5_;
      }
      
      private function getAllCards(param1:AbilityDef, param2:Boolean = true, param3:Boolean = false, param4:Boolean = false, param5:Boolean = true, param6:Boolean = true) : Array
      {
         var _loc9_:Dictionary = null;
         var _loc10_:* = 0;
         var _loc11_:FSCard = null;
         var _loc7_:Array = null;
         var _loc8_:Boolean = InstanceMng.getBattleEngine().isOwnerTurn();
         if(param2)
         {
            _loc7_ = this.addCardsFromCatalogToVector(param1,this.mOwnerBattleInfo.getFightCards(),_loc7_,param5,param6);
            _loc7_ = this.addCardsFromCatalogToVector(param1,this.mOpponentBattleInfo.getFightCards(),_loc7_,param5,param6);
         }
         else if(param3)
         {
            if(_loc8_)
            {
               _loc7_ = this.addCardsFromCatalogToVector(param1,this.mOwnerBattleInfo.getFightCards(),_loc7_,param5,param6);
            }
            else
            {
               _loc7_ = this.addCardsFromCatalogToVector(param1,this.mOpponentBattleInfo.getFightCards(),_loc7_,param5,param6);
            }
         }
         else if(_loc8_)
         {
            _loc7_ = this.addCardsFromCatalogToVector(param1,this.mOpponentBattleInfo.getFightCards(),_loc7_,param5,param6);
         }
         else
         {
            _loc7_ = this.addCardsFromCatalogToVector(param1,this.mOwnerBattleInfo.getFightCards(),_loc7_,param5,param6);
         }
         if(param4 && _loc7_ != null && _loc7_.length > 0)
         {
            _loc10_ = int(_loc7_.length - 1);
            while(_loc10_ >= 0)
            {
               if(!param1.isCardEligibleForAbility(_loc7_[_loc10_]))
               {
                  _loc7_.removeAt(_loc10_);
               }
               _loc10_--;
            }
            _loc11_ = Utils.getRandomItemFromArr(_loc7_);
            _loc7_.length = 0;
            if(_loc11_ != null)
            {
               _loc7_.push(_loc11_);
            }
         }
         return _loc7_;
      }
      
      private function getAllCardsByCost(param1:AbilityDef, param2:Boolean, param3:int, param4:Boolean = true, param5:Boolean = false, param6:Boolean = false) : Array
      {
         var _loc9_:FSCard = null;
         var _loc11_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:Array = this.getAllCards(param1,param4,param5);
         var _loc10_:Boolean = false;
         if(Boolean(_loc8_) && _loc8_.length > 0)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc8_.length)
            {
               _loc10_ = false;
               _loc9_ = _loc8_[_loc11_];
               _loc10_ = param2 ? Boolean(_loc9_) && _loc9_.getCardDef().getSummonCost() < param3 : Boolean(_loc9_) && _loc9_.getCardDef().getSummonCost() > param3;
               if(_loc10_)
               {
                  if(_loc7_ == null)
                  {
                     _loc7_ = new Array();
                  }
                  _loc7_.push(_loc9_);
               }
               _loc11_++;
            }
         }
         if(param6 && _loc7_ != null && _loc7_.length > 0)
         {
            _loc9_ = Utils.getRandomItemFromArr(_loc7_);
            _loc7_.length = 0;
            _loc7_.push(_loc9_);
         }
         return _loc7_;
      }
      
      private function getAllCardsByAttackValue(param1:AbilityDef, param2:Boolean, param3:int, param4:Boolean = true, param5:Boolean = false, param6:Boolean = false) : Array
      {
         var _loc9_:FSCard = null;
         var _loc11_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:Array = this.getAllCards(param1,param4,param5);
         var _loc10_:Boolean = false;
         if(Boolean(_loc8_) && _loc8_.length > 0)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc8_.length)
            {
               _loc10_ = false;
               _loc9_ = _loc8_[_loc11_];
               _loc10_ = param2 ? Boolean(_loc9_) && _loc9_.getDamage() < param3 : Boolean(_loc9_) && _loc9_.getDamage() > param3;
               if(_loc10_)
               {
                  if(_loc7_ == null)
                  {
                     _loc7_ = new Array();
                  }
                  _loc7_.push(_loc9_);
               }
               _loc11_++;
            }
         }
         if(param6 && _loc7_ != null && _loc7_.length > 0)
         {
            _loc9_ = Utils.getRandomItemFromArr(_loc7_);
            _loc7_.length = 0;
            _loc7_.push(_loc9_);
         }
         return _loc7_;
      }
      
      private function getAllCardsByDefenseValue(param1:AbilityDef, param2:Boolean, param3:int, param4:Boolean = true, param5:Boolean = false, param6:Boolean = false) : Array
      {
         var _loc9_:FSCard = null;
         var _loc11_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:Array = this.getAllCards(param1,param4,param5);
         var _loc10_:Boolean = false;
         if(Boolean(_loc8_) && _loc8_.length > 0)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc8_.length)
            {
               _loc10_ = false;
               _loc9_ = _loc8_[_loc11_];
               _loc10_ = param2 ? Boolean(_loc9_) && _loc9_.getDefense() < param3 : Boolean(_loc9_) && _loc9_.getDefense() > param3;
               if(_loc10_)
               {
                  if(_loc7_ == null)
                  {
                     _loc7_ = new Array();
                  }
                  _loc7_.push(_loc9_);
               }
               _loc11_++;
            }
         }
         if(param6 && _loc7_ != null && _loc7_.length > 0)
         {
            _loc9_ = Utils.getRandomItemFromArr(_loc7_);
            _loc7_.length = 0;
            _loc7_.push(_loc9_);
         }
         return _loc7_;
      }
      
      private function getCardWithHigherHealth(param1:AbilityDef, param2:Boolean = true, param3:Boolean = false, param4:Boolean = true, param5:Boolean = true) : FSCard
      {
         var _loc7_:FSCard = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc6_:Array = this.getAllCards(param1,param2,param3,false,param4,param5);
         var _loc8_:FSCard = null;
         if(Boolean(_loc6_) && _loc6_.length > 0)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc6_.length)
            {
               _loc7_ = _loc6_[_loc9_];
               _loc10_ = _loc7_.getDefense();
               _loc8_ = _loc8_ != null && _loc8_.getDefense() > _loc10_ ? _loc8_ : _loc7_;
               _loc9_++;
            }
         }
         return _loc8_;
      }
      
      private function getCardWithLowerHealth(param1:AbilityDef, param2:Boolean = true, param3:Boolean = false, param4:Boolean = true, param5:Boolean = true) : FSCard
      {
         var _loc7_:FSCard = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc6_:Array = this.getAllCards(param1,param2,param3,false,param4,param5);
         var _loc8_:FSCard = null;
         if(Boolean(_loc6_) && _loc6_.length > 0)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc6_.length)
            {
               _loc7_ = _loc6_[_loc9_];
               _loc10_ = _loc7_.getDefense();
               _loc8_ = _loc8_ != null && _loc8_.getDefense() < _loc10_ ? _loc8_ : _loc7_;
               _loc9_++;
            }
         }
         return _loc8_;
      }
      
      private function getCardWithHigherAttack(param1:AbilityDef, param2:Boolean = true, param3:Boolean = false, param4:Boolean = true, param5:Boolean = true) : FSCard
      {
         var _loc7_:FSCard = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc6_:Array = this.getAllCards(param1,param2,param3,false,param4,param5);
         var _loc8_:FSCard = null;
         if(Boolean(_loc6_) && _loc6_.length > 0)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc6_.length)
            {
               _loc7_ = _loc6_[_loc9_];
               _loc10_ = _loc7_.getDamage();
               _loc8_ = _loc8_ != null && _loc8_.getDamage() > _loc10_ ? _loc8_ : _loc7_;
               _loc9_++;
            }
         }
         return _loc8_;
      }
      
      private function getCardWithLowerAttack(param1:AbilityDef, param2:Boolean = true, param3:Boolean = false, param4:Boolean = true, param5:Boolean = true) : FSCard
      {
         var _loc7_:FSCard = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc6_:Array = this.getAllCards(param1,param2,param3,false,param4,param5);
         var _loc8_:FSCard = null;
         if(Boolean(_loc6_) && _loc6_.length > 0)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc6_.length)
            {
               _loc7_ = _loc6_[_loc9_];
               _loc10_ = _loc7_.getDamage();
               _loc8_ = _loc8_ != null && _loc8_.getDamage() < _loc10_ ? _loc8_ : _loc7_;
               _loc9_++;
            }
         }
         return _loc8_;
      }
      
      private function addCardsFromCatalogToVector(param1:AbilityDef, param2:Dictionary, param3:Array = null, param4:Boolean = true, param5:Boolean = true) : Array
      {
         var _loc7_:FSCard = null;
         var _loc8_:Boolean = false;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc6_:Array = param3 == null ? new Array() : param3;
         var _loc9_:String = param1.getKeyName();
         var _loc10_:Boolean = _loc9_ == SPECIAL_DEMOTE || _loc9_ == SPECIAL_TOTALDEMOTE;
         var _loc11_:Boolean = _loc9_ == SPECIAL_BETTEREQUIP || _loc9_ == SPECIAL_FULLPROMOTE;
         for each(_loc7_ in param2)
         {
            _loc12_ = _loc7_.getCardDef().getPreviousUpgradeSku();
            _loc13_ = _loc7_.getCardDef().getUpgradeSku();
            _loc8_ = _loc7_.isOnSupportLane();
            if((_loc8_) && param4 || !_loc8_ && param5)
            {
               if((!_loc11_ || _loc11_ && _loc13_ != null && _loc13_ != "") && (!_loc10_ || _loc10_ && _loc12_ != null && _loc12_ != ""))
               {
                  _loc6_.push(_loc7_);
               }
            }
         }
         return _loc6_;
      }
      
      private function getPlayers(param1:Boolean = true, param2:Boolean = false, param3:Array = null) : Array
      {
         var _loc6_:UserBattleInfo = null;
         var _loc4_:Array = param3 == null ? new Array() : param3;
         var _loc5_:Dictionary = this.mBattleEngine.getUserBattleInfoCatalog();
         var _loc7_:Boolean = InstanceMng.getBattleEngine().isOwnerTurn();
         for each(_loc6_ in _loc5_)
         {
            if(param1)
            {
               _loc4_.push(_loc6_);
            }
            else if(param2)
            {
               if(_loc7_)
               {
                  if(_loc6_.isOwnerBattleInfo())
                  {
                     _loc4_.push(_loc6_);
                  }
               }
               else if(!_loc6_.isOwnerBattleInfo())
               {
                  _loc4_.push(_loc6_);
               }
            }
            else if(_loc7_)
            {
               if(!_loc6_.isOwnerBattleInfo())
               {
                  _loc4_.push(_loc6_);
               }
            }
            else if(_loc6_.isOwnerBattleInfo())
            {
               _loc4_.push(_loc6_);
            }
         }
         return _loc4_;
      }
      
      private function getSelfCard(param1:FSCard) : Array
      {
         var _loc2_:Array = new Array();
         _loc2_.push(param1);
         return _loc2_;
      }
      
      private function getFriendlyAdjacentCard(param1:FSCard) : Array
      {
         var _loc2_:Array = null;
         if(param1 != null)
         {
            param1.getAdjacentCards();
         }
         return _loc2_;
      }
      
      private function getAttackCard(param1:Boolean, param2:FSCard, param3:Boolean = true) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:FSCard = null;
         var _loc6_:Boolean = false;
         if(param2 != null)
         {
            _loc6_ = param3 == true ? !param2.isAttacking() : param3;
            if(param1)
            {
               _loc5_ = param2.getAttackLaneCard();
            }
            else
            {
               _loc5_ = param2.getAttackableCard(true,null,_loc6_);
               if(_loc5_ == null)
               {
                  _loc5_ = param2.getAttackableCard(false,null,_loc6_);
               }
            }
            if(_loc5_ != null)
            {
               if(_loc4_ == null)
               {
                  _loc4_ = new Array();
               }
               _loc4_.push(_loc5_);
            }
         }
         return _loc4_;
      }
      
      private function getEnemyCardInFront(param1:Boolean, param2:FSCard, param3:Boolean = true) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:FSCard = null;
         var _loc6_:Boolean = false;
         if(param2 != null)
         {
            _loc6_ = param3 == true ? !param2.isAttacking() : param3;
            if(param1)
            {
               _loc5_ = param2.getAttackLaneCard();
            }
            else
            {
               _loc5_ = param2.getAttackableCard(true,null,_loc6_,true);
               if(_loc5_ == null)
               {
                  _loc5_ = param2.getAttackableCard(false,null,_loc6_,true);
               }
            }
            if(_loc5_ != null)
            {
               if(_loc4_ == null)
               {
                  _loc4_ = new Array();
               }
               _loc4_.push(_loc5_);
            }
         }
         return _loc4_;
      }
      
      public function isPersistentAbilityIcon(param1:Ability) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = param1.getAbilityDef().getKeyName();
         switch(_loc3_)
         {
            case SPECIAL_CAPTURED:
            case SPECIAL_MASSCAPTURED:
            case SPECIAL_RISING:
            case SPECIAL_MASSRISING:
            case SPECIAL_SELFRISING:
            case SPECIAL_MASSIVERISING:
            case SPECIAL_UNBLOCKABLE:
            case SPECIAL_MASSUNBLOCKABLE:
            case SPECIAL_CODEINTERCEPTION:
            case SPECIAL_MASSCODEINTERCEPTION:
            case SPECIAL_TACTICALMASTER:
            case SPECIAL_MASSTACTICALMASTER:
            case SPECIAL_POISON:
            case SPECIAL_MASSPOISON:
               return true;
            default:
               return false;
         }
      }
      
      public function abilityAffectsMultipleTargets(param1:Ability) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(!param1)
         {
            return _loc2_;
         }
         _loc3_ = param1.getAbilityDef().getTargetIndex();
         switch(_loc3_)
         {
            case TARGET_ALL:
            case TARGET_ALL_CARDS:
            case TARGET_ALL_ENEMY:
            case TARGET_ALL_ENEMY_CARDS:
            case TARGET_ALL_FRIENDLY:
            case TARGET_ALL_FRIENDLY_CARDS:
            case TARGET_ALL_FRIENDLY_CARDS_EXCEPT_ITSELF:
            case TARGET_ALL_PLAYERS:
               return true;
            default:
               return false;
         }
      }
      
      public function isCardEligibleForSpecialAbility(param1:FSCard, param2:AbilityDef) : Boolean
      {
         var _loc4_:String = null;
         var _loc3_:Boolean = true;
         if(param2)
         {
            _loc4_ = param2.getKeyName();
            switch(_loc4_)
            {
               case AbilitiesMng.SPECIAL_BETTEREQUIP:
               case AbilitiesMng.SPECIAL_FULLPROMOTE:
                  _loc3_ = param1.getCardDef().getUpgradeCost() > -1;
                  break;
               case AbilitiesMng.SPECIAL_DEMOTE:
               case AbilitiesMng.SPECIAL_TOTALDEMOTE:
                  _loc3_ = param1.getCardDef().getTier() > 1;
                  break;
               default:
                  _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      public function unload() : void
      {
         this.mBattleEngine = null;
         this.mBattleScreen = null;
         this.mOwnerBattleInfo = null;
         this.mOpponentBattleInfo = null;
      }
   }
}

