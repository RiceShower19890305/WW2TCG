package com.fs.tcgengine.view.anims.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCardXL;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.extensions.ColorArgb;
   
   public class PermanentParticleAnimation extends CardAnimation
   {
      
      public function PermanentParticleAnimation()
      {
         super();
      }
      
      override protected function triggerParticleSystem() : void
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         var _loc4_:ColorArgb = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(Boolean(mParticleSystem != null) && Boolean(mAttachedToComponent) && Boolean(FSCardXL(mAttachedToComponent).getParentCard()))
         {
            _loc1_ = FSCardXL(mAttachedToComponent).getParentCard().getCardDef().getFactionSku();
            _loc2_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(_loc1_)).getColor();
            _loc3_ = Utils.HexToRGB(_loc2_);
            _loc4_ = new ColorArgb(_loc3_.r / 255,_loc3_.g / 255,_loc3_.b / 255,1);
            mParticleSystem.startColor = _loc4_;
            if(Boolean(FSCardXL(mAttachedToComponent).getBG()) || Boolean(FSCardXL(mAttachedToComponent).getBGAnimated()))
            {
               _loc5_ = FSCardXL(mAttachedToComponent).hasAnimatedBG() ? FSCardXL(mAttachedToComponent).getBGAnimated().x : FSCardXL(mAttachedToComponent).getBG().x;
               _loc6_ = FSCardXL(mAttachedToComponent).hasAnimatedBG() ? FSCardXL(mAttachedToComponent).getBGAnimated().y : FSCardXL(mAttachedToComponent).getBG().y;
               _loc8_ = FSCardXL(mAttachedToComponent).hasAnimatedBG() ? int(FSCardXL(mAttachedToComponent).getBGAnimated().width) : int(FSCardXL(mAttachedToComponent).getBG().width);
               _loc9_ = FSCardXL(mAttachedToComponent).hasAnimatedBG() ? int(FSCardXL(mAttachedToComponent).getBGAnimated().height) : int(FSCardXL(mAttachedToComponent).getBG().height);
            }
            else
            {
               _loc5_ = Number(mAttachedToComponent.x);
               _loc6_ = Number(mAttachedToComponent.y);
            }
            _loc7_ = InstanceMng.getApplication().getStage().localToGlobal(new Point(_loc5_,_loc6_));
            if(Boolean(FSCardXL(mAttachedToComponent).getBG()) || Boolean(FSCardXL(mAttachedToComponent).getBGAnimated()))
            {
               mParticleSystem.x = _loc7_.x + (_loc8_ - mParticleSystem.width) / 2;
               mParticleSystem.y = _loc7_.y + _loc9_;
            }
            else
            {
               mParticleSystem.x = _loc7_.x + (mAttachedToComponent.width - mParticleSystem.width) / 2;
               mParticleSystem.y = _loc7_.y + mAttachedToComponent.height;
            }
            mAttachedToComponent.addChildAt(mParticleSystem,0);
            Starling.juggler.add(mParticleSystem);
            mParticleSystem.start();
         }
      }
   }
}

