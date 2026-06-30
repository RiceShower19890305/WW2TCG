package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.GameModeDef;
   
   public class GameModesDefMng extends DefMng
   {
      
      public static const DESTROY_GAMEMODE:String = "destroy";
      
      public static const SABOTAGE_GAMEMODE:String = "sabotage";
      
      public static const CAPTURE_GAMEMODE:String = "capture";
      
      public static const SURVIVE_GAMEMODE:String = "survive";
      
      public static const SUPREMACY_GAMEMODE:String = "supremacy";
      
      public function GameModesDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new GameModeDef();
      }
   }
}

