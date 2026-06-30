package com.fs.tcgengine.view.components.battle
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSCardPreview;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class GraveyardViewer extends Component
   {
      
      private var mQuadBG:Quad;
      
      private var mGraveyardCardsVector:Vector.<FSCardPreview>;
      
      private var mCloseGraveyardButton:FSButton;
      
      private var mOpenByAbility:Boolean;
      
      public function GraveyardViewer(param1:Boolean = false)
      {
         this.mOpenByAbility = param1;
         super();
         this.createUI();
         this.loadGraveyardCards();
      }
      
      private function loadGraveyardCards() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:CardDef = null;
         var _loc5_:UserBattleInfo = InstanceMng.getBattleEngine().isOwnerTurn() ? InstanceMng.getBattleEngine().getOwnerBattleInfo() : InstanceMng.getBattleEngine().getOpponentBattleInfo();
         if(_loc5_.isAnyCardInGraveyard())
         {
            _loc3_ = _loc5_.getGraveyardCards();
            if(this.mGraveyardCardsVector == null)
            {
               this.mGraveyardCardsVector = new Vector.<FSCardPreview>();
            }
            InstanceMng.getResourcesMng().loadCardImagesByArray(_loc3_);
            InstanceMng.getResourcesMng().loadAssets(this.onCardBGItemLoaded);
         }
      }
      
      private function onCardBGItemLoaded() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc7_:FSCard = null;
         var _loc6_:UserBattleInfo = InstanceMng.getBattleEngine().isOwnerTurn() ? InstanceMng.getBattleEngine().getOwnerBattleInfo() : InstanceMng.getBattleEngine().getOpponentBattleInfo();
         if(_loc6_.isAnyCardInGraveyard())
         {
            _loc5_ = _loc6_.getGraveyardCards();
            _loc1_ = 0;
            while(_loc1_ < _loc5_.length)
            {
               _loc3_ = _loc5_[_loc1_].split(":")[0];
               _loc7_ = InstanceMng.getCardsMng().createCardPreview(_loc3_);
               _loc7_.x = _loc7_.width * (_loc1_ + 1);
               _loc7_.y += _loc7_.height;
               if(!this.mOpenByAbility)
               {
                  _loc7_.touchable = false;
               }
               else
               {
                  _loc7_.activateHighlightTween();
               }
               this.mGraveyardCardsVector.push(_loc7_);
               addChild(_loc7_);
               _loc1_++;
            }
         }
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createGraveyardCloseButton();
      }
      
      private function createGraveyardCloseButton() : void
      {
         if(this.mCloseGraveyardButton == null)
         {
            this.mCloseGraveyardButton = new FSButton(Root.assets.getTexture("return_icon_on"));
            this.mCloseGraveyardButton.x = this.mQuadBG.width - this.mCloseGraveyardButton.width;
            this.mCloseGraveyardButton.y = this.mCloseGraveyardButton.height;
            this.mCloseGraveyardButton.addEventListener(TouchEvent.TOUCH,this.onCloseGraveyard);
            addChild(this.mCloseGraveyardButton);
         }
      }
      
      private function onCloseGraveyard(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this.mCloseGraveyardButton,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            this.dispose();
         }
      }
      
      private function createBG() : void
      {
         if(this.mQuadBG == null)
         {
            this.mQuadBG = new Quad(Starling.current.stage.stageWidth,Starling.current.stage.stageHeight,0);
            this.mQuadBG.alpha = 0.5;
            addChild(this.mQuadBG);
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         if(this.mQuadBG)
         {
            this.mQuadBG.removeFromParent(true);
            this.mQuadBG = null;
         }
         if(this.mCloseGraveyardButton)
         {
            this.mCloseGraveyardButton.removeFromParent(true);
            this.mCloseGraveyardButton = null;
         }
         if(this.mGraveyardCardsVector)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mGraveyardCardsVector.length)
            {
               this.mGraveyardCardsVector[_loc1_].removeFromParent();
               this.mGraveyardCardsVector[_loc1_].destroy();
               _loc1_++;
            }
            Utils.destroyArray(this.mGraveyardCardsVector);
            this.mGraveyardCardsVector = null;
         }
         super.dispose();
      }
      
      public function removeFromGraveyard(param1:FSCardPreview) : void
      {
         var _loc2_:UserBattleInfo = InstanceMng.getBattleEngine().isOwnerTurn() ? InstanceMng.getBattleEngine().getOwnerBattleInfo() : InstanceMng.getBattleEngine().getOpponentBattleInfo();
         this.lockCards();
         if(_loc2_.isCardInGraveyard(param1))
         {
            this.removeCardFromGraveyardVisual(param1);
            _loc2_.removeCardFromGraveyardLogic(param1);
            if(InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               FSBattleScreen(InstanceMng.getCurrentScreen()).addCardToHand(param1.getCardDef().getSku());
            }
            if(this.mOpenByAbility)
            {
               this.dispose();
            }
         }
      }
      
      private function lockCards() : void
      {
         var _loc1_:FSCardPreview = null;
         if(Boolean(this.mGraveyardCardsVector) && this.mGraveyardCardsVector.length > 0)
         {
            for each(_loc1_ in this.mGraveyardCardsVector)
            {
               _loc1_.touchable = false;
            }
         }
      }
      
      private function removeCardFromGraveyardVisual(param1:FSCardPreview) : void
      {
         var _loc2_:FSCardPreview = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(Boolean(this.mGraveyardCardsVector) && this.mGraveyardCardsVector.length > 0)
         {
            _loc3_ = false;
            _loc4_ = 0;
            for each(_loc2_ in this.mGraveyardCardsVector)
            {
               if(_loc2_.getCardDef().getSku() == param1.getCardDef().getSku() && !_loc3_)
               {
                  _loc2_.removeFromParent();
                  _loc2_.destroy();
                  _loc2_ = null;
                  this.mGraveyardCardsVector.splice(_loc4_,1);
                  _loc3_ = true;
               }
               _loc4_++;
            }
         }
      }
   }
}

