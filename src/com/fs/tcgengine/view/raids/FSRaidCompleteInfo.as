package com.fs.tcgengine.view.raids
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.guilds.Guild;
   import com.fs.tcgengine.model.rules.RaidDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSRaidsScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.greensock.TweenMax;
   import feathers.controls.ScrollContainer;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.VerticalLayout;
   import starling.utils.Align;
   
   public class FSRaidCompleteInfo extends Component implements FSModelUnloadableInterface
   {
      
      private const TITLE_COLUMN_WIDTH:int = 100;
      
      private const TITLE_COLUMN_HEIGHT:int = 30;
      
      private var mRaidBoss:FSRaidBoss;
      
      private var mRaidUsersScrollContainer:ScrollContainer;
      
      private var mBG:CustomComponent;
      
      private var mRaidSku:String;
      
      private var mDifficulty:int;
      
      private var mPositionTitleTextfield:FSTextfield;
      
      private var mNameTitleTextfield:FSTextfield;
      
      private var mPointsTitleTextfield:FSTextfield;
      
      private var mDamageDoneTitleTextfield:FSTextfield;
      
      private var mIsRaidComplete:Boolean;
      
      private var mVectorUserPlayed:Vector.<FSUserPlayedRaidSlot>;
      
      public function FSRaidCompleteInfo(param1:String, param2:int, param3:Boolean = false)
      {
         this.mRaidSku = param1;
         this.mDifficulty = param2;
         this.mIsRaidComplete = param3;
         super();
         this.createUI();
         this.getRaidCompleteUsersInfo();
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createRaidBoss();
         this.createColumnTitles();
      }
      
      private function createColumnTitles() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = Utils.isAndroid();
         var _loc4_:Boolean = Utils.isIphone();
         var _loc5_:Boolean = Utils.isDesktop();
         if(_loc3_ || _loc5_ || Utils.isBrowser())
         {
            _loc1_ = this.TITLE_COLUMN_WIDTH * 0.6;
            _loc2_ = this.TITLE_COLUMN_HEIGHT * 0.6;
         }
         else
         {
            _loc1_ = this.TITLE_COLUMN_WIDTH;
            _loc2_ = this.TITLE_COLUMN_HEIGHT;
         }
         if(this.mPositionTitleTextfield == null)
         {
            this.mPositionTitleTextfield = new FSTextfield(_loc1_ * 0.85,_loc2_,TextManager.getText("TID_RAID_RANKING_POSITION"));
            this.mPositionTitleTextfield.x = this.mRaidBoss.x - this.mPositionTitleTextfield.width * 0.3;
            this.mPositionTitleTextfield.y = this.mRaidBoss.y + this.mRaidBoss.height * 1.2;
            addChild(this.mPositionTitleTextfield);
         }
         if(this.mNameTitleTextfield == null)
         {
            this.mNameTitleTextfield = new FSTextfield(_loc1_,_loc2_,TextManager.getText("TID_RAID_RANKING_NAME"));
            this.mNameTitleTextfield.x = this.mPositionTitleTextfield.x + this.mPositionTitleTextfield.width * 1.5;
            this.mNameTitleTextfield.y = this.mRaidBoss.y + this.mRaidBoss.height * 1.2;
            addChild(this.mNameTitleTextfield);
         }
         if(this.mDamageDoneTitleTextfield == null)
         {
            this.mDamageDoneTitleTextfield = new FSTextfield(_loc1_,_loc2_,TextManager.getText("TID_DAMAGE_DONE"));
            this.mDamageDoneTitleTextfield.x = this.mNameTitleTextfield.x + this.mNameTitleTextfield.width * 1.5;
            this.mDamageDoneTitleTextfield.y = this.mRaidBoss.y + this.mRaidBoss.height * 1.2;
            addChild(this.mDamageDoneTitleTextfield);
         }
         if(this.mIsRaidComplete)
         {
            this.setNameTitleNewPosition();
            this.setDamageDoneNewPosition();
            if(this.mPointsTitleTextfield == null)
            {
               this.mPointsTitleTextfield = new FSTextfield(_loc1_,_loc2_,TextManager.getText("TID_RAID_RANKING_POINTS"));
               this.mPointsTitleTextfield.x = this.mDamageDoneTitleTextfield.x + this.mDamageDoneTitleTextfield.width * 1.1;
               this.mPointsTitleTextfield.y = this.mRaidBoss.y + this.mRaidBoss.height * 1.2;
               addChild(this.mPointsTitleTextfield);
            }
         }
      }
      
      private function setDamageDoneNewPosition() : void
      {
         if(this.mDamageDoneTitleTextfield)
         {
            this.mDamageDoneTitleTextfield.x = this.mNameTitleTextfield.x + this.mNameTitleTextfield.width * 1.1;
         }
      }
      
      private function setNameTitleNewPosition() : void
      {
         if(this.mNameTitleTextfield)
         {
            this.mNameTitleTextfield.x = this.mPositionTitleTextfield.x + this.mPositionTitleTextfield.width * 1.1;
         }
      }
      
      private function createRaidBoss() : void
      {
         var _loc1_:RaidDef = null;
         if(this.mRaidBoss == null)
         {
            _loc1_ = RaidDef(InstanceMng.getRaidsDefMng().getDefBySku(this.mRaidSku));
            if(_loc1_)
            {
               this.mRaidBoss = new FSRaidBoss(_loc1_,this.mDifficulty,false);
               this.mRaidBoss.init();
               this.mRaidBoss.x = this.mBG.x + this.mRaidBoss.width * 0.1;
               this.mRaidBoss.y = this.mBG.y + this.mRaidBoss.height * 0.15;
               addChild(this.mRaidBoss);
            }
         }
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = Utils.createCustomBox("dungeon_ladder_bg",1140);
            addChild(this.mBG);
         }
      }
      
      public function onUsersInfoSuccess(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Component = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Guild = null;
         var _loc10_:UserData = null;
         var _loc11_:int = 0;
         if(param1 != null)
         {
            _loc5_ = new Array();
            _loc5_.push(param1);
            _loc7_ = false;
            _loc8_ = false;
            if(this.mVectorUserPlayed == null || Boolean(this.mVectorUserPlayed && _loc5_) && Boolean(_loc5_.length > this.mVectorUserPlayed.length))
            {
               this.createNewsSlots(_loc5_);
            }
            if(_loc5_)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc5_.length)
               {
                  if(_loc5_[_loc2_].damage != 0)
                  {
                     _loc9_ = InstanceMng.getGuildsMng().getMyGuild();
                     _loc10_ = _loc9_ ? _loc9_.getMemberUserDataById(_loc5_[_loc2_].playerId) : null;
                     if(_loc10_)
                     {
                        _loc6_ = _loc10_.getAccountId() == InstanceMng.getServerConnection().getUserId() ? TextManager.getText("TID_SOCIAL_ME") : _loc10_.getName();
                        if(this.mRaidUsersScrollContainer)
                        {
                           _loc3_ = 0;
                           while(_loc3_ < this.mRaidUsersScrollContainer.numChildren)
                           {
                              _loc4_ = Component(this.mRaidUsersScrollContainer.getChildAt(_loc3_));
                              if(_loc4_ != null)
                              {
                                 if(_loc4_ is FSUserPlayedRaidSlot && FSUserPlayedRaidSlot(_loc4_).getUserData() != null)
                                 {
                                    _loc7_ = _loc10_.getAccountId() == FSUserPlayedRaidSlot(_loc4_).getUserData().getAccountId();
                                    if(_loc7_)
                                    {
                                       _loc8_ = true;
                                       _loc11_ = int(_loc5_[_loc2_].damage);
                                       FSUserPlayedRaidSlot(_loc4_).increaseDamage(_loc11_);
                                       if(Boolean(InstanceMng.getCurrentScreen() is FSRaidsScreen) && Boolean(FSRaidsScreen(InstanceMng.getCurrentScreen()).getRaidIncompleteInfo()) && Boolean(FSRaidsScreen(InstanceMng.getCurrentScreen()).getRaidIncompleteInfo().getRaidBoss()))
                                       {
                                          FSRaidsScreen(InstanceMng.getCurrentScreen()).getRaidIncompleteInfo().getRaidBoss().updateProgressBar();
                                       }
                                    }
                                 }
                              }
                              _loc3_++;
                           }
                           if(!_loc8_)
                           {
                              this.createNewsSlots(_loc5_);
                              if(Boolean(InstanceMng.getCurrentScreen() is FSRaidsScreen) && Boolean(FSRaidsScreen(InstanceMng.getCurrentScreen()).getRaidIncompleteInfo()) && Boolean(FSRaidsScreen(InstanceMng.getCurrentScreen()).getRaidIncompleteInfo().getRaidBoss()))
                              {
                                 FSRaidsScreen(InstanceMng.getCurrentScreen()).getRaidIncompleteInfo().getRaidBoss().updateProgressBar();
                              }
                           }
                        }
                     }
                  }
                  _loc2_++;
               }
               if(this.mRaidUsersScrollContainer)
               {
                  this.mRaidUsersScrollContainer.sortChildren(DictionaryUtils.sortRaidPlayersByDamage);
                  this.mRaidUsersScrollContainer.validate();
                  this.updatePositionRanking();
               }
            }
         }
      }
      
      private function updatePositionRanking() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Component = null;
         if(this.mRaidUsersScrollContainer)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mRaidUsersScrollContainer.numChildren)
            {
               _loc2_ = Component(this.mRaidUsersScrollContainer.getChildAt(_loc1_));
               if(_loc2_)
               {
                  FSUserPlayedRaidSlot(_loc2_).updateRankPosition(_loc1_);
               }
               _loc1_++;
            }
         }
      }
      
      private function createNewsSlots(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSUserPlayedRaidSlot = null;
         var _loc4_:UserData = null;
         var _loc5_:int = 0;
         if(param1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               if(param1[_loc2_].damage != 0)
               {
                  _loc4_ = InstanceMng.getGuildsMng().getMyGuild() ? InstanceMng.getGuildsMng().getMyGuild().getMemberUserDataById(param1[_loc2_].playerId) : null;
                  if(_loc4_)
                  {
                     if(_loc4_.getAccountId() == InstanceMng.getServerConnection().getUserId())
                     {
                        name = TextManager.getText("TID_SOCIAL_ME");
                     }
                     else
                     {
                        name = _loc4_.getName();
                     }
                     if(!this.existSlotForThisName(name))
                     {
                        if(this.mVectorUserPlayed == null)
                        {
                           _loc5_ = 1;
                        }
                        else
                        {
                           _loc5_ = this.mVectorUserPlayed.length + 1;
                        }
                        _loc3_ = new FSUserPlayedRaidSlot(param1[_loc2_],_loc5_,this.mRaidSku,this.mDifficulty,_loc4_,this.mIsRaidComplete);
                        this.addUserInfoToScrollContainer(_loc3_);
                     }
                  }
               }
               _loc2_++;
            }
         }
      }
      
      private function existSlotForThisName(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         if(this.mVectorUserPlayed)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mVectorUserPlayed.length)
            {
               if(FSUserPlayedRaidSlot(this.mVectorUserPlayed[_loc2_]).getName() == param1)
               {
                  _loc3_ = true;
                  break;
               }
               _loc2_++;
            }
         }
         return _loc3_;
      }
      
      private function getRaidCompleteUsersInfo() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(true,true,Align.CENTER,Align.CENTER,1,null,this);
         var _loc1_:String = InstanceMng.getUserDataMng().getOwnerUserData().getGuildId();
         this.fillPlayersScores();
      }
      
      private function fillPlayersScores() : void
      {
         var _loc1_:RaidDef = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:FSUserPlayedRaidSlot = null;
         var _loc6_:Guild = null;
         var _loc7_:UserData = null;
         if(InstanceMng.getCurrentScreen() is FSRaidsScreen)
         {
            _loc1_ = RaidDef(InstanceMng.getRaidsDefMng().getDefBySku(this.mRaidSku));
            if(_loc1_ == null)
            {
               return;
            }
            _loc2_ = InstanceMng.getRaidsMng().getTotaMPRaidDamageDone(_loc1_,this.mDifficulty);
            _loc4_ = 1;
            _loc6_ = InstanceMng.getGuildsMng().getMyGuild();
            if(Boolean(_loc2_) && Boolean(_loc6_))
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  if(_loc6_.existsMemberByAccountId(_loc2_[_loc3_].playerId))
                  {
                     _loc7_ = _loc6_.getMemberUserDataById(_loc2_[_loc3_].playerId);
                     if(_loc7_)
                     {
                        if(_loc2_[_loc3_].damage != 0)
                        {
                           _loc5_ = new FSUserPlayedRaidSlot(_loc2_[_loc3_],_loc4_,this.mRaidSku,this.mDifficulty,_loc7_,this.mIsRaidComplete);
                           this.addUserInfoToScrollContainer(_loc5_);
                           _loc4_++;
                        }
                     }
                     else
                     {
                        _loc6_.refreshGuildMembersInfo();
                     }
                  }
                  else if(_loc2_[_loc3_].damage != 0)
                  {
                     _loc7_ = null;
                     _loc5_ = new FSUserPlayedRaidSlot(_loc2_[_loc3_],_loc4_,this.mRaidSku,this.mDifficulty,_loc7_,this.mIsRaidComplete,true);
                     this.addUserInfoToScrollContainer(_loc5_);
                     _loc4_++;
                  }
                  _loc3_++;
               }
            }
            if(this.mRaidUsersScrollContainer == null || Boolean(this.mRaidUsersScrollContainer && this.mVectorUserPlayed) && Boolean(_loc4_ - 1 != this.mVectorUserPlayed.length))
            {
               if(this.mRaidUsersScrollContainer)
               {
                  this.mRaidUsersScrollContainer.removeChildren();
                  this.mVectorUserPlayed.length = 0;
                  this.mVectorUserPlayed = null;
               }
               TweenMax.delayedCall(2,this.fillPlayersScores);
            }
            if(Boolean(this.mRaidUsersScrollContainer && this.mVectorUserPlayed) && Boolean(_loc4_ - 1 == this.mVectorUserPlayed.length) || _loc2_ == null)
            {
               InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
            }
         }
      }
      
      private function addUserInfoToScrollContainer(param1:FSUserPlayedRaidSlot) : void
      {
         if(Boolean(this.mRaidUsersScrollContainer == null) && Boolean(this.mBG) && Boolean(param1))
         {
            this.mRaidUsersScrollContainer = new ScrollContainer();
            this.mRaidUsersScrollContainer.width = this.mBG.width;
            this.mRaidUsersScrollContainer.height = this.mBG.height * 0.7;
            this.mRaidUsersScrollContainer.layout = this.getContainerLayoutVertical();
            this.mRaidUsersScrollContainer.x = this.mBG.x;
            this.mRaidUsersScrollContainer.y = this.mBG.y + param1.height * 1.9;
            this.mRaidUsersScrollContainer.touchable = true;
            addChild(this.mRaidUsersScrollContainer);
         }
         if(this.mVectorUserPlayed == null)
         {
            this.mVectorUserPlayed = new Vector.<FSUserPlayedRaidSlot>();
         }
         this.mVectorUserPlayed.push(param1);
         if(this.mRaidUsersScrollContainer)
         {
            this.mRaidUsersScrollContainer.addChild(param1);
         }
      }
      
      private function getContainerLayoutVertical() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 5;
         _loc1_.horizontalAlign = HorizontalAlign.CENTER;
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         if(this.mRaidBoss)
         {
            this.mRaidBoss.removeFromParent(true);
            this.mRaidBoss = null;
         }
         if(this.mRaidUsersScrollContainer)
         {
            this.mRaidUsersScrollContainer.removeFromParent(true);
            this.mRaidUsersScrollContainer = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mPositionTitleTextfield)
         {
            this.mPositionTitleTextfield.removeFromParent(true);
            this.mPositionTitleTextfield = null;
         }
         if(this.mNameTitleTextfield)
         {
            this.mNameTitleTextfield.removeFromParent(true);
            this.mNameTitleTextfield = null;
         }
         if(this.mPointsTitleTextfield)
         {
            this.mPointsTitleTextfield.removeFromParent(true);
            this.mPointsTitleTextfield = null;
         }
         if(this.mDamageDoneTitleTextfield)
         {
            this.mDamageDoneTitleTextfield.removeFromParent(true);
            this.mDamageDoneTitleTextfield = null;
         }
         if(this.mVectorUserPlayed)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mVectorUserPlayed.length)
            {
               this.mVectorUserPlayed[_loc1_].removeFromParent(true);
               _loc1_++;
            }
            Utils.destroyArray(this.mVectorUserPlayed);
            this.mVectorUserPlayed = null;
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:int = 0;
         if(this.mRaidBoss)
         {
            this.mRaidBoss.removeFromParent();
            this.mRaidBoss.destroy();
            this.mRaidBoss = null;
         }
         if(this.mRaidUsersScrollContainer)
         {
            this.mRaidUsersScrollContainer.removeFromParent();
            this.mRaidUsersScrollContainer = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG = null;
         }
         if(this.mPositionTitleTextfield)
         {
            this.mPositionTitleTextfield.removeFromParent();
            this.mPositionTitleTextfield = null;
         }
         if(this.mNameTitleTextfield)
         {
            this.mNameTitleTextfield.removeFromParent();
            this.mNameTitleTextfield = null;
         }
         if(this.mPointsTitleTextfield)
         {
            this.mPointsTitleTextfield.removeFromParent();
            this.mPointsTitleTextfield = null;
         }
         if(this.mDamageDoneTitleTextfield)
         {
            this.mDamageDoneTitleTextfield.removeFromParent();
            this.mDamageDoneTitleTextfield = null;
         }
         if(this.mVectorUserPlayed)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mVectorUserPlayed.length)
            {
               this.mVectorUserPlayed[_loc1_].removeFromParent();
               _loc1_++;
            }
            Utils.destroyArray(this.mVectorUserPlayed);
            this.mVectorUserPlayed = null;
         }
      }
      
      public function getRaidBoss() : FSRaidBoss
      {
         return this.mRaidBoss;
      }
      
      public function getRaidUsersScrollContainer() : ScrollContainer
      {
         return this.mRaidUsersScrollContainer;
      }
   }
}

