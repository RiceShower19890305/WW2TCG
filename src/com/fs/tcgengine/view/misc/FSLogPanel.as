package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.greensock.TweenMax;
   import starling.core.Starling;
   import starling.utils.Align;
   
   public class FSLogPanel extends Component implements FSModelUnloadableInterface
   {
      
      private var mBG:CustomComponent;
      
      private var mLogTextfield:FSTextfield;
      
      private var mLogText:String;
      
      private var mShown:Boolean;
      
      public function FSLogPanel()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         touchable = false;
         this.createImage();
         this.createLog();
         pivotX = width / 2;
         pivotY = height / 2;
      }
      
      private function createImage() : void
      {
         if(this.mBG == null)
         {
            this.mBG = Utils.createCustomBox("log_banner",1350);
         }
         addChild(this.mBG);
      }
      
      protected function createLog() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.mLogTextfield == null)
         {
            _loc1_ = Config.getConfig().getLogPanelExtraFontSize();
            _loc2_ = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE + _loc1_;
            this.mLogTextfield = new FSTextfield(this.mBG.width * 0.9,this.mBG.height * 0.85);
            this.mLogTextfield.fontName = FSResourceMng.getFontByType();
            this.mLogTextfield.x = (this.mBG.width - this.mLogTextfield.width) / 2;
            this.mLogTextfield.y = (this.mBG.height - this.mLogTextfield.height) / 2;
            this.mLogTextfield.fontSize = _loc2_;
            this.mLogTextfield.touchable = false;
         }
         if(!contains(this.mLogTextfield))
         {
            addChild(this.mLogTextfield);
         }
      }
      
      public function setLogText(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Boolean = true, param5:Boolean = true, param6:Number = 0.999, param7:String = "center", param8:String = "top", param9:* = null, param10:Boolean = false, param11:Number = 3) : void
      {
         var _loc12_:Function = null;
         var _loc13_:Screen = null;
         var _loc14_:int = 0;
         var _loc15_:String = null;
         TweenMax.killTweensOf(this);
         if(this.mLogTextfield == null)
         {
            return;
         }
         this.mLogTextfield.fontName = FSResourceMng.getFontByType();
         if(this.mBG)
         {
            TweenMax.killTweensOf(this.mBG);
         }
         scaleX = 1;
         scaleY = 1;
         InstanceMng.getLogPanel().setAtDefaultPos();
         if(this.mLogTextfield != null && param1 != "" && param1 != null)
         {
            if(param5)
            {
               _loc15_ = !param2 ? Constants.SOUND_HELP : Constants.SOUND_HELP_ERROR;
               Utils.playSound(_loc15_,SoundManager.TYPE_SFX);
            }
            this.mBG.alpha = param6;
            this.removeLog();
            this.mShown = true;
            alpha = 0.999;
            this.mLogText = param1;
            _loc12_ = null;
            if(!param3)
            {
               _loc12_ = this.fadeMessage;
            }
            else
            {
               TweenMax.killDelayedCallsTo(SpecialFX.appendChar);
               TweenMax.killDelayedCallsTo(SpecialFX.typeWriterEffect);
               TweenMax.killTweensOf(this);
            }
            if(param4 && !param3 && Boolean(this.mLogText))
            {
               SpecialFX.typeWriterEffect(this.mLogTextfield,this.mLogText,0.03,_loc12_);
            }
            else if(param1)
            {
               this.mLogTextfield.text = this.mLogText;
               if(!param3 && _loc12_ != null)
               {
                  TweenMax.delayedCall(param11,_loc12_,[param11,param11 / 2]);
               }
            }
            _loc13_ = InstanceMng.getCurrentScreen();
            if(param9)
            {
               _loc14_ = int(param9.width);
            }
            else
            {
               _loc14_ = Boolean(_loc13_) && Boolean(_loc13_ is FSBattleScreen) && param10 ? FSBattleScreen(_loc13_).getBFWidth() : Starling.current.stage.stageWidth;
            }
            switch(param7)
            {
               case Align.LEFT:
                  x = width / 2;
                  break;
               case Align.CENTER:
                  x = _loc14_ / 2;
                  break;
               case Align.RIGHT:
                  x = _loc14_ - width / 2;
            }
            if(param9 != null)
            {
               x += param9 ? param9.x : 0;
               x -= width > _loc14_ ? (width - _loc14_) / 2 : 0;
            }
            if(param10)
            {
               x += _loc13_ is FSBattleScreen ? FSBattleScreen(_loc13_).getBFExtraSpaceX() : 0;
               x -= width > _loc14_ ? (width - _loc14_) / 2 : 0;
            }
            switch(param8)
            {
               case Align.TOP:
                  y = height / 2;
                  break;
               case Align.CENTER:
                  y = Starling.current.stage.stageHeight / 2;
                  break;
               case Align.BOTTOM:
                  y = Starling.current.stage.stageHeight - height / 2;
            }
            if(param9 != null)
            {
               y += param9 ? param9.y : 0;
            }
            FSResourceMng.addToStage(this,FSResourceMng.LAYER_UI);
         }
      }
      
      public function setAtDefaultPos() : void
      {
         x = Starling.current.stage.stageWidth / 2;
         y = height / 2;
      }
      
      public function removeLog() : void
      {
         TweenMax.killTweensOf(this);
         TweenMax.killDelayedCallsTo(this.fadeMessage);
         TweenMax.killDelayedCallsTo(SpecialFX.tweenLogToAlpha);
         alpha = 0.999;
         this.fadeMessage(0,0);
         if(InstanceMng.getCurrentScreen())
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(false,false,Align.RIGHT,Align.CENTER,1,null,this);
         }
      }
      
      private function fadeMessage(param1:Number = 3, param2:Number = 2) : void
      {
         if(param1 == 0)
         {
            alpha = 0.0001;
            this.onMessageFaded();
         }
         else
         {
            TweenMax.delayedCall(param1,SpecialFX.tweenLogToAlpha,[this,0,param2,0,this.onMessageFaded]);
         }
      }
      
      public function getCurrentText() : String
      {
         return this.mLogText;
      }
      
      private function onMessageFaded() : void
      {
         removeFromParent();
         if(this.mLogText)
         {
            this.mLogText = "";
         }
         this.mShown = false;
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG = null;
         }
         if(this.mLogTextfield)
         {
            this.mLogTextfield.removeFromParent(true);
            this.mLogTextfield = null;
         }
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG = null;
         }
         if(this.mLogTextfield)
         {
            this.mLogTextfield.removeFromParent();
            this.mLogTextfield = null;
         }
      }
      
      public function getBG() : Component
      {
         return this.mBG;
      }
      
      public function getTextfield() : FSTextfield
      {
         return this.mLogTextfield;
      }
   }
}

