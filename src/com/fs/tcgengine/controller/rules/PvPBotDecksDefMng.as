package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.PvPBotDeckDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   
   public class PvPBotDecksDefMng extends DefMng
   {
      
      public function PvPBotDecksDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function notifyLoadingResource(param1:String) : void
      {
      }
      
      override protected function createDef() : Def
      {
         return new PvPBotDeckDef();
      }
      
      public function getRandomPvPBotDeckDefs() : PvPBotDeckDef
      {
         var _loc1_:PvPBotDeckDef = null;
         var _loc2_:Dictionary = getAllDefs();
         var _loc3_:Array = DictionaryUtils.getKeys(_loc2_);
         _loc3_.sort(Utils.randomize);
         return _loc2_[_loc3_[0]];
      }
      
      public function printPvPBotDeckDefsDeckValues() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Dictionary = getAllDefs();
         var _loc2_:Array = DictionaryUtils.getKeys(_loc1_);
         _loc2_.sort();
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc3_ = PvPBotDeckDef(_loc1_[_loc2_[_loc5_]]).getDeckValue();
            FSDebug.debugTrace("Bot Deck #" + PvPBotDeckDef(_loc1_[_loc2_[_loc5_]]).getSku() + " deck value: " + _loc3_);
            _loc5_++;
         }
      }
      
      public function getRandomPvPBotDeckDefsByDeckValue(param1:int, param2:int = 0, param3:Dictionary = null, param4:Array = null) : PvPBotDeckDef
      {
         var _loc9_:int = 0;
         var _loc12_:Array = null;
         if(param3 == null)
         {
            param3 = getAllDefs();
         }
         if(param4 == null)
         {
            param4 = DictionaryUtils.getKeys(param3);
         }
         var _loc5_:Boolean = param1 < 15000;
         param1 *= param2 == 0 && _loc5_ ? 0.75 : 1;
         var _loc6_:int = param1 * 0.1;
         var _loc7_:int = param1 * 0.01;
         var _loc8_:int = _loc7_ * param2;
         var _loc10_:int = param1 + (_loc6_ + _loc8_);
         var _loc11_:int = param1 - (_loc6_ + _loc8_);
         var _loc13_:int = 0;
         while(_loc13_ < param4.length)
         {
            _loc9_ = PvPBotDeckDef(param3[param4[_loc13_]]).getDeckValue();
            if(_loc9_ < _loc10_ && _loc9_ > _loc11_)
            {
               if(_loc12_ == null)
               {
                  _loc12_ = new Array();
               }
               _loc12_.push(PvPBotDeckDef(param3[param4[_loc13_]]));
            }
            _loc13_++;
         }
         if(_loc12_ == null || _loc12_ != null && _loc12_.length == 0)
         {
            return this.getRandomPvPBotDeckDefsByDeckValue(param1,param2 + 1,param3,param4);
         }
         var _loc14_:String = "";
         var _loc15_:int = 0;
         while(_loc15_ < _loc12_.length)
         {
            _loc14_ += "\n Bot Deck #" + PvPBotDeckDef(_loc12_[_loc15_]).getSku() + " deck value: " + PvPBotDeckDef(_loc12_[_loc15_]).getDeckValue();
            _loc15_++;
         }
         FSDebug.debugTrace("\n Bots Available for a deck value of: " + param1 + ":" + _loc14_);
         _loc12_.sort(Utils.randomize);
         return _loc12_[0];
      }
   }
}

