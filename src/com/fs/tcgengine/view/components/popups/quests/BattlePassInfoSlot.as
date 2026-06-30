package com.fs.tcgengine.view.components.popups.quests
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.display.Quad;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class BattlePassInfoSlot extends Component implements FSModelUnloadableInterface
   {
      
      private var mQuad:Quad;
      
      private var mIcon:FSImage;
      
      private var mTextfield:FSTextfield;
      
      private var mOnClickedText:String;
      
      private var mOnClickPopulateTextfield:FSTextfield;
      
      private var mSlotsVectorRef:Vector.<BattlePassInfoSlot>;
      
      private var mInfoImage:FSImage;
      
      private var mOnClickExtraFunction:Function;
      
      public function BattlePassInfoSlot(param1:int, param2:int, param3:String, param4:String = "", param5:uint = 16777215, param6:String = "", param7:FSTextfield = null, param8:Vector.<BattlePassInfoSlot> = null, param9:Function = null)
      {
         super();
         this.mOnClickedText = param6;
         this.mOnClickPopulateTextfield = param7;
         this.mSlotsVectorRef = param8;
         this.mOnClickExtraFunction = param9;
         this.createUI(param1,param2,param3,param4,param5,param6,param7);
         Utils.alignComponentAndFixPosition(this);
      }
      
      private function createUI(param1:int, param2:int, param3:String, param4:String = "", param5:uint = 16777215, param6:String = "", param7:FSTextfield = null, param8:Vector.<BattlePassInfoSlot> = null) : void
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(this.mQuad == null)
         {
            this.mQuad = new Quad(param1,param2,param5);
            this.mQuad.alpha = 0.1;
            this.mQuad.touchable = true;
            this.mQuad.addEventListener(TouchEvent.TOUCH,this.onQuadTouched);
            addChild(this.mQuad);
         }
         if(this.mIcon == null && param4 != "")
         {
            this.mIcon = new FSImage(Root.assets.getTexture(param4));
            this.mIcon.touchable = false;
            this.mIcon.x = (param1 - this.mIcon.width) / 2;
            this.mIcon.y = this.mIcon.height / 6;
            addChild(this.mIcon);
         }
         if(this.mTextfield == null)
         {
            _loc9_ = param1 * 0.95;
            _loc10_ = param2 * 0.35;
            this.mTextfield = new FSTextfield(_loc9_,_loc10_,param3);
            this.mTextfield.touchable = false;
            this.mTextfield.x = (param1 - this.mTextfield.width) / 2;
            this.mTextfield.y = param2 - this.mTextfield.height;
            addChild(this.mTextfield);
         }
         if(this.mInfoImage == null)
         {
            this.mInfoImage = new FSImage(Root.assets.getTexture("battlepass_info_mini_icon"));
            this.mInfoImage.touchable = false;
            this.mInfoImage.x = this.mQuad.x + this.mQuad.width - this.mInfoImage.width;
            this.mInfoImage.y = this.mQuad.y;
            addChild(this.mInfoImage);
         }
      }
      
      private function onQuadTouched(param1:TouchEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            if(this.mOnClickedText != "" && this.mOnClickPopulateTextfield != null)
            {
               this.mOnClickPopulateTextfield.text = this.mOnClickedText;
            }
            if(this.mSlotsVectorRef)
            {
               _loc3_ = 0;
               while(_loc3_ < this.mSlotsVectorRef.length)
               {
                  this.mSlotsVectorRef[_loc3_].mQuad.alpha = this.mSlotsVectorRef[_loc3_] != this ? 0.1 : 0.35;
                  this.mSlotsVectorRef[_loc3_].mQuad.color = this.mSlotsVectorRef[_loc3_] != this ? 16777215 : 8583768;
                  _loc3_++;
               }
            }
            if(this.mOnClickExtraFunction != null)
            {
               this.mOnClickExtraFunction();
            }
         }
         _loc2_ = param1.getTouch(this,TouchPhase.HOVER);
         scale = _loc2_ ? 1.02 : 1;
      }
      
      override public function dispose() : void
      {
         if(this.mQuad)
         {
            this.mQuad.removeFromParent(true);
            this.mQuad = null;
         }
         if(this.mIcon)
         {
            this.mIcon.removeFromParent(true);
            this.mIcon = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         if(this.mInfoImage)
         {
            this.mInfoImage.removeFromParent(true);
            this.mInfoImage = null;
         }
         this.mOnClickPopulateTextfield = null;
         this.mOnClickedText = "";
         this.mSlotsVectorRef = null;
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mQuad)
         {
            this.mQuad.removeFromParent();
            this.mQuad = null;
         }
         if(this.mIcon)
         {
            this.mIcon.removeFromParent();
            this.mIcon.destroy();
            this.mIcon = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent();
            this.mTextfield = null;
         }
         if(this.mInfoImage)
         {
            this.mInfoImage.removeFromParent();
            this.mInfoImage = null;
         }
         this.mOnClickPopulateTextfield = null;
         this.mOnClickedText = "";
         this.mSlotsVectorRef = null;
      }
   }
}

