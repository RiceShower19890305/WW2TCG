package com.fs.tcgengine.view.components.map
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.ComicMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.rules.ComicStripDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import starling.core.Starling;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   
   public class ComicStrip extends Component
   {
      
      private const FX_ROTATE:String = "rotate";
      
      private var mComicStripDef:ComicStripDef;
      
      private var mBG:FSImage;
      
      private var mTextfield:FSTextfield;
      
      private var mIsActive:Boolean = false;
      
      private var mFXImage:FSImage;
      
      public function ComicStrip()
      {
         super();
      }
      
      public function init(param1:ComicStripDef) : void
      {
         this.mComicStripDef = param1;
         this.setResourcesToLoad();
         this.mIsActive = Boolean(this.mComicStripDef) && this.mComicStripDef.getIndex() == 1;
      }
      
      private function setResourcesToLoad() : void
      {
         var _loc1_:Screen = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this.mComicStripDef)
         {
            _loc1_ = InstanceMng.getCurrentScreen();
            _loc2_ = this.mComicStripDef.getFX();
            if(_loc2_ != "" && _loc2_ != null && Boolean(_loc1_))
            {
               InstanceMng.getResourcesMng().addResourceToLoad("comic/" + this.mComicStripDef.getFX(),FSResourceMng.TYPE_TEXTURE_PNG);
            }
            _loc3_ = this.mComicStripDef.getSound();
            if(_loc3_ != null && _loc3_ != "" && Boolean(_loc1_))
            {
               InstanceMng.getResourcesMng().addResourceToLoad(_loc3_,FSResourceMng.TYPE_AUDIO);
            }
         }
      }
      
      public function show() : void
      {
         this.createUI();
         addEventListener(TouchEvent.TOUCH,this.onTouch);
         var _loc1_:Component = InstanceMng.getCurrentScreen() ? InstanceMng.getCurrentScreen().getComicContainer() : null;
         if(this.mComicStripDef)
         {
            alpha = 0.001;
            _loc1_.addChild(this);
         }
      }
      
      public function refreshPosition() : void
      {
         var _loc7_:Boolean = false;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = this.mComicStripDef ? this.mComicStripDef.getFXTransition() : "";
         if(_loc3_ != "")
         {
            switch(_loc3_)
            {
               case this.FX_ROTATE:
                  pivotX = width / 2;
                  pivotY = height / 2;
                  _loc1_ = width / 2;
                  _loc2_ = height / 2;
            }
         }
         var _loc4_:Component = InstanceMng.getCurrentScreen() ? InstanceMng.getCurrentScreen().getComicContainer() : null;
         var _loc5_:int = _loc4_.width;
         var _loc6_:int = _loc4_.height;
         if(this.mComicStripDef)
         {
            _loc7_ = this.mComicStripDef.getIsBG();
            x = _loc7_ && Boolean(this.mBG) ? 0 : _loc5_ * (this.mComicStripDef.getPosX() / 100) + _loc1_;
            y = _loc7_ && Boolean(this.mBG) ? 0 : _loc6_ * (this.mComicStripDef.getPosY() / 100) + _loc2_;
         }
      }
      
      public function activate() : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         FSDebug.debugTrace("Activating comic strip: " + this.mComicStripDef.getSku());
         var _loc1_:Component = InstanceMng.getCurrentScreen().getComicContainer();
         if(_loc1_ != null && _loc1_.alpha == 0.001)
         {
            _loc1_.alpha = 0.999;
         }
         this.setActive(true);
         if(this.mComicStripDef)
         {
            if(!this.mComicStripDef.getIsBG())
            {
               _loc2_ = this.mComicStripDef.getFX();
               _loc3_ = _loc2_ == "" || _loc2_ == null ? 1 : 0;
               _loc4_ = this.getComicStripDef() ? this.getComicStripDef().getZoomAmount() : 1;
               TweenMax.delayedCall(_loc3_,SpecialFX.createComicStripZoomTransition,[this,_loc1_,_loc4_,0.5,1,this.onComicZoomedIn]);
               if(parent != null)
               {
                  parent.addChild(this);
               }
            }
            else
            {
               _loc5_ = this.mComicStripDef ? this.mComicStripDef.getStartTime() : 0;
               TweenMax.delayedCall(_loc5_,SpecialFX.tweenToAlpha,[this,0.999,0.5,0]);
               TweenMax.delayedCall(_loc5_,this.onComicZoomedIn);
            }
         }
      }
      
      public function onComicZoomedIn() : void
      {
         var _loc1_:Component = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:ComicMng = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Texture = null;
         var _loc9_:Number = NaN;
         _loc1_ = InstanceMng.getCurrentScreen() ? InstanceMng.getCurrentScreen().getComicContainer() : null;
         if(this.mComicStripDef)
         {
            _loc2_ = this.mComicStripDef.getSound();
            _loc3_ = _loc2_ != "" && _loc2_ != null ? _loc2_.split("/")[1] : "";
            if(_loc3_ != "")
            {
               Utils.playSound(_loc3_,SoundManager.TYPE_SFX);
            }
            if(this.mComicStripDef.getIsBG())
            {
               _loc5_ = this.mComicStripDef.getFX();
               if(_loc5_ != null && _loc5_ != "")
               {
                  _loc6_ = 0;
                  _loc7_ = Starling.current.stage.stageWidth / 4;
                  _loc6_ = 0;
                  while(_loc6_ < 3)
                  {
                     _loc8_ = Root.assets.getTexture(_loc5_);
                     if(_loc8_)
                     {
                        this.mFXImage = new FSImage(_loc8_);
                        this.mFXImage.x = Utils.randomInt(-_loc7_,_loc7_);
                        this.mFXImage.alpha = 0.001;
                        this.mFXImage.touchable = false;
                        if(_loc1_)
                        {
                           _loc1_.addChild(this.mFXImage);
                        }
                        TweenMax.delayedCall(_loc6_ + Utils.randomNumber(0,1),this.onFXImageAdded,[this.mFXImage]);
                     }
                     _loc6_++;
                  }
               }
            }
            else
            {
               _loc5_ = this.mComicStripDef ? this.mComicStripDef.getFX() : "";
               if(_loc5_ != null && _loc5_ != "")
               {
                  _loc4_ = InstanceMng.getComicsMng();
                  if(_loc4_)
                  {
                     TweenMax.delayedCall(this.mComicStripDef.getFadeTime(),this.comicsMngActivateNextStrip);
                  }
                  return;
               }
            }
            _loc4_ = InstanceMng.getComicsMng();
            if((Boolean(_loc4_)) && Boolean(this.mComicStripDef))
            {
               _loc9_ = this.mComicStripDef.getFadeTime();
               TweenMax.delayedCall(_loc9_,SpecialFX.createComicStripZoomTransition,[this,_loc1_,1,0.5,1,this.comicsMngActivateNextStrip]);
            }
         }
      }
      
      private function comicsMngActivateNextStrip() : void
      {
         if(InstanceMng.getComicsMng())
         {
            InstanceMng.getComicsMng().activateNextStrip();
         }
      }
      
      private function onFXImageAdded(param1:FSImage) : void
      {
         if(param1 != null)
         {
            param1.alpha = 0.999;
            SpecialFX.tweenToAlpha(param1,0.001,3,0,this.onFXImageTweenedToAlpha,[param1]);
         }
      }
      
      private function onFXImageTweenedToAlpha(param1:FSImage) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      public function reset() : void
      {
         var _loc1_:Component = null;
         if(this.mIsActive)
         {
            alpha = 0.999;
            if(this.mFXImage)
            {
               this.mFXImage.removeFromParent();
               this.mFXImage.destroy();
               this.mFXImage = null;
            }
            TweenMax.killDelayedCallsTo(SpecialFX.createComicStripZoomTransition);
            TweenMax.killDelayedCallsTo(this.onComicZoomedIn);
            TweenMax.killDelayedCallsTo(SpecialFX.tweenToAlpha);
            TweenMax.killDelayedCallsTo(this.onComicZoomedIn);
            _loc1_ = InstanceMng.getCurrentScreen().getComicContainer();
            SpecialFX.createComicStripZoomTransition(this,_loc1_,1,0,alpha);
            this.setActive(false);
         }
      }
      
      public function fade(param1:Function) : void
      {
         SpecialFX.tweenToAlpha(this,0.001,1,0,this.onComicFaded,[param1]);
         var _loc2_:String = Boolean(this.mComicStripDef) && Boolean(this.mComicStripDef.getSound() != "") && this.mComicStripDef.getSound() != null ? this.mComicStripDef.getSound().split("/")[1] : "";
         if(_loc2_ != "")
         {
            Utils.stopSound(_loc2_);
         }
         if(param1 != null)
         {
            TweenMax.delayedCall(1,param1);
         }
      }
      
      private function onComicFaded(param1:Function) : void
      {
         removeFromParent(false);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(Boolean(InstanceMng.getComicsMng()) && Boolean(InstanceMng.getComicsMng().isComicSkippable()) && Boolean(_loc2_))
         {
            this.reset();
            InstanceMng.getComicsMng().activateNextStrip(true);
         }
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createTextfield();
      }
      
      private function createBG() : void
      {
         if(this.mBG == null && Boolean(this.mComicStripDef))
         {
            this.mBG = new FSImage(Root.assets.getTexture(this.mComicStripDef.getBGImageName()));
            addChild(this.mBG);
         }
      }
      
      private function createTextfield() : void
      {
         if(Boolean(this.mTextfield == null && this.mComicStripDef) && Boolean(this.mComicStripDef.getHasText()) && Boolean(this.mBG))
         {
            this.mTextfield = new FSTextfield(this.mBG.width * (this.mComicStripDef.getTextWidth() / 100),this.mBG.height * (this.mComicStripDef.getTextHeight() / 100),this.mComicStripDef.getDesc().toUpperCase());
            this.mTextfield.fontName = FSResourceMng.getFontByType(Config.getConfig().getTutorialPopupFontName());
            this.mTextfield.format.color = Config.getConfig().getComicTextColor();
            this.mTextfield.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
            this.mTextfield.x = this.mBG.width * (this.mComicStripDef.getTextPosX() / 100);
            this.mTextfield.y = this.mBG.height * (this.mComicStripDef.getTextPosY() / 100);
            addChild(this.mTextfield);
         }
      }
      
      public function getIndex() : int
      {
         var _loc1_:int = -1;
         if(this.mComicStripDef != null)
         {
            _loc1_ = this.mComicStripDef.getIndex();
         }
         return _loc1_;
      }
      
      public function getShowOrder() : int
      {
         var _loc1_:int = -1;
         if(this.mComicStripDef != null)
         {
            _loc1_ = this.mComicStripDef.getShowOrder();
         }
         return _loc1_;
      }
      
      public function getComicStripDef() : ComicStripDef
      {
         return this.mComicStripDef;
      }
      
      public function setActive(param1:Boolean) : void
      {
         this.mIsActive = param1;
      }
      
      public function getBG() : FSImage
      {
         return this.mBG;
      }
      
      override public function dispose() : void
      {
         this.mComicStripDef = null;
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         if(this.mFXImage)
         {
            this.mFXImage.removeFromParent(true);
            this.mFXImage = null;
         }
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
   }
}

