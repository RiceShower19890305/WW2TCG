package com.fs.tcgengine.view.components.shop
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   
   public class ShopItemSlotInfo extends Component
   {
      
      private var mRarityImage:FSImage;
      
      private var mTextfield:FSTextfield;
      
      private var mRarityDef:RarityDef;
      
      public function ShopItemSlotInfo(param1:String, param2:String, param3:RarityDef = null, param4:String = "", param5:Number = 1)
      {
         super();
         this.mRarityDef = param3;
         this.init(param1,param2,param5);
      }
      
      private function init(param1:String, param2:String, param3:Number = 1) : void
      {
         this.createRarityImage(param1,param3);
         this.createText(param2);
      }
      
      private function createRarityImage(param1:String, param2:Number = 1) : void
      {
         if(this.mRarityImage == null)
         {
            this.mRarityImage = new FSImage(Root.assets.getTexture(param1));
            this.mRarityImage.scale = param2;
            addChild(this.mRarityImage);
         }
      }
      
      private function createText(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(this.mTextfield == null)
         {
            _loc2_ = this.mRarityImage.width * 1.35;
            _loc3_ = this.mRarityImage.height * 0.8;
            this.mTextfield = new FSTextfield(_loc2_,_loc3_,param1,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
            _loc4_ = FSResourceMng.getFontByType();
            this.mTextfield.fontName = _loc4_;
            this.mTextfield.x = 0;
            this.mTextfield.y = this.mRarityImage.y + this.mRarityImage.height;
            if(this.mRarityImage)
            {
               this.mRarityImage.x = (this.mTextfield.width - this.mRarityImage.width) / 2;
            }
            addChild(this.mTextfield);
         }
      }
      
      public function resizeTextfieldWidth(param1:Number = 1.35) : void
      {
         if(Boolean(this.mTextfield) && Boolean(this.mRarityImage))
         {
            this.mTextfield.width = this.mRarityImage.width * param1;
            if(this.mRarityImage)
            {
               this.mRarityImage.x = (this.mTextfield.width - this.mRarityImage.width) / 2;
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.mRarityImage)
         {
            this.mRarityImage.removeFromParent(true);
            this.mRarityImage = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         this.mRarityDef = null;
         super.dispose();
      }
   }
}

