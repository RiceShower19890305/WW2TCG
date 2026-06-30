package com.fs.tcgengine.view.components.misc
{
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import feathers.controls.Callout;
   import feathers.controls.ScrollContainer;
   import feathers.controls.supportClasses.LayoutViewPort;
   import mx.utils.StringUtil;
   import starling.core.Starling;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   import starling.text.TextFieldAutoSize;
   import starling.utils.Align;
   
   public class FSTextfield extends TextField
   {
      
      private var mSkipGlyphsCheck:Boolean = false;
      
      public var mInPool:Boolean = false;
      
      private var mTooltip:Callout;
      
      private var mTooltipText:String;
      
      public function FSTextfield(param1:int, param2:int, param3:String = "", param4:uint = 16777215, param5:Number = -1, param6:Boolean = false)
      {
         super(param1,param2,param3);
         this.setup(param1,param2,param3,param4,param5,param6);
      }
      
      public function setup(param1:int = 0, param2:int = 0, param3:String = "", param4:uint = 16777215, param5:Number = -1, param6:Boolean = false) : void
      {
         touchable = false;
         removeFromParent();
         Utils.resetComponent(this);
         param3 = param3;
         this.mSkipGlyphsCheck = param6;
         param5 = param5 == -1 ? FSResourceMng.FONT_STD_TITLE_SIZE : param5;
         format.setTo(FSResourceMng.getFontByType(),param5,param4,Align.CENTER,Align.CENTER);
         format.bold = false;
         autoScale = true;
         autoSize = TextFieldAutoSize.NONE;
         border = Config.isDebug() && Config.smTextfieldsBorder;
         Utils.refreshTextfieldIfTextHasGlyphs(this,param3,this.fontName);
         width = param1;
         height = param2;
         setRequiresRedraw();
      }
      
      public function set fontName(param1:String) : void
      {
         format.font = param1;
         if(!this.mSkipGlyphsCheck)
         {
            Utils.refreshTextfieldIfTextHasGlyphs(this,text,param1);
         }
      }
      
      public function setSkipGlyphsCheck(param1:Boolean) : void
      {
         this.mSkipGlyphsCheck = param1;
      }
      
      override public function set text(param1:String) : void
      {
         super.text = param1;
         batchable = Boolean(text) && text.length < 15;
         if(!this.mSkipGlyphsCheck)
         {
            Utils.refreshTextfieldIfTextHasGlyphs(this,text,format.font);
         }
      }
      
      public function set fontSize(param1:Number) : void
      {
         format.size = param1;
      }
      
      public function set color(param1:uint) : void
      {
         format.color = param1;
      }
      
      public function get color() : uint
      {
         return format.color;
      }
      
      public function set bold(param1:Boolean) : void
      {
         format.bold = param1;
      }
      
      public function get fontName() : String
      {
         return format.font;
      }
      
      public function get fontSize() : Number
      {
         return format.size;
      }
      
      public function get fontColor() : uint
      {
         return format.color;
      }
      
      public function isInPool() : Boolean
      {
         return this.mInPool;
      }
      
      public function setInPool(param1:Boolean) : void
      {
         this.mInPool = param1;
      }
      
      public function setTooltipText(param1:String) : void
      {
         this.mTooltipText = param1 != null && param1 != "" ? StringUtil.trim(param1) : "";
         if(this.mTooltipText != "" && this.mTooltipText != null)
         {
            addEventListener(TouchEvent.TOUCH,this.onTouch);
         }
         else if(hasEventListener(TouchEvent.TOUCH))
         {
            removeEventListener(TouchEvent.TOUCH,this.onTouch);
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_)
         {
            this.showTooltip();
         }
         else
         {
            this.closeTooltip();
         }
      }
      
      private function showTooltip() : void
      {
         if(this.mTooltip == null && this.mTooltipText != "" && this.mTooltipText != null && stage != null)
         {
            if(parent)
            {
               FSDebug.debugTrace("parent: " + parent);
               if(parent is LayoutViewPort && parent.parent != null)
               {
                  FSDebug.debugTrace("is scrolling? " + ScrollContainer(parent.parent).isScrolling);
               }
            }
            if(parent != null && parent is LayoutViewPort && parent.parent is ScrollContainer && ScrollContainer(parent.parent).isScrolling)
            {
               return;
            }
            this.mTooltip = Callout.show(Utils.getTooltipContent(this.mTooltipText),this,null,false);
            this.mTooltip.closeOnTouchEndedOutside = true;
            this.mTooltip.closeOnTouchBeganOutside = true;
            this.mTooltip.disposeContent = false;
            this.mTooltip.maxWidth = Starling.current.stage.stageWidth / 3;
            this.mTooltip.touchable = false;
            this.mTooltip.alpha = 0.001;
            SpecialFX.tweenToAlpha(this.mTooltip,0.999,0.25,0);
         }
         else if(Utils.isMobile())
         {
            if(Boolean(this.mTooltip) && this.mTooltip.parent == null)
            {
               this.removeTooltip();
               this.showTooltip();
            }
         }
      }
      
      public function closeTooltip() : void
      {
         if(this.mTooltip)
         {
            SpecialFX.tweenToAlpha(this.mTooltip,0.001,0.25,0,this.removeTooltip);
         }
      }
      
      private function removeTooltip() : void
      {
         if(this.mTooltip)
         {
            this.mTooltip.close();
            this.mTooltip.removeFromParent(true);
            this.mTooltip = null;
         }
      }
      
      override public function dispose() : void
      {
         if(this.mTooltip)
         {
            this.mTooltip.removeFromParent(true);
         }
         this.mTooltip = null;
         this.removeCustomEventListeners();
         super.dispose();
      }
      
      protected function removeCustomEventListeners() : void
      {
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
      }
   }
}

