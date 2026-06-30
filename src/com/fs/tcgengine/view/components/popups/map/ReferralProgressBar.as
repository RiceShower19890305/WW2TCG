package com.fs.tcgengine.view.components.popups.map
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSGaugeProgressBar;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.misc.PopupReferral;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.utils.Align;
   
   public class ReferralProgressBar extends Component implements FSModelUnloadableInterface
   {
      
      private var mProgressBar:FSGaugeProgressBar;
      
      private var mProgressBarFG:FSImage;
      
      private var mType:int;
      
      private var mLeftIcon:FSImage;
      
      public function ReferralProgressBar(param1:int)
      {
         super();
         this.mType = param1;
         this.createUI();
         alignPivot(Align.LEFT,Align.TOP);
         touchable = true;
      }
      
      private function createUI() : void
      {
         this.createProgressBar();
         this.createIcon();
      }
      
      private function createProgressBar() : void
      {
         if(this.mProgressBarFG == null)
         {
            this.mProgressBarFG = new FSImage(Root.assets.getTexture("recruit_progress_bar_frame"));
            this.mProgressBarFG.touchable = false;
            addChild(this.mProgressBarFG);
         }
         if(this.mProgressBar == null)
         {
            this.mProgressBar = new FSGaugeProgressBar("","recruit_progress_bar",1,false,this.mProgressBarFG.width);
            this.mProgressBar.scaleX = 0.95;
            this.mProgressBar.touchable = false;
            this.mProgressBar.alignPivot();
            this.mProgressBar.x = this.mProgressBarFG.x + this.mProgressBarFG.width / 2;
            this.mProgressBar.y = this.mProgressBarFG.y + this.mProgressBarFG.height / 2;
            this.mProgressBar.setRatio(0);
            this.mProgressBar.touchable = false;
            addChildAt(this.mProgressBar,0);
         }
      }
      
      protected function createIcon() : void
      {
         var _loc1_:String = "";
         var _loc2_:String = "";
         var _loc3_:int = int(ServerConnection.smServerReferralsDefs[this.mType]["conditionLevel"]);
         var _loc4_:int = int(ServerConnection.smServerReferralsDefs[this.mType]["conditionMatchesPlayed"]);
         switch(this.mType)
         {
            case PopupReferral.REFERRAL_TYPE_RECRUIT:
               _loc1_ = "recruit_info_icon";
               _loc2_ = TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_ICON_INFO",true),[_loc3_]);
               break;
            case PopupReferral.REFERRAL_TYPE_PLAY_PVP:
               _loc1_ = "recruit_pvp_info_icon";
               _loc2_ = TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_ICON_PVP_INFO",true),[_loc4_]);
               break;
            case PopupReferral.REFERRAL_TYPE_PLAY_RAIDS:
               _loc1_ = "recruit_raid_info_icon";
               _loc2_ = TextManager.getText("TID_RECRUIT_ICON_RAID_INFO",true);
         }
         if(this.mLeftIcon == null)
         {
            this.mLeftIcon = new FSImage(Root.assets.getTexture(_loc1_));
            this.mLeftIcon.touchable = true;
            this.mLeftIcon.setTooltipText(_loc2_);
            this.mLeftIcon.addEventListener(TouchEvent.TOUCH,this.onIconTouch);
         }
         this.mLeftIcon.x = -this.mLeftIcon.width / 3;
         this.mLeftIcon.y = (this.mProgressBarFG.height - this.mLeftIcon.height) / 2;
         addChild(this.mLeftIcon);
      }
      
      private function onIconTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.mLeftIcon);
         if(_loc2_)
         {
            this.mLeftIcon.showTooltip();
         }
         else
         {
            this.mLeftIcon.closeTooltip();
         }
      }
      
      public function updateProgressBar(param1:int, param2:int) : void
      {
         var _loc3_:Number = param1 / param2;
         if(Boolean(this.mProgressBar) && this.mProgressBar.getRatio() != _loc3_)
         {
            this.mProgressBar.setValueAnimated(param1 / param2,0.25);
         }
         this.mProgressBar.setText(param1 + "/" + param2);
      }
      
      override public function dispose() : void
      {
         if(this.mProgressBar)
         {
            this.mProgressBar.removeFromParent(true);
            this.mProgressBar = null;
         }
         if(this.mProgressBarFG)
         {
            this.mProgressBarFG.removeFromParent(true);
            this.mProgressBarFG = null;
         }
         if(this.mLeftIcon)
         {
            this.mLeftIcon.removeFromParent(true);
            this.mLeftIcon = null;
         }
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mProgressBar)
         {
            this.mProgressBar.removeFromParent();
            this.mProgressBar = null;
         }
         if(this.mProgressBarFG)
         {
            this.mProgressBarFG.removeFromParent();
            this.mProgressBarFG = null;
         }
         if(this.mLeftIcon)
         {
            this.mLeftIcon.removeFromParent();
            this.mLeftIcon = null;
         }
      }
   }
}

