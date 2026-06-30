package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.TutorialDef;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   
   public class TutorialDefMng extends DefMng
   {
      
      public function TutorialDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new TutorialDef();
      }
      
      public function getTutorialDefsByLevelSku(param1:String) : Array
      {
         var _loc2_:Array = null;
         var _loc5_:TutorialDef = null;
         var _loc3_:Dictionary = getAllDefs();
         var _loc4_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_.getLevelSku() == param1 && _loc4_ == UserDataMng.DIFFICULTY_EASY)
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Array();
               }
               _loc2_.push(_loc5_);
            }
         }
         return _loc2_;
      }
      
      public function getTutorialDefByIndex(param1:int) : TutorialDef
      {
         var _loc2_:TutorialDef = null;
         var _loc3_:String = null;
         if(param1 >= 1)
         {
            _loc3_ = "tutorial_" + Utils.transformValueToString(param1.toString(),2);
            _loc2_ = TutorialDef(getDefBySku(_loc3_));
         }
         return _loc2_;
      }
   }
}

