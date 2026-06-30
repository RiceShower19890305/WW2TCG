package com.fs.tcgengine.model.userdata
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   
   public class UserBattleInfoPvP extends UserBattleInfo implements FSModelUnloadableInterface
   {
      
      public function UserBattleInfoPvP(param1:Boolean, param2:String, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      private function resumeHPPoints() : int
      {
         var _loc1_:Object = PvPConnectionMng.smPvPBattleData ? PvPConnectionMng.smPvPBattleData["save"] : null;
         if(_loc1_)
         {
            if(isOwnerBattleInfo())
            {
               return _loc1_.ownerBattleInfo.mHP;
            }
            return _loc1_.opponentBattleInfo.mHP;
         }
         return PvPConnectionMng.getHPForPvPMatch();
      }
      
      private function resumeActionPoints() : int
      {
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:Object = PvPConnectionMng.smPvPBattleData["save"];
         if(_loc2_)
         {
            if(isOwnerBattleInfo())
            {
               return _loc2_.ownerBattleInfo.mActionPointsLeft;
            }
            return _loc2_.opponentBattleInfo.mActionPointsLeft;
         }
         _loc3_ = isOwnerBattleInfo() ? mLevelDef.getActionPointsPerTurn() : mLevelDef.getAIActionPointsPerTurn();
         _loc4_ = getAPGenerated();
         return int(_loc3_ + _loc4_);
      }
      
      override protected function init(param1:Boolean, param2:String, param3:Boolean = false) : void
      {
         var _loc4_:int = 0;
         if(param1)
         {
            mUserData = Utils.getOwnerUserData();
         }
         else
         {
            mUserData = InstanceMng.getUserDataMng().getOpponentUserData(param3);
         }
         mEmblemDictionary = new Dictionary(true);
         setLevelDef(LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(BattleEnginePvP.PVP_LEVEL_SKU)));
         if(mLevelDef != null)
         {
            setHP(new FSNumber(this.resumeHPPoints()));
            _loc4_ = this.resumeActionPoints();
            setActionPointsLeft(_loc4_);
            fillCards();
            mFightCards = new Dictionary(true);
            return;
         }
         throw new Error("Level Definition NOT FOUND!");
      }
      
      override protected function fillOwnerCards() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Dictionary = null;
         if(PvPConnectionMng.smPvPBattleData["save"] != null)
         {
            _loc1_ = PvPConnectionMng.smPvPBattleData["save"]["ownerBattleInfo"]["mDeck"];
            if(_loc1_ != null)
            {
               _loc2_ = DictionaryUtils.getDictionaryByObject(_loc1_);
               if(_loc2_ != null)
               {
                  fillDeck(_loc2_);
               }
            }
         }
         else
         {
            super.fillOwnerCards();
         }
      }
      
      override protected function fillAICards() : void
      {
         var _loc2_:String = null;
         var _loc3_:Dictionary = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc1_:Object = PvPConnectionMng.smPvPBattleData ? PvPConnectionMng.smPvPBattleData["decks"] : null;
         if(Boolean(_loc1_) && Boolean(_loc1_.hasOwnProperty("opponentInfo")) && Boolean(_loc1_["opponentInfo"].hasOwnProperty("offlineDeck")))
         {
            _loc2_ = _loc1_["opponentInfo"]["offlineDeck"];
            if(_loc2_ != null)
            {
               _loc3_ = DictionaryUtils.addCards(_loc2_.split(","),_loc3_,true,Config.getConfig().getDeckCardsAmount());
               if(_loc3_ != null)
               {
                  fillDeck(_loc3_);
               }
            }
         }
         else
         {
            _loc4_ = InstanceMng.getBattleEngine() != null && InstanceMng.getBattleEngine().isOnlineMatch();
            _loc5_ = InstanceMng.getUserDataMng().getOpponentUserData(_loc4_).getSelectedDeckIndexPvP();
            fillDeck(InstanceMng.getUserDataMng().getOpponentUserData(_loc4_).getDeck(_loc5_));
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

