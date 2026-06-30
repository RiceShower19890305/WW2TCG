package com.fs.tcgengine.particles
{
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import starling.display.DisplayObjectContainer;
   import starling.utils.Align;
   
   public class TextParticlesMng
   {
      
      public static const COLOR_DAMAGE_RECEIVED_STD:uint = 16711680;
      
      public static const COLOR_DAMAGE_RECEIVED_ABILITY:uint = 14614751;
      
      public static const COLOR_HEAL_RECEIVED:uint = 65280;
      
      public static const COLOR_INACTIVE:uint = 10066329;
      
      private const VERTICAL_OFFSET:int = 30;
      
      private var mTextParticlesAvailablePool:Vector.<FSTextfield>;
      
      private var mDamageItemsAvailablePool:Vector.<TextParticleWithBG>;
      
      private var mParticlesAttachedCatalog:Dictionary;
      
      public function TextParticlesMng()
      {
         super();
      }
      
      public function showStandardTextParticle(param1:String, param2:uint, param3:*, param4:int = -1, param5:String = "center", param6:String = "center", param7:String = "", param8:String = "top") : void
      {
         var _loc9_:FSTextfield = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         param4 = param4 == -1 ? FSResourceMng.FONT_STD_TITLE_SIZE : param4;
         if(this.mTextParticlesAvailablePool == null)
         {
            this.mTextParticlesAvailablePool = new Vector.<FSTextfield>();
         }
         if(this.mTextParticlesAvailablePool.length > 0)
         {
            _loc9_ = this.mTextParticlesAvailablePool.pop();
         }
         else
         {
            _loc9_ = new FSTextfield(130,80);
            _loc9_.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
         }
         _loc9_.fontName = param7 == "" || param7 == null ? FSResourceMng.getFontByType() : param7;
         _loc9_.text = param1 ? param1 : "";
         _loc9_.fontSize = param4 + 6;
         var _loc10_:Number = this.getParticlesAttachedToComponent(param3) / 1.3;
         switch(param5)
         {
            case Align.LEFT:
               _loc11_ = param3.x - param3.width / 2;
               break;
            case Align.CENTER:
               _loc11_ = param3.x - _loc9_.width / 2;
               break;
            case Align.RIGHT:
               _loc11_ = param3.x + param3.width / 2 - _loc9_.width - 5;
         }
         switch(param6)
         {
            case Align.TOP:
               _loc12_ = param3.y - param3.height / 2 + _loc9_.height / 5;
               break;
            case Align.CENTER:
               _loc12_ = param3.y - _loc9_.height / 2;
               break;
            case Align.BOTTOM:
               _loc12_ = param3.y + param3.height / 2 - _loc9_.height / 2;
         }
         _loc9_.format.horizontalAlign = param5;
         _loc9_.x = _loc11_;
         _loc9_.y = _loc12_;
         _loc9_.color = param2;
         var _loc13_:int = param8 == Align.TOP ? int(-this.VERTICAL_OFFSET) : this.VERTICAL_OFFSET;
         var _loc14_:FSCoordinate = new FSCoordinate(_loc9_.x,_loc9_.y + _loc13_);
         this.addParticleAttachedToComponent(param3);
         if(param3.parent != null)
         {
            TweenMax.delayedCall(_loc10_,this.addChildToComponentsParent,[param3,_loc9_]);
         }
         TweenMax.delayedCall(_loc10_,SpecialFX.createTransition,[_loc9_,_loc14_,1.5,0,this.onCompleteTransition,[_loc9_,param3]]);
      }
      
      private function addChildToComponentsParent(param1:*, param2:FSTextfield) : void
      {
         if(Boolean(param1) && Boolean(param2) && Boolean(param1.parent))
         {
            param1.parent.addChild(param2);
         }
      }
      
      public function showTextParticle(param1:String, param2:uint, param3:*, param4:int = -1, param5:String = "center", param6:String = "", param7:int = 130, param8:Number = 1.5) : void
      {
         var _loc9_:FSTextfield = null;
         var _loc11_:FSCoordinate = null;
         param4 = param4 == -1 ? FSResourceMng.FONT_STD_TITLE_SIZE : param4;
         if(this.mTextParticlesAvailablePool == null)
         {
            this.mTextParticlesAvailablePool = new Vector.<FSTextfield>();
         }
         if(this.mTextParticlesAvailablePool.length > 0)
         {
            _loc9_ = this.mTextParticlesAvailablePool.pop();
         }
         else
         {
            _loc9_ = new FSTextfield(param7,80);
            _loc9_.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
         }
         _loc9_.fontName = param6 == "" ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE) : param6;
         _loc9_.text = param1;
         _loc9_.fontSize = param4 + 6;
         var _loc10_:Number = this.getParticlesAttachedToComponent(param3) / 1.3;
         switch(param5)
         {
            case Align.LEFT:
               _loc11_ = new FSCoordinate(param3.x - param3.width / 2 + 5,param3.y);
               break;
            case Align.CENTER:
               _loc11_ = new FSCoordinate(param3.x - _loc9_.width / 2,param3.y);
               break;
            case Align.RIGHT:
               _loc11_ = new FSCoordinate(param3.x + param3.width / 2 - _loc9_.width - 5,param3.y);
         }
         _loc9_.format.horizontalAlign = param5;
         if(param3 is FSBattlefieldUserPortrait)
         {
            _loc11_.mX += param3.width / 2;
            _loc11_.mY += param3.height / 2;
         }
         _loc9_.x = _loc11_.getX();
         _loc9_.y = _loc11_.getY();
         _loc9_.color = param2;
         var _loc12_:FSCoordinate = new FSCoordinate(_loc9_.x,_loc9_.y - this.VERTICAL_OFFSET);
         this.addParticleAttachedToComponent(param3);
         if(param3.parent != null)
         {
            TweenMax.delayedCall(_loc10_,this.addChildToComponentsParent,[param3,_loc9_]);
         }
         TweenMax.delayedCall(_loc10_,SpecialFX.createTransition,[_loc9_,_loc12_,param8,0,this.onCompleteTransition,[_loc9_,param3],null,false,this.addChildToComponentsParent,[param3,_loc9_]]);
      }
      
      public function createTextParticleWithBG(param1:String) : TextParticleWithBG
      {
         var _loc2_:TextParticleWithBG = new TextParticleWithBG();
         _loc2_.setBG(param1);
         return _loc2_;
      }
      
      private function addTextParticleWithBGToPool(param1:String, param2:String, param3:String, param4:String) : TextParticleWithBG
      {
         var _loc5_:TextParticleWithBG = null;
         if(this.mDamageItemsAvailablePool == null)
         {
            this.mDamageItemsAvailablePool = new Vector.<TextParticleWithBG>();
         }
         if(this.mDamageItemsAvailablePool.length > 0)
         {
            _loc5_ = this.mDamageItemsAvailablePool.pop();
         }
         else
         {
            _loc5_ = this.createTextParticleWithBG(param2);
         }
         _loc5_.setText(param1);
         _loc5_.setBG(param2,param3,param4);
         return _loc5_;
      }
      
      public function showTextParticleOnBattle(param1:String, param2:uint, param3:*, param4:int = -1, param5:String = "center", param6:String = "center", param7:String = "", param8:String = "damage_icon", param9:Boolean = false, param10:String = "std", param11:String = "center", param12:Boolean = false) : void
      {
         var _loc13_:TextParticleWithBG = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:FSImage = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:FSCoordinate = null;
         if(Config.getConfig().battleShowsDamageSplashBG())
         {
            param4 = param4 == -1 ? FSResourceMng.FONT_STD_TITLE_SIZE : param4;
            _loc13_ = this.addTextParticleWithBGToPool(param1,param8,param11,param7);
            _loc13_.scaleX = 1;
            _loc13_.scaleY = 1;
            _loc13_.alignPivot();
            param5 = param8 != "damage_icon" ? param5 : Align.CENTER;
            _loc17_ = param3.width / param3.scaleX;
            _loc18_ = param3.height / param3.scaleY;
            switch(param5)
            {
               case Align.LEFT:
                  if(param3 is FSCard)
                  {
                     _loc14_ = param9 ? param3.x - param3.width / 2 - _loc13_.width / 2 : -_loc13_.width / 2;
                  }
                  else
                  {
                     _loc14_ = param9 ? param3.x + 5 + _loc13_.width / 2 : _loc13_.width / 2;
                  }
                  break;
               case Align.CENTER:
                  _loc14_ = param9 ? param3.x + _loc17_ / 2 : _loc17_ / 2;
                  break;
               case Align.RIGHT:
                  if(param3 is FSCard)
                  {
                     _loc14_ = param9 ? param3.x + _loc17_ / 2 + _loc13_.width / 2 : _loc17_ - _loc13_.width / 2;
                  }
                  else
                  {
                     _loc14_ = param9 ? param3.x + _loc17_ / 2 - _loc13_.width / 2 : _loc17_ - _loc13_.width / 2;
                  }
            }
            switch(param6)
            {
               case Align.TOP:
                  _loc15_ = param9 ? param3.y + _loc13_.height / 2 : _loc13_.height / 2;
                  break;
               case Align.CENTER:
                  _loc15_ = param9 ? param3.y + _loc18_ : _loc18_ / 2;
                  break;
               case Align.BOTTOM:
                  _loc15_ = param9 ? param3.y + _loc18_ : _loc18_;
            }
            _loc13_.x = _loc14_;
            _loc13_.y = _loc15_;
            _loc13_.y -= param12 ? param3.height / 2 : 0;
            this.addParticleAttachedToComponent(param3);
            if(param9)
            {
               if(param3.parent != null)
               {
                  param3.parent.addChild(_loc13_);
               }
            }
            else if(param3)
            {
               param3.addChild(_loc13_);
            }
            switch(param10)
            {
               case "std":
                  SpecialFX.createYoYoZoomTransition(_loc13_,1.15,0.5,1,this.onCompleteTransition,[_loc13_,param3],false);
                  break;
               case "up":
                  _loc19_ = new FSCoordinate(_loc13_.x,_loc13_.y - this.VERTICAL_OFFSET);
                  SpecialFX.createTransition(_loc13_,_loc19_,1.5,0,this.onCompleteTransition,[_loc13_,param3]);
            }
         }
         else
         {
            this.showTextParticle(param1,param2,param3,param4,param5,param7);
         }
      }
      
      private function addParticleAttachedToComponent(param1:*) : void
      {
         if(this.mParticlesAttachedCatalog == null)
         {
            this.mParticlesAttachedCatalog = new Dictionary(true);
         }
         if(this.mParticlesAttachedCatalog[param1] == null)
         {
            this.mParticlesAttachedCatalog[param1] = 1;
         }
         else
         {
            this.mParticlesAttachedCatalog[param1] += 1;
         }
      }
      
      private function removeParticleAttachedToComponent(param1:*) : void
      {
         if(this.mParticlesAttachedCatalog)
         {
            if(this.mParticlesAttachedCatalog[param1])
            {
               this.mParticlesAttachedCatalog[param1] = this.mParticlesAttachedCatalog[param1] - 1;
               if(this.mParticlesAttachedCatalog[param1] <= 0)
               {
                  this.mParticlesAttachedCatalog[param1] = null;
                  delete this.mParticlesAttachedCatalog[param1];
               }
            }
         }
      }
      
      private function getParticlesAttachedToComponent(param1:*) : int
      {
         var _loc2_:int = 0;
         if(this.mParticlesAttachedCatalog != null)
         {
            if(this.mParticlesAttachedCatalog[param1] != null)
            {
               _loc2_ = int(this.mParticlesAttachedCatalog[param1]);
            }
         }
         return _loc2_;
      }
      
      private function onCompleteTransition(param1:DisplayObjectContainer, param2:*) : void
      {
         if(param1 != null)
         {
            SpecialFX.tweenToAlpha(param1,0,1,0,this.removeFromDisplayList,[param1,param2]);
         }
      }
      
      private function removeFromDisplayList(param1:DisplayObjectContainer, param2:*) : void
      {
         if(param1 != null)
         {
            if(param2 != null)
            {
               this.removeParticleAttachedToComponent(param2);
            }
            param1.removeFromParent();
         }
         if(param1 is TextParticleWithBG)
         {
            if(this.mDamageItemsAvailablePool != null)
            {
               param1.alpha = 1;
               this.mDamageItemsAvailablePool.push(param1);
            }
         }
         else if(this.mTextParticlesAvailablePool != null)
         {
            param1.alpha = 1;
            this.mTextParticlesAvailablePool.push(param1);
         }
      }
      
      public function cleanPools() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:FSTextfield = null;
         var _loc4_:TextParticleWithBG = null;
         if(this.mTextParticlesAvailablePool)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mTextParticlesAvailablePool.length)
            {
               _loc3_ = this.mTextParticlesAvailablePool[_loc1_];
               _loc3_.removeFromParent(true);
               _loc3_ = null;
               _loc1_++;
            }
            Utils.destroyArray(this.mTextParticlesAvailablePool);
            this.mTextParticlesAvailablePool = null;
         }
         if(this.mDamageItemsAvailablePool)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mDamageItemsAvailablePool.length)
            {
               _loc4_ = this.mDamageItemsAvailablePool[_loc1_];
               _loc4_.removeFromParent(true);
               _loc4_ = null;
               _loc1_++;
            }
            Utils.destroyArray(this.mDamageItemsAvailablePool);
            this.mDamageItemsAvailablePool = null;
         }
         if(this.mParticlesAttachedCatalog)
         {
            for each(_loc2_ in this.mParticlesAttachedCatalog)
            {
               _loc2_ = null;
            }
            DictionaryUtils.clearDictionary(this.mParticlesAttachedCatalog);
            this.mParticlesAttachedCatalog = null;
         }
      }
   }
}

