package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import com.fs.tcgengine.utils.Utils;
   import starling.events.Event;
   
   public class PopupNewSeason extends PopupStandard
   {
      
      protected var mNewSeason:int;
      
      private var mIsPvPSeason:Boolean;
      
      private var mIsDungeonsSeason:Boolean;
      
      public function PopupNewSeason(param1:Boolean = true)
      {
         super(false);
      }
      
      public function setupNewSeason(param1:int, param2:Boolean, param3:Boolean) : void
      {
         this.mNewSeason = param1;
         this.mIsPvPSeason = param2;
         this.mIsDungeonsSeason = param3;
      }
      
      override protected function onAccept(param1:Event) : void
      {
         super.onAccept(param1);
         mOnClosedFunction = this.onAcceptPerformOps;
      }
      
      protected function onAcceptPerformOps() : void
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         if(this.mIsPvPSeason)
         {
            PvPConnectionMng.onSeasonChangedResetParams(this.mNewSeason);
         }
         else
         {
            _loc1_.setDungeonsSeason(this.mNewSeason);
            _loc1_.setDungeonsPlayed(0);
            _loc1_.setDungeonsWon(0);
            _loc1_.setDungeonsLost(0);
            if(InstanceMng.getCurrentScreen() is FSDungeonsScreen)
            {
               FSDungeonsScreen(InstanceMng.getCurrentScreen()).setChooseButtonEnabled(true);
            }
         }
         InstanceMng.getUserDataMng().persistenceSaveData();
      }
   }
}

