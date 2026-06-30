package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.BoostsMng;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   
   public class BoostsPanel extends Component
   {
      
      private var mLevelDef:LevelDef;
      
      private var mContainer:Component;
      
      private var mBoostsVector:Vector.<BoostItem>;
      
      private var mParentContainerWidth:int;
      
      public function BoostsPanel(param1:LevelDef, param2:int)
      {
         super();
         this.mParentContainerWidth = param2;
         this.mLevelDef = param1;
         this.init();
      }
      
      private function init() : void
      {
         if(this.mLevelDef != null)
         {
            if(this.mContainer == null)
            {
               this.mContainer = new Component();
               addChild(this.mContainer);
            }
            this.createBoosterItems();
         }
      }
      
      public function refresh(param1:LevelDef) : void
      {
         this.mLevelDef = param1;
         this.removeOldBoosters();
         this.init();
      }
      
      private function removeOldBoosters() : void
      {
         var _loc1_:BoostItem = null;
         if(this.mBoostsVector != null)
         {
            for each(_loc1_ in this.mBoostsVector)
            {
               _loc1_.removeFromParent();
               _loc1_.destroy();
            }
            this.mBoostsVector.length = 0;
         }
      }
      
      private function createBoosterItems() : void
      {
         var _loc2_:FSCoordinate = null;
         var _loc3_:BoostItem = null;
         var _loc4_:int = 0;
         var _loc5_:BoostDef = null;
         var _loc6_:String = null;
         var _loc1_:Array = this.mLevelDef.getPreBoostsArr();
         if(_loc1_ != null)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc1_.length)
            {
               _loc6_ = _loc1_[_loc4_];
               _loc5_ = BoostDef(InstanceMng.getBoostsDefMng().getDefBySku(_loc6_));
               _loc3_ = new BoostItem(_loc4_,_loc5_,BoostsMng.PRE_BOOST);
               if(this.mBoostsVector == null)
               {
                  this.mBoostsVector = new Vector.<BoostItem>();
               }
               _loc3_.setEnabled(!Config.KICKSTARTER_EDITION);
               this.mBoostsVector.push(_loc3_);
               _loc2_ = Utils.getXYPositionInContainer(_loc4_,_loc3_.width,_loc3_.height,this.mParentContainerWidth,_loc3_.height,_loc1_.length,1);
               _loc3_.x = _loc2_.getX() + _loc3_.width / 2;
               _loc3_.y = _loc2_.getY() + _loc3_.height / 2;
               this.mContainer.addChild(_loc3_);
               _loc4_++;
            }
         }
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         var _loc2_:BoostItem = null;
         if(this.mBoostsVector != null)
         {
            for each(_loc2_ in this.mBoostsVector)
            {
               _loc2_.setEnabled(param1);
            }
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:BoostItem = null;
         if(this.mBoostsVector)
         {
            for each(_loc1_ in this.mBoostsVector)
            {
               _loc1_.removeFromParent(true);
               _loc1_ = null;
            }
            Utils.destroyArray(this.mBoostsVector);
            this.mBoostsVector = null;
         }
         if(this.mContainer)
         {
            this.mContainer.removeFromParent(true);
            this.mContainer = null;
         }
         this.mLevelDef = null;
         super.dispose();
      }
   }
}

