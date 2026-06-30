package com.fs.tcgengine.view.dungeons
{
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.pvp.PlayerPvPScorePortrait;
   
   public class PlayerDungeonsScorePortrait extends PlayerPvPScorePortrait
   {
      
      public function PlayerDungeonsScorePortrait(param1:String = "", param2:int = 1, param3:String = "", param4:Number = 0, param5:int = 0, param6:Boolean = false, param7:Boolean = true)
      {
         super(param1,param2,param3,param4,param5,param6,param7);
      }
      
      override public function getMedalRankingName() : String
      {
         return "dungeon_ranking";
      }
      
      override protected function createNameTextfield(param1:String) : void
      {
         super.createNameTextfield(param1);
         if(mNameTextfield)
         {
            mNameTextfield.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
            mNameTextfield.width *= 1.2;
         }
      }
      
      override protected function createPunctuationTextfield(param1:Number) : void
      {
      }
   }
}

