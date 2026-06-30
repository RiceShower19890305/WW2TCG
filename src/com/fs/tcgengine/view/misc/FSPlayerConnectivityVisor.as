package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   
   public class FSPlayerConnectivityVisor extends Component
   {
      
      private var mOnlineStatusImage:FSImage;
      
      private var mLastActivityTimeMS:Number;
      
      private var mShowGreenLightUnderThreshold:Number = 10;
      
      private var mShowTooltip:Boolean;
      
      public function FSPlayerConnectivityVisor(param1:Number, param2:Number = 5, param3:Boolean = false)
      {
         super();
         this.mLastActivityTimeMS = param1;
         this.mShowGreenLightUnderThreshold = param2;
         this.mShowTooltip = param3;
         this.createUI();
         if(Utils.isMobile())
         {
            scaleX *= 1.5;
            scaleY *= 1.5;
         }
      }
      
      private function createUI() : void
      {
         this.refreshStatus();
      }
      
      private function createStatusImage(param1:Boolean) : void
      {
         var _loc2_:String = param1 ? "online_led" : "offline_led";
         if(this.mOnlineStatusImage == null)
         {
            this.mOnlineStatusImage = new FSImage(Root.assets.getTexture(_loc2_),false);
            this.mOnlineStatusImage.touchable = true;
            addChild(this.mOnlineStatusImage);
         }
         else
         {
            this.mOnlineStatusImage.texture = Root.assets.getTexture(_loc2_);
         }
      }
      
      public function refreshStatus() : void
      {
         var _loc1_:Number = TimerUtil.minToMs(this.mShowGreenLightUnderThreshold);
         var _loc2_:Number = ServerConnection.smServerTimeMS - this.mLastActivityTimeMS;
         _loc2_ = _loc2_ < 0 ? 0 : _loc2_;
         var _loc3_:String = "";
         var _loc4_:Boolean = TimerUtil.msToDays(_loc2_) > 0;
         var _loc5_:Boolean = TimerUtil.msToHour(_loc2_) > 0;
         var _loc6_:Boolean = TimerUtil.msToMin(_loc2_) > 0;
         var _loc7_:String = _loc4_ ? TextManager.getText("TID_GEN_TIME_DAYS_ABR",true) + " " : null;
         var _loc8_:String = !_loc4_ && _loc5_ ? TextManager.getText("TID_GEN_TIME_HOURS_ABR",true) + " " : null;
         var _loc9_:String = !_loc5_ && _loc6_ ? TextManager.getText("TID_GEN_TIME_MINUTES_ABR",true) + " " : null;
         var _loc10_:String = !_loc6_ ? TextManager.getText("TID_GEN_TIME_SECONDS_ABR",true) + " " : null;
         _loc3_ = TimerUtil.getTimeTextFromMs(_loc2_,_loc7_,_loc8_,_loc9_,_loc10_);
         this.createStatusImage(_loc2_ <= _loc1_);
         if(this.mShowTooltip)
         {
            setTooltipText(TextManager.replaceParameters(TextManager.getText("TID_GEN_PLAYER_AGO"),[_loc3_]));
         }
      }
      
      override public function dispose() : void
      {
         if(this.mOnlineStatusImage)
         {
            this.mOnlineStatusImage.removeFromParent(true);
            this.mOnlineStatusImage = null;
         }
         super.dispose();
      }
   }
}

