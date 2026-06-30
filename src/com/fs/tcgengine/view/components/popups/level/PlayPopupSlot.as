package com.fs.tcgengine.view.components.popups.level
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.BattleEventDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.RaidLevelDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.misc.FSBattleEventInfo;
   import com.fs.tcgengine.view.misc.BoostsPanel;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.utils.Align;
   
   public class PlayPopupSlot extends Component
   {
      
      public static const POS_TOP:int = 0;
      
      public static const POS_MID:int = 1;
      
      public static const POS_BOT:int = 2;
      
      public static const TYPE_NONE:int = 0;
      
      public static const TYPE_SCORE:int = 1;
      
      public static const TYPE_EVENT:int = 2;
      
      public static const TYPE_DECK:int = 3;
      
      public static const TYPE_BOOSTERS:int = 4;
      
      public static const TYPE_MATCH_SUMMARY:int = 5;
      
      public static const TYPE_HARD_LEVEL_NOTIFIER:int = 6;
      
      private var mBG:FSImage;
      
      private var mPosition:int;
      
      private var mType:int;
      
      private var mLevelScore:FSTextfield;
      
      protected var mBoostsLabel:FSTextfield;
      
      private var mBoostsPanel:BoostsPanel;
      
      private var mBattleEventInfo:FSBattleEventInfo;
      
      private var mDeckSelectorInfo:PlayPopupDeckSelector;
      
      private var mPunctuationContainer:PunctuationContainer;
      
      private var mLevelDef:LevelDef;
      
      private var mHardLevelTextfield:FSTextfield;
      
      public function PlayPopupSlot(param1:int, param2:int, param3:LevelDef = null)
      {
         super();
         this.mType = param1;
         this.mPosition = param2;
         this.mLevelDef = param3;
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createMainComponents();
      }
      
      private function createMainComponents() : void
      {
         switch(this.mType)
         {
            case TYPE_SCORE:
               this.createScore();
               break;
            case TYPE_EVENT:
               this.createEvent();
               break;
            case TYPE_DECK:
               this.createDeck();
               break;
            case TYPE_BOOSTERS:
               this.createBoosters();
               break;
            case TYPE_MATCH_SUMMARY:
               this.createMatchSummary();
               break;
            case TYPE_HARD_LEVEL_NOTIFIER:
               this.createHardLevelNotifier();
         }
      }
      
      private function createHardLevelNotifier() : void
      {
         var _loc1_:int = this.mLevelDef.getHardness();
         var _loc2_:String = _loc1_ == 1 ? TextManager.getText("TID_LEVEL_HARD") : TextManager.getText("TID_LEVEL_VERY_HARD");
         this.mHardLevelTextfield = new FSTextfield(this.mBG.width * 0.68,this.mBG.height,_loc2_);
         this.mHardLevelTextfield.x = this.mBG.width / 6;
         var _loc3_:uint = _loc1_ == 0 ? 12517631 : 16711680;
         this.mHardLevelTextfield.color = _loc3_;
         addChild(this.mHardLevelTextfield);
      }
      
      private function createScore() : void
      {
         var _loc1_:String = null;
         if(this.mLevelScore == null)
         {
            _loc1_ = TextManager.getText("TID_GEN_RETRIEVING_LEVEL_SCORE");
            this.mLevelScore = new FSTextfield(this.mBG.width,this.mBG.height,_loc1_);
            this.mLevelScore.alpha = 0.5;
            addChild(this.mLevelScore);
         }
      }
      
      public function updateScore(param1:int) : void
      {
         if(this.mLevelScore)
         {
            this.mLevelScore.text = TextManager.getText("TID_GEN_LEVEL_SCORE") + ": " + param1;
            SpecialFX.tweenToAlpha(this.mLevelScore,1,1,0);
         }
      }
      
      private function createEvent() : void
      {
         var _loc1_:BattleEventDef = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(Boolean(this.mBattleEventInfo == null) && Boolean(this.mLevelDef) && this.mLevelDef.hasBattleEvent())
         {
            if(this.mLevelDef is RaidLevelDef)
            {
               _loc1_ = BattleEventDef(InstanceMng.getBattleEventDefMng().getDefBySku(RaidLevelDef(this.mLevelDef).getBattleEventSkuByDifficulty(UserDataMng.DIFFICULTY_EASY,UserData.WORLD_DEFAULT)));
            }
            else
            {
               _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
               _loc3_ = this.mLevelDef.getMapWorldParentIndex();
               _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc4_);
               _loc1_ = BattleEventDef(InstanceMng.getBattleEventDefMng().getDefBySku(LevelDef(this.mLevelDef).getBattleEventSkuByDifficulty(_loc2_,_loc4_)));
            }
            if(_loc1_)
            {
               this.mBattleEventInfo = new FSBattleEventInfo(_loc1_,this.mBG.width);
               this.mBattleEventInfo.y = (this.mBG.height - this.mBattleEventInfo.height) / 2;
               addChild(this.mBattleEventInfo);
            }
         }
      }
      
      private function createDeck() : void
      {
         if(this.mDeckSelectorInfo == null)
         {
            this.mDeckSelectorInfo = new PlayPopupDeckSelector(this.mBG.width);
            this.mDeckSelectorInfo.name = "deckSelectorInfo";
            this.mDeckSelectorInfo.y = (this.mBG.height - this.mDeckSelectorInfo.height) / 2;
            addChild(this.mDeckSelectorInfo);
         }
      }
      
      private function createBoosters() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mBoostsLabel == null)
         {
            _loc2_ = this.mBG.width / 4;
            _loc3_ = this.mBG.height;
            this.mBoostsLabel = new FSTextfield(_loc2_,_loc3_,TextManager.getText("TID_GEN_LEVEL_BOOST_SELECTION"));
            this.mBoostsLabel.x = this.mBG.width / 6;
            this.mBoostsLabel.format.horizontalAlign = Align.RIGHT;
            addChild(this.mBoostsLabel);
         }
         var _loc1_:Array = this.mLevelDef.getPreBoostsArr();
         if(_loc1_ != null && _loc1_.length > 0)
         {
            if(this.mBoostsPanel == null)
            {
               this.mBoostsPanel = new BoostsPanel(this.mLevelDef,this.mBG.width / 2.5);
               this.mBoostsPanel.alignPivot();
               this.mBoostsPanel.x = this.mBG.width * 0.65;
               this.mBoostsPanel.y = this.mBG.height / 2;
            }
            else
            {
               this.mBoostsPanel.refresh(this.mLevelDef);
            }
            addChild(this.mBoostsPanel);
         }
      }
      
      private function createMatchSummary() : void
      {
         if(this.mPunctuationContainer == null)
         {
            this.mPunctuationContainer = new PunctuationContainer();
            this.mPunctuationContainer.y = (this.mBG.height - this.mPunctuationContainer.height) / 2;
            addChild(this.mPunctuationContainer);
         }
      }
      
      public function increasePunctuationItemsValue(param1:Boolean) : void
      {
         if(this.mPunctuationContainer)
         {
            this.mPunctuationContainer.increasePunctuationItemsValue(param1);
         }
      }
      
      private function createBG() : void
      {
         var _loc1_:String = null;
         if(this.mBG == null)
         {
            _loc1_ = "";
            switch(this.mPosition)
            {
               case POS_TOP:
                  _loc1_ = "start_level_score";
                  break;
               case POS_MID:
                  _loc1_ = "start_level_mid";
                  break;
               case POS_BOT:
                  _loc1_ = "start_level_bottom";
            }
            this.mBG = new FSImage(Root.assets.getTexture(_loc1_));
            addChild(this.mBG);
         }
      }
      
      public function onDeckSelectionChanged(param1:int, param2:int) : void
      {
         if(this.mDeckSelectorInfo)
         {
            this.mDeckSelectorInfo.onDeckSelectionChanged(param1,param2);
         }
      }
      
      public function hideCarrousels(param1:Boolean = true) : void
      {
         if(this.mDeckSelectorInfo)
         {
            this.mDeckSelectorInfo.hideCarrousels(param1);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG.destroy();
            this.mBG = null;
         }
         if(this.mLevelScore)
         {
            this.mLevelScore.removeFromParent(true);
            this.mLevelScore = null;
         }
         if(this.mHardLevelTextfield)
         {
            this.mHardLevelTextfield.removeFromParent(true);
            this.mHardLevelTextfield = null;
         }
         if(this.mBoostsLabel)
         {
            this.mBoostsLabel.removeFromParent(true);
            this.mBoostsLabel = null;
         }
         if(this.mBoostsPanel)
         {
            this.mBoostsPanel.removeFromParent(true);
            this.mBoostsPanel = null;
         }
         if(this.mBattleEventInfo)
         {
            this.mBattleEventInfo.removeFromParent(true);
            this.mBattleEventInfo = null;
         }
         if(this.mDeckSelectorInfo)
         {
            this.mDeckSelectorInfo.removeFromParent(true);
            this.mDeckSelectorInfo = null;
         }
         if(this.mPunctuationContainer)
         {
            this.mPunctuationContainer.removeFromParent(true);
            this.mPunctuationContainer = null;
         }
         this.mLevelDef = null;
         super.dispose();
      }
   }
}

