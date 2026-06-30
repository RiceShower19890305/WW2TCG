package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.TutorialDeckBuilderDef;
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   
   public class TutorialDeckBuilderDefMng extends DefMng
   {
      
      public function TutorialDeckBuilderDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new TutorialDeckBuilderDef();
      }
      
      public function getTutorialDefByIndex(param1:int) : TutorialDeckBuilderDef
      {
         var _loc2_:TutorialDeckBuilderDef = null;
         var _loc3_:String = null;
         if(param1 >= 1)
         {
            _loc3_ = this.getTutorialDefPrefix() + Utils.transformValueToString(param1.toString(),2);
            _loc2_ = TutorialDeckBuilderDef(getDefBySku(_loc3_));
         }
         return _loc2_;
      }
      
      protected function getTutorialDefPrefix() : String
      {
         return "tutorial_db_";
      }
      
      public function getTutorialDefsArray() : Array
      {
         var _loc1_:Array = null;
         var _loc3_:TutorialDeckBuilderDef = null;
         var _loc2_:Dictionary = getAllDefs();
         for each(_loc3_ in _loc2_)
         {
            if(_loc1_ == null)
            {
               _loc1_ = new Array();
            }
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
   }
}

