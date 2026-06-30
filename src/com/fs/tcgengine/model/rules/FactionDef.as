package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   
   public class FactionDef extends Def
   {
      
      private var mIconBGName:String;
      
      private var mBackBGName:String;
      
      private var mBackBGXLName:String;
      
      private var mColor:uint;
      
      private var mCategoriesFrameBG:Dictionary;
      
      public function FactionDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("iconBGName" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.iconBGName);
            this.setIconBGName(_loc2_);
         }
         if("bgBack" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.bgBack);
            this.setBackBGName(_loc2_);
         }
         if("color" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.color);
            this.setColor(uint(_loc2_));
         }
         if("bgBackXL" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.bgBackXL);
            this.mBackBGXLName = _loc2_;
         }
         if("bgCat_01" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.bgCat_01);
            this.addCategoryFrameBG("category_01",_loc2_);
         }
         if("bgCat_02" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.bgCat_02);
            this.addCategoryFrameBG("category_02",_loc2_);
         }
         if("bgCat_03" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.bgCat_03);
            this.addCategoryFrameBG("category_03",_loc2_);
         }
         if("bgCat_04" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.bgCat_04);
            this.addCategoryFrameBG("category_04",_loc2_);
         }
         if("bgCat_05" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.bgCat_05);
            this.addCategoryFrameBG("category_05",_loc2_);
         }
      }
      
      public function getIconBGName() : String
      {
         return this.mIconBGName;
      }
      
      public function setIconBGName(param1:String) : void
      {
         this.mIconBGName = param1;
      }
      
      public function getBackBGName() : String
      {
         return this.mBackBGName;
      }
      
      public function setBackBGName(param1:String) : void
      {
         this.mBackBGName = param1;
      }
      
      public function setColor(param1:uint) : void
      {
         this.mColor = param1;
      }
      
      public function getColor() : uint
      {
         return this.mColor;
      }
      
      public function getBackBGXLName() : String
      {
         return this.mBackBGXLName;
      }
      
      private function addCategoryFrameBG(param1:String, param2:String) : void
      {
         if(this.mCategoriesFrameBG == null)
         {
            this.mCategoriesFrameBG = new Dictionary(true);
         }
         this.mCategoriesFrameBG[param1] = param2;
      }
      
      public function getCategoryFrameBG(param1:String) : String
      {
         return Boolean(this.mCategoriesFrameBG) && this.mCategoriesFrameBG[param1] != null ? this.mCategoriesFrameBG[param1] : getBGImageName();
      }
      
      public function getCategoryFrameBGXL(param1:String) : String
      {
         return Boolean(this.mCategoriesFrameBG) && this.mCategoriesFrameBG[param1] != null ? this.mCategoriesFrameBG[param1] + "_XL" : getBGXLImageName();
      }
   }
}

