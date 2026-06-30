package com.fs.tcgengine.view.raids
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.RaidDef;
   import com.fs.tcgengine.model.rules.RaidLevelDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSRaidsScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSGaugeProgressBar;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.core.Starling;
   import starling.utils.Align;
   
   public class FSRaidBoss extends Component implements FSModelUnloadableInterface
   {
      
      private const BOSS_NAME_BG:String = "raid_boss_name_panel";
      
      private var mRaidDef:RaidDef;
      
      private var mRaidLevelDef:RaidLevelDef;
      
      private var mRaidBossDef:HeroCharacterDef;
      
      private var mBossIcon:FSImage;
      
      private var mBossNameBg:FSImage;
      
      private var mBossNameTextfield:FSTextfield;
      
      private var mProgressBar:FSGaugeProgressBar;
      
      private var mDifficulty:int;
      
      private var mBelongsToPopup:Boolean;
      
      public function FSRaidBoss(param1:RaidDef, param2:int, param3:Boolean)
      {
         this.mRaidDef = param1;
         this.mDifficulty = param2;
         this.mBelongsToPopup = param3;
         if(this.mRaidDef)
         {
            this.mRaidLevelDef = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getLevelDefByLevelIndex(this.mRaidDef.getLevelsByDifficultyIndex(this.mDifficulty)));
            if(this.mRaidLevelDef)
            {
               this.mRaidBossDef = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mRaidLevelDef.getEnemyHeroSku(UserData.WORLD_DEFAULT)));
            }
         }
         super();
      }
      
      public function init() : void
      {
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createNameBG();
         this.createNameTextfield();
         this.createProgressBar();
         this.loadBossIcon();
      }
      
      private function loadBossIcon() : void
      {
         var _loc1_:String = null;
         InstanceMng.getCurrentScreen().showLoadingIcon(true,true,Align.LEFT,Align.CENTER,1,null,this);
         if(this.mRaidBossDef)
         {
            _loc1_ = this.mRaidBossDef.getBGImageName();
            _loc1_ += "_portrait";
            if(Root.assets.getTexture(_loc1_) == null)
            {
               InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc1_,FSResourceMng.TYPE_TEXTURE_PNG);
            }
            InstanceMng.getResourcesMng().loadAssets(this.onBossIconLoaded);
         }
      }
      
      private function onBossIconLoaded() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
         this.createBossIcon();
      }
      
      private function getProgressBarWidth() : int
      {
         var _loc1_:int = Utils.isBrowser() ? int(Starling.current.stage.stageWidth * 0.3) : int(Starling.current.stage.stageWidth * 0.35);
         return this.mBelongsToPopup ? int(Starling.current.stage.stageWidth * 0.3) : _loc1_;
      }
      
      private function createProgressBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         if(Boolean(this.mRaidLevelDef) && this.mProgressBar == null)
         {
            _loc3_ = Root.assets.getTexture("raid_progress_bar_bg") != null ? "raid_progress_bar" : "gauge";
            _loc4_ = this.getProgressBarWidth();
            if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
            {
               _loc5_ = this.mRaidLevelDef.getIAHP();
               _loc6_ = InstanceMng.getRaidsMng().getTotalRaidDamageDone(this.mRaidDef,this.mDifficulty);
               _loc7_ = _loc6_ > 0;
               _loc1_ = _loc5_ - _loc6_ <= 0 ? 0 : int(_loc5_ - _loc6_);
               _loc8_ = _loc1_ <= 0;
               if(_loc8_)
               {
                  this.mProgressBar = new FSGaugeProgressBar(TextManager.getText("TID_RAID_DEFEATED"),_loc3_);
                  this.mProgressBar.setWidth(_loc4_);
                  this.mProgressBar.setRatio(0);
               }
               else
               {
                  _loc2_ = Number(_loc1_ / this.mRaidLevelDef.getIAHP());
                  this.mProgressBar = new FSGaugeProgressBar(_loc1_.toString() + " / " + this.mRaidLevelDef.getIAHP() + " (" + (_loc2_ * 100).toFixed(0) + "%)",_loc3_);
                  this.mProgressBar.setWidth(_loc4_);
                  this.mProgressBar.setRatio(_loc2_);
               }
            }
            else if(InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               _loc1_ = FSBattleScreen(InstanceMng.getCurrentScreen()).getBattleEngine().getOpponentBattleInfo().getHP();
               if(_loc1_ > 0)
               {
                  _loc2_ = Number(_loc1_ / this.mRaidLevelDef.getIAHP());
                  this.mProgressBar = new FSGaugeProgressBar(_loc1_.toString() + " / " + this.mRaidLevelDef.getIAHP() + " (" + (_loc2_ * 100).toFixed(0) + "%)",_loc3_);
                  this.mProgressBar.setWidth(_loc4_);
                  this.mProgressBar.setRatio(_loc2_);
               }
               else
               {
                  this.mProgressBar = new FSGaugeProgressBar(TextManager.getText("TID_RAID_DEFEATED"),_loc3_);
                  this.mProgressBar.setWidth(_loc4_);
                  this.mProgressBar.setRatio(0);
               }
            }
            if(Utils.isIphone() || Utils.isAndroidOrDesktop())
            {
               this.mProgressBar.x += this.mProgressBar.width * 0.1;
               this.mProgressBar.y += this.mProgressBar.height * 1.4;
               this.mProgressBar.width *= 0.8;
            }
            else
            {
               this.mProgressBar.x += this.mProgressBar.width * 0.15;
               this.mProgressBar.y += this.mProgressBar.height * 1.4;
            }
            addChild(this.mProgressBar);
         }
      }
      
      private function createNameTextfield() : void
      {
         if(Boolean(this.mRaidBossDef) && Boolean(this.mBossNameBg) && this.mBossNameTextfield == null)
         {
            this.mBossNameTextfield = new FSTextfield(this.mBossNameBg.width,this.mBossNameBg.height,this.mRaidBossDef.getName());
            this.mBossNameTextfield.x = this.mBossNameBg.x;
            this.mBossNameTextfield.y = this.mBossNameBg.y;
            addChild(this.mBossNameTextfield);
         }
      }
      
      private function createNameBG() : void
      {
         if(Boolean(this.mRaidDef) && this.mBossNameBg == null)
         {
            this.mBossNameBg = new FSImage(Root.assets.getTexture(this.BOSS_NAME_BG));
            this.mBossNameBg.x += this.mBossNameBg.width * 0.5;
            addChild(this.mBossNameBg);
         }
      }
      
      private function createBossIcon() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mRaidBossDef) && this.mBossIcon == null)
         {
            _loc1_ = this.mRaidBossDef.getBGImageName();
            _loc1_ += "_portrait";
            if(Root.assets.getTexture(_loc1_) == null)
            {
               _loc1_ = this.mRaidBossDef.getBGImageName();
            }
            this.mBossIcon = new FSImage(Root.assets.getTexture(_loc1_));
            addChild(this.mBossIcon);
         }
      }
      
      public function updateProgressBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         if(Boolean(this.mRaidLevelDef) && Boolean(this.mProgressBar))
         {
            _loc3_ = this.getProgressBarWidth();
            if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
            {
               _loc1_ = InstanceMng.getRaidsMng().getRaidBossHP(this.mRaidDef,this.mDifficulty);
               if(_loc1_ <= 0)
               {
                  this.mProgressBar.setText(TextManager.getText("TID_RAID_DEFEATED"));
                  this.mProgressBar.setWidth(_loc3_);
                  this.mProgressBar.setRatio(0);
               }
               else
               {
                  _loc2_ = Number(_loc1_ / this.mRaidLevelDef.getIAHP());
                  if(_loc2_ != this.mProgressBar.getRatio())
                  {
                     this.mProgressBar.setWidth(_loc3_);
                     this.mProgressBar.setRatio(_loc2_,_loc1_.toString() + " / " + this.mRaidLevelDef.getIAHP() + " (" + (_loc2_ * 100).toFixed(0) + "%)");
                  }
               }
            }
         }
      }
      
      private function updateProgressBarRatioText(param1:Number) : void
      {
         var _loc2_:int = 0;
         if(this.mRaidLevelDef)
         {
            _loc2_ = InstanceMng.getRaidsMng().getRaidBossHP(this.mRaidDef,this.mDifficulty);
            this.mProgressBar.setRatio(param1,_loc2_.toString() + " / " + this.mRaidLevelDef.getIAHP() + " (" + (param1 * 100).toFixed(0) + "%)");
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBossIcon)
         {
            this.mBossIcon.removeFromParent();
            this.mBossIcon.destroy();
            this.mBossIcon = null;
         }
         if(this.mBossNameBg)
         {
            this.mBossNameBg.removeFromParent();
            this.mBossNameBg.destroy();
            this.mBossNameBg = null;
         }
         if(this.mBossNameTextfield)
         {
            this.mBossNameTextfield.removeFromParent(true);
            this.mBossNameTextfield = null;
         }
         if(this.mProgressBar)
         {
            this.mProgressBar.removeFromParent(true);
            this.mProgressBar = null;
         }
         this.mRaidDef = null;
         this.mRaidLevelDef = null;
         this.mRaidBossDef = null;
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mBossIcon)
         {
            this.mBossIcon.removeFromParent();
            this.mBossIcon = null;
         }
         if(this.mBossNameBg)
         {
            this.mBossNameBg.removeFromParent();
            this.mBossNameBg = null;
         }
         if(this.mBossNameTextfield)
         {
            this.mBossNameTextfield.removeFromParent();
            this.mBossNameTextfield = null;
         }
         if(this.mProgressBar)
         {
            this.mProgressBar.removeFromParent();
            this.mProgressBar = null;
         }
      }
   }
}

