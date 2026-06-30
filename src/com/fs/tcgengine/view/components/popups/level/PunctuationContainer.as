package com.fs.tcgengine.view.components.popups.level
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.ScoreMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.PunctuationItem;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.HorizontalLayout;
   
   public class PunctuationContainer extends Component
   {
      
      private const TURNS_PUNCTUATION_IMG_NAME:String = "turn_icon";
      
      private const COMBAT_PUNCTUATION_IMG_NAME:String = "combat_icon";
      
      private const HP_PUNCTUATION_IMG_NAME:String = "life_icon_popup";
      
      private var mPunctuationContainer:ScrollContainer;
      
      private var mTurnsPointsContainer:PunctuationItem;
      
      private var mCombatPointsContainer:PunctuationItem;
      
      private var mHPPointsContainer:PunctuationItem;
      
      public function PunctuationContainer()
      {
         super();
         this.showPunctuationContainer();
         this.mPunctuationContainer.x += this.mPunctuationContainer.width / 3;
      }
      
      private function showPunctuationContainer() : void
      {
         var _loc1_:HorizontalLayout = null;
         if(this.mPunctuationContainer == null)
         {
            this.mPunctuationContainer = new ScrollContainer();
            _loc1_ = new HorizontalLayout();
            this.mPunctuationContainer.layout = _loc1_;
            this.mPunctuationContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.mPunctuationContainer.verticalScrollPolicy = ScrollPolicy.OFF;
         }
         if(this.mTurnsPointsContainer == null)
         {
            this.mTurnsPointsContainer = new PunctuationItem(this.TURNS_PUNCTUATION_IMG_NAME,"+0");
            this.mPunctuationContainer.addChild(this.mTurnsPointsContainer);
            this.mTurnsPointsContainer.setTooltipText(TextManager.getText("TID_GEN_SCORE_TIME",true));
         }
         if(this.mCombatPointsContainer == null)
         {
            this.mCombatPointsContainer = new PunctuationItem(this.COMBAT_PUNCTUATION_IMG_NAME,"+0");
            this.mCombatPointsContainer.setTooltipText(TextManager.getText("TID_GEN_SCORE_COMBAT",true));
            this.mPunctuationContainer.addChild(this.mCombatPointsContainer);
         }
         if(this.mHPPointsContainer == null)
         {
            this.mHPPointsContainer = new PunctuationItem(this.HP_PUNCTUATION_IMG_NAME,"+0");
            this.mHPPointsContainer.setTooltipText(TextManager.getText("TID_GEN_SCORE_LIFE",true));
            this.mPunctuationContainer.addChild(this.mHPPointsContainer);
         }
         this.mTurnsPointsContainer.setValue(0,0);
         this.mCombatPointsContainer.setValue(0,0);
         this.mHPPointsContainer.setValue(0,0);
         this.mPunctuationContainer.width = this.mTurnsPointsContainer.width * 3;
         this.mPunctuationContainer.height = this.mTurnsPointsContainer.height;
         addChild(this.mPunctuationContainer);
      }
      
      public function increasePunctuationItemsValue(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ScoreMng = InstanceMng.getScoreMng();
         var _loc4_:int = _loc3_ != null ? _loc3_.getPointsGainedByTurnsLeft(param1) : 0;
         var _loc5_:int = _loc3_ != null ? _loc3_.getPointsGainedByCombat() : 0;
         var _loc6_:int = _loc3_ != null ? _loc3_.getPointsGainedByHPLeft(param1) : 0;
         if(this.mTurnsPointsContainer != null)
         {
            TweenMax.delayedCall(_loc2_,this.setPunctuationItemValue,[this.mTurnsPointsContainer,_loc4_]);
            _loc2_++;
         }
         if(this.mCombatPointsContainer != null)
         {
            TweenMax.delayedCall(_loc2_,this.setPunctuationItemValue,[this.mCombatPointsContainer,_loc5_]);
            _loc2_++;
         }
         if(this.mHPPointsContainer != null)
         {
            TweenMax.delayedCall(_loc2_,this.setPunctuationItemValue,[this.mHPPointsContainer,_loc6_]);
            _loc2_++;
         }
      }
      
      private function setPunctuationItemValue(param1:PunctuationItem, param2:Number) : void
      {
         if(param1)
         {
            param1.setValue(param2);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mPunctuationContainer)
         {
            this.mPunctuationContainer.removeFromParent(true);
            this.mPunctuationContainer = null;
         }
         if(this.mTurnsPointsContainer)
         {
            this.mTurnsPointsContainer.removeFromParent(true);
            this.mTurnsPointsContainer = null;
         }
         if(this.mCombatPointsContainer)
         {
            this.mCombatPointsContainer.removeFromParent(true);
            this.mCombatPointsContainer = null;
         }
         if(this.mHPPointsContainer)
         {
            this.mHPPointsContainer.removeFromParent(true);
            this.mHPPointsContainer = null;
         }
         super.dispose();
      }
   }
}

