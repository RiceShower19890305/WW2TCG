package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import starling.display.Quad;
   
   public class CardFusionLayer extends Component
   {
      
      private var mCard:FSCard;
      
      private var mBGQuad:Quad;
      
      private var mIcon:FSImage;
      
      private var mText:FSTextfield;
      
      public function CardFusionLayer(param1:FSCard)
      {
         this.mCard = param1;
         super();
         this.createUI();
         alignPivot();
      }
      
      public function createUI(param1:FSCard = null) : void
      {
         this.mCard = param1 ? param1 : this.mCard;
         this.createQuadBG();
         this.createIcon("fusion");
         this.createText(TextManager.getText("TID_CARDFUSION"));
      }
      
      protected function createText(param1:String = "") : void
      {
         var _loc4_:int = 0;
         var _loc2_:RarityDef = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(this.mCard.getCardDef().getCardRarity()));
         var _loc3_:uint = this.getRarityColor(_loc2_.getIndex());
         if(Boolean(this.mBGQuad) && Boolean(this.mIcon) && this.mText == null)
         {
            _loc4_ = this.mBGQuad.width - this.mIcon.width;
            this.mText = new FSTextfield(_loc4_,this.mBGQuad.height,param1,_loc3_,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
            this.mText.x = this.mIcon.x + this.mIcon.width / 2;
            this.mText.y = this.mBGQuad.y;
            this.mText.touchable = false;
            addChild(this.mText);
         }
         else if(this.mText)
         {
            this.mText.color = _loc3_;
         }
      }
      
      protected function createIcon(param1:String) : void
      {
         var _loc2_:RarityDef = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(this.mCard.getCardDef().getCardRarity()));
         var _loc3_:String = param1 + "_arrow_rarity_0" + int(_loc2_.getSku().split("_")[1]);
         if(Boolean(this.mBGQuad) && this.mIcon == null)
         {
            this.mIcon = new FSImage(Root.assets.getTexture(_loc3_));
            this.mIcon.x = this.mBGQuad.x;
            this.mIcon.touchable = false;
            addChild(this.mIcon);
         }
         else if(this.mIcon)
         {
            this.mIcon.texture = Root.assets.getTexture(_loc3_);
         }
         if(Boolean(this.mIcon) && Boolean(this.mBGQuad))
         {
            this.mIcon.x = this.mBGQuad.x;
            this.mIcon.y = this.mBGQuad.y + this.mBGQuad.height / 2 - this.mIcon.height / 2;
            SpecialFX.createYoYoZoomTransition(this.mIcon,1.3,1,-1);
         }
      }
      
      private function createQuadBG() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         if(this.mBGQuad == null)
         {
            _loc1_ = this.mCard.getSubcomponentsContainer().width * 0.975;
            _loc2_ = this.mCard.getSubcomponentsContainer().x;
            this.mBGQuad = new Quad(_loc1_,this.mCard.height * 0.25,0);
            this.mBGQuad.x = _loc2_;
            this.mBGQuad.alpha = 0.5;
            this.mBGQuad.touchable = false;
            addChild(this.mBGQuad);
         }
      }
      
      protected function getRarityColor(param1:int) : uint
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case 0:
               _loc2_ = Config.getConfig().gameGetCommonColor();
               break;
            case 1:
               _loc2_ = Config.getConfig().gameGetUnCommonColor();
               break;
            case 2:
               _loc2_ = Config.getConfig().gameGetRareColor();
               break;
            case 3:
               _loc2_ = Config.getConfig().gameGetEpicColor();
               break;
            case 4:
               _loc2_ = Config.getConfig().gameGetLegendaryColor();
               break;
            case 5:
               _loc2_ = Config.getConfig().gameGetMegaLegendaryColor();
               break;
            case 6:
               _loc2_ = Config.getConfig().gameGetUltraLegendaryColor();
               break;
            case 7:
               _loc2_ = Config.getConfig().gameGetUberLegendaryColor();
         }
         return _loc2_;
      }
      
      override public function dispose() : void
      {
         TweenMax.killTweensOf(this.mIcon);
         if(this.mBGQuad)
         {
            this.mBGQuad.removeFromParent(true);
            this.mBGQuad = null;
         }
         if(this.mIcon)
         {
            this.mIcon.removeFromParent(true);
            this.mIcon = null;
         }
         if(this.mText)
         {
            this.mText.removeFromParent(true);
            this.mText = null;
         }
         this.mCard = null;
         super.dispose();
      }
   }
}

