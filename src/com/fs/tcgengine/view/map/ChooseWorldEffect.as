package com.fs.tcgengine.view.map
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.MapDef;
   import com.fs.tcgengine.model.rules.WorldDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSShopInfoCard;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class ChooseWorldEffect extends Component
   {
      
      private var mBGQuad:Quad;
      
      private var mInfoContainer:Component;
      
      private var mWorld1Def:WorldDef;
      
      private var mWorld2Def:WorldDef;
      
      private var mDescription:FSTextfield;
      
      private var mChooseWorldButton:FSButton;
      
      private var mBackToWorldsSelectionButton:FSButton;
      
      private var mWorld1Img:FSImage;
      
      private var mWorld2Img:FSImage;
      
      private var mCurrentHighlightedWorldDef:WorldDef;
      
      private var mRewardsWorld1:Vector.<FSShopInfoCard>;
      
      private var mRewardsWorld2:Vector.<FSShopInfoCard>;
      
      private var mRewardsTextfield:FSTextfield;
      
      private var mWorld1CardReward1:FSCard;
      
      private var mWorld1CardReward2:FSCard;
      
      private var mWorld2CardReward1:FSCard;
      
      private var mWorld2CardReward2:FSCard;
      
      public function ChooseWorldEffect(param1:WorldDef, param2:WorldDef)
      {
         super();
         this.mWorld1Def = param1;
         this.mWorld2Def = param2;
         this.setResourcesToLoad();
      }
      
      private function setResourcesToLoad() : void
      {
         if(this.mBGQuad == null)
         {
            this.mBGQuad = new Quad(Starling.current.stage.stageWidth,Starling.current.stage.stageHeight,0);
            this.mBGQuad.touchable = true;
         }
         this.mBGQuad.alpha = 0.9;
         addChild(this.mBGQuad);
         InstanceMng.getCurrentScreen().showLoadingIcon(true,true);
         InstanceMng.getResourcesMng().addResourcesFolderByName("frames");
         InstanceMng.getResourcesMng().addResourcesFolderByName("framesFactionsRarities");
         InstanceMng.getResourcesMng().addResourceToLoad("worlds/" + this.mWorld1Def.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
         InstanceMng.getResourcesMng().addResourceToLoad("worlds/" + this.mWorld2Def.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
         InstanceMng.getResourcesMng().loadCardImagesByArray(this.mWorld1Def.getRewardsSkus());
         InstanceMng.getResourcesMng().loadCardImagesByArray(this.mWorld2Def.getRewardsSkus());
         InstanceMng.getResourcesMng().loadAssets(this.notifyAssetsLoaded);
      }
      
      private function notifyAssetsLoaded() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
         this.init();
      }
      
      public function init() : void
      {
         this.mWorld1CardReward1 = InstanceMng.getCardsMng().createCard(this.mWorld1Def.getRewardsSkus()[0]);
         this.mWorld1CardReward2 = InstanceMng.getCardsMng().createCard(this.mWorld1Def.getRewardsSkus()[1]);
         this.mWorld2CardReward1 = InstanceMng.getCardsMng().createCard(this.mWorld2Def.getRewardsSkus()[0]);
         this.mWorld2CardReward2 = InstanceMng.getCardsMng().createCard(this.mWorld2Def.getRewardsSkus()[1]);
         if(this.mWorld1Img == null)
         {
            this.mWorld1Img = new FSImage(Root.assets.getTexture(this.mWorld1Def.getBGImageName()));
            this.mWorld1Img.alignPivot();
            this.mWorld1Img.x = this.mWorld1Img.width / 2;
            this.mWorld1Img.y = Starling.current.stage.stageHeight / 2;
            this.mWorld1Img.alpha = 0;
            addChild(this.mWorld1Img);
            this.mWorld1Img.addEventListener(TouchEvent.TOUCH,this.onImage1Touch);
         }
         if(this.mWorld2Img == null)
         {
            this.mWorld2Img = new FSImage(Root.assets.getTexture(this.mWorld2Def.getBGImageName()));
            this.mWorld2Img.alignPivot();
            this.mWorld2Img.x = Starling.current.stage.stageWidth - this.mWorld2Img.width / 2;
            this.mWorld2Img.y = this.mWorld1Img.y;
            this.mWorld2Img.alpha = 0;
            addChild(this.mWorld2Img);
            this.mWorld2Img.addEventListener(TouchEvent.TOUCH,this.onImage2Touch);
         }
         SpecialFX.tweenToAlpha(this.mWorld1Img,1,1,0);
         SpecialFX.tweenToAlpha(this.mWorld2Img,1,1,0);
      }
      
      private function onImage1Touch(param1:TouchEvent) : void
      {
         var _loc3_:FSCoordinate = null;
         var _loc2_:Touch = param1 ? param1.getTouch(this.mWorld1Img,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            if(this.mCurrentHighlightedWorldDef != this.mWorld1Def)
            {
               this.mWorld2Img.touchable = false;
               _loc3_ = new FSCoordinate(this.mWorld2Img.x,-this.mWorld2Img.height);
               SpecialFX.createTransition(this.mWorld2Img,_loc3_,0.15,0,this.createContainer,[this.mWorld1Def,this.mWorld1Img,Align.RIGHT]);
            }
         }
         this.mWorld2Img.alpha = Boolean(param1) && Boolean(param1.getTouch(this.mWorld1Img,TouchPhase.HOVER)) ? 0.75 : 1;
      }
      
      private function onImage2Touch(param1:TouchEvent) : void
      {
         var _loc3_:FSCoordinate = null;
         var _loc2_:Touch = param1 ? param1.getTouch(this.mWorld2Img,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            if(this.mCurrentHighlightedWorldDef != this.mWorld2Def)
            {
               this.mWorld1Img.touchable = false;
               _loc3_ = new FSCoordinate(this.mWorld1Img.x,-this.mWorld1Img.height / 2);
               SpecialFX.createTransition(this.mWorld1Img,_loc3_,0.15,0,this.createContainer,[this.mWorld2Def,this.mWorld2Img,Align.LEFT]);
            }
         }
         this.mWorld1Img.alpha = Boolean(param1) && Boolean(param1.getTouch(this.mWorld2Img,TouchPhase.HOVER)) ? 0.75 : 1;
      }
      
      private function createContainer(param1:WorldDef, param2:FSImage, param3:String) : void
      {
         var _loc5_:int = 0;
         this.mCurrentHighlightedWorldDef = param1;
         if(this.mInfoContainer == null)
         {
            this.mInfoContainer = new Component();
         }
         var _loc4_:int = Starling.current.stage.stageWidth;
         _loc5_ = Starling.current.stage.stageHeight;
         if(this.mDescription == null)
         {
            this.mDescription = new FSTextfield(_loc4_ * 0.95 - param2.width,_loc5_ * 0.35,"",16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
         }
         this.mDescription.width = _loc4_ * 0.95 - param2.width;
         this.mDescription.x = 0;
         this.mDescription.y = 0;
         this.mDescription.text = param1.getDesc();
         this.mInfoContainer.addChild(this.mDescription);
         if(this.mRewardsTextfield == null)
         {
            this.mRewardsTextfield = new FSTextfield(this.mDescription.width,this.mDescription.height * 0.25);
            this.mRewardsTextfield.x = 0;
            this.mRewardsTextfield.y = this.mDescription.y + this.mDescription.height;
            this.mRewardsTextfield.format.verticalAlign = Align.BOTTOM;
            this.mRewardsTextfield.text = TextManager.getText("TID_GEN_LEVEL_REWARDS");
            this.mInfoContainer.addChild(this.mRewardsTextfield);
         }
         if(this.mRewardsWorld1)
         {
            this.cleanCardsRewardsVec(this.mRewardsWorld1);
         }
         if(this.mRewardsWorld2)
         {
            this.cleanCardsRewardsVec(this.mRewardsWorld2);
         }
         if(this.mCurrentHighlightedWorldDef == this.mWorld1Def)
         {
            this.mRewardsWorld1 = this.createCardRewards(param1,this.mRewardsWorld1);
         }
         else
         {
            this.mRewardsWorld2 = this.createCardRewards(param1,this.mRewardsWorld2);
         }
         if(this.mChooseWorldButton == null)
         {
            this.mChooseWorldButton = new FSButton(Root.assets.getTexture("accept_button_large"),TextManager.getText("TID_DUNGEON_CHOOSE_BUTTON"));
            this.mChooseWorldButton.addEventListener(Event.TRIGGERED,this.onChooseWorld);
         }
         this.mChooseWorldButton.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
         this.mChooseWorldButton.x = this.mDescription.x + this.mDescription.width / 2;
         this.mChooseWorldButton.y = _loc5_ - this.mChooseWorldButton.height * 1.35;
         this.mInfoContainer.addChild(this.mChooseWorldButton);
         if(this.mBackToWorldsSelectionButton == null)
         {
            this.mBackToWorldsSelectionButton = new FSButton(Root.assets.getTexture("back_button_2"));
            this.mBackToWorldsSelectionButton.addEventListener(Event.TRIGGERED,this.onBackToWorldsSelection);
         }
         this.mChooseWorldButton.x -= this.mBackToWorldsSelectionButton.width / 2;
         this.mBackToWorldsSelectionButton.x = this.mChooseWorldButton.x + this.mChooseWorldButton.width / 2 + this.mBackToWorldsSelectionButton.width / 2;
         this.mBackToWorldsSelectionButton.y = this.mChooseWorldButton.y;
         this.mInfoContainer.addChild(this.mBackToWorldsSelectionButton);
         this.createContainerTransition(param3,true);
      }
      
      private function createCardRewards(param1:WorldDef, param2:Vector.<FSShopInfoCard>) : Vector.<FSShopInfoCard>
      {
         var _loc4_:FSShopInfoCard = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:FSCard = null;
         var _loc8_:FSTextfield = null;
         var _loc3_:Array = param1.getRewardsSkus();
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            if(param2 == null)
            {
               param2 = new Vector.<FSShopInfoCard>();
            }
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               _loc7_ = this.getCardReference(param1,_loc6_);
               if(_loc7_)
               {
                  _loc4_ = InstanceMng.getResourcesMng().createShopInfoCard(_loc7_,1,false,false,true);
                  _loc4_.alignPivot();
                  _loc4_.x = _loc6_ == 0 ? this.mRewardsTextfield.x + _loc4_.width / 1.25 : this.mRewardsTextfield.x + this.mRewardsTextfield.width - _loc4_.width / 1.25;
                  _loc4_.y = _loc6_ == 0 ? this.mRewardsTextfield.y + this.mRewardsTextfield.height * 1.1 + _loc4_.height / 2 : param2[0].y;
                  this.mInfoContainer.addChild(_loc4_);
                  _loc5_ = _loc6_ == 0 ? TextManager.getText("TID_LEVEL_DIFF_1") : TextManager.getText("TID_LEVEL_DIFF_3");
                  _loc8_ = new FSTextfield(_loc4_.width,_loc4_.height * 0.25,_loc5_,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
                  _loc8_.x = _loc4_.x - _loc8_.width / 2;
                  _loc8_.y = _loc4_.y + _loc4_.height / 1.75;
                  _loc8_.format.verticalAlign = Align.TOP;
                  this.mInfoContainer.addChild(_loc8_);
                  param2.push(_loc4_);
               }
               _loc6_++;
            }
         }
         return param2;
      }
      
      private function getCardReference(param1:WorldDef, param2:int) : FSCard
      {
         if(param1 == this.mWorld1Def)
         {
            return param2 == 0 ? this.mWorld1CardReward1 : this.mWorld1CardReward2;
         }
         return param2 == 0 ? this.mWorld2CardReward1 : this.mWorld2CardReward2;
      }
      
      private function onChooseWorld() : void
      {
         InstanceMng.getPopupMng().openConfirmationPopup(TextManager.getText("TID_WORLD_CONFIRMATION"),this.onChoose,this.onCancel);
      }
      
      private function onChoose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MapDef = null;
         var _loc3_:int = 0;
         if(InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            _loc1_ = FSMapScreen(InstanceMng.getCurrentScreen()).getCurrentMapIndex();
            _loc2_ = MapDef(InstanceMng.getMapsDefMng().getDefBySku("map_" + Utils.transformValueToString(_loc1_.toString(),2)));
            _loc3_ = _loc2_.getWorldParentIndex();
            InstanceMng.getUserDataMng().getOwnerUserData().setMapWorldChoice(_loc3_,this.mCurrentHighlightedWorldDef.getIndex());
            InstanceMng.getUserDataMng().updateMapWorldChoices();
            removeFromParent(true);
            InstanceMng.getCurrentScreen().dispatchEventWith(Screen.GO_TO_MAP,true);
         }
      }
      
      private function onCancel() : void
      {
      }
      
      private function createContainerTransition(param1:String, param2:Boolean, param3:Function = null) : void
      {
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         var _loc4_:int = Starling.current.stage.stageWidth;
         var _loc5_:int = Starling.current.stage.stageHeight;
         if(param2)
         {
            this.mInfoContainer.x = param1 == Align.RIGHT ? _loc4_ : -this.mInfoContainer.width;
            addChild(this.mInfoContainer);
         }
         this.mInfoContainer.y = (_loc5_ - this.mInfoContainer.height) / 2;
         if(param2)
         {
            _loc8_ = param1 == Align.RIGHT ? int((_loc4_ - (this.mInfoContainer.width + this.mWorld1Img.width)) / 2) : int((_loc4_ - (this.mInfoContainer.width + this.mWorld2Img.width)) / 2);
            _loc6_ = param1 == Align.RIGHT ? int(this.mWorld1Img.width + _loc8_ / 2) : int(_loc8_ / 2);
         }
         else
         {
            _loc6_ = param1 == Align.RIGHT ? int(_loc4_ + this.mInfoContainer.width) : int(-this.mInfoContainer.width);
         }
         var _loc7_:FSCoordinate = new FSCoordinate(_loc6_,(_loc5_ - this.mInfoContainer.height) / 2);
         SpecialFX.createTransition(this.mInfoContainer,_loc7_,0.15,0,param3);
      }
      
      private function onBackToWorldsSelection(param1:Event) : void
      {
         var stageW:int = 0;
         var onContainerHidden:Function = null;
         var e:Event = param1;
         onContainerHidden = function():void
         {
            var worldImg:FSImage = null;
            var onWorldInPosition:Function = null;
            onWorldInPosition = function():void
            {
               worldImg.touchable = true;
               mCurrentHighlightedWorldDef = null;
               mInfoContainer.removeFromParent();
            };
            worldImg = mCurrentHighlightedWorldDef == mWorld1Def ? mWorld2Img : mWorld1Img;
            var posX:int = mCurrentHighlightedWorldDef == mWorld1Def ? int(stageW - worldImg.width / 2) : int(worldImg.width / 2);
            var coord:FSCoordinate = new FSCoordinate(posX,Starling.current.stage.stageHeight / 2);
            SpecialFX.createTransition(worldImg,coord,0.25,0,onWorldInPosition);
         };
         stageW = Starling.current.stage.stageWidth;
         var align:String = this.mCurrentHighlightedWorldDef == this.mWorld1Def ? Align.RIGHT : Align.LEFT;
         this.createContainerTransition(align,false,onContainerHidden);
      }
      
      private function cleanCardsRewardsVec(param1:Vector.<FSShopInfoCard>) : Vector.<FSShopInfoCard>
      {
         var _loc2_:FSShopInfoCard = null;
         var _loc3_:int = 0;
         if(param1)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc2_ = param1[_loc3_];
               if(_loc2_)
               {
                  _loc2_.removeFromParent();
                  _loc2_.destroy();
               }
               _loc3_++;
            }
            Utils.destroyArray(param1);
            param1 = null;
         }
         return param1;
      }
      
      override public function dispose() : void
      {
         if(this.mBGQuad)
         {
            this.mBGQuad.removeFromParent(true);
            this.mBGQuad = null;
         }
         if(this.mDescription)
         {
            this.mDescription.removeFromParent(true);
            this.mDescription = null;
         }
         if(this.mChooseWorldButton)
         {
            this.mChooseWorldButton.removeFromParent(true);
            this.mChooseWorldButton = null;
         }
         if(this.mBackToWorldsSelectionButton)
         {
            this.mBackToWorldsSelectionButton.removeFromParent(true);
            this.mBackToWorldsSelectionButton = null;
         }
         if(this.mWorld1Img)
         {
            this.mWorld1Img.removeFromParent(true);
            this.mWorld1Img = null;
         }
         if(this.mWorld2Img)
         {
            this.mWorld2Img.removeFromParent(true);
            this.mWorld2Img = null;
         }
         if(this.mInfoContainer)
         {
            this.mInfoContainer.removeFromParent(true);
            this.mInfoContainer = null;
         }
         if(this.mRewardsTextfield)
         {
            this.mRewardsTextfield.removeFromParent(true);
            this.mRewardsTextfield = null;
         }
         this.cleanCardsRewardsVec(this.mRewardsWorld1);
         this.cleanCardsRewardsVec(this.mRewardsWorld2);
         this.mRewardsWorld1 = null;
         this.mRewardsWorld2 = null;
         DictionaryUtils.disposeCard(this.mWorld1CardReward1);
         DictionaryUtils.disposeCard(this.mWorld1CardReward2);
         DictionaryUtils.disposeCard(this.mWorld2CardReward1);
         DictionaryUtils.disposeCard(this.mWorld2CardReward2);
         this.mWorld1CardReward1 = null;
         this.mWorld1CardReward2 = null;
         this.mWorld2CardReward1 = null;
         this.mWorld2CardReward2 = null;
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("frames",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesXL",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("framesFactionsRarities",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         Root.assets.removeTexture(this.mWorld1Def.getBGImageName());
         Root.assets.removeTexture(this.mWorld2Def.getBGImageName());
         this.mWorld1Def = null;
         this.mWorld2Def = null;
         this.mCurrentHighlightedWorldDef = null;
         super.dispose();
      }
   }
}

