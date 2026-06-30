package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.DungeonLevelDef;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.Layout;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   
   public class FSPower extends FSCard
   {
      
      public function FSPower(param1:String)
      {
         super(param1);
      }
      
      override public function showDamageAndShield(param1:Boolean = false) : void
      {
      }
      
      override protected function showUpgradeCost(param1:int = -1) : void
      {
      }
      
      override public function createTierFrame(param1:Boolean = false) : void
      {
      }
      
      public function executePower(param1:UserBattleInfo, param2:Boolean) : void
      {
         var _loc3_:Ability = null;
         var _loc4_:Boolean = false;
         if(Boolean(mAbilities) && mAbilities.length > 0)
         {
            InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_POWER_USED,this);
            _loc3_ = mAbilities[0];
            if(_loc3_.canBeExecutedAndHasTargets())
            {
               mParentUserBattleInfo = param1;
               if(InstanceMng.getBattleEngine() != null && !InstanceMng.getAbilitiesMng().isTargetSelectionAbility(_loc3_.getAbilityDef()))
               {
                  _loc4_ = checkIfNeedsToBeStoredInSaveObj(false,false);
                  if(_loc4_)
                  {
                     BattleEnginePvP(InstanceMng.getBattleEngine()).onPowerUnitTargetSelected("");
                  }
               }
               _loc3_.execute();
               if(InstanceMng.getBattleEngine() != null && !InstanceMng.getAbilitiesMng().isTargetSelectionAbility(_loc3_.getAbilityDef()))
               {
                  InstanceMng.getBattleEngine().notifyActionDone(PowerDef(mCardDef).getSummonCost());
                  if(InstanceMng.getCurrentScreen() is FSBattleScreen)
                  {
                     FSBattleScreen(InstanceMng.getCurrentScreen()).suggestPlayableCardON();
                  }
               }
               if(InstanceMng.getAbilitiesMng().isTargetSelectionAbility(_loc3_.getAbilityDef()))
               {
                  if(InstanceMng.getCurrentScreen() is FSBattleScreen)
                  {
                     FSBattleScreen(InstanceMng.getCurrentScreen()).showCancelPower(param2);
                  }
               }
               else if(param2)
               {
                  InstanceMng.getBattleEngine().enableOwnerPowerButton(false);
               }
               else
               {
                  InstanceMng.getBattleEngine().enableOpponentPowerButton(false);
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_TARGET_NOT_ELEGIBLE"),true);
            }
         }
      }
      
      override public function addCardBack() : void
      {
         var _loc4_:FactionDef = null;
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:Screen = InstanceMng.getCurrentScreen();
         if(_loc3_ is FSBattleScreen)
         {
            _loc1_ = (_loc3_ as FSBattleScreen).getBattleEngine().isBattleOver();
            _loc2_ = (_loc3_ as FSBattleScreen).getBattleEngine().getLevelDef() is DungeonLevelDef;
         }
         if(!(this is FSCardXL) && !(_loc3_ is FSDeckBuilderScreen))
         {
            if(mBack == null)
            {
               _loc4_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(mCardDef.getFactionSku()));
               if(_loc4_ != null)
               {
                  mBack = new FSImage(Root.assets.getTexture(_loc4_.getBackBGName()));
                  mBack.x = mBack.width;
                  mBack.y = 0;
                  mBack.scaleX *= -1;
                  mBack.visible = true;
                  addChild(mBack);
               }
            }
            updateCardBackVisibility();
         }
      }
      
      override protected function canShowSummonCost() : Boolean
      {
         return mSummonTextfield == null && (getType() != TYPE_ACTION || getType() == TYPE_ACTION && Config.getConfig().cardShowSummonCostOnActions());
      }
      
      override protected function createSummonCostTextfield() : void
      {
         var _loc1_:Number = NaN;
         if(Config.getConfig().getShowSummonCost())
         {
            _loc1_ = !Utils.isTablet() ? 0.8 * Layout.getFontMultiplier() * 1.25 : Layout.getFontMultiplier();
            if(this.canShowSummonCost())
            {
               if(mSummonTextfield == null)
               {
                  mSummonTextfield = new FSTextfield(1,1,"",16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
                  mSummonTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
                  mSummonTextfield.touchable = false;
                  mSummonTextfield.alignPivot();
                  if(Utils.isIphone())
                  {
                     mSummonTextfield.x = mFrameSummonIcon.x - mFrameSummonIcon.width * 0.18;
                     mSummonTextfield.y = mFrameSummonIcon.y - mFrameSummonIcon.height * 0.18;
                  }
                  else
                  {
                     mSummonTextfield.x = mFrameSummonIcon.x;
                     mSummonTextfield.y = mFrameSummonIcon.y;
                  }
                  mSummonTextfield.width = mFrameSummonIcon.width * _loc1_;
                  mSummonTextfield.height = mFrameSummonIcon.height * _loc1_;
               }
               mSummonTextfield.text = String(getCardCostByType());
               mSubComponentsContainer.addChild(mSummonTextfield);
            }
         }
      }
   }
}

