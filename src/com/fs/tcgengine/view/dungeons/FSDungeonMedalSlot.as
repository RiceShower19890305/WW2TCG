package com.fs.tcgengine.view.dungeons
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.pvp.FSPvPMedalSlot;
   
   public class FSDungeonMedalSlot extends FSPvPMedalSlot
   {
      
      public function FSDungeonMedalSlot(param1:Def, param2:Popup)
      {
         super(param1,param2);
      }
      
      override protected function getRankingAssetName() : String
      {
         return "dungeon_ranking_";
      }
   }
}

