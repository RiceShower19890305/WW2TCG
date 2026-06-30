package com.fs.tcgengine.view.components.popups.map
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.misc.PopupReferral;
   import flash.geom.Point;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class ReferralRewardInfo extends Component implements FSModelUnloadableInterface
   {
      
      private var mBG:CustomComponent;
      
      private var mFG:FSImage;
      
      private var mNameTextfield:FSTextfield;
      
      private var mGoldTextfield:FSTextfield;
      
      private var mPackAnim:PackAnimation;
      
      private var mLeftIcon:FSImage;
      
      private var mType:int;
      
      private var mAmount:int;
      
      private var mRewardDef:Object;
      
      private var mIsMouseHeldDown:Boolean;
      
      private var mHoverHelperPoint:Point;
      
      public function ReferralRewardInfo(param1:int, param2:int, param3:Object)
      {
         super();
         this.mType = param1;
         this.mAmount = param2;
         this.mRewardDef = param3;
         this.createUI();
         alignPivot(Align.LEFT,Align.TOP);
         touchable = true;
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createFG();
         this.createName();
         this.createGoldTextfield();
         this.createIcon();
      }
      
      private function createBG() : void
      {
         var _loc1_:String = "button_deck_normal";
         if(this.mBG == null)
         {
            this.mBG = Utils.createCustomBox(_loc1_,278);
            this.mBG.touchable = true;
            addEventListener(TouchEvent.TOUCH,this.onTouch);
            addChild(this.mBG);
         }
         else
         {
            this.mBG.updateTextures(_loc1_,278);
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Touch = null;
         var _loc4_:Number = NaN;
         if(param1)
         {
            _loc2_ = param1.getTouch(this.mBG);
            _loc3_ = param1.getTouch(this,TouchPhase.HOVER);
            _loc4_ = _loc3_ ? 1 : 0.8;
            if(this.mBG)
            {
               this.mBG.alpha = _loc4_;
            }
            if(param1.getTouch(this,TouchPhase.BEGAN))
            {
               this.mIsMouseHeldDown = true;
            }
            else if(param1.getTouch(this,TouchPhase.ENDED))
            {
               this.onMouseUp();
               this.mIsMouseHeldDown = false;
            }
            else if(Boolean(_loc2_) && _loc2_.phase != TouchPhase.HOVER)
            {
               if(this.mHoverHelperPoint == null)
               {
                  this.mHoverHelperPoint = new Point();
               }
               this.mHoverHelperPoint.x = _loc2_.globalX;
               this.mHoverHelperPoint.y = _loc2_.globalY;
               this.globalToLocal(this.mHoverHelperPoint,this.mHoverHelperPoint);
               this.mIsMouseHeldDown = this.hitTest(this.mHoverHelperPoint) != null;
            }
         }
      }
      
      private function onMouseUp() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Popup = null;
         var _loc5_:int = 0;
         if(!this.mIsMouseHeldDown || InstanceMng.getPopupMng().getPopupShown() is PopupReferral && PopupReferral(InstanceMng.getPopupMng().getPopupShown()).isScrollContainerScrolling())
         {
            return;
         }
         if(!InstanceMng.getUserDataMng().getOwnerUserData().isInBlackList())
         {
            if(!InstanceMng.getUserDataMng().getOwnerUserData().isInDuplicatedList())
            {
               _loc1_ = "";
               _loc2_ = int(ServerConnection.smServerReferralsDefs[this.mType]["conditionLevel"]);
               _loc3_ = int(ServerConnection.smServerReferralsDefs[this.mType]["conditionMatchesPlayed"]);
               switch(this.mType)
               {
                  case PopupReferral.REFERRAL_TYPE_RECRUIT:
                     _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_INFO_TYPE_0"),[this.mAmount,_loc2_]);
                     break;
                  case PopupReferral.REFERRAL_TYPE_PLAY_PVP:
                     _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_INFO_TYPE_1"),[this.mAmount,_loc3_]);
                     break;
                  case PopupReferral.REFERRAL_TYPE_PLAY_RAIDS:
                     _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_INFO_TYPE_2"),[this.mAmount]);
               }
               _loc4_ = InstanceMng.getPopupMng().getPopupShown();
               if((Boolean(_loc4_)) && _loc4_ is PopupReferral)
               {
                  _loc5_ = Boolean(this.mRewardDef) && this.mRewardDef.hasOwnProperty("gold") ? int(this.mRewardDef["gold"]) : 0;
                  _loc4_.hideTemporarily(InstanceMng.getPopupMng().openProductDetailPopup,[this.getRewardType(),this.getRewardSku(),_loc5_,_loc1_]);
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_MIGRATION_ERROR_MIGRATED"),true,false,false);
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GEN_FRAUD_PURCHASE"),true,false,false);
         }
      }
      
      private function getRewardType() : int
      {
         var _loc1_:int = -1;
         if(this.mRewardDef)
         {
            if(this.mRewardDef.hasOwnProperty("cardSku") && this.mRewardDef["cardSku"] != null && this.mRewardDef["cardSku"] != "")
            {
               return 0;
            }
            if(this.mRewardDef.hasOwnProperty("packSku") && this.mRewardDef["packSku"] != null && this.mRewardDef["packSku"] != "")
            {
               return 1;
            }
            if(this.mRewardDef.hasOwnProperty("gold") && this.mRewardDef["gold"] != null && this.mRewardDef["gold"] > 0)
            {
               return 3;
            }
         }
         return _loc1_;
      }
      
      private function getRewardSku() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = this.getRewardType();
         if(this.mRewardDef)
         {
            switch(_loc2_)
            {
               case 0:
                  return this.mRewardDef.hasOwnProperty("cardSku") && this.mRewardDef["cardSku"] != null && this.mRewardDef["cardSku"] != "" ? this.mRewardDef["cardSku"] : "";
               case 1:
                  return this.mRewardDef.hasOwnProperty("packSku") && this.mRewardDef["packSku"] != null && this.mRewardDef["packSku"] != "" ? this.mRewardDef["packSku"] : "";
            }
         }
         return _loc1_;
      }
      
      private function getRewardBG() : String
      {
         return Boolean(this.mRewardDef) && Boolean(this.mRewardDef.hasOwnProperty("bg")) && this.mRewardDef["bg"] != null ? this.mRewardDef["bg"] : "";
      }
      
      private function createFG() : void
      {
         var _loc3_:String = null;
         var _loc4_:PackDef = null;
         var _loc1_:String = "";
         var _loc2_:int = this.getRewardType();
         switch(_loc2_)
         {
            case 0:
               _loc1_ = this.getRewardBG();
               break;
            case 1:
               _loc3_ = this.getRewardSku();
               if(this.mPackAnim == null)
               {
                  _loc4_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc3_));
                  if(_loc4_)
                  {
                     this.mPackAnim = new PackAnimation(_loc4_.getAnimBG());
                     this.mPackAnim.touchable = false;
                     this.mPackAnim.scaleX = 0.6;
                     this.mPackAnim.scaleY = 0.6;
                     this.mPackAnim.x = this.mBG.x + (this.mBG.width - this.mPackAnim.width) / 2 + this.mPackAnim.width / 2;
                     this.mPackAnim.y = this.mBG.y + (this.mBG.height - this.mPackAnim.height) / 2 + this.mPackAnim.height / 2;
                     addChild(this.mPackAnim);
                  }
               }
               break;
            case 3:
               _loc1_ = "large_gold_reward";
         }
         if(_loc1_ != "")
         {
            if(this.mFG == null)
            {
               this.mFG = new FSImage(Root.assets.getTexture(_loc1_));
               this.mFG.touchable = false;
               this.mFG.x = (this.mBG.width - this.mFG.width) / 2;
               this.mFG.y = (this.mBG.height - this.mFG.height) / 2.75;
               addChild(this.mFG);
            }
         }
      }
      
      private function createName() : void
      {
         var _loc1_:String = "x" + this.mAmount;
         if(this.mNameTextfield == null)
         {
            this.mNameTextfield = new FSTextfield(this.mBG.width * 0.8,this.mBG.height / 3.25,_loc1_,16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
            this.mNameTextfield.touchable = false;
            this.mNameTextfield.x = (this.mBG.width - this.mNameTextfield.width) / 2;
            this.mNameTextfield.y = this.mBG.height - this.mNameTextfield.height;
            addChild(this.mNameTextfield);
         }
      }
      
      private function createGoldTextfield() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this.getRewardType() == 3)
         {
            _loc1_ = Boolean(this.mRewardDef) && this.mRewardDef.hasOwnProperty("gold") ? int(this.mRewardDef["gold"]) : 0;
            _loc2_ = _loc1_.toString();
            if(this.mGoldTextfield == null)
            {
               this.mGoldTextfield = new FSTextfield(this.mBG.width * 0.8,this.mBG.height / 3.25,_loc2_,16777215);
               this.mGoldTextfield.touchable = false;
               this.mGoldTextfield.x = (this.mBG.width - this.mGoldTextfield.width) / 2;
               this.mGoldTextfield.y = this.mBG.height / 2 - this.mGoldTextfield.height / 2;
               addChild(this.mGoldTextfield);
            }
         }
      }
      
      private function createIcon() : void
      {
         var _loc1_:String = "";
         var _loc2_:String = "";
         var _loc3_:int = int(ServerConnection.smServerReferralsDefs[this.mType]["conditionLevel"]);
         var _loc4_:int = int(ServerConnection.smServerReferralsDefs[this.mType]["conditionMatchesPlayed"]);
         switch(this.mType)
         {
            case PopupReferral.REFERRAL_TYPE_RECRUIT:
               _loc1_ = "recruit_icon";
               _loc2_ = TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_INFO_TYPE_0",true),[this.mAmount,_loc3_]);
               break;
            case PopupReferral.REFERRAL_TYPE_PLAY_PVP:
               _loc1_ = "recruit_pvp_icon";
               _loc2_ = TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_INFO_TYPE_1",true),[this.mAmount,_loc4_]);
               break;
            case PopupReferral.REFERRAL_TYPE_PLAY_RAIDS:
               _loc1_ = "recruit_raid_icon";
               _loc2_ = TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_INFO_TYPE_2",true),[this.mAmount]);
         }
         if(this.mLeftIcon == null)
         {
            this.mLeftIcon = new FSImage(Root.assets.getTexture(_loc1_));
            this.mLeftIcon.touchable = true;
            this.mLeftIcon.setTooltipText(_loc2_);
            this.mLeftIcon.addEventListener(TouchEvent.TOUCH,this.onIconTouch);
         }
         this.mLeftIcon.x = -this.mLeftIcon.width / 3;
         this.mLeftIcon.y = this.mBG.height - this.mLeftIcon.height * 0.9;
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
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mFG)
         {
            this.mFG.removeFromParent(true);
            this.mFG = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent(true);
            this.mNameTextfield = null;
         }
         if(this.mGoldTextfield)
         {
            this.mGoldTextfield.removeFromParent(true);
            this.mGoldTextfield = null;
         }
         if(this.mPackAnim)
         {
            this.mPackAnim.removeFromParent(true);
            this.mPackAnim = null;
         }
         if(this.mLeftIcon)
         {
            this.mLeftIcon.removeFromParent(true);
            this.mLeftIcon = null;
         }
         this.mHoverHelperPoint = null;
         this.mRewardDef = null;
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG = null;
         }
         if(this.mFG)
         {
            this.mFG.removeFromParent();
            this.mFG = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent();
            this.mNameTextfield = null;
         }
         if(this.mGoldTextfield)
         {
            this.mGoldTextfield.removeFromParent();
            this.mGoldTextfield = null;
         }
         if(this.mPackAnim)
         {
            this.mPackAnim.removeFromParent();
            this.mPackAnim = null;
         }
         if(this.mLeftIcon)
         {
            this.mLeftIcon.removeFromParent();
            this.mLeftIcon = null;
         }
         this.mHoverHelperPoint = null;
         this.mRewardDef = null;
      }
   }
}

