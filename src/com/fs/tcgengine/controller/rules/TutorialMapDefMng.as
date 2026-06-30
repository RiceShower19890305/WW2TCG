package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.TutorialDeckBuilderDef;
   import com.fs.tcgengine.model.rules.TutorialMapDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import flash.utils.Dictionary;
   
   public class TutorialMapDefMng extends TutorialDeckBuilderDefMng
   {
      
      public function TutorialMapDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new TutorialMapDef();
      }
      
      override protected function getTutorialDefPrefix() : String
      {
         return "tutorial_map_";
      }
      
      public function getTutorialDefsByLevelSku(param1:int, param2:int, param3:Array = null) : Array
      {
         var _loc4_:TutorialMapDef = null;
         if(param3 == null)
         {
            param3 = new Array();
         }
         else
         {
            param3.length = 0;
         }
         for each(_loc4_ in mDefsBySku)
         {
            if(_loc4_.getLevel() == param1 && param2 == _loc4_.getDifficulty())
            {
               param3.push(_loc4_);
            }
         }
         if(param3)
         {
            param3.sort(DictionaryUtils.sortByIndexAsc);
         }
         return param3;
      }
      
      public function getTutorialDefByTutorialReward(param1:String) : TutorialMapDef
      {
         var _loc2_:TutorialMapDef = null;
         var _loc4_:TutorialDeckBuilderDef = null;
         var _loc3_:Dictionary = getAllDefs();
         for each(_loc4_ in _loc3_)
         {
            if(TutorialMapDef(_loc4_).getType() == TutorialMapDef.TUTORIAL_MAP_TYPE_REWARD && TutorialMapDef(_loc4_).getTutorialReward() == param1)
            {
               _loc2_ = TutorialMapDef(_loc4_);
            }
         }
         return _loc2_;
      }
   }
}

