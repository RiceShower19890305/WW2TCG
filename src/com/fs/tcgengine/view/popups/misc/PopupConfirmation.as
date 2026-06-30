package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.CustomComponent;
   import starling.core.Starling;
   import starling.events.Event;
   
   public class PopupConfirmation extends PopupStandard
   {
      
      private var mOnAcceptFunction:Function;
      
      private var mOnCancelFunction:Function;
      
      public function PopupConfirmation(param1:Boolean = true)
      {
         super(param1);
      }
      
      public function setAcceptFunction(param1:Function) : void
      {
         if(param1 != null)
         {
            this.mOnAcceptFunction = param1;
         }
      }
      
      public function setCancelFunction(param1:Function) : void
      {
         if(param1 != null)
         {
            this.mOnCancelFunction = param1;
         }
         else
         {
            FSDebug.debugTrace("ERROR -> You HAVE to set a non-null function");
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         super.onAccept(param1);
         mOnClosedFunction = this.mOnAcceptFunction;
      }
      
      override public function onClose(param1:Event) : void
      {
         super.onClose(param1);
         mOnClosedFunction = this.mOnCancelFunction;
      }
      
      override protected function performOnOpenDefaultOps(param1:FSCoordinate, param2:Number = 0.6) : void
      {
         super.performOnOpenDefaultOps(param1,0.85);
      }
      
      public function setup(param1:Boolean, param2:String = "", param3:uint = 16777215) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:FSCoordinate = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         if(param1)
         {
            _loc4_ = 1500;
            _loc5_ = Constants.POPUP_LARGE_NAME;
            mBox.scale = Constants.POPUP_SETTINGS_ADV_SCALE_FACTOR;
            CustomComponent(mBox).updateTextures(_loc5_,_loc4_,false);
            _loc6_ = Starling.current.stage.stageWidth;
            _loc7_ = Starling.current.stage.stageHeight;
            setupCloseButton();
            if(Boolean(mAcceptButton) && Boolean(mBox))
            {
               mAcceptButton.upState = mAcceptButton.downState = Root.assets.getTexture(Constants.ACCEPT_BUTTON_UP_NAME);
               Utils.setupButton9Scale(mAcceptButton,8.75,10,6.25,7.5,135,28.5);
               mAcceptButton.x = mBox.width / 2;
               mAcceptButton.y = mBox.height - mAcceptButton.height / 2;
               mAcceptButton.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD);
               mAcceptButton.fontColor = param3;
               if(param2 != "")
               {
                  mAcceptButton.text = param2;
               }
            }
            if(mInfoTextfield)
            {
               _loc9_ = mBox.width * 0.8;
               _loc10_ = mAcceptButton ? mBox.height - mAcceptButton.height * 1.75 : mBox.height / 2;
               mInfoTextfield.width = _loc9_;
               mInfoTextfield.height = _loc10_;
               mInfoTextfield.x = (mBox.width - mInfoTextfield.width) / 2;
            }
            _loc8_ = new FSCoordinate((_loc6_ - width) / 2,(_loc7_ - height) / 2);
            x = _loc8_.getX();
            y = _loc8_.getY();
         }
      }
   }
}

