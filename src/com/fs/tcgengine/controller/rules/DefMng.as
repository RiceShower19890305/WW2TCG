package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   
   public class DefMng
   {
      
      protected var mDefsBySku:Dictionary;
      
      protected var mJSONDef:Object;
      
      protected var mDefsByProdId:Dictionary;
      
      protected var mDefsByVGoodShortcode:Dictionary;
      
      protected var mTag:String;
      
      public function DefMng(param1:String)
      {
         super();
         this.mTag = param1;
         this.notifyLoadingResource(param1);
         this.mJSONDef = Root.assets.getObject(param1);
         if(this.mDefsBySku == null)
         {
            this.mDefsBySku = new Dictionary(true);
         }
         if(this.mDefsByProdId == null)
         {
            this.mDefsByProdId = new Dictionary(true);
         }
         if(this.mDefsByVGoodShortcode == null)
         {
            this.mDefsByVGoodShortcode = new Dictionary(true);
         }
         setTimeout(this.readDefs,20);
      }
      
      protected function notifyLoadingResource(param1:String) : void
      {
         var _loc2_:Boolean = Boolean(InstanceMng.getApplication()) && Boolean(InstanceMng.getApplication().getRuleMng()) ? InstanceMng.getApplication().getRuleMng().areDefaultDefsRead() : false;
         if(Boolean(param1 != "" && !_loc2_) && Boolean(Starling.current) && Boolean(Starling.current.root))
         {
            Root(Starling.current.root).setLoadingTextfieldText("Initializing " + Utils.capitalizeFirstLetter(param1));
         }
      }
      
      protected function readDefaultDefs() : void
      {
      }
      
      protected function readDefs() : void
      {
         var _loc1_:Def = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc2_:int = 0;
         if(this.mJSONDef != null)
         {
            for(_loc4_ in this.mJSONDef)
            {
               _loc3_ = this.mJSONDef[_loc4_];
               _loc1_ = this.createDef();
               _loc1_.fromJSON(_loc3_);
               this.addDef(_loc1_);
            }
         }
         Root.assets.removeObject(this.mTag);
         this.mJSONDef = null;
      }
      
      protected function createDef() : Def
      {
         return new Def();
      }
      
      public function addDef(param1:Def) : void
      {
         if(this.mDefsBySku[param1.getSku()] == null)
         {
            this.mDefsBySku[param1.getSku()] = param1;
         }
         var _loc2_:String = Utils.isAndroidOrDesktop() ? param1.getProdId().toLowerCase() : param1.getProdId();
         if(_loc2_ != "" && _loc2_ != null)
         {
            if(this.mDefsByProdId[_loc2_] == null)
            {
               this.mDefsByProdId[_loc2_] = param1;
            }
         }
         var _loc3_:String = param1.getVirtualGoodShortCode();
         if(_loc3_ != "" && _loc3_ != null)
         {
            if(this.mDefsByVGoodShortcode[_loc3_] == null)
            {
               this.mDefsByVGoodShortcode[_loc3_] = param1;
            }
         }
      }
      
      public function removeDef(param1:Def) : void
      {
         if(this.mDefsBySku[param1.getSku()] != null)
         {
            this.mDefsBySku[param1.getSku()] = null;
         }
         var _loc2_:String = param1.getProdId();
         if(_loc2_ != "" && _loc2_ != null)
         {
            if(this.mDefsByProdId[_loc2_] != null)
            {
               this.mDefsByProdId[_loc2_] = null;
            }
         }
         var _loc3_:String = param1.getVirtualGoodShortCode();
         if(_loc3_ != "" && _loc3_ != null)
         {
            if(this.mDefsByVGoodShortcode[_loc3_] != null)
            {
               this.mDefsByVGoodShortcode[_loc3_] = null;
            }
         }
      }
      
      public function getDefBySku(param1:String) : Def
      {
         return this.mDefsBySku[param1];
      }
      
      public function getDefsAmount() : int
      {
         return DictionaryUtils.getDictionaryLength(this.mDefsBySku);
      }
      
      public function getAllDefs() : Dictionary
      {
         return this.mDefsBySku;
      }
      
      public function getDefByProdId(param1:String) : Def
      {
         param1 = Utils.isAndroidOrDesktop() || InstanceMng.getApplication() != null && InstanceMng.getApplication().isKongregateVersion() ? param1.toLowerCase() : param1;
         return this.mDefsByProdId[param1];
      }
      
      public function getDefByVGoodShortCode(param1:String) : Def
      {
         return this.mDefsByVGoodShortcode[param1.toUpperCase()];
      }
   }
}

