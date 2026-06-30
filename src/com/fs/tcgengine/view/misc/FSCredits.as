package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.KickstarterBackerDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.text.TextFieldAutoSize;
   import starling.utils.Align;
   
   public class FSCredits extends Component
   {
      
      private var mBGQuad:Quad;
      
      private var mCreditsScrollText:FSTextfield;
      
      private var mVersionTextfield:FSTextfield;
      
      protected var mGameName:String;
      
      protected var mGameOfficialWebsite:String;
      
      private var mLogoGene:FSImage;
      
      public function FSCredits()
      {
         super();
         this.mGameName = Config.getConfig().gameCreditsGameName();
         this.mGameOfficialWebsite = Config.getConfig().gameCreditsGameURL();
         this.createBG();
         this.setResourcesToLoad();
         this.createVersionTextfield();
         this.addGeneralitatLogo();
      }
      
      protected function createVersionTextfield() : void
      {
         var _loc1_:int = 0;
         if(this.mVersionTextfield == null)
         {
            _loc1_ = FSResourceMng.isOriental() ? int(InstanceMng.getApplication().getDefaultStageWidth() / 3) : 1;
            this.mVersionTextfield = new FSTextfield(_loc1_,30,this.mGameName + " v" + Utils.getAppVersion(),16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
            this.mVersionTextfield.format.horizontalAlign = Align.RIGHT;
            this.mVersionTextfield.autoSize = FSResourceMng.isOriental() ? TextFieldAutoSize.NONE : TextFieldAutoSize.BOTH_DIRECTIONS;
            this.mVersionTextfield.autoScale = false;
            this.mVersionTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mVersionTextfield.x = Starling.current.stage.stageWidth - this.mVersionTextfield.width;
            this.mVersionTextfield.y = Starling.current.stage.stageHeight - this.mVersionTextfield.height;
            addChild(this.mVersionTextfield);
         }
      }
      
      protected function setResourcesToLoad() : void
      {
         this.createCreditsScroll();
      }
      
      private function createBG() : void
      {
         if(this.mBGQuad == null)
         {
            this.mBGQuad = new Quad(Starling.current.stage.stageWidth,Starling.current.stage.stageHeight,0);
            this.mBGQuad.alpha = 0.001;
            addChild(this.mBGQuad);
            this.mBGQuad.addEventListener(TouchEvent.TOUCH,this.onTouch);
         }
         SpecialFX.tweenToAlpha(this.mBGQuad,0.999,0.5,0);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this.mBGQuad,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(this.mCreditsScrollText)
            {
               this.mCreditsScrollText.visible = false;
            }
            if(this.mVersionTextfield)
            {
               this.mVersionTextfield.visible = false;
            }
            TweenMax.killTweensOf(SpecialFX.createTransition);
            this.onExitCredits();
         }
      }
      
      private function addGeneralitatLogo() : void
      {
         if(Root.assets.getTexture("logo_generalitat") != null)
         {
            if(this.mLogoGene == null)
            {
               this.mLogoGene = new FSImage(Root.assets.getTexture("logo_generalitat"));
               addChild(this.mLogoGene);
            }
         }
      }
      
      private function createCreditsScroll() : void
      {
         var _loc1_:int = 0;
         var _loc4_:String = null;
         _loc1_ = Config.getConfig().gameCreditsHasKickstarter() ? 50 : 20;
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         if(this.mCreditsScrollText == null)
         {
            _loc4_ = TextManager.getText("TID_CREDITS",true) + "\n\n\n";
            _loc4_ = _loc4_ + this.getDevelopers();
            _loc4_ = _loc4_ + this.getSpecialThanksPeople();
            if(Config.getConfig().gameCreditsHasKickstarter())
            {
               _loc4_ += this.addKickstarter();
            }
            _loc4_ += this.mGameName + " (c) v" + Utils.getAppVersion() + "\n";
            _loc4_ = _loc4_ + ("Copyright © 2021 FrozenShard S.L. Barcelona, SPAIN - " + TextManager.getText("TID_CREDITS_RESERVED",true) + "\n");
            _loc4_ = _loc4_ + (this.mGameOfficialWebsite + "\n");
            this.mCreditsScrollText = new FSTextfield(Starling.current.stage.stageWidth * 0.75,Starling.current.stage.stageHeight * 2,_loc4_,16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE,true);
            this.mCreditsScrollText.autoScale = false;
            this.mCreditsScrollText.autoSize = FSResourceMng.isOriental() ? TextFieldAutoSize.NONE : TextFieldAutoSize.VERTICAL;
            this.mCreditsScrollText.touchable = false;
         }
         this.mCreditsScrollText.visible = true;
         this.mCreditsScrollText.x = (Starling.current.stage.stageWidth - this.mCreditsScrollText.width) / 2;
         this.mCreditsScrollText.y = Starling.current.stage.stageHeight;
         addChild(this.mCreditsScrollText);
         var _loc3_:FSCoordinate = new FSCoordinate(this.mCreditsScrollText.x,-this.mCreditsScrollText.height);
         SpecialFX.createTransition(this.mCreditsScrollText,_loc3_,_loc1_,0,this.onExitCredits,null,Linear.easeNone);
      }
      
      protected function getDevelopers() : String
      {
         var _loc1_:String = TextManager.getText("TID_CREDITS_TEAM",true) + "\n\n";
         return _loc1_ + (Config.getConfig().gameCreditsDevs() + "\n\n\n");
      }
      
      protected function getSpecialThanksPeople() : String
      {
         var _loc1_:String = TextManager.getText("TID_CREDITS_THANKS",true) + "\n\n";
         return _loc1_ + (Config.getConfig().gameCreditsThanks() + "\n\n\n");
      }
      
      protected function addKickstarter() : String
      {
         var _loc1_:String = "Kickstarter Official Sponsors:\n\n";
         _loc1_ += this.getKickstarterBackersList("sponsor");
         _loc1_ += "\n\n\n";
         _loc1_ += "Kickstarter Official Backers:\n\n";
         _loc1_ += this.getKickstarterBackersList("backer");
         return _loc1_ + "\n\n\n";
      }
      
      private function getKickstarterBackersList(param1:String) : String
      {
         var _loc4_:KickstarterBackerDef = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc2_:String = "";
         var _loc3_:Array = InstanceMng.getKickstarterBackersDefMng().getBackersListSortedBySurname(param1);
         if(_loc3_ != null)
         {
            _loc6_ = "";
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc4_ = KickstarterBackerDef(InstanceMng.getKickstarterBackersDefMng().getDefBySku(_loc3_[_loc5_].split(":")[0]));
               _loc6_ = _loc5_ == _loc3_.length - 1 ? "" : ", ";
               _loc2_ += _loc4_.getKickName() + " " + _loc4_.getKickSurname() + _loc6_;
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      private function onExitCredits() : void
      {
         InstanceMng.getCurrentScreen().getOptionsPanel().setCreditsBeingShown(false);
         if(this.mBGQuad)
         {
            this.mBGQuad.removeEventListener(TouchEvent.TOUCH,this.onTouch);
         }
         TweenMax.killDelayedCallsTo(this.onExitCredits);
         TweenMax.killTweensOf(this);
         if(this.mCreditsScrollText)
         {
            SpecialFX.tweenToAlpha(this.mCreditsScrollText,0.001,0.1,0);
         }
         if(this.mBGQuad)
         {
            SpecialFX.tweenToAlpha(this.mBGQuad,0.001,2,0,this.unload);
         }
         if(this.mVersionTextfield)
         {
            SpecialFX.tweenToAlpha(this.mVersionTextfield,0.001,0.1,0);
         }
         if(this.mLogoGene)
         {
            SpecialFX.tweenToAlpha(this.mLogoGene,0.001,0.1,0);
         }
      }
      
      private function unload() : void
      {
         FSDebug.debugTrace("Unloading Credits");
         if(this.mBGQuad)
         {
            this.mBGQuad.removeFromParent(true);
            this.mBGQuad = null;
         }
         if(this.mCreditsScrollText)
         {
            this.mCreditsScrollText.removeFromParent(true);
            this.mCreditsScrollText = null;
         }
         if(this.mVersionTextfield)
         {
            this.mVersionTextfield.removeFromParent(true);
            this.mVersionTextfield = null;
         }
         if(this.mLogoGene)
         {
            this.mLogoGene.removeFromParent();
            this.mLogoGene.destroy();
            this.mLogoGene = null;
         }
         Root.assets.removeXml("kickstarterBackers",true);
      }
      
      override public function dispose() : void
      {
         this.unload();
         super.dispose();
      }
   }
}

