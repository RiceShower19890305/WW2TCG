package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.PortraitDef;
   import com.fs.tcgengine.model.rules.ShopBoostDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSShopInfoCard;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.misc.PopupAchievements;
   import com.fs.tcgengine.view.popups.misc.PopupRewards;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.fs.tcgengine.view.popups.purchases.PopupShopItem;
   import com.fs.tcgengine.view.popups.quests.PopupBattlePass;
   import com.fs.tcgengine.view.popups.quests.PopupQuest;
   import com.greensock.TimelineLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.greensock.easing.Bounce;
   import com.greensock.easing.Elastic;
   import com.greensock.easing.Sine;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.display.Sprite3D;
   import starling.events.Event;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   
   public class RewardsEffect extends Component
   {
      
      private const CARD_UNFOLD_TIME:Number = 0.5;
      
      private const CHEST_EFFECT:Boolean = true;
      
      private var mBGQuad:Quad;
      
      private var mContainer:Component;
      
      private var mExitButton:FSButton;
      
      protected var mRequestCardsArr:Array;
      
      private var mCardsCatalog:Dictionary;
      
      private var mRewardsToClaim:Object;
      
      private var mServerResponseReceived:Boolean = false;
      
      private var mIsDungeon:Boolean;
      
      private var mRewardIndex:int;
      
      private var mRewardsDelivered:Boolean;
      
      private var mChestBG:String;
      
      private var mPackAnimation:PackAnimation;
      
      private var mOrigin:String;
      
      private var mGlobalPoint:Point;
      
      private var mPoint:Point;
      
      private var mCardsReceived:Boolean;
      
      public function RewardsEffect(param1:String, param2:Object, param3:Boolean, param4:String = "")
      {
         super();
         this.restart(param1,param2,param3,param4);
      }
      
      public function restart(param1:String, param2:Object, param3:Boolean, param4:String = "") : void
      {
         var _loc5_:Array = null;
         var _loc6_:UserData = null;
         var _loc7_:int = 0;
         this.mRewardsDelivered = false;
         if(this.mCardsCatalog)
         {
            DictionaryUtils.clearDictionary(this.mCardsCatalog);
         }
         this.setTouchable(false);
         if(InstanceMng.getCurrentScreen())
         {
            if(InstanceMng.getCurrentScreen().getOptionsPanel())
            {
               InstanceMng.getCurrentScreen().getOptionsPanel().touchable = false;
            }
            if(InstanceMng.getCurrentScreen().getGuildsButton())
            {
               InstanceMng.getCurrentScreen().getGuildsButton().touchable = false;
            }
         }
         this.mRewardsToClaim = param2;
         this.mIsDungeon = param3;
         this.mChestBG = param4;
         this.mOrigin = param1;
         if(this.mExitButton)
         {
            this.mExitButton.alpha = 0;
         }
         if(this.mIsDungeon)
         {
            if(Boolean(this.mRewardsToClaim) && Boolean(this.mRewardsToClaim["hasCards"]))
            {
               _loc5_ = this.mRewardsToClaim["cards"].split(",");
               _loc6_ = Utils.getOwnerUserData();
               if((Boolean(_loc6_)) && Boolean(_loc5_))
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc5_.length)
                  {
                     _loc6_.addCardToCollection(_loc5_[_loc7_] + ":1");
                     _loc6_.addCardToNewCardsCollection(_loc5_[_loc7_] + ":1");
                     _loc7_++;
                  }
               }
            }
         }
         if(Boolean(this.mRewardsToClaim) && Boolean(this.mRewardsToClaim.hasPacks))
         {
            this.rollPacksCards(this.mRewardsToClaim.packs);
         }
         this.setResourcesToLoad();
      }
      
      private function setResourcesToLoad() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(true,true);
         this.requestAssetsDependingOnRewards();
         if(!(InstanceMng.getCurrentScreen() is FSShopScreen))
         {
            if(Root.assets.getTextureAtlas("framesFactionsRarities_0") == null)
            {
               InstanceMng.getResourcesMng().addResourcesFolderByName("framesFactionsRarities");
            }
            if(Root.assets.getTextureAtlas("frames_0") == null)
            {
               InstanceMng.getResourcesMng().addResourcesFolderByName("frames");
            }
         }
         InstanceMng.getResourcesMng().loadAssets(this.notifyAssetsLoaded);
      }
      
      private function requestAssetsDependingOnRewards() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(this.mRewardsToClaim)
         {
            if(this.mRewardsToClaim.hasCards)
            {
               _loc1_ = this.mRewardsToClaim.cards;
               this.mRequestCardsArr = _loc1_ ? _loc1_.split(",") : null;
               this.requestResourcesFromRequestCardsArr();
            }
            if(this.mRewardsToClaim.hasPortraits)
            {
               _loc3_ = this.mRewardsToClaim.portraits;
               this.requestResourcesFromRequestPortraits(_loc3_);
            }
            if(this.mRewardsToClaim.hasSkins)
            {
               _loc4_ = this.mRewardsToClaim.skins;
               this.requestResourcesFromRequestSkins(_loc4_);
            }
            if(this.mRewardsToClaim.hasBoosts)
            {
               _loc5_ = this.mRewardsToClaim.boosts;
            }
         }
      }
      
      private function requestResourcesFromRequestPortraits(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PortraitDef = null;
         var _loc4_:Array = param1 ? param1.split(",") : null;
         if((Boolean(_loc4_)) && !Config.smPortraitFramesInAtlas)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               _loc3_ = PortraitDef(InstanceMng.getPortraitsDefMng().getDefBySku(_loc4_[_loc2_]));
               if(Boolean(_loc3_) && Root.assets.getTexture(_loc3_.getBGImageName()) == null)
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc3_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
               }
               _loc2_++;
            }
         }
      }
      
      private function requestResourcesFromRequestSkins(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:HeroCharacterDef = null;
         var _loc4_:Array = param1 ? param1.split(",") : null;
         if(_loc4_)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               _loc3_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(_loc4_[_loc2_]));
               if(Boolean(_loc3_) && Root.assets.getTexture(_loc3_.getBGImageName()) == null)
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc3_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
               }
               _loc2_++;
            }
         }
      }
      
      private function rollPacksCards(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PackDef = null;
         var _loc6_:Dictionary = null;
         var _loc8_:String = null;
         var _loc4_:Array = param1 ? param1.split(",") : null;
         var _loc5_:String = "";
         var _loc7_:String = "";
         if(_loc4_)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               _loc3_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc4_[_loc2_]));
               if(_loc3_)
               {
                  _loc8_ = InstanceMng.getCurrentScreen() is FSBattleScreen ? PacksDefMng.PACK_DUNGEONS : PacksDefMng.PACK_SHOP;
                  _loc6_ = Utils.rollCardsPack(_loc3_,_loc8_);
                  if(_loc6_)
                  {
                     this.mRewardsToClaim.hasCards = true;
                     for each(_loc7_ in _loc6_)
                     {
                        this.mRewardsToClaim.cards = this.mRewardsToClaim.cards ? this.mRewardsToClaim.cards + "," + _loc7_ : _loc7_;
                     }
                  }
               }
               _loc2_++;
            }
         }
      }
      
      private function requestResourcesFromRequestCardsArr() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this.mRequestCardsArr)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mRequestCardsArr.length)
            {
               this.requestCardResources(this.mRequestCardsArr[_loc1_]);
               _loc1_++;
            }
         }
      }
      
      protected function requestCardResources(param1:String) : void
      {
         var _loc2_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1));
         InstanceMng.getResourcesMng().loadCardImagesByCardDef(_loc2_,false);
      }
      
      private function notifyAssetsLoaded() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
         this.init();
      }
      
      private function showCards(param1:Boolean, param2:Number, param3:int, param4:Boolean = false) : void
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:FSCard = null;
         var _loc8_:FSShopInfoCard = null;
         var _loc10_:Number = NaN;
         var _loc9_:Number = 0;
         if(this.mRequestCardsArr)
         {
            _loc6_ = 0;
            while(_loc6_ < this.mRequestCardsArr.length)
            {
               _loc5_ = this.mRequestCardsArr[_loc6_];
               if(this.mCardsCatalog == null)
               {
                  this.mCardsCatalog = new Dictionary(true);
               }
               _loc7_ = InstanceMng.getCardsMng().createCard(_loc5_);
               _loc7_.touchable = false;
               _loc8_ = InstanceMng.getResourcesMng().createShopInfoCard(_loc7_,1,false);
               _loc8_.alignPivot();
               _loc9_ = param4 ? 0 : _loc6_ * 0.4;
               this.mContainer.addChild(_loc8_);
               this.performItemOutOfChestEffect(_loc8_,param3,param2 + _loc9_);
               ++this.mRewardIndex;
               this.mCardsCatalog[_loc6_] = _loc7_;
               _loc6_++;
            }
            this.mCardsReceived = true;
            if(param1)
            {
               _loc10_ = param4 ? 0 : _loc9_ + 0.5;
               TweenMax.delayedCall(_loc10_,this.unFoldCardCovers,[param4]);
               if(this.mPackAnimation)
               {
                  TweenMax.delayedCall(_loc10_ + 0.5,this.mPackAnimation.fadeParticles);
               }
            }
         }
      }
      
      private function performItemOutOfChestEffect(param1:*, param2:int, param3:Number = 0, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc7_:String = null;
         var _loc8_:FSCoordinate = null;
         var _loc9_:Number = NaN;
         var _loc6_:Number = 0.65;
         if(param1)
         {
            _loc7_ = param4 ? Constants.SOUND_GOLD_SPENT : "unfold_rare";
            TweenMax.delayedCall(param3,Utils.playSound,[_loc7_,SoundManager.TYPE_SFX]);
            param1.alpha = 0;
            param1.scale = 0.25;
            param1.alignPivot();
            if(this.mPackAnimation)
            {
               if(this.mGlobalPoint == null)
               {
                  this.mGlobalPoint = new Point(this.mPackAnimation.x,this.mPackAnimation.y);
               }
               this.mPoint = this.mContainer.globalToLocal(this.mGlobalPoint,this.mPoint);
               param1.x = this.mPoint.x;
               param1.y = this.mPoint.y;
               if(param1 is Sprite3D)
               {
                  param1.rotationX = Utils.randomNumber(-1,1);
                  param1.rotationY = Utils.randomNumber(-1,1);
               }
            }
            else
            {
               param1.x = Starling.current.stage.stageWidth / 2;
               param1.y = Starling.current.stage.height + param1.height / 2;
            }
            _loc8_ = this.getRewardPosition(param2);
            TweenMax.to(param1,_loc6_,{
               "delay":param3,
               "bezier":{"values":[{
                  "x":this.mContainer.width / 2,
                  "y":this.mContainer.height / 2
               },{
                  "x":_loc8_.getX(),
                  "y":_loc8_.getY()
               }]},
               "ease":Sine.easeInOut
            });
            if(param1 is Sprite3D)
            {
               TweenMax.to(param1,_loc6_ * 2,{
                  "delay":param3,
                  "rotationX":0,
                  "rotationY":0,
                  "ease":Elastic.easeInOut
               });
            }
            _loc9_ = Utils.isIOS() && !Utils.isIphone() ? 1.4 : 1.25;
            TweenMax.to(param1,_loc6_,{
               "delay":param3,
               "scale":_loc9_,
               "ease":Sine.easeInOut
            });
            TweenMax.to(param1,_loc6_ * 1.85,{
               "delay":param3,
               "alpha":1
            });
            if(param4)
            {
               if(!InstanceMng.getCurrentScreen() is FSShopScreen)
               {
                  TweenMax.delayedCall(param3,Utils.playSound,[Constants.SOUND_GOLD_SPENT,SoundManager.TYPE_SFX]);
               }
               TweenMax.delayedCall(param3,Utils.requestScreenShake,[0.5,3]);
            }
            if(param5)
            {
               TweenMax.delayedCall(param3,SpecialFX.tweenRotate,[param1,10]);
            }
         }
      }
      
      private function unFoldCardCovers(param1:Boolean = false) : void
      {
         var _loc2_:FSShopInfoCard = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Number = NaN;
         var _loc6_:Number = this.CARD_UNFOLD_TIME;
         _loc3_ = 0;
         while(_loc3_ < this.mContainer.numChildren)
         {
            _loc4_ = _loc3_ == this.mContainer.numChildren - 1;
            if(this.mContainer.getChildAt(_loc3_) != null && this.mContainer.getChildAt(_loc3_) is FSShopInfoCard)
            {
               _loc2_ = FSShopInfoCard(this.mContainer.getChildAt(_loc3_));
               _loc5_ = param1 ? 0 : _loc3_ * _loc6_;
               TweenMax.delayedCall(_loc5_,this.fadeOffInfoCardCover,[_loc2_,_loc5_,_loc4_]);
            }
            _loc3_++;
         }
      }
      
      private function fadeOffInfoCardCover(param1:FSShopInfoCard, param2:Number, param3:Boolean) : void
      {
         var onCoverFadeOff:Function = null;
         var infoCard:FSShopInfoCard = param1;
         var delay:Number = param2;
         var lastCard:Boolean = param3;
         onCoverFadeOff = function():void
         {
            infoCard.createCardBack();
            infoCard.checkIfNewCard(true);
            infoCard.checkIfCraftAvailable();
         };
         if(infoCard)
         {
            infoCard.fadeOffCover(delay,lastCard,onCoverFadeOff);
         }
      }
      
      private function setTouchable(param1:Boolean) : void
      {
         if(this.mExitButton)
         {
            this.mExitButton.enabled = param1;
         }
      }
      
      private function createRewards(param1:Boolean = false) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         if(!this.mRewardsDelivered)
         {
            this.mRewardsDelivered = true;
            if(this.mRewardsToClaim)
            {
               _loc2_ = 0;
               _loc3_ = 0;
               _loc3_ += this.mRewardsToClaim.hasGold ? 1 : 0;
               _loc3_ += this.mRewardsToClaim.hasRaidPoints ? 1 : 0;
               _loc3_ += this.mRewardsToClaim.hasQuestPoints ? 1 : 0;
               _loc3_ += this.mRewardsToClaim.hasAHTokens ? 1 : 0;
               _loc3_ += this.mRewardsToClaim.hasCards ? String(this.mRewardsToClaim.cards).split(",").length : 0;
               _loc3_ += this.mRewardsToClaim.hasPortraits ? String(this.mRewardsToClaim.portraits).split(",").length : 0;
               _loc3_ += this.mRewardsToClaim.hasSkins ? String(this.mRewardsToClaim.skins).split(",").length : 0;
               _loc3_ += this.mRewardsToClaim.hasBoosts ? String(this.mRewardsToClaim.boosts).split(",").length : 0;
               this.createContainer(_loc3_);
               if(this.mRewardsToClaim.hasGold)
               {
                  this.createCurrencyReward(this.mRewardsToClaim.gold,ServerConnection.CURRENCY_GOLD,_loc3_,_loc2_);
                  _loc2_ += param1 ? 0 : 0.5;
               }
               if(this.mRewardsToClaim.hasRaidPoints)
               {
                  this.createCurrencyReward(this.mRewardsToClaim.raidPoints,ServerConnection.CURRENCY_RAID_COINS,_loc3_,_loc2_);
                  _loc2_ += param1 ? 0 : 0.5;
               }
               if(this.mRewardsToClaim.hasQuestPoints)
               {
                  this.createCurrencyReward(this.mRewardsToClaim.questPoints,ServerConnection.CURRENCY_QUEST_COINS,_loc3_,_loc2_);
                  _loc2_ += param1 ? 0 : 0.5;
               }
               if(this.mRewardsToClaim.hasAHTokens)
               {
                  this.createCurrencyReward(this.mRewardsToClaim.AHTokens,ServerConnection.CURRENCY_AH_TOKENS,_loc3_,_loc2_);
                  _loc2_ += param1 ? 0 : 0.5;
               }
               if(this.mRewardsToClaim.hasPortraits)
               {
                  this.createPortraitsReward(this.mRewardsToClaim.portraits,_loc2_,_loc3_);
                  _loc2_ += param1 ? 0 : 0.5;
               }
               if(this.mRewardsToClaim.hasSkins)
               {
                  this.createSkinsReward(this.mRewardsToClaim.skins,_loc2_,_loc3_);
                  _loc2_ += param1 ? 0 : 0.5;
               }
               if(this.mRewardsToClaim.hasBoosts)
               {
                  this.createBoostsReward(this.mRewardsToClaim.boosts,_loc2_,_loc3_);
                  _loc2_ += param1 ? 0 : 0.5;
               }
               if(this.mRewardsToClaim.hasCards)
               {
                  this.createCardsReward(this.mRewardsToClaim.cards,_loc2_,_loc3_,param1);
                  _loc2_ += param1 ? 0 : (this.mRequestCardsArr.length + 1) * this.CARD_UNFOLD_TIME * 2.5;
               }
               else
               {
                  this.mCardsReceived = true;
               }
               TweenMax.delayedCall(_loc2_,this.onRewardsUnfolded);
            }
            else
            {
               FSDebug.debugTrace("There are no rewards to claim");
            }
            this.trackDungeonRewards();
         }
      }
      
      private function getRewardPosition(param1:int) : FSCoordinate
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc2_:FSCoordinate = new FSCoordinate();
         var _loc3_:int = Starling.current.stage.stageWidth;
         var _loc4_:int = Starling.current.stage.stageHeight * 0.8;
         var _loc5_:int = param1 > 5 ? 4 : 3;
         if(param1 <= _loc5_)
         {
            _loc2_ = Utils.getXYPositionInContainer(this.mRewardIndex,_loc3_ / _loc5_,_loc4_ / 2,_loc3_,_loc4_,param1,1,false);
         }
         else
         {
            _loc2_ = Utils.getXYPositionInContainer(this.mRewardIndex,_loc3_ / _loc5_,_loc4_ / 2,_loc3_,_loc4_,_loc5_,2,false);
            if(this.mRewardIndex >= _loc5_ && param1 < 6)
            {
               _loc6_ = param1 - _loc5_;
               _loc7_ = this.mRewardIndex - _loc5_;
               _loc8_ = _loc2_.mY;
               _loc2_ = Utils.getXYPositionInContainer(_loc7_,_loc3_ / _loc5_,_loc4_ / 2,_loc3_,_loc4_,_loc6_,2,false);
               _loc2_.mY = _loc8_;
            }
         }
         return _loc2_;
      }
      
      private function trackDungeonRewards() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         if(InstanceMng.getServerConnection().isUserLoggedIn() && this.mIsDungeon)
         {
            _loc1_ = Boolean(this.mRewardsToClaim) && Boolean(this.mRewardsToClaim.hasGold) && Boolean(this.mRewardsToClaim.gold) ? int(this.mRewardsToClaim.gold) : 0;
            _loc2_ = Boolean(this.mRewardsToClaim) && Boolean(this.mRewardsToClaim.hasRaidPoints) && Boolean(this.mRewardsToClaim.raidPoints) ? int(this.mRewardsToClaim.raidPoints) : 0;
            _loc3_ = Boolean(this.mRewardsToClaim) && Boolean(this.mRewardsToClaim.hasQuestPoints) && Boolean(this.mRewardsToClaim.questPoints) ? int(this.mRewardsToClaim.questPoints) : 0;
            _loc4_ = Boolean(this.mRewardsToClaim) && Boolean(this.mRewardsToClaim.hasAHTokens) && Boolean(this.mRewardsToClaim.AHTokens) ? int(this.mRewardsToClaim.AHTokens) : 0;
            _loc5_ = Boolean(this.mRewardsToClaim) && Boolean(this.mRewardsToClaim.hasCards) && Boolean(this.mRewardsToClaim.cards) ? this.mRewardsToClaim.cards : "";
            _loc6_ = Boolean(this.mRewardsToClaim) && Boolean(this.mRewardsToClaim.hasPacks) && Boolean(this.mRewardsToClaim.packs) ? this.mRewardsToClaim.packs : "";
            _loc7_ = Boolean(this.mRewardsToClaim) && Boolean(this.mRewardsToClaim.hasPortraits) && Boolean(this.mRewardsToClaim.portraits) ? this.mRewardsToClaim.portraits : "";
            _loc8_ = Boolean(this.mRewardsToClaim) && Boolean(this.mRewardsToClaim.hasSkins) && Boolean(this.mRewardsToClaim.skins) ? this.mRewardsToClaim.skins : "";
            _loc9_ = Boolean(this.mRewardsToClaim) && Boolean(this.mRewardsToClaim.hasBoosts) && Boolean(this.mRewardsToClaim.boosts) ? this.mRewardsToClaim.boosts : "";
            _loc10_ = InstanceMng.getDungeonsMng().getCurrentDungeonDef().getIndex();
            _loc11_ = InstanceMng.getDungeonsMng().getCurrentDungeonDifficulty();
            _loc12_ = InstanceMng.getDungeonsMng().getVirtualLevelIndex();
            _loc13_ = InstanceMng.getDungeonsMng().hasFinishedAllLevels();
            InstanceMng.getServerConnection().addDungeonCompleted(_loc1_,_loc5_,_loc6_,_loc7_,_loc10_,_loc11_,_loc12_,_loc13_);
            FSTracker.trackMiscAction(FSTracker.CATEGORY_DUNGEONS,FSTracker.ACTION_DUNGEON_REWARDS_SUMMARY,this.mRewardsToClaim);
         }
      }
      
      private function onRewardsUnfolded() : void
      {
         var prepareToExit:Function = null;
         var pos:FSCoordinate = null;
         prepareToExit = function():void
         {
            createExitButton();
            setTouchable(true);
         };
         if(this.mPackAnimation)
         {
            pos = new FSCoordinate(this.mPackAnimation.x,Starling.current.stage.stageHeight + this.mPackAnimation.height * 2);
            SpecialFX.createTransition(this.mPackAnimation,pos,0.5,0,prepareToExit,null,Back.easeIn);
         }
         else
         {
            prepareToExit();
         }
      }
      
      private function createContainer(param1:int) : void
      {
         if(this.mContainer == null)
         {
            this.mContainer = new Component();
            this.mContainer.alignPivot();
            this.mContainer.x = Starling.current.stage.stageWidth / 2;
            this.mContainer.y = Starling.current.stage.stageHeight / 2.5;
         }
         else
         {
            this.mContainer.removeChildren();
         }
         addChild(this.mContainer);
      }
      
      private function createCurrencyReward(param1:int, param2:String, param3:int, param4:Number = 0) : void
      {
         var _loc5_:String = Utils.getShopCurrencyIcons(param2);
         var _loc6_:FSButton = new FSButton(Root.assets.getTexture(_loc5_),"0");
         _loc6_.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
         _loc6_.scaleWhenDown = 1;
         _loc6_.enableScaleOnMouseOver(false);
         _loc6_.disableTriggeredEvent();
         this.performItemOutOfChestEffect(_loc6_,param3,param4,true);
         ++this.mRewardIndex;
         this.mContainer.addChild(_loc6_);
         if(_loc6_.getTextfield())
         {
            TweenMax.delayedCall(param4,SpecialFX.createTextfieldAmountTransition,[_loc6_.getTextfield(),param1,1,true]);
         }
      }
      
      private function createCardsReward(param1:int, param2:Number, param3:int, param4:Boolean = false) : void
      {
         this.showCards(true,param2,param3,param4);
      }
      
      private function createSkinsReward(param1:String, param2:Number, param3:int) : void
      {
         var i:int = 0;
         var skinDef:HeroCharacterDef = null;
         var extraDelay:Number = NaN;
         var rewardImg:FSImage = null;
         var skins:String = param1;
         var delay:Number = param2;
         var itemsAmount:int = param3;
         var onEffectFinished:Function = function():void
         {
            Utils.requestScreenShake(0.5,10);
         };
         var skinsArr:Array = skins.split(",");
         i = 0;
         while(i < skinsArr.length)
         {
            skinDef = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(skinsArr[i]));
            if(skinDef)
            {
               rewardImg = new FSImage(Root.assets.getTexture(skinDef.getBGImageName()));
               extraDelay = i * 0.4;
               this.performItemOutOfChestEffect(rewardImg,itemsAmount,delay + extraDelay);
               ++this.mRewardIndex;
               InstanceMng.getUserDataMng().getOwnerUserData().addSkinToCatalog(skinDef.getSku());
               this.mContainer.addChild(rewardImg);
            }
            i++;
         }
      }
      
      private function createBoostsReward(param1:String, param2:Number, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc6_:ShopBoostDef = null;
         var _loc7_:BoostDef = null;
         var _loc11_:FSButton = null;
         var _loc5_:Array = param1.split(",");
         var _loc8_:String = "";
         var _loc9_:String = "";
         var _loc10_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc5_.length)
         {
            _loc9_ = String(_loc5_[_loc4_]).split(":")[0];
            _loc10_ = int(String(_loc5_[_loc4_]).split(":")[1]);
            _loc6_ = ShopBoostDef(InstanceMng.getShopBoostsDefMng().getDefBySku(_loc9_));
            if(_loc6_)
            {
               _loc8_ = _loc6_.getBGImageName();
            }
            _loc7_ = BoostDef(InstanceMng.getBoostsDefMng().getDefBySku(_loc9_));
            if(_loc7_)
            {
               _loc8_ = _loc7_.getBGBuy();
            }
            if(_loc8_)
            {
               _loc11_ = new FSButton(Root.assets.getTexture(_loc8_),"x" + _loc10_);
               _loc11_.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
               _loc11_.scaleWhenDown = 1;
               _loc11_.enableScaleOnMouseOver(false);
               _loc11_.disableTriggeredEvent();
               this.performItemOutOfChestEffect(_loc11_,param3,param2,true);
               ++this.mRewardIndex;
               this.mContainer.addChild(_loc11_);
            }
            _loc4_++;
         }
      }
      
      private function createPortraitsReward(param1:String, param2:Number, param3:int) : void
      {
         var i:int = 0;
         var addRewardToContainer:Function = null;
         var portraitsArr:Array = null;
         var portraitDef:PortraitDef = null;
         var rewardImg:FSImage = null;
         var portraits:String = param1;
         var delay:Number = param2;
         var itemsAmount:int = param3;
         addRewardToContainer = function():void
         {
            if(Boolean(mContainer) && Boolean(rewardImg))
            {
               mContainer.addChild(rewardImg);
            }
         };
         var onEffectFinished:Function = function():void
         {
            Utils.requestScreenShake(0.5,10);
            SpecialFX.tweenRotate(rewardImg,10);
         };
         if(portraits)
         {
            portraitsArr = portraits.split(",");
            i = 0;
            while(i < portraitsArr.length)
            {
               portraitDef = PortraitDef(InstanceMng.getPortraitsDefMng().getDefBySku(portraitsArr[i]));
               if(portraitDef)
               {
                  rewardImg = new FSImage(Root.assets.getTexture(portraitDef.getBGImageName()));
                  this.performItemOutOfChestEffect(rewardImg,itemsAmount,delay,false,true);
                  ++this.mRewardIndex;
                  TweenMax.delayedCall(delay,addRewardToContainer);
                  if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
                  {
                     InstanceMng.getUserDataMng().getOwnerUserData().addPortraitToCatalog(portraitDef.getSku());
                  }
                  addRewardToContainer();
               }
               i++;
            }
         }
      }
      
      public function init() : void
      {
         var performPackOpeningAnimation:Function = null;
         var packDef:PackDef = null;
         var packAnimBG:String = null;
         var popup:Popup = null;
         var packAnimPopup:PackAnimation = null;
         var p:Point = null;
         var playFallingAnim:Function = function():void
         {
            var _loc1_:int = Starling.current.stage.stageHeight;
            var _loc2_:TimelineLite = new TimelineLite();
            if(mPackAnimation)
            {
               _loc2_.to(mPackAnimation,0.75,{
                  "y":_loc1_ - mPackAnimation.height / 2,
                  "ease":Bounce.easeOut,
                  "onComplete":performPackOpeningAnimation
               });
            }
         };
         performPackOpeningAnimation = function():void
         {
            if(mPackAnimation)
            {
               TweenMax.delayedCall(0.25,mPackAnimation.performOpeningAnimation,[createRewards]);
            }
         };
         if(this.mBGQuad == null)
         {
            this.mBGQuad = new Quad(Starling.current.stage.stageWidth,Starling.current.stage.stageHeight,0);
            this.mBGQuad.touchable = true;
            this.mBGQuad.addEventListener(TouchEvent.TOUCH,this.onBGTouch);
         }
         this.mBGQuad.alpha = 0.7;
         addChild(this.mBGQuad);
         if(!this.CHEST_EFFECT)
         {
            this.skipIntros();
            return;
         }
         if(this.mChestBG != "")
         {
            packDef = PackDef(InstanceMng.getPacksDefMng().getDefBySku(this.mChestBG));
            packAnimBG = PackDef(packDef).getAnimBG();
            if(this.mPackAnimation == null)
            {
               this.mPackAnimation = new PackAnimation(packAnimBG);
            }
            else
            {
               this.mPackAnimation.restart(this.mChestBG);
            }
            this.mPackAnimation.alignPivot();
            this.mPackAnimation.touchable = false;
            popup = InstanceMng.getPopupMng().getPopupShown();
            if(popup != null && popup is PopupShopItem)
            {
               packAnimPopup = PopupShopItem(popup).getPackAnimation();
               this.mPackAnimation.scale = packAnimPopup ? packAnimPopup.scale : 1;
               SpecialFX.tweenToAlpha(popup,0,0.15,0,popup.closePopup);
               p = packAnimPopup ? packAnimPopup.localToGlobal(new Point(packAnimPopup.x,packAnimPopup.y),p) : new Point(Starling.current.stage.stageWidth / 2,-this.mPackAnimation.height);
               this.mPackAnimation.x = Starling.current.stage.stageWidth / 2;
               this.mPackAnimation.y = p.y;
            }
            else
            {
               this.mPackAnimation.x = Starling.current.stage.stageWidth / 2;
               this.mPackAnimation.y = -this.mPackAnimation.height;
               this.mPackAnimation.alpha = 0;
               SpecialFX.tweenToAlpha(this.mPackAnimation,1,0.25,0);
            }
            playFallingAnim();
            addChild(this.mPackAnimation);
         }
      }
      
      private function skipIntros() : void
      {
         TweenMax.killAll(true);
         this.createRewards(true);
         TweenMax.killAll(true);
         InstanceMng.getCurrentScreen().resetGuildsButtonPosition();
      }
      
      private function onBGTouch(param1:TouchEvent) : void
      {
         if(param1.getTouch(this.mBGQuad,TouchPhase.ENDED))
         {
            this.skipIntros();
         }
      }
      
      private function createExitButton() : void
      {
         var _loc1_:Texture = null;
         if(this.mExitButton == null)
         {
            _loc1_ = Root.assets.getTexture(Constants.ACCEPT_BUTTON_UP_NAME);
            this.mExitButton = new FSButton(_loc1_,TextManager.getText("TID_GEN_BUTTON_OK"),_loc1_,false,_loc1_);
            this.mExitButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mExitButton.x = Starling.current.stage.stageWidth / 2;
            this.mExitButton.y = Starling.current.stage.stageHeight - this.mExitButton.height / 1.5;
            this.mExitButton.addEventListener(Event.TRIGGERED,this.onExitTriggered);
         }
         this.mExitButton.alpha = 0;
         addChild(this.mExitButton);
         SpecialFX.tweenToAlpha(this.mExitButton,0.999,0.5,0);
      }
      
      private function onExitTriggered() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:PortraitDef = null;
         var _loc8_:Array = null;
         var _loc9_:HeroCharacterDef = null;
         var _loc10_:Array = null;
         var _loc11_:CardDef = null;
         var _loc12_:Vector.<String> = null;
         var _loc13_:Vector.<String> = null;
         var _loc14_:Boolean = false;
         var _loc15_:String = null;
         var _loc16_:FSShopInfoCard = null;
         if(Root.assets)
         {
            Root.assets.purgeQueue();
         }
         this.mServerResponseReceived = false;
         if(InstanceMng.getPopupMng().getPopupInBackground())
         {
            if(InstanceMng.getPopupMng().getPopupShown() != null)
            {
               if(InstanceMng.getPopupMng().getPopupShown() is PopupQuest)
               {
                  PopupQuest(InstanceMng.getPopupMng().getPopupShown()).onQuestsMngResetedCleanPopup();
               }
               else if(InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass)
               {
                  PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()).refreshQuestsSection(false);
               }
            }
            InstanceMng.getPopupMng().resumePopupInBackground();
         }
         Utils.stopSound(Constants.SOUND_VICTORY);
         if(Utils.isMusicOn() && Config.getConfig().battleHasOwnMusic())
         {
            if(Config.smTracklistModeOn)
            {
               Utils.loadNextTrack();
            }
            else
            {
               Utils.resumeAllSounds();
            }
         }
         if(InstanceMng.getUserDataMng())
         {
            InstanceMng.getUserDataMng().persistenceSaveData();
         }
         this.mRewardIndex = 0;
         var _loc1_:Boolean = false;
         if(Boolean(this.mRewardsToClaim) && Boolean(this.mRewardsToClaim.hasOwnProperty("hasPortraits")) && this.mRewardsToClaim.hasPortraits != null)
         {
            _loc6_ = String(this.mRewardsToClaim.portraits).split(",");
            if(_loc6_)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc6_.length)
               {
                  _loc7_ = PortraitDef(InstanceMng.getPortraitsDefMng().getDefBySku(_loc6_[_loc2_]));
                  if((Boolean(_loc7_)) && Boolean(Root.assets.getTexture(_loc7_.getBGImageName())))
                  {
                     _loc1_ = InstanceMng.getCurrentScreen() is FSShopScreen && FSShopScreen(InstanceMng.getCurrentScreen()).isBGBDisposable(_loc7_.getBGImageName());
                     if(_loc1_)
                     {
                        Root.assets.removeTexture(_loc7_.getBGImageName());
                     }
                  }
                  _loc2_++;
               }
            }
         }
         if(Boolean(this.mRewardsToClaim) && Boolean(this.mRewardsToClaim.hasOwnProperty("hasSkins")) && this.mRewardsToClaim.hasSkins != null)
         {
            _loc8_ = String(this.mRewardsToClaim.skins).split(",");
            if(_loc8_)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc8_.length)
               {
                  _loc9_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(_loc8_[_loc2_]));
                  if((Boolean(_loc9_)) && Boolean(Root.assets.getTexture(_loc9_.getBGImageName())))
                  {
                     _loc1_ = InstanceMng.getCurrentScreen() is FSShopScreen && FSShopScreen(InstanceMng.getCurrentScreen()).isBGBDisposable(_loc9_.getBGImageName());
                     if(_loc1_)
                     {
                        Root.assets.removeTexture(_loc9_.getBGImageName());
                     }
                  }
                  _loc2_++;
               }
            }
         }
         if(Boolean(this.mRewardsToClaim) && Boolean(this.mRewardsToClaim.hasOwnProperty("hasCards")) && this.mRewardsToClaim.hasCards != null)
         {
            _loc10_ = String(this.mRewardsToClaim.cards).split(",");
            _loc14_ = InstanceMng.getCurrentScreen() is FSShopScreen;
            if(_loc10_)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc10_.length)
               {
                  _loc11_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc10_[_loc2_]));
                  _loc13_ = _loc11_ ? InstanceMng.getCardsMng().getCardTiersOnPlaySoundnames(_loc11_) : null;
                  if(_loc11_)
                  {
                     if(_loc13_)
                     {
                        _loc3_ = 0;
                        while(_loc3_ < _loc13_.length)
                        {
                           _loc15_ = _loc13_[_loc3_];
                           if(_loc15_ != "" && _loc15_ != null)
                           {
                              Root.assets.removeSound(_loc15_);
                           }
                           _loc3_++;
                        }
                     }
                  }
                  _loc12_ = _loc11_ ? InstanceMng.getCardsMng().getCardTiersImageNames(_loc11_) : null;
                  if(Boolean(_loc11_) && Boolean(Root.assets.getTexture(_loc11_.getBGImageName())))
                  {
                     if(_loc12_)
                     {
                        _loc3_ = 0;
                        while(_loc3_ < _loc12_.length)
                        {
                           _loc1_ = !_loc14_ || _loc14_ && FSShopScreen(InstanceMng.getCurrentScreen()).isBGBDisposable(_loc12_[_loc3_]);
                           if(_loc1_)
                           {
                              Root.assets.removeTexture(_loc12_[_loc3_]);
                           }
                           else
                           {
                              FSDebug.debugTrace(_loc12_[_loc3_] + " NON DISPOSABLE");
                           }
                           _loc3_++;
                        }
                     }
                  }
                  _loc2_++;
               }
            }
         }
         if(this.mContainer)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mContainer.numChildren)
            {
               if(this.mContainer.getChildAt(_loc2_) != null && this.mContainer.getChildAt(_loc2_) is FSShopInfoCard)
               {
                  _loc16_ = FSShopInfoCard(this.mContainer.getChildAt(_loc2_));
               }
               if(_loc16_)
               {
                  _loc13_ = _loc16_.getSoundsUsed();
                  if(_loc13_)
                  {
                     _loc3_ = 0;
                     while(_loc3_ < _loc13_.length)
                     {
                        _loc15_ = _loc13_[_loc3_];
                        if(_loc15_ != "" && _loc15_ != null)
                        {
                           Root.assets.removeSound(_loc15_);
                        }
                        _loc3_++;
                     }
                  }
               }
               _loc2_++;
            }
            this.mContainer.removeChildren();
            this.mContainer.removeFromParent();
            this.mContainer = null;
         }
         removeFromParent(true);
         Screen.smOpeningPack = false;
         if(InstanceMng.getPopupMng().getPopupShown())
         {
            if(InstanceMng.getPopupMng().getPopupShown() is PopupStandard)
            {
               PopupStandard(InstanceMng.getPopupMng().getPopupShown()).enableCloseButton(true);
            }
            if(InstanceMng.getPopupMng().getPopupShown() is PopupRewards && Boolean(PopupRewards(InstanceMng.getPopupMng().getPopupShown()).getScrollcontainer()))
            {
               PopupRewards(InstanceMng.getPopupMng().getPopupShown()).getScrollcontainer().touchable = true;
            }
         }
         if(Boolean(InstanceMng.getCurrentScreen()) && Boolean(InstanceMng.getCurrentScreen().getOptionsPanel()))
         {
            InstanceMng.getCurrentScreen().getOptionsPanel().touchable = true;
         }
         if(Boolean(InstanceMng.getCurrentScreen()) && Boolean(InstanceMng.getCurrentScreen().getGuildsButton()))
         {
            InstanceMng.getCurrentScreen().getGuildsButton().touchable = true;
         }
         var _loc4_:Boolean = Root.smBattleData ? Boolean(Root.smBattleData.isDungeon) : false;
         var _loc5_:Boolean = Root.smBattleData ? Boolean(Root.smBattleData.isRaid) : false;
         if(!_loc4_ && !_loc5_)
         {
            if(InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               FSBattleScreen(InstanceMng.getCurrentScreen()).showMap();
            }
         }
         this.onRemovedPerformActions();
      }
      
      override public function dispose() : void
      {
         var _loc1_:Boolean = InstanceMng.getCurrentScreen() is FSBattleScreen || InstanceMng.getCurrentScreen() is FSMapScreen;
         if(this.mCardsReceived)
         {
            Utils.destroyArray(this.mRequestCardsArr);
            this.mRequestCardsArr = null;
         }
         if(this.mBGQuad)
         {
            this.mBGQuad.removeFromParent(true);
            this.mBGQuad = null;
         }
         if(InstanceMng.getComicsMng())
         {
            InstanceMng.getComicsMng().unload();
         }
         if(this.mContainer)
         {
            this.mContainer.removeFromParent(true);
            this.mContainer = null;
         }
         if(this.mExitButton)
         {
            this.mExitButton.removeFromParent(true);
            this.mExitButton = null;
         }
         if(Boolean(this.mCardsCatalog) && _loc1_)
         {
            DictionaryUtils.disposeCatalogCards(this.mCardsCatalog);
            DictionaryUtils.clearDictionary(this.mCardsCatalog);
            this.mCardsCatalog = null;
         }
         else
         {
            DictionaryUtils.clearDictionary(this.mCardsCatalog);
            this.mCardsCatalog = null;
         }
         if(this.mPackAnimation)
         {
            this.mPackAnimation.removeFromParent(true);
            this.mPackAnimation = null;
         }
         this.mPoint = null;
         this.mGlobalPoint = null;
         if(_loc1_)
         {
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesFactionsRarities",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("frames",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         }
         super.dispose();
      }
      
      private function onRemovedPerformActions() : void
      {
         var _loc2_:Boolean = false;
         var _loc1_:UserData = Utils.getOwnerUserData();
         switch(this.mOrigin)
         {
            case PacksDefMng.PACK_TUTORIAL_MAP_REWARD:
               if(_loc1_ != null)
               {
                  if(UserDataMng.smRatePopupShownThisSession == false && !_loc1_.flagsGetRatePopupShown() && _loc1_.getCurrentDifficulty() == UserDataMng.DIFFICULTY_EASY && !Utils.isDesktop())
                  {
                     UserDataMng.smRatePopupShownThisSession = true;
                     InstanceMng.getPopupMng().openRateAppPopup();
                  }
                  else if(InstanceMng.getCurrentScreen() is FSMapScreen)
                  {
                     FSMapScreen(InstanceMng.getCurrentScreen()).performPortraitTransition(true);
                  }
               }
               break;
            case PacksDefMng.PACK_DUNGEONS:
               _loc2_ = Boolean(Root.smBattleData) && Boolean(Root.smBattleData.isDungeon);
               if(_loc2_)
               {
                  InstanceMng.getDungeonsMng().resetDungeonsMng();
               }
               break;
            case PacksDefMng.PACK_RAIDS:
               InstanceMng.getRaidsMng().resetRaidsMng();
               break;
            case PacksDefMng.PACK_ACH_PROGRESS:
            case PacksDefMng.PACK_STARS_REWARD:
               InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
               if(InstanceMng.getPopupMng().getPopupShown() is PopupAchievements)
               {
                  PopupAchievements(InstanceMng.getPopupMng().getPopupShown()).lockUI(false);
               }
               break;
            case PacksDefMng.PACK_REWARD:
               if(_loc1_ != null)
               {
                  if(InstanceMng.getCurrentScreen() is FSMapScreen)
                  {
                     FSMapScreen(InstanceMng.getCurrentScreen()).performPortraitTransition(true);
                  }
               }
         }
         Utils.callGC();
      }
   }
}

