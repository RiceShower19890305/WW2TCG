package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   
   public class JobsDefMng extends DefMng
   {
      
      public function JobsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new JobDef();
      }
      
      public function getDefByIndex(param1:int) : JobDef
      {
         var _loc2_:JobDef = null;
         var _loc3_:JobDef = null;
         for each(_loc3_ in mDefsBySku)
         {
            if(_loc3_.getIndex() == param1)
            {
               return _loc3_;
            }
         }
         return _loc2_;
      }
      
      public function getAllJobSkus() : Array
      {
         var _loc2_:JobDef = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in mDefsBySku)
         {
            _loc1_.push(String(_loc2_.getSku() + ":0"));
         }
         return _loc1_;
      }
      
      public function getBasicsJobDef() : Array
      {
         var _loc2_:JobDef = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in mDefsBySku)
         {
            if(_loc2_.isBasicDeck())
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_.sort(DictionaryUtils.sortJobDefByIndex);
      }
      
      public function getAllJobsDef() : Array
      {
         var _loc2_:JobDef = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in mDefsBySku)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_.sort(DictionaryUtils.sortJobDefByIndex);
      }
      
      public function getBasicJobByDeck(param1:String) : JobDef
      {
         var _loc2_:JobDef = null;
         var _loc3_:JobDef = null;
         for each(_loc2_ in mDefsBySku)
         {
            if(_loc2_.isBasicDeck() && param1 == _loc2_.getBasicDeckSku())
            {
               _loc3_ = _loc2_;
               break;
            }
         }
         return _loc3_;
      }
   }
}

