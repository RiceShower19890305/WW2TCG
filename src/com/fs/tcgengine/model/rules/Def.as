package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   
   public class Def
   {
      
      protected var mSku:String = "";
      
      protected var mBGImageName:String = "";
      
      protected var mBGXLImageName:String = "";
      
      protected var mName:String = "";
      
      protected var mNameForAbility:String = "";
      
      protected var mNamePlural:String = "";
      
      protected var mDesc:String = "";
      
      protected var mProdId:String = "";
      
      private var mIndex:int;
      
      protected var mVGoodShortCode:String = "";
      
      private var mShopPosition:int;
      
      private var mShopDisplayOnlyToPayingUsers:Boolean = false;
      
      public function Def()
      {
         super();
      }
      
      public function fromJSON(param1:Object) : Boolean
      {
         var _loc3_:String = null;
         var _loc2_:Boolean = true;
         if(_loc2_)
         {
            if("sku" in param1)
            {
               _loc3_ = Utils.cleanMasterString(param1.sku);
               this.setSku(_loc3_);
            }
            if("index" in param1)
            {
               _loc3_ = Utils.cleanMasterString(param1.index);
               this.setIndex(int(_loc3_));
            }
            if("name" in param1)
            {
               _loc3_ = Utils.cleanMasterString(param1.name);
               this.setName(_loc3_);
            }
            if("nameForAbility" in param1)
            {
               _loc3_ = Utils.cleanMasterString(param1.nameForAbility);
               this.mNameForAbility = String(_loc3_);
            }
            if("namePlural" in param1)
            {
               _loc3_ = Utils.cleanMasterString(param1.namePlural);
               this.setName(_loc3_,true);
            }
            if("desc" in param1)
            {
               _loc3_ = Utils.cleanMasterString(param1.desc);
               this.setDesc(_loc3_);
            }
            if("bg" in param1)
            {
               _loc3_ = Utils.cleanMasterString(param1.bg);
               this.setBGImageName(_loc3_);
            }
            if("bgXL" in param1)
            {
               _loc3_ = Utils.cleanMasterString(param1.bgXL);
               this.setBGXLImageName(_loc3_);
            }
            if("prodId" in param1)
            {
               _loc3_ = Utils.cleanMasterString(param1.prodId);
               this.setProdId(_loc3_);
            }
            if("vGood_ShortCode" in param1)
            {
               _loc3_ = Utils.cleanMasterString(param1.vGood_ShortCode);
               this.mVGoodShortCode = _loc3_;
            }
            if("shopPosition" in param1)
            {
               _loc3_ = Utils.cleanMasterString(param1.shopPosition);
               this.mShopPosition = int(_loc3_);
            }
            if("shopDisplayOnlyToPayingUsers" in param1)
            {
               _loc3_ = Utils.cleanMasterString(param1.shopDisplayOnlyToPayingUsers);
               this.mShopDisplayOnlyToPayingUsers = Utils.stringToBoolean(_loc3_);
            }
            this.doFromJSON(param1);
         }
         return _loc2_;
      }
      
      protected function doFromJSON(param1:Object) : void
      {
      }
      
      public function getSku() : String
      {
         return this.mSku;
      }
      
      public function setSku(param1:String) : void
      {
         this.mSku = param1;
      }
      
      public function getIndex() : int
      {
         return this.mIndex;
      }
      
      public function setIndex(param1:int) : void
      {
         this.mIndex = param1;
      }
      
      public function getBGImageName() : String
      {
         return this.mBGImageName;
      }
      
      public function setBGImageName(param1:String) : void
      {
         this.mBGImageName = param1;
      }
      
      public function getBGXLImageName() : String
      {
         return this.mBGXLImageName;
      }
      
      public function setBGXLImageName(param1:String) : void
      {
         this.mBGXLImageName = param1;
      }
      
      public function getNameTID(param1:Boolean = false, param2:Boolean = false) : String
      {
         return param1 ? this.mNamePlural : this.mName;
      }
      
      public function getNameForAbilityTID() : String
      {
         return this.mNameForAbility;
      }
      
      public function getNameForAbility() : String
      {
         return this.mNameForAbility != "" && this.mNameForAbility != null ? TextManager.getText(this.mNameForAbility) : "";
      }
      
      public function getName(param1:Boolean = false, param2:Boolean = false) : String
      {
         return param1 ? TextManager.getText(this.mNamePlural) : TextManager.getText(this.mName,false,param2);
      }
      
      public function setName(param1:String, param2:Boolean = false) : void
      {
         if(!param2)
         {
            this.mName = param1;
         }
         else
         {
            this.mNamePlural = param1;
         }
      }
      
      public function getDesc() : String
      {
         return TextManager.getText(this.mDesc,true);
      }
      
      public function getDescTID() : String
      {
         return this.mDesc;
      }
      
      public function setDesc(param1:String) : void
      {
         this.mDesc = param1;
      }
      
      protected function setProdId(param1:String) : void
      {
         this.mProdId = param1;
      }
      
      public function getProdId() : String
      {
         var _loc1_:String = "";
         if(this.mProdId != "")
         {
            if(InstanceMng.getApplication().isBrowserVersion())
            {
               if(InstanceMng.getApplication().isFacebookBrowser())
               {
                  _loc1_ = this.mProdId;
               }
               else if(InstanceMng.getApplication().isKongregateVersion())
               {
                  _loc1_ = this.mProdId.replace(".","-").toLowerCase();
               }
            }
            else
            {
               _loc1_ = Config.getConfig().getAppNameSpace() + "." + this.mProdId;
            }
         }
         return Utils.isAndroid() ? _loc1_.toLowerCase() : _loc1_;
      }
      
      public function getVirtualGoodShortCode() : String
      {
         return this.mVGoodShortCode;
      }
      
      public function getShopPosition() : int
      {
         return this.mShopPosition;
      }
      
      protected function processAttributeArr(param1:Array, param2:String, param3:String) : Array
      {
         var _loc5_:int = 0;
         var _loc4_:Array = String(param2).split(param3);
         if((Boolean(_loc4_)) && _loc4_.length > 0)
         {
            if(param1 == null)
            {
               param1 = new Array();
            }
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               param1.push(_loc4_[_loc5_]);
               _loc5_++;
            }
         }
         return param1;
      }
      
      protected function processAttributeCatalog(param1:Dictionary, param2:String) : Dictionary
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc3_:Array = String(param2).split(",");
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            if(param1 == null)
            {
               param1 = new Dictionary(true);
            }
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc4_ = String(_loc3_[_loc5_]).split(":");
               param1[_loc4_[0]] = _loc4_[1];
               _loc5_++;
            }
         }
         return param1;
      }
      
      public function shopDisplayOnlyToPayingUsers() : Boolean
      {
         return this.mShopDisplayOnlyToPayingUsers;
      }
   }
}

