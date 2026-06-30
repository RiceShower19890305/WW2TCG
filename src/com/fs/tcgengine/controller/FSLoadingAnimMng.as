package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Event;
   import starling.utils.Align;
   import starling.utils.deg2rad;
   
   public class FSLoadingAnimMng
   {
      
      private static const SPINNER_HPOS:String = Config.getConfig().getGameLoadingSpinnerHPos();
      
      private static const SPINNER_VPOS:String = Config.getConfig().getGameLoadingSpinnerVPos();
      
      private static const TIP_HPOS:String = Config.getConfig().getGameLoadingTipHPos();
      
      private static const TIP_VPOS:String = Config.getConfig().getGameLoadingTipVPos();
      
      private static const LOADING_TEXT_SHOW:Boolean = Config.getConfig().getGameLoadingTextShow();
      
      private var mLoadingScreenImage:FSImage;
      
      protected var mLoadingProgressImage:FSImage;
      
      private var mLoadingTextfield:FSTextfield;
      
      private var mLoadingScreenTipsBG:FSImage;
      
      private var mLoadingScreenTipsTextfield:FSTextfield;
      
      public function FSLoadingAnimMng(param1:FSImage)
      {
         super();
         this.mLoadingScreenImage = param1;
         this.createUI();
         this.setRandomTip();
      }
      
      public function setRandomTip() : void
      {
         var _loc1_:Vector.<String> = new Vector.<String>();
         var _loc2_:Boolean = false;
         var _loc3_:String = "";
         var _loc4_:int = 1;
         while(_loc2_ == false)
         {
            _loc3_ = TextManager.getText("TID_TIP_" + _loc4_,true);
            if(_loc3_ == null || _loc3_ == "" || _loc3_.indexOf("[") == 0)
            {
               _loc2_ = true;
            }
            else if(!(InstanceMng.getApplication().isKongregateVersion() && _loc3_.indexOf("Facebook") != -1))
            {
               _loc1_.push(_loc3_);
            }
            _loc4_++;
         }
         if(_loc1_ != null && _loc1_.length > 0)
         {
            if(this.mLoadingScreenTipsTextfield)
            {
               this.mLoadingScreenTipsTextfield.text = _loc1_[Utils.randomInt(0,_loc1_.length - 1)];
               FSResourceMng.addToStage(this.mLoadingScreenTipsTextfield,FSResourceMng.LAYER_GAME);
            }
         }
         else
         {
            this.mLoadingScreenTipsBG.removeFromParent();
         }
      }
      
      private function createUI() : void
      {
         this.createSpinner();
         this.createProgressNumberTextField();
         this.createTipsBG();
         this.createTipsTextField();
      }
      
      private function createTipsBG() : void
      {
         if(this.mLoadingScreenTipsBG == null)
         {
            this.mLoadingScreenTipsBG = new FSImage(Root.assets.getTexture("tip_panel"));
            this.mLoadingScreenTipsBG.alignPivot();
            this.mLoadingScreenTipsBG.x = this.getLoadingTipBGHorizontalPosition(this.mLoadingScreenImage);
            this.mLoadingScreenTipsBG.y = this.getLoadingTipBGVerticalPosition(this.mLoadingScreenImage);
         }
         FSResourceMng.addToStage(this.mLoadingScreenTipsBG,FSResourceMng.LAYER_GAME);
      }
      
      private function createTipsTextField() : void
      {
         var _loc1_:Number = NaN;
         if(this.mLoadingScreenTipsTextfield == null)
         {
            _loc1_ = !Utils.isDesktop() ? FSResourceMng.FONT_STD_SUBTITLE_SIZE : FSResourceMng.FONT_STD_SMALL_SIZE;
            this.mLoadingScreenTipsTextfield = new FSTextfield(this.mLoadingScreenImage.width * 0.7,FSResourceMng.FONT_STD_SUBTITLE_SIZE * 2.75,"",16777215,_loc1_);
            this.mLoadingScreenTipsTextfield.alignPivot();
            this.mLoadingScreenTipsTextfield.x = this.mLoadingScreenTipsBG.x;
            this.mLoadingScreenTipsTextfield.y = this.mLoadingScreenTipsBG.y;
         }
      }
      
      private function createProgressNumberTextField() : void
      {
         var _loc1_:int = 0;
         if(this.mLoadingTextfield == null)
         {
            _loc1_ = Config.getConfig().gameLoadingFullSize() ? int(this.mLoadingProgressImage.height) : int(this.mLoadingProgressImage.height * 0.2);
            this.mLoadingTextfield = new FSTextfield(this.mLoadingProgressImage.width,_loc1_);
            if(Utils.isDesktop())
            {
               this.mLoadingTextfield.fontSize = 18;
            }
            this.mLoadingTextfield.x = this.mLoadingProgressImage.x - this.mLoadingProgressImage.width / 2;
            this.mLoadingTextfield.y = Config.getConfig().gameLoadingFullSize() ? this.mLoadingProgressImage.y - this.mLoadingProgressImage.height / 2 : this.mLoadingProgressImage.y + this.mLoadingProgressImage.height / 3;
         }
         this.mLoadingTextfield.visible = LOADING_TEXT_SHOW;
         FSResourceMng.addToStage(this.mLoadingTextfield,FSResourceMng.LAYER_GAME);
      }
      
      private function createSpinner() : void
      {
         if(this.mLoadingProgressImage == null)
         {
            this.mLoadingProgressImage = new FSImage(Root.assets.getTexture("loading_spinner"));
            this.mLoadingProgressImage.alignPivot();
            if(this.mLoadingScreenImage)
            {
               this.mLoadingProgressImage.x = this.getLoadingSpinnerHorizontalPosition(this.mLoadingScreenImage);
               this.mLoadingProgressImage.y = this.getLoadingSpinnerVerticalPosition(this.mLoadingScreenImage);
            }
         }
         this.mLoadingProgressImage.visible = true;
         FSResourceMng.addToStage(this.mLoadingProgressImage,FSResourceMng.LAYER_GAME);
      }
      
      public function setLoadingText(param1:String) : void
      {
         if(this.mLoadingTextfield)
         {
            this.mLoadingTextfield.text = param1;
         }
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         if(this.mLoadingProgressImage)
         {
            this.mLoadingProgressImage.rotation += deg2rad(1);
         }
      }
      
      private function getLoadingSpinnerHorizontalPosition(param1:FSImage) : int
      {
         var _loc2_:int = 0;
         switch(SPINNER_HPOS)
         {
            case Align.LEFT:
               _loc2_ = param1.width * 0.1;
               break;
            case Align.CENTER:
               _loc2_ = param1.width / 2;
               break;
            case Align.RIGHT:
               _loc2_ = param1.width * 0.92;
               break;
            default:
               _loc2_ = param1.width / 2;
         }
         return _loc2_;
      }
      
      private function getLoadingSpinnerVerticalPosition(param1:FSImage) : int
      {
         var _loc2_:int = 0;
         switch(SPINNER_VPOS)
         {
            case Align.TOP:
               _loc2_ = param1.height * 0.1;
               break;
            case Align.CENTER:
               _loc2_ = param1.height / 2;
               break;
            case Align.BOTTOM:
               _loc2_ = param1.height * 0.89;
               break;
            default:
               _loc2_ = param1.height / 2;
         }
         return _loc2_;
      }
      
      private function getLoadingTipBGHorizontalPosition(param1:FSImage) : int
      {
         var _loc2_:int = 0;
         switch(TIP_HPOS)
         {
            case Align.LEFT:
               _loc2_ = param1.height * 0.1;
               break;
            case Align.CENTER:
               _loc2_ = param1.width / 2;
               break;
            case Align.RIGHT:
               _loc2_ = param1.height * 0.89;
               break;
            default:
               _loc2_ = param1.width / 2;
         }
         return _loc2_;
      }
      
      private function getLoadingTipBGVerticalPosition(param1:FSImage) : int
      {
         var _loc2_:int = 0;
         switch(TIP_VPOS)
         {
            case Align.TOP:
               _loc2_ = param1.height * 0.15;
               break;
            case Align.CENTER:
               _loc2_ = param1.height / 2;
               break;
            case Align.BOTTOM:
               _loc2_ = param1.height * 0.87;
               break;
            default:
               _loc2_ = param1.height * 0.9;
         }
         return _loc2_;
      }
      
      public function dispose() : void
      {
         if(this.mLoadingProgressImage)
         {
            this.mLoadingProgressImage.removeFromParent();
            this.mLoadingProgressImage = null;
         }
         if(this.mLoadingTextfield)
         {
            this.mLoadingTextfield.removeFromParent();
            this.mLoadingTextfield = null;
         }
         if(this.mLoadingScreenTipsBG)
         {
            this.mLoadingScreenTipsBG.removeFromParent();
            this.mLoadingScreenTipsBG = null;
         }
         if(this.mLoadingScreenTipsTextfield)
         {
            this.mLoadingScreenTipsTextfield.removeFromParent();
            this.mLoadingScreenTipsTextfield = null;
         }
      }
   }
}

