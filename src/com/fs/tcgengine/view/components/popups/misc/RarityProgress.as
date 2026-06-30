package com.fs.tcgengine.view.components.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import flash.utils.Dictionary;
   import starling.utils.Align;
   
   public class RarityProgress extends Component
   {
      
      private var mBG:FSImage;
      
      private var mTextfield:FSTextfield;
      
      private var mRarityDef:RarityDef;
      
      public function RarityProgress(param1:RarityDef)
      {
         super();
         this.mRarityDef = param1;
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createTextfield();
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture(this.mRarityDef.getBGPack()));
            addChild(this.mBG);
         }
      }
      
      private function createTextfield() : void
      {
         if(this.mTextfield == null)
         {
            this.mTextfield = new FSTextfield(this.mBG.width * 1.5,this.mBG.height * 0.9,"");
            this.mTextfield.format.horizontalAlign = Align.LEFT;
            this.mTextfield.fontName = FSResourceMng.getFontByType();
            this.mTextfield.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
            this.mTextfield.x = this.mBG.x + this.mBG.width;
            this.mTextfield.y = this.mBG.y;
            addChild(this.mTextfield);
         }
         this.refreshProgress();
      }
      
      public function refreshProgress() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(this.mTextfield)
         {
            _loc1_ = InstanceMng.getCardsDefMng().getAllCardsDefs(this.mRarityDef.getSku(),1,null,-1,null,null,false,0);
            _loc2_ = DictionaryUtils.getDictionaryLength(_loc1_);
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getCardsFromCollection(this.mRarityDef.getSku());
            _loc4_ = _loc3_ ? int(_loc3_.length) : 0;
            _loc5_ = _loc4_ + "/" + _loc2_;
            this.mTextfield.text = _loc5_;
            if(_loc4_ == _loc2_)
            {
               this.mTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
            }
         }
      }
      
      public function changeBGScale(param1:Number) : void
      {
         if(this.mBG)
         {
            this.mBG.scale = param1;
         }
         if(this.mTextfield)
         {
            this.mTextfield.width = this.mBG.width * 1.5;
            this.mTextfield.height = this.mBG.height * 0.9;
            this.mTextfield.x = this.mBG.x + this.mBG.width;
            this.mTextfield.y = this.mBG.y;
         }
      }
      
      override public function dispose() : void
      {
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
         this.mRarityDef = null;
         super.dispose();
      }
   }
}

