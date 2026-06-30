package com.fs.tcgengine.view.raids
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.RaidsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.RaidDef;
   import com.fs.tcgengine.model.rules.RaidLevelDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSRaidsScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import flash.ui.Mouse;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   
   public class FSRaidSlotDifficultyInfo extends Component implements FSModelUnloadableInterface
   {
      
      protected var mBG:FSImage;
      
      protected var mProgressBarBG:FSImage;
      
      private var mTextfield:FSTextfield;
      
      protected var mTicketCost:FSButton;
      
      private var mParentRaidSlotInfo:FSRaidSlotInfo;
      
      private var mDifficultyIndex:int;
      
      private var mIsSelected:Boolean;
      
      private var mCurrentRaidBossHp:int = -2147483648;
      
      private var mCurrentRaidIsBossDefeated:Boolean = false;
      
      private var mInfoRaidObtained:Boolean = false;
      
      private var mPercentageLifeBossTextfield:FSTextfield;
      
      private var mIsThisSlotCreated:Boolean = false;
      
      public function FSRaidSlotDifficultyInfo(param1:FSRaidSlotInfo, param2:int)
      {
         super();
         this.mParentRaidSlotInfo = param1;
         this.mDifficultyIndex = param2;
         this.init();
      }
      
      private function init() : void
      {
         this.touchable = false;
         if(!this.mInfoRaidObtained)
         {
            this.manageRaidInfo();
         }
         this.addEventListeners();
      }
      
      public function manageRaidInfo() : void
      {
         var _loc1_:String = null;
         var _loc2_:RaidLevelDef = null;
         var _loc3_:int = 0;
         if(Boolean(this.mParentRaidSlotInfo) && Boolean(this.mParentRaidSlotInfo.getRaidDef()))
         {
            _loc1_ = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getLevelDefByLevelIndex(this.mParentRaidSlotInfo.getRaidDef().getLevelsByDifficultyIndex(this.mDifficultyIndex))).getSku();
         }
         if(_loc1_)
         {
            _loc2_ = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getDefBySku(_loc1_));
            _loc3_ = _loc2_.getIAHP();
            this.setDataRaid(_loc3_,false,false);
            this.getBossHP();
         }
      }
      
      private function getBossHP() : void
      {
         var _loc2_:Object = null;
         var _loc1_:RaidDef = this.mParentRaidSlotInfo.getRaidDef();
         if(Boolean(_loc1_) && Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc2_ = this.mParentRaidSlotInfo.getRaidDef().getIsMultiPlayer() ? RaidsMng.smRaidScoresMP : RaidsMng.smRaidScoresSP;
            if(_loc2_)
            {
               this.onGetScoresACK(_loc2_);
            }
         }
      }
      
      private function onGetScoresACK(param1:Object) : void
      {
         var _loc2_:RaidDef = null;
         var _loc3_:RaidLevelDef = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         if(Boolean(this.mParentRaidSlotInfo) && Boolean(InstanceMng.getCurrentScreen() is FSRaidsScreen) && InstanceMng.getCurrentScreen().isFullyLoaded())
         {
            _loc2_ = this.mParentRaidSlotInfo.getRaidDef();
            if(_loc2_)
            {
               _loc3_ = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getLevelDefByLevelIndex(_loc2_.getLevelsByDifficultyIndex(this.mDifficultyIndex)));
               if(_loc3_)
               {
                  _loc4_ = InstanceMng.getRaidsMng().getRaidBossHP(this.mParentRaidSlotInfo.getRaidDef(),this.mDifficultyIndex);
                  _loc5_ = _loc4_ <= 0;
                  this.setDataRaid(_loc4_,_loc5_,!_loc5_);
                  if(!this.mIsThisSlotCreated && Boolean(this.mParentRaidSlotInfo))
                  {
                     this.mParentRaidSlotInfo.createUISlotDifficulty(this,this.mDifficultyIndex);
                  }
                  this.mInfoRaidObtained = true;
                  this.updateBGBasedOnPercentageDone();
               }
            }
         }
      }
      
      public function createUI() : void
      {
         this.createBG();
         this.createTicketButton();
         this.createText();
         this.mIsThisSlotCreated = true;
         if(this.mDifficultyIndex == RaidsMng.RAID_DIFFICULTY_EASY)
         {
            this.mParentRaidSlotInfo.unlockItem();
         }
      }
      
      private function addEventListeners() : void
      {
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      public function setInfoRaidObtained(param1:Boolean) : void
      {
         this.mInfoRaidObtained = param1;
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:FSRaidsScreen = null;
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(!Root.assets.isLoading && InstanceMng.getCurrentScreen() is FSRaidsScreen)
            {
               _loc3_ = FSRaidsScreen(InstanceMng.getCurrentScreen());
               if(_loc3_)
               {
                  _loc3_.resetRaidVariables();
               }
               if(InstanceMng.getRaidsMng().isWeeklySeasonActive())
               {
                  FSDebug.debugTrace("Slot Click");
                  if(!this.mInfoRaidObtained)
                  {
                     this.manageRaidInfo();
                  }
                  this.mParentRaidSlotInfo.onDifficultySelected(this.mDifficultyIndex);
                  _loc3_.onDifficultySelected(this.mDifficultyIndex);
                  _loc3_.removeRaidStatus();
                  if(Boolean(!this.mCurrentRaidIsBossDefeated) && Boolean(_loc3_.getSelectedRaidDef()) && _loc3_.getSelectedRaidDef().getIsMultiPlayer())
                  {
                     _loc3_.createRecommendedPlayersSize();
                  }
                  if(!_loc3_.isRaidStatusActive())
                  {
                     _loc3_.changeNameLadder();
                  }
                  _loc3_.setChooseButtonEnabled(!this.mCurrentRaidIsBossDefeated);
               }
               else
               {
                  if(this.mParentRaidSlotInfo)
                  {
                     this.mParentRaidSlotInfo.onDifficultySelected(-1);
                     this.mParentRaidSlotInfo.setExpanded(false);
                  }
                  _loc3_.onDifficultySelected(-1);
                  _loc3_.removeRaidStatus();
               }
            }
         }
         _loc2_ = param1.getTouch(this,TouchPhase.HOVER);
         alpha = _loc2_ ? 0.8 : 1;
         if(Utils.isBrowser() || Utils.isDesktop())
         {
            Mouse.cursor = _loc2_ ? "hand" : "auto";
         }
      }
      
      public function setSelected(param1:Boolean) : void
      {
         if(this.mIsSelected != param1)
         {
            this.mIsSelected = param1;
            this.manageBG();
         }
      }
      
      private function manageBG() : void
      {
         var _loc1_:Texture = null;
         if(this.mBG)
         {
            _loc1_ = this.mIsSelected ? Root.assets.getTexture("raid_diff_button_selected") : Root.assets.getTexture("dungeon_diff_button");
            this.mBG.texture = _loc1_;
         }
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            if(this.mParentRaidSlotInfo != null)
            {
               if(this.mCurrentRaidIsBossDefeated)
               {
                  this.mBG = new FSImage(Root.assets.getTexture("dungeon_diff_button_selected"));
               }
               else
               {
                  this.mBG = new FSImage(Root.assets.getTexture("dungeon_diff_button"));
               }
               addChild(this.mBG);
            }
         }
         if(this.mProgressBarBG == null)
         {
            this.mProgressBarBG = new FSImage(Root.assets.getTexture("dungeon_diff_button_selected"));
            addChild(this.mProgressBarBG);
         }
         this.updateBGBasedOnPercentageDone();
      }
      
      private function createTicketButton() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this.mTicketCost == null && !this.mCurrentRaidIsBossDefeated)
         {
            if(Boolean(this.mParentRaidSlotInfo) && Boolean(this.mParentRaidSlotInfo.getRaidDef()))
            {
               _loc1_ = this.mParentRaidSlotInfo.getRaidDef().getKeyCostByDifficultyIndex(this.mDifficultyIndex).toString() + "x";
            }
            if(Boolean(this.mParentRaidSlotInfo) && Boolean(this.mParentRaidSlotInfo.getRaidDef()) && this.mParentRaidSlotInfo.getRaidDef().getIsMultiPlayer())
            {
               _loc2_ = "raid_ticket_mp";
            }
            else
            {
               _loc2_ = "raid_ticket_sp";
            }
            if(Root.assets.getTexture(_loc2_))
            {
               this.mTicketCost = new FSButton(Root.assets.getTexture(_loc2_),_loc1_);
               this.mTicketCost.fontColor = 16777215;
               this.mTicketCost.fontName = FSResourceMng.getFontByType();
               this.mTicketCost.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
               this.mTicketCost.enableScaleOnMouseOver(false);
               this.mTicketCost.x = this.mTicketCost.width / 2;
               this.mTicketCost.y = this.mBG.height / 2;
               addChild(this.mTicketCost);
            }
         }
      }
      
      private function createText() : void
      {
         var _loc1_:String = null;
         if(this.mTextfield == null)
         {
            switch(this.mDifficultyIndex)
            {
               case RaidsMng.RAID_DIFFICULTY_EASY:
                  _loc1_ = TextManager.getText("TID_DUNGEON_DIFFICULTY_01");
                  break;
               case RaidsMng.RAID_DIFFICULTY_MEDIUM:
                  _loc1_ = TextManager.getText("TID_DUNGEON_DIFFICULTY_02");
                  break;
               case RaidsMng.RAID_DIFFICULTY_HARD:
                  _loc1_ = TextManager.getText("TID_DUNGEON_DIFFICULTY_03");
                  break;
               case RaidsMng.RAID_DIFFICULTY_EXPERT:
                  _loc1_ = TextManager.getText("TID_RAID_EXPERT");
            }
            if(this.mCurrentRaidIsBossDefeated)
            {
               _loc1_ = TextManager.getText("TID_RAID_COMPLETED");
            }
            if(this.mTicketCost)
            {
               this.mTextfield = new FSTextfield(this.mBG.width - this.mTicketCost.width,this.mBG.height,_loc1_);
               this.mTextfield.x = this.mTicketCost.x + this.mTicketCost.width / 2;
            }
            else
            {
               this.mTextfield = new FSTextfield(this.mBG.width,this.mBG.height,_loc1_);
               this.mTextfield.x = this.mBG.x;
            }
            this.mTextfield.y = 0;
            addChild(this.mTextfield);
         }
      }
      
      public function getDifficultyIndex() : int
      {
         return this.mDifficultyIndex;
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mProgressBarBG)
         {
            this.mProgressBarBG.removeFromParent(true);
            this.mProgressBarBG = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         if(this.mTicketCost)
         {
            this.mTicketCost.removeFromParent(true);
            this.mTicketCost = null;
         }
         if(this.mPercentageLifeBossTextfield)
         {
            this.mPercentageLifeBossTextfield.removeFromParent(true);
            this.mPercentageLifeBossTextfield = null;
         }
         this.mParentRaidSlotInfo = null;
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG.destroy();
            this.mBG = null;
         }
         if(this.mProgressBarBG)
         {
            this.mProgressBarBG.removeFromParent();
            this.mProgressBarBG = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent();
            this.mTextfield = null;
         }
         if(this.mTicketCost)
         {
            this.mTicketCost.removeFromParent();
            this.mTicketCost.destroy();
            this.mTicketCost = null;
         }
         if(this.mPercentageLifeBossTextfield)
         {
            this.mPercentageLifeBossTextfield.removeFromParent();
            this.mPercentageLifeBossTextfield = null;
         }
         this.mParentRaidSlotInfo = null;
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      public function setDataRaid(param1:int, param2:Boolean, param3:Boolean) : void
      {
         this.mCurrentRaidBossHp = param1;
         this.mCurrentRaidIsBossDefeated = param2;
      }
      
      public function getParentSlot() : FSRaidSlotInfo
      {
         return this.mParentRaidSlotInfo;
      }
      
      public function updateBGBasedOnPercentageDone() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         if(Boolean(this.mProgressBarBG) && InstanceMng.getCurrentScreen() is FSRaidsScreen)
         {
            _loc1_ = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getLevelDefByLevelIndex(this.mParentRaidSlotInfo.getRaidDef().getLevelsByDifficultyIndex(this.mDifficultyIndex))).getSku();
            _loc2_ = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getDefBySku(_loc1_)).getIAHP();
            _loc3_ = InstanceMng.getRaidsMng().getRaidBossHP(this.mParentRaidSlotInfo.getRaidDef(),this.mDifficultyIndex);
            _loc4_ = this.mIsSelected ? this.mCurrentRaidBossHp / _loc2_ : this.mCurrentRaidBossHp / _loc2_;
            this.mProgressBarBG.scaleX = _loc4_ >= 1 ? 1 : _loc4_;
            if(Boolean(this.mBG) && this.mCurrentRaidBossHp <= 0)
            {
               this.mBG.texture = Root.assets.getTexture("dungeon_diff_button");
            }
         }
      }
   }
}

