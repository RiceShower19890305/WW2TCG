package com.fs.tcgengine.resources
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.particles.FSPDParticleSystem;
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   
   public class AssetsParticles
   {
      
      private static var smParticlesPool:Dictionary;
      
      public static var smParticleSmokeXML:Class = AssetsParticles_smParticleSmokeXML;
      
      public static var smParticleSmokeFireXML:Class = AssetsParticles_smParticleSmokeFireXML;
      
      public static var smParticleSnowStormXML:Class = AssetsParticles_smParticleSnowStormXML;
      
      public static var smParticleFireStormXML:Class = AssetsParticles_smParticleFireStormXML;
      
      public static var smParticleSandStormXML:Class = AssetsParticles_smParticleSandStormXML;
      
      public static var smParticleDefeatFireXML:Class = AssetsParticles_smParticleDefeatFireXML;
      
      public static var smParticleFireHouseXML:Class = AssetsParticles_smParticleFireHouseXML;
      
      public static var smParticlePackUnfoldXML:Class = AssetsParticles_smParticlePackUnfoldXML;
      
      public static var smParticleFlamethrowerXML:Class = AssetsParticles_smParticleFlamethrowerXML;
      
      public static var smParticleHealXML:Class = AssetsParticles_smParticleHealXML;
      
      public static var smParticleExplosionXML:Class = AssetsParticles_smParticleExplosionXML;
      
      public static var smParticleBulletsMixXML:Class = AssetsParticles_smParticleBulletsMixXML;
      
      public static var smParticleApHighlightMixXML:Class = AssetsParticles_smParticleApHighlightMixXML;
      
      public static var smParticleDebuffXML:Class = AssetsParticles_smParticleDebuffXML;
      
      public static var smParticleEpicCardXML:Class = AssetsParticles_smParticleEpicCardXML;
      
      public static var smParticleRareCardXML:Class = AssetsParticles_smParticleRareCardXML;
      
      public static var smParticleOrangeCardXML:Class = AssetsParticles_smParticleOrangeCardXML;
      
      public static var smParticlePurpleCardXML:Class = AssetsParticles_smParticlePurpleCardXML;
      
      public static var smParticleHighlightCardXML:Class = AssetsParticles_smParticleHighlightCardXML;
      
      public static var smParticlePromoteCardXML:Class = AssetsParticles_smParticlePromoteCardXML;
      
      public static var smParticleSleepXML:Class = AssetsParticles_smParticleSleepXML;
      
      public static var smParticleWaterExplosionXML:Class = AssetsParticles_smParticleWaterExplosionXML;
      
      public static var smParticleWaterThrowerXML:Class = AssetsParticles_smParticleWaterThrowerXML;
      
      public static var smParticleCharmXML:Class = AssetsParticles_smParticleCharmXML;
      
      public static var smParticleMagicExplosionXML:Class = AssetsParticles_smParticleMagicExplosionXML;
      
      public static var smParticleLeafsXML:Class = AssetsParticles_smParticleLeafsXML;
      
      public static var smParticleWindXML:Class = AssetsParticles_smParticleWindXML;
      
      public static var smParticleStompXML:Class = AssetsParticles_smParticleStompXML;
      
      public static var smParticleSolarXML:Class = AssetsParticles_smParticleSolarXML;
      
      public static var smParticleZoomInXML:Class = AssetsParticles_smParticleZoomInXML;
      
      public static var smParticleDiveXML:Class = AssetsParticles_smParticleDiveXML;
      
      public static var smParticlePoisonXML:Class = AssetsParticles_smParticlePoisonXML;
      
      public static var smParticleWaterfall1XML:Class = AssetsParticles_smParticleWaterfall1XML;
      
      public static var smParticleWaterfall2XML:Class = AssetsParticles_smParticleWaterfall2XML;
      
      public static var smParticleFireBuffXML:Class = AssetsParticles_smParticleFireBuffXML;
      
      public static var smParticleStarXML:Class = AssetsParticles_smParticleStarXML;
      
      public static var smParticleFireworks1XML:Class = AssetsParticles_smParticleFireworks1XML;
      
      public static var smParticleFireworks2XML:Class = AssetsParticles_smParticleFireworks2XML;
      
      public static var smParticleFireworks3XML:Class = AssetsParticles_smParticleFireworks3XML;
      
      public static var smParticleSkinXML:Class = AssetsParticles_smParticleSkinXML;
      
      public static var smParticleSnowXML:Class = AssetsParticles_smParticleSnowXML;
      
      public static var smParticleSpellFireXML:Class = AssetsParticles_smParticleSpellFireXML;
      
      public static var smParticleSpellCorruptedXML:Class = AssetsParticles_smParticleSpellCorruptedXML;
      
      public static var smParticleSpellRocketXML:Class = AssetsParticles_smParticleSpellRocketXML;
      
      public static var smParticleSpellShadowXML:Class = AssetsParticles_smParticleSpellShadowXML;
      
      public static var smParticleVortexXML:Class = AssetsParticles_smParticleVortexXML;
      
      public static var smParticleGunshotXML:Class = AssetsParticles_smParticleGunshotXML;
      
      public static var smParticleBigBulletXML:Class = AssetsParticles_smParticleBigBulletXML;
      
      public function AssetsParticles()
      {
         super();
      }
      
      private static function getParticleSystemFromPool(param1:String) : FSPDParticleSystem
      {
         var _loc2_:FSPDParticleSystem = null;
         if(smParticlesPool != null)
         {
            if(smParticlesPool[param1] != null)
            {
               if(Vector.<FSPDParticleSystem>(smParticlesPool[param1]).length > 0)
               {
                  _loc2_ = Vector.<FSPDParticleSystem>(smParticlesPool[param1]).pop();
               }
               else
               {
                  _loc2_ = createParticleSystem(param1);
               }
            }
            else
            {
               _loc2_ = createParticleSystem(param1);
            }
         }
         else
         {
            _loc2_ = createParticleSystem(param1);
         }
         if(_loc2_)
         {
            _loc2_.alpha = 0.999;
            _loc2_.touchable = false;
         }
         return _loc2_;
      }
      
      public static function printMemoryUsed() : void
      {
         var _loc1_:Vector.<FSPDParticleSystem> = null;
         var _loc2_:int = 0;
         if(smParticlesPool)
         {
            _loc2_ = 0;
            for each(_loc1_ in smParticlesPool)
            {
               _loc2_ += _loc1_ ? _loc1_.length : 0;
            }
            FSDebug.debugTrace("Particle systems in MEM: " + _loc2_);
         }
      }
      
      public static function addParticleSystemToPool(param1:String, param2:FSPDParticleSystem) : void
      {
         if(smParticlesPool == null)
         {
            smParticlesPool = new Dictionary(true);
         }
         if(smParticlesPool[param1] == null)
         {
            smParticlesPool[param1] = new Vector.<FSPDParticleSystem>();
         }
         Vector.<FSPDParticleSystem>(smParticlesPool[param1]).push(param2);
      }
      
      public static function requestParticleSystem(param1:String) : FSPDParticleSystem
      {
         return getParticleSystemFromPool(param1);
      }
      
      public static function createParticleSystem(param1:String) : FSPDParticleSystem
      {
         var _loc2_:FSPDParticleSystem = null;
         switch(param1)
         {
            case "snow":
               _loc2_ = requestSnowParticleSystem();
               break;
            case "smoke":
               _loc2_ = requestSmokeParticleSystem();
               break;
            case "smoke_fire":
               _loc2_ = requestSmokeFireParticleSystem();
               break;
            case "fire":
               _loc2_ = requestFireParticleSystem();
               break;
            case "fire_buff":
               _loc2_ = requestFireBuffParticleSystem();
               break;
            case "sand":
               _loc2_ = smParticleSandStormXML();
               break;
            case "defeat:fire":
               _loc2_ = smParticleDefeatFireXML();
               break;
            case "fire_house":
               _loc2_ = requestFireHouseParticleSystem();
               break;
            case "pack_unfold":
               _loc2_ = requestPackUnfoldParticleSystem();
               break;
            case "flamethrower":
               _loc2_ = requestFlamethrowerParticleSystem();
               break;
            case "heal":
               _loc2_ = requestHealParticleSystem();
               break;
            case "debuff":
               _loc2_ = requestDebuffParticleSystem();
               break;
            case "explosion":
               _loc2_ = requestExplosionParticleSystem();
               break;
            case "bullets_mix":
               _loc2_ = requestBulletsMixParticleSystem();
               break;
            case "ap_highlight":
               _loc2_ = requestAPHighlightParticleSystem();
               break;
            case "defeat_fire":
               _loc2_ = requestDefeatFireParticleSystem();
               break;
            case "epic_card":
               _loc2_ = requestEpicCardParticleSystem();
               break;
            case "rare_card":
               _loc2_ = requestRareCardParticleSystem();
               break;
            case "orange":
               _loc2_ = requestOrangeParticleSystem();
               break;
            case "purple":
               _loc2_ = requestPurpleParticleSystem();
               break;
            case "card_highlight":
               _loc2_ = requestCardHighlightedParticleSystem();
               break;
            case "promote":
               _loc2_ = requestCardPromoteParticleSystem();
               break;
            case "sleep":
               _loc2_ = requestSleepParticleSystem();
               break;
            case "wind":
               _loc2_ = requestWindParticleSystem();
               break;
            case "water_explosion":
               _loc2_ = requestWaterExplosionParticleSystem();
               break;
            case "water":
               _loc2_ = requestWaterThrowerParticleSystem();
               break;
            case "charm":
               _loc2_ = requestCharmParticleSystem();
               break;
            case "magic_explosion":
               _loc2_ = requestMagicExplosionParticleSystem();
               break;
            case "leafs":
               _loc2_ = requestLeafsParticleSystem();
               break;
            case "stomp":
               _loc2_ = requestStompParticleSystem();
               break;
            case "solar":
               _loc2_ = requestSolarParticleSystem();
               break;
            case "zoom_in":
               _loc2_ = requestZoomInParticleSystem();
               break;
            case "dive":
               _loc2_ = requestDiveParticleSystem();
               break;
            case "poison":
               _loc2_ = requestPoisonParticleSystem();
               break;
            case "waterfall1":
               _loc2_ = requestWaterfall1ParticleSystem();
               break;
            case "waterfall2":
               _loc2_ = requestWaterfall2ParticleSystem();
               break;
            case "star":
               _loc2_ = requestStarParticleSystem();
               break;
            case "firework1":
               _loc2_ = requestFireworks1ParticleSystem();
               break;
            case "firework2":
               _loc2_ = requestFireworks2ParticleSystem();
               break;
            case "firework3":
               _loc2_ = requestFireworks3ParticleSystem();
               break;
            case "forest":
            case "fog":
               break;
            case "menuSnow":
               _loc2_ = requestMenuSnowParticleSystem();
               break;
            case "spell_fire":
               _loc2_ = requestSpellFireParticleSystem();
               break;
            case "spell_corrupted":
               _loc2_ = requestSpellCorruptedParticleSystem();
               break;
            case "spell_rocket":
               _loc2_ = requestSpellRocketParticleSystem();
               break;
            case "spell_shadow":
               _loc2_ = requestSpellShadowParticleSystem();
               break;
            case "vortex":
               _loc2_ = requestVortexParticleSystem();
               break;
            case "gunshot":
               _loc2_ = requestGunshotParticleSystem();
               break;
            case "bigbullet":
               _loc2_ = requestBigBulletParticleSystem();
               break;
            default:
               if(param1 != null && param1 != "" && param1.indexOf("skin_") != -1)
               {
                  _loc2_ = requestSkinParticleSystem(param1);
               }
         }
         setupScale(_loc2_);
         if(_loc2_)
         {
            _loc2_.setSku(param1);
         }
         return _loc2_;
      }
      
      public static function requestSmokeParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleSmokeXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = Starling.current.stage.stageWidth / 1.5;
         _loc1_.y = Starling.current.stage.stageWidth / 3;
         _loc1_.scaleX = 1.2;
         _loc1_.scaleY = 1.2;
         return _loc1_;
      }
      
      public static function requestSmokeFireParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = null;
         _loc1_ = new FSPDParticleSystem(XML(new smParticleSmokeFireXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         _loc1_.scaleX = 0.35;
         _loc1_.scaleY = 0.35;
         return _loc1_;
      }
      
      public static function requestSnowParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleSnowStormXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0 - 10;
         return _loc1_;
      }
      
      public static function requestFireParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleFireStormXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = Starling.current.stage.stageWidth + 50;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestFireHouseParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleFireHouseXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestPackUnfoldParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticlePackUnfoldXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestFlamethrowerParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleFlamethrowerXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestHealParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleHealXML()),Root.assets.getTexture("particle_heal"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestZoomInParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleZoomInXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestDiveParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleDiveXML()),Root.assets.getTexture("particle_dive"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestPoisonParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticlePoisonXML()),Root.assets.getTexture("particle_poison"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestWaterfall1ParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleWaterfall1XML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestWaterfall2ParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleWaterfall2XML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestDebuffParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleDebuffXML()),Root.assets.getTexture("particle_negative"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestEpicCardParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleEpicCardXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestRareCardParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleRareCardXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestOrangeParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleOrangeCardXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestPurpleParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticlePurpleCardXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestCardHighlightedParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleHighlightCardXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestCardPromoteParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticlePromoteCardXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestMagicExplosionParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleMagicExplosionXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestSleepParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleSleepXML()),Root.assets.getTexture("particle_sleep"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestWaterExplosionParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleWaterExplosionXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestWaterThrowerParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleWaterThrowerXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestCharmParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleCharmXML()),Root.assets.getTexture("particle_charm"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestGunshotParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleGunshotXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestBigBulletParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleBigBulletXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestLeafsParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleLeafsXML()),Root.assets.getTexture("particle_leaf"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestStarParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleStarXML()),Root.assets.getTexture("particle_star"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestFireworks1ParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleFireworks1XML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestFireworks2ParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleFireworks2XML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestFireworks3ParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleFireworks3XML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestSkinParticleSystem(param1:String) : FSPDParticleSystem
      {
         var _loc2_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleSkinXML()),Root.assets.getTexture("particle_" + param1));
         _loc2_.x = 0;
         _loc2_.y = 0;
         return _loc2_;
      }
      
      public static function requestMenuSnowParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleSnowXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestVortexParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleVortexXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestSpellFireParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleSpellFireXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestSpellCorruptedParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleSpellCorruptedXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestSpellRocketParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleSpellRocketXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestSpellShadowParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleSpellShadowXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestFireBuffParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleFireBuffXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestWindParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleWindXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestStompParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleStompXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestSolarParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleSolarXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestExplosionParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleExplosionXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestBulletsMixParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleBulletsMixXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestAPHighlightParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleApHighlightMixXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestSandParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleSandStormXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = -50;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      public static function requestDefeatFireParticleSystem() : FSPDParticleSystem
      {
         var _loc1_:FSPDParticleSystem = new FSPDParticleSystem(XML(new smParticleDefeatFireXML()),Root.assets.getTexture("particle_texture"));
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      private static function setupScale(param1:FSPDParticleSystem) : void
      {
         if(param1)
         {
            if(Utils.isAndroidOrDesktop() || Utils.isBrowser())
            {
               param1.scaleX = 1 / Starling.current.contentScaleFactor;
               param1.scaleY = 1 / Starling.current.contentScaleFactor;
            }
         }
      }
   }
}

