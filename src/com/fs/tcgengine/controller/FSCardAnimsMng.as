package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.view.anims.cards.APHighlightAnimation;
   import com.fs.tcgengine.view.anims.cards.AirplaneBulletsAnim;
   import com.fs.tcgengine.view.anims.cards.ArrowAnimation;
   import com.fs.tcgengine.view.anims.cards.ArrowDamageAnimation;
   import com.fs.tcgengine.view.anims.cards.ArtilleryAnim;
   import com.fs.tcgengine.view.anims.cards.AudioCardAnimation;
   import com.fs.tcgengine.view.anims.cards.AxeAnimation;
   import com.fs.tcgengine.view.anims.cards.AxeDamageAnimation;
   import com.fs.tcgengine.view.anims.cards.BloodSplashAnimation;
   import com.fs.tcgengine.view.anims.cards.BomberAnim;
   import com.fs.tcgengine.view.anims.cards.BulletsMixAnimation;
   import com.fs.tcgengine.view.anims.cards.CannonAnimation;
   import com.fs.tcgengine.view.anims.cards.CardAnimation;
   import com.fs.tcgengine.view.anims.cards.CardShiningPromoteAnimation;
   import com.fs.tcgengine.view.anims.cards.CarriageAnimation;
   import com.fs.tcgengine.view.anims.cards.CharmAnimation;
   import com.fs.tcgengine.view.anims.cards.CustomSpritesheetAnimation;
   import com.fs.tcgengine.view.anims.cards.ElephantAnimation;
   import com.fs.tcgengine.view.anims.cards.ExplosionAnimation;
   import com.fs.tcgengine.view.anims.cards.FlamethrowerAnimation;
   import com.fs.tcgengine.view.anims.cards.IconRotateAnimation;
   import com.fs.tcgengine.view.anims.cards.IconZoomAnimation;
   import com.fs.tcgengine.view.anims.cards.InfantryBulletsAnim;
   import com.fs.tcgengine.view.anims.cards.JavelinAnimation;
   import com.fs.tcgengine.view.anims.cards.JavelinDamageAnimation;
   import com.fs.tcgengine.view.anims.cards.LightningAnimation;
   import com.fs.tcgengine.view.anims.cards.MovieClipZoomAnimation;
   import com.fs.tcgengine.view.anims.cards.PermanentParticleAnimation;
   import com.fs.tcgengine.view.anims.cards.PoisonAnimation;
   import com.fs.tcgengine.view.anims.cards.PromoteAudioOnlyAnimation;
   import com.fs.tcgengine.view.anims.cards.RandomizePosAnimation;
   import com.fs.tcgengine.view.anims.cards.ShipBulletAnim;
   import com.fs.tcgengine.view.anims.cards.SleepAnimation;
   import com.fs.tcgengine.view.anims.cards.SmokeAnimation;
   import com.fs.tcgengine.view.anims.cards.SniperBulletsAnim;
   import com.fs.tcgengine.view.anims.cards.SolarAnimation;
   import com.fs.tcgengine.view.anims.cards.StompAnimation;
   import com.fs.tcgengine.view.anims.cards.SubmarineBulletAnim;
   import com.fs.tcgengine.view.anims.cards.TankBulletAnim;
   import com.fs.tcgengine.view.anims.cards.WaterAnimation;
   import com.fs.tcgengine.view.anims.cards.WaterExplosionAnimation;
   import com.fs.tcgengine.view.anims.cards.WindAnimation;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSShopInfoCard;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   
   public class FSCardAnimsMng
   {
      
      public static const INFANTRY_DAMAGE_ANIM:String = "infantry_bullet";
      
      public static const INFANTRY_GERMAN_DAMAGE_ANIM:String = "infantry_bullet_german";
      
      public static const INFANTRY_RUSSIAN_DAMAGE_ANIM:String = "infantry_bullet_russian";
      
      public static const INFANTRY_JAPANESE_DAMAGE_ANIM:String = "infantry_bullet_japanese";
      
      public static const AUDIO_ANIM:String = "audio_anim";
      
      public static const TANK_DAMAGE_ANIM:String = "tank_bullet";
      
      public static const AIR_DAMAGE_ANIM:String = "air_bullet";
      
      public static const SHIP_DAMAGE_ANIM:String = "ship_bullet";
      
      public static const SUBMARINE_DAMAGE_ANIM:String = "submarine_bullet";
      
      public static const SNIPER_DAMAGE_ANIM:String = "sniper_bullet";
      
      public static const ARTILLERY_DAMAGE_ANIM:String = "artillery_bullet";
      
      public static const INFANTRY_BULLETS_AMOUNT:int = 5;
      
      public static const INFANTRY_GUN_FIRE_SOUND_NAME:String = "gun_fire";
      
      public static const INFANTRY_GERMAN_BULLETS_AMOUNT:int = 2;
      
      public static const INFANTRY_GERMAN_GUN_FIRE_SOUND_NAME:String = "karabiner";
      
      public static const INFANTRY_GERMAN_SPEED_FACTOR:Number = 0.06;
      
      public static const INFANTRY_RUSSIAN_BULLETS_AMOUNT:int = 4;
      
      public static const INFANTRY_RUSSIAN_GUN_FIRE_SOUND_NAME:String = "gun_fire_russian";
      
      public static const INFANTRY_RUSSIAN_SPEED_FACTOR:Number = 0.05;
      
      public static const INFANTRY_JAPANESE_BULLETS_AMOUNT:int = 5;
      
      public static const INFANTRY_JAPANESE_GUN_FIRE_SOUND_NAME:String = "ak47";
      
      public static const INFANTRY_JAPANESE_SPEED_FACTOR:Number = 0.04;
      
      public static const AIRPLANES_BULLETS_AMOUNT:int = 8;
      
      public static const AIRPLANES_GUN_FIRE_SOUND_NAME:String = "airplane_fire";
      
      public static const TANK_BULLETS_AMOUNT:int = 1;
      
      public static const TANK_GUN_FIRE_SOUND_NAME:String = "tank_fire_1";
      
      public static const TANK_GUN_FIRE_2_SOUND_NAME:String = "tank_fire_2";
      
      public static const STD_BULLET_IMAGE_NAME:String = "bullet_hole";
      
      public static const TANK_BULLET_IMAGE_NAME:String = "tank_bullet_hole";
      
      public static const SNIPER_GUN_FIRE_SOUND_NAME:String = "sniper_fire";
      
      public static const SNIPER_BULLET_IMAGE_NAME:String = "bullet_hole";
      
      public static const ARROW_SOUND_NAME:String = "attack_1";
      
      public static const ARROW_DAMAGE_ANIM:String = "arrow_nailed";
      
      public static const JAVELIN_DAMAGE_ANIM:String = "javelin_nailed";
      
      public static const AXE_DAMAGE_ANIM:String = "axe_nailed";
      
      public function FSCardAnimsMng()
      {
         super();
      }
      
      public function requestCardAnimDamageDealed(param1:FSCard) : CardAnimation
      {
         var _loc2_:CardAnimation = null;
         var _loc3_:Boolean = false;
         var _loc4_:UnitDef = null;
         var _loc5_:String = null;
         if(param1 != null && param1.getDamage() > 0)
         {
            _loc3_ = param1.isUnit();
            if(_loc3_)
            {
               _loc4_ = UnitDef(param1.getCardDef());
               _loc5_ = _loc4_.getDealDamageAnimSku();
               switch(_loc5_)
               {
                  case INFANTRY_DAMAGE_ANIM:
                     _loc2_ = new InfantryBulletsAnim(param1);
                     break;
                  case INFANTRY_GERMAN_DAMAGE_ANIM:
                     _loc2_ = new InfantryBulletsAnim(param1,INFANTRY_GERMAN_BULLETS_AMOUNT,INFANTRY_GERMAN_GUN_FIRE_SOUND_NAME,"",INFANTRY_GERMAN_SPEED_FACTOR);
                     break;
                  case INFANTRY_RUSSIAN_DAMAGE_ANIM:
                     _loc2_ = new InfantryBulletsAnim(param1,INFANTRY_RUSSIAN_BULLETS_AMOUNT,INFANTRY_RUSSIAN_GUN_FIRE_SOUND_NAME,"",INFANTRY_RUSSIAN_SPEED_FACTOR);
                     break;
                  case INFANTRY_JAPANESE_DAMAGE_ANIM:
                     _loc2_ = new InfantryBulletsAnim(param1,INFANTRY_JAPANESE_BULLETS_AMOUNT,INFANTRY_JAPANESE_GUN_FIRE_SOUND_NAME,"",INFANTRY_JAPANESE_SPEED_FACTOR);
                     break;
                  case TANK_DAMAGE_ANIM:
                     _loc2_ = new TankBulletAnim(param1);
                     break;
                  case ARTILLERY_DAMAGE_ANIM:
                     _loc2_ = new TankBulletAnim(param1,-1,"artillery");
                     break;
                  case AIR_DAMAGE_ANIM:
                     _loc2_ = new AirplaneBulletsAnim(param1);
                     break;
                  case SHIP_DAMAGE_ANIM:
                     _loc2_ = new ShipBulletAnim(param1);
                     break;
                  case SUBMARINE_DAMAGE_ANIM:
                     _loc2_ = new SubmarineBulletAnim(param1);
                     break;
                  case SNIPER_DAMAGE_ANIM:
                     _loc2_ = new SniperBulletsAnim(param1);
                     break;
                  case AUDIO_ANIM:
                     _loc2_ = new AudioCardAnimation(param1);
                     break;
                  case ARROW_DAMAGE_ANIM:
                     _loc2_ = new ArrowDamageAnimation(param1,1);
                     break;
                  case JAVELIN_DAMAGE_ANIM:
                     _loc2_ = new JavelinDamageAnimation(param1,1);
                     break;
                  case AXE_DAMAGE_ANIM:
                     _loc2_ = new AxeDamageAnimation(param1,1);
               }
            }
         }
         return _loc2_;
      }
      
      public function requestHealAnimation(param1:*) : void
      {
         var _loc2_:CardAnimation = new CardAnimation();
         _loc2_.setup(param1,"heal");
         if(param1 is FSCard)
         {
            FSCard(param1).addCardAnim(_loc2_);
         }
      }
      
      public function requestZoomInAnimation(param1:*) : PermanentParticleAnimation
      {
         var _loc2_:PermanentParticleAnimation = new PermanentParticleAnimation();
         _loc2_.setup(param1,"zoom_in");
         if(param1 is FSCard)
         {
            FSCard(param1).addCardAnim(_loc2_);
         }
         return _loc2_;
      }
      
      public function requestDebuffAnimation(param1:*) : void
      {
         var _loc2_:CardAnimation = new CardAnimation();
         _loc2_.setup(param1,"debuff");
         if(param1 is FSCard)
         {
            FSCard(param1).addCardAnim(_loc2_);
         }
      }
      
      public function requestSacrificeAnimation(param1:*, param2:int = 5) : LightningAnimation
      {
         var _loc3_:LightningAnimation = new LightningAnimation(param2);
         _loc3_.setup(param1);
         return _loc3_;
      }
      
      public function requestCardAnimAbility(param1:Ability, param2:*) : void
      {
         var _loc3_:CardAnimation = null;
         var _loc4_:String = null;
         var _loc5_:FSCard = null;
         if(param1 != null)
         {
            _loc4_ = param1.getAbilityDef().getAnimKey();
            if(_loc4_ != null && _loc4_ != "")
            {
               switch(_loc4_)
               {
                  case AbilitiesMng.FLAMETHROWER_ANIM:
                     _loc3_ = new FlamethrowerAnimation(_loc4_,param1);
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  case AbilitiesMng.BULLETS_MIX_ANIM:
                     _loc3_ = new BulletsMixAnimation(null);
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  case AbilitiesMng.ARTILLERY_EXPLOSIONS_ANIM:
                     _loc3_ = new ArtilleryAnim(param1.getAbilityDef(),param1.getParentCard(),6,FSCardAnimsMng.TANK_GUN_FIRE_SOUND_NAME,FSCardAnimsMng.TANK_BULLET_IMAGE_NAME,0.25);
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  case AbilitiesMng.EXPLOSION_ANIM:
                  case AbilitiesMng.EXPLOSION_AIR_ANIM:
                  case AbilitiesMng.EXPLOSION_INFANTRY_ANIM:
                  case AbilitiesMng.EXPLOSION_RUSSIAN_ANIM:
                  case AbilitiesMng.EXPLOSION_TANK_ANIM:
                     _loc3_ = new ExplosionAnimation(_loc4_,param1);
                     _loc3_.setup(param2,"explosion",new FSImage(Root.assets.getTexture(ExplosionAnimation.EXTRA_IMAGE_NAME)));
                     break;
                  case AbilitiesMng.ICON_ZOOM_ANIM:
                     _loc3_ = new IconZoomAnimation(param1);
                     _loc3_.setup(param2);
                     break;
                  case AbilitiesMng.MOVIE_CLIP_ZOOM_ANIM:
                     if(param2 is FSCard)
                     {
                        FSCard(param2).removeCardAnimsByAbility(param1.getAbilityDef().getKeyName());
                     }
                     _loc3_ = new MovieClipZoomAnimation(param1);
                     _loc3_.setAbilityItBelongsTo(param1.getAbilityDef().getKeyName());
                     _loc3_.setup(param2);
                     break;
                  case AbilitiesMng.ICON_ROTATE_ANIM:
                     _loc3_ = new IconRotateAnimation(param1);
                     _loc3_.setup(param2);
                     break;
                  case AbilitiesMng.ONLY_AUDIO_ANIM:
                     _loc3_ = new PromoteAudioOnlyAnimation();
                     _loc3_.setup(param2);
                     break;
                  case AbilitiesMng.AP_HIGHLIGHT_ANIM:
                     _loc3_ = new APHighlightAnimation();
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  case AbilitiesMng.RANZOMIZE_POS_ANIM:
                     _loc3_ = new RandomizePosAnimation(param1);
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  case AbilitiesMng.SPRITESHEET_ANIM:
                     _loc3_ = new CustomSpritesheetAnimation(param1);
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  case AbilitiesMng.BLOOD_SPLASH_ANIM:
                     _loc3_ = new BloodSplashAnimation();
                     _loc3_.setup(param2,"",new FSImage(Root.assets.getTexture(BloodSplashAnimation.EXTRA_IMAGE_NAME)));
                     break;
                  case AbilitiesMng.SLEEP_ANIM:
                     if(Boolean(param2) && param2 is FSCard)
                     {
                        FSCard(param2).removeCardAnimsByAbility(AbilitiesMng.SPECIAL_CAPTURED);
                     }
                     _loc3_ = new SleepAnimation();
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  case AbilitiesMng.WATER_EXPLOSION_ANIM:
                     _loc3_ = new WaterExplosionAnimation();
                     _loc3_.setup(param2,_loc4_.toLowerCase(),new FSImage(Root.assets.getTexture(WaterExplosionAnimation.EXTRA_IMAGE_NAME)));
                     break;
                  case AbilitiesMng.WATER_ANIM:
                     _loc3_ = new WaterAnimation();
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  case AbilitiesMng.CHARM_ANIM:
                     if(Boolean(param2) && param2 is FSCard)
                     {
                        FSCard(param2).removeCardAnimsByAbility(AbilitiesMng.SPECIAL_CAPTURED);
                     }
                     _loc3_ = new CharmAnimation(param1);
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  case AbilitiesMng.SOLAR_ANIM:
                     _loc3_ = new SolarAnimation();
                     _loc3_.setup(param2,_loc4_.toLowerCase(),new FSImage(Root.assets.getTexture(SolarAnimation.EXTRA_IMAGE_NAME)));
                     break;
                  case AbilitiesMng.WIND_ANIM:
                     _loc3_ = new WindAnimation(param1);
                     _loc3_.setup(param2,"",new FSImage(Root.assets.getTexture(WindAnimation.EXTRA_IMAGE_NAME)));
                     break;
                  case AbilitiesMng.STOMP_ANIM:
                     _loc3_ = new StompAnimation();
                     _loc3_.setup(param2);
                     break;
                  case AbilitiesMng.POISON_ANIM:
                     if(Boolean(param2) && param2 is FSCard)
                     {
                        FSCard(param2).removeCardAnimsByAbility(AbilitiesMng.SPECIAL_POISON);
                     }
                     else if(Boolean(param2) && param2.parent is FSBattlefieldUserPortrait)
                     {
                        FSBattlefieldUserPortrait(param2.parent).removeCardAnimsByAbility(AbilitiesMng.SPECIAL_POISON);
                     }
                     _loc3_ = new PoisonAnimation(param1,param1.getParentCard());
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  case AbilitiesMng.SMOKE_ANIM:
                  case AbilitiesMng.SMOKE_FIRE_ANIM:
                     if(Boolean(param2) && param2 is FSCard)
                     {
                        FSCard(param2).removeCardAnimsByAbility(AbilitiesMng.SPECIAL_POISON);
                     }
                     else if(Boolean(param2) && param2.parent is FSBattlefieldUserPortrait)
                     {
                        FSBattlefieldUserPortrait(param2.parent).removeCardAnimsByAbility(AbilitiesMng.SPECIAL_POISON);
                     }
                     _loc3_ = new SmokeAnimation(param1,param1.getParentCard());
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  case AbilitiesMng.ARROW_ANIM:
                     if(Boolean(param2) && param2 is FSCard)
                     {
                        FSCard(param2).removeCardAnimsByAbility(AbilitiesMng.ARROW_ANIM);
                     }
                     else if(Boolean(param2) && param2.parent is FSBattlefieldUserPortrait)
                     {
                        FSBattlefieldUserPortrait(param2.parent).removeCardAnimsByAbility(AbilitiesMng.ARROW_ANIM);
                     }
                     _loc3_ = new ArrowAnimation(param1,param1.getParentCard());
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     if(Boolean(param2) && param2 is FSCard)
                     {
                        TweenMax.delayedCall(0.5,this.executeArrowDamageAnim,[param2,param1]);
                     }
                     break;
                  case AbilitiesMng.CANNON_ANIM:
                     if(Boolean(param2) && param2 is FSCard)
                     {
                        FSCard(param2).removeCardAnimsByAbility(AbilitiesMng.CANNON_ANIM);
                     }
                     else if(Boolean(param2) && param2.parent is FSBattlefieldUserPortrait)
                     {
                        FSBattlefieldUserPortrait(param2.parent).removeCardAnimsByAbility(AbilitiesMng.CANNON_ANIM);
                     }
                     _loc3_ = new CannonAnimation(param1,param1.getParentCard());
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  case AbilitiesMng.JAVELIN_ANIM:
                     if(Boolean(param2) && param2 is FSCard)
                     {
                        FSCard(param2).removeCardAnimsByAbility(AbilitiesMng.JAVELIN_ANIM);
                     }
                     else if(Boolean(param2) && param2.parent is FSBattlefieldUserPortrait)
                     {
                        FSBattlefieldUserPortrait(param2.parent).removeCardAnimsByAbility(AbilitiesMng.JAVELIN_ANIM);
                     }
                     _loc3_ = new JavelinAnimation(param1,param1.getParentCard());
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     if(Boolean(param2) && param2 is FSCard)
                     {
                        TweenMax.delayedCall(0.5,this.executeJavelinDamageAnim,[param2,param1]);
                     }
                     break;
                  case AbilitiesMng.AXE_ANIM:
                     if(Boolean(param2) && param2 is FSCard)
                     {
                        FSCard(param2).removeCardAnimsByAbility(AbilitiesMng.AXE_ANIM);
                     }
                     else if(Boolean(param2) && param2.parent is FSBattlefieldUserPortrait)
                     {
                        FSBattlefieldUserPortrait(param2.parent).removeCardAnimsByAbility(AbilitiesMng.AXE_ANIM);
                     }
                     _loc3_ = new AxeAnimation(param1,param1.getParentCard());
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     if(Boolean(param2) && param2 is FSCard)
                     {
                        TweenMax.delayedCall(0.5,this.executeAxeDamageAnim,[param2]);
                     }
                     break;
                  case AbilitiesMng.ELEPHANT_ANIM:
                     if(Boolean(param2) && param2 is FSCard)
                     {
                        FSCard(param2).removeCardAnimsByAbility(AbilitiesMng.ELEPHANT_ANIM);
                     }
                     _loc3_ = new ElephantAnimation(param1,param1.getParentCard());
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  case AbilitiesMng.ELEPHANT_BF_ANIM:
                     if(Boolean(param2) && param2 is FSCard)
                     {
                        FSCard(param2).removeCardAnimsByAbility(AbilitiesMng.ELEPHANT_BF_ANIM);
                     }
                     _loc3_ = new ElephantAnimation(param1,param1.getParentCard(),true);
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  case AbilitiesMng.BOMBER_BF_ANIM:
                     if(Boolean(param2) && param2 is FSCard)
                     {
                        FSCard(param2).removeCardAnimsByAbility(AbilitiesMng.BOMBER_BF_ANIM);
                     }
                     _loc3_ = new BomberAnim(param1.getAbilityDef(),param1.getParentCard());
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  case AbilitiesMng.CARRIAGE_ANIM:
                     if(Boolean(param2) && param2 is FSCard)
                     {
                        FSCard(param2).removeCardAnimsByAbility(AbilitiesMng.CARRIAGE_ANIM);
                     }
                     _loc3_ = new CarriageAnimation(param1,param1.getParentCard());
                     _loc3_.setup(param2,_loc4_.toLowerCase());
                     break;
                  default:
                     _loc3_ = new CardAnimation();
                     _loc3_.setup(param2,_loc4_.toLowerCase());
               }
               if(param2 is FSCard)
               {
                  _loc3_.touchable = false;
                  FSCard(param2).addCardAnim(_loc3_);
               }
            }
         }
      }
      
      private function executeArrowDamageAnim(param1:*, param2:Ability) : void
      {
         var _loc3_:String = Boolean(param2) && Boolean(param2.isAbilityPassive()) && Boolean(param2.getAbilityDef().getEndAnimAsset()) ? param2.getAbilityDef().getEndAnimAsset() : "";
         var _loc4_:CardAnimation = new ArrowDamageAnimation(FSCard(param1),1,"",_loc3_);
         if(_loc4_)
         {
            _loc4_.setup(param1);
            param1.addCardAnim(_loc4_);
         }
      }
      
      private function executeJavelinDamageAnim(param1:*, param2:Ability) : void
      {
         var _loc3_:String = Boolean(param2) && Boolean(param2.isAbilityPassive()) && Boolean(param2.getAbilityDef().getEndAnimAsset()) ? param2.getAbilityDef().getEndAnimAsset() : "";
         var _loc4_:CardAnimation = new JavelinDamageAnimation(FSCard(param1),1);
         if(_loc4_)
         {
            _loc4_.setup(param1);
            param1.addCardAnim(_loc4_);
         }
      }
      
      private function executeAxeDamageAnim(param1:*) : void
      {
         var _loc2_:CardAnimation = new AxeDamageAnimation(FSCard(param1),1);
         if(_loc2_)
         {
            _loc2_.setup(param1);
            param1.addCardAnim(_loc2_);
         }
      }
      
      public function requestEpicCardUnfolded(param1:FSShopInfoCard) : void
      {
         var _loc2_:CardAnimation = new CardAnimation();
         _loc2_.setup(param1,"epic_card");
      }
      
      public function requestRareCardUnfolded(param1:FSShopInfoCard) : void
      {
         var _loc2_:CardAnimation = new CardAnimation();
         _loc2_.setup(param1,"rare_card");
      }
      
      public function requestOrangeCardUnfolded(param1:FSShopInfoCard) : void
      {
         var _loc2_:CardAnimation = new CardAnimation();
         _loc2_.setup(param1,"orange");
      }
      
      public function requestPurpleCardUnfolded(param1:FSShopInfoCard) : void
      {
         var _loc2_:CardAnimation = new CardAnimation();
         _loc2_.setup(param1,"purple");
      }
      
      public function requestShiningPromoteCardAnim(param1:FSCard) : void
      {
         var _loc2_:CardShiningPromoteAnimation = new CardShiningPromoteAnimation();
         _loc2_.setup(param1,"promote");
      }
   }
}

