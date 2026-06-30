package com.fs.tcgengine.view.components.popups.map
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.DailyRewardDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.misc.PopupDailyRewards;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class DailyReward extends Component
   {
      
      public static const TYPE_GOLD:int = 0;
      
      public static const TYPE_CARD:int = 1;
      
      public static const TYPE_PACK:int = 2;
      
      public static const TYPE_QUEST_COINS:int = 3;
      
      public static const TYPE_RAID_COINS:int = 4;
      
      private var mBG:CustomComponent;
      
      private var mTitle:FSTextfield;
      
      private var mBGItem:*;
      
      private var mInfoTitle:FSTextfield;
      
      private var mInfoBody:FSTextfield;
      
      private var mIsTodayReward:Boolean = false;
      
      private var mDailyRewardDef:DailyRewardDef;
      
      private var mParentPopup:PopupDailyRewards;
      
      private var mAlreadyClaimed:Boolean = false;
      
      public function DailyReward(param1:DailyRewardDef, param2:Boolean, param3:PopupDailyRewards, param4:Boolean)
      {
         super();
         this.mDailyRewardDef = param1;
         this.mIsTodayReward = param2;
         this.mParentPopup = param3;
         this.mAlreadyClaimed = param4;
         this.createUI();
         scale = this.mDailyRewardDef.isOldPlayerComingBackDef() ? 1.5 : 1;
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createTitle();
         this.createBGItem();
         this.createInfo();
      }
      
      public function setBGTouchable(param1:Boolean) : void
      {
         if(this.mIsTodayReward && Boolean(this.mBG))
         {
            this.mBG.touchable = param1;
         }
      }
      
      private function createBG() : void
      {
         var _loc1_:String = null;
         if(this.mBG == null)
         {
            _loc1_ = this.getSlotBGName();
            this.mBG = Utils.createCustomBox(_loc1_,266);
            addChild(this.mBG);
            if(this.mIsTodayReward)
            {
               this.mBG.touchable = true;
               this.mBG.addEventListener(TouchEvent.TOUCH,this.onBGTouch);
            }
         }
      }
      
      private function onBGTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.mBG,TouchPhase.ENDED);
         if(_loc2_)
         {
            this.onClaimTriggered();
         }
      }
      
      private function onClaimTriggered() : void
      {
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            this.mBG.touchable = false;
            this.mBG.removeEventListener(TouchEvent.TOUCH,this.onBGTouch);
            InstanceMng.getServerConnection().getServerTime(this.mParentPopup.onServerTimeACKGiveRewards);
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GEN_LOG_NEEDED"),true);
         }
      }
      
      private function createTitle() : void
      {
         var _loc1_:String = null;
         if(this.mTitle == null)
         {
            _loc1_ = this.getSlotTitleText();
            this.mTitle = new FSTextfield(this.mBG.width * 0.875,this.mBG.height * 0.245,_loc1_);
            this.mTitle.touchable = false;
            this.mTitle.x = (this.mBG.width - this.mTitle.width) / 2;
            this.mTitle.y = this.mBG.height - this.mTitle.height * 1.125;
            addChild(this.mTitle);
         }
      }
      
      private function getSlotTitleText() : String
      {
         var _loc1_:String = this.mIsTodayReward ? TextManager.getText("TID_ACHIEVEMENT_CLAIM") : TextManager.getText("TID_GEN_TIME_DAY") + " " + this.mDailyRewardDef.getDay();
         return this.mAlreadyClaimed ? TextManager.getText("TID_GEN_CLAIMED") : _loc1_;
      }
      
      private function createBGItem() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         if(this.mBGItem == null)
         {
            _loc2_ = "";
            switch(this.mDailyRewardDef.getType())
            {
               case TYPE_PACK:
                  this.mBGItem = this.createPackImage();
                  break;
               default:
                  _loc1_ = this.mDailyRewardDef.getBGImageName();
            }
            _loc3_ = this.mDailyRewardDef.getType() == TYPE_PACK;
            _loc4_ = this.mDailyRewardDef.getType() == TYPE_CARD;
            if(!_loc3_)
            {
               this.mBGItem = new FSImage(Root.assets.getTexture(_loc1_));
            }
            this.mBGItem.touchable = false;
            this.mBGItem.x = (this.mBG.width - this.mBGItem.width) / 2;
            this.mBGItem.y = this.mBG.y;
            if(_loc3_)
            {
               this.mBGItem.x += this.mBGItem.width / 2;
               this.mBGItem.y += this.mBGItem.height / 1.35;
            }
            else if(_loc4_)
            {
               this.mBGItem.y += this.mBGItem.height * 0.1;
            }
            addChild(this.mBGItem);
         }
      }
      
      public function createPackImage() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:String = null;
         var _loc3_:PackDef = null;
         if(_loc1_ == null)
         {
            _loc2_ = this.mDailyRewardDef.getPackSku();
            _loc3_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc2_));
            if(_loc3_)
            {
               _loc1_ = new PackAnimation(_loc3_.getAnimBG());
               _loc1_.scaleX *= 0.4;
               _loc1_.scaleY *= 0.4;
               _loc1_.touchable = false;
            }
         }
         return _loc1_;
      }
      
      private function createInfo() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         switch(this.mDailyRewardDef.getType())
         {
            case TYPE_GOLD:
               _loc2_ = this.mDailyRewardDef.getGold().toString();
               break;
            case TYPE_QUEST_COINS:
               _loc2_ = this.mDailyRewardDef.getQuestCoins().toString();
               break;
            case TYPE_RAID_COINS:
               _loc2_ = this.mDailyRewardDef.getRaidCoins().toString();
               break;
            default:
               return;
         }
         if(this.mInfoBody == null)
         {
            this.mInfoBody = new FSTextfield(this.mTitle.width,this.mTitle.height * 1.5,_loc2_);
            this.mInfoBody.touchable = false;
            this.mInfoBody.x = this.mTitle.x;
            this.mInfoBody.y = this.mTitle.y - this.mInfoBody.height;
            addChild(this.mInfoBody);
         }
      }
      
      private function getSlotBGName() : String
      {
         var _loc1_:String = this.mIsTodayReward ? "daily_reward_slot_claim" : "daily_reward_slot";
         _loc1_ = this.mAlreadyClaimed ? "daily_reward_slot_claimed" : _loc1_;
         if(!this.mAlreadyClaimed && !this.mIsTodayReward)
         {
            if(this.mDailyRewardDef.getDay() == 15)
            {
               _loc1_ += "_15";
            }
            else if(this.mDailyRewardDef.getDay() == 30)
            {
               _loc1_ += "_30";
            }
         }
         return _loc1_;
      }
      
      public function updateIsTodayReward(param1:Boolean) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this.mIsTodayReward != param1)
         {
            this.mIsTodayReward = param1;
            if(this.mBG)
            {
               _loc2_ = this.getSlotBGName();
               this.mBG.updateTextures(_loc2_,266);
            }
            if(this.mTitle)
            {
               _loc3_ = this.getSlotTitleText();
               this.mTitle.text = _loc3_;
            }
         }
      }
      
      public function getDayIndex() : int
      {
         return this.mDailyRewardDef != null ? this.mDailyRewardDef.getDay() : -1;
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mBGItem)
         {
            this.mBGItem.removeFromParent(true);
            this.mBGItem = null;
         }
         if(this.mInfoTitle)
         {
            this.mInfoTitle.removeFromParent(true);
            this.mInfoTitle = null;
         }
         if(this.mTitle)
         {
            this.mTitle.removeFromParent(true);
            this.mTitle = null;
         }
         if(this.mInfoBody)
         {
            this.mInfoBody.removeFromParent(true);
            this.mInfoBody = null;
         }
         this.mParentPopup = null;
         this.mAlreadyClaimed = false;
         super.dispose();
      }
   }
}

