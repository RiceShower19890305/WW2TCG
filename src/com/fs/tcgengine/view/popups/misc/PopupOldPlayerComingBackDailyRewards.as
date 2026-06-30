package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.popups.map.DailyReward;
   
   public class PopupOldPlayerComingBackDailyRewards extends PopupDailyRewards
   {
      
      public function PopupOldPlayerComingBackDailyRewards(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function createUI() : void
      {
         if(mDailyRewardDef)
         {
            super.createUI();
            createFields();
            setMainFieldText(TextManager.getText("TID_WELCOME_BACK"));
            init();
         }
      }
      
      override protected function createDailyRewardItems(param1:Boolean) : void
      {
         super.createDailyRewardItems(true);
      }
      
      override protected function createLeftSection(param1:String) : void
      {
         super.createLeftSection("TID_WELCOME_BACK_INFO");
      }
      
      override public function onServerTimeACKGiveRewards(param1:Object) : void
      {
         var onPopupClosed:Function = null;
         var ownerUserData:UserData = null;
         var dailyRewardTimeMS:Number = NaN;
         var dateObj:Object = null;
         var date:Date = null;
         var dateMS:Number = NaN;
         var packDef:PackDef = null;
         var data:Object = param1;
         onPopupClosed = function():void
         {
            Utils.openPack(packDef,PacksDefMng.PACK_DAILY_REWARDS);
         };
         if(data != null)
         {
            ownerUserData = Utils.getOwnerUserData();
            if(ownerUserData)
            {
               dailyRewardTimeMS = ownerUserData.getOldPlayerComingBackDailyRewardTimeMS();
               if(mDailyRewardDef)
               {
                  ownerUserData.setOldPlayerComingBackLastDailyRewardClaimedIndex(mDailyRewardDef.getDay());
                  if(mDailyRewardDef.getDay() == 3)
                  {
                     ownerUserData.setIsOldPlayerComingBack(false);
                  }
                  dateObj = Utils.parseJSONData(data);
                  date = TimerUtil.convertServerUCTDateToDate(dateObj.now);
                  dateMS = date.getTime();
                  if(mDailyRewardDef.getDay() == 1 || !Config.smDailyRewardExpires)
                  {
                     FSDebug.debugTrace("CLAIMED! -> time: " + dateMS);
                     if(dateMS != 0 && dateMS != -1)
                     {
                        ownerUserData.setOldPlayerComingBackDailyRewardTimeMS(dateMS);
                     }
                     else
                     {
                        ownerUserData.setOldPlayerComingBackDailyRewardTimeMS(ServerConnection.smServerTimeMS);
                     }
                  }
                  switch(mDailyRewardDef.getType())
                  {
                     case DailyReward.TYPE_GOLD:
                        ownerUserData.addGold(mDailyRewardDef.getGold());
                        closePopup();
                        break;
                     case DailyReward.TYPE_CARD:
                     case DailyReward.TYPE_PACK:
                        packDef = PackDef(InstanceMng.getPacksDefMng().getDefBySku(mDailyRewardDef.getPackSku()));
                        if(packDef)
                        {
                           closePopup(onPopupClosed);
                        }
                        break;
                     case DailyReward.TYPE_QUEST_COINS:
                        ownerUserData.addQuestsCoins(mDailyRewardDef.getQuestCoins());
                        closePopup();
                        break;
                     case DailyReward.TYPE_RAID_COINS:
                        ownerUserData.addRaidCoins(mDailyRewardDef.getRaidCoins());
                        closePopup();
                  }
                  InstanceMng.getUserDataMng().persistenceSaveData();
                  Utils.setLogText(TextManager.getText("TID_DAILYREWARDS_SUCCESS"));
                  FSTracker.trackDailyRewardClaimed(mDailyRewardDef,true);
               }
            }
         }
         else
         {
            InstanceMng.getServerConnection().getServerTime(this.onServerTimeACKGiveRewards);
         }
      }
      
      override protected function scheduleNotifications() : void
      {
      }
   }
}

