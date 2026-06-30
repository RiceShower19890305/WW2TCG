package com.fs.tcgengine.view.components.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   
   public class FSCurrencyVisor extends Component
   {
      
      private var mBG:FSImage;
      
      private var mCurrencyImage:FSImage;
      
      private var mCurrencyType:String;
      
      private var mCurrencyTextfield:FSTextfield;
      
      private var mShowFastPurchasePopupOnClick:Boolean;
      
      private var mCraftCurrencyCardSku:String;
      
      private var mCraftCurrencyCardDef:CardDef;
      
      public function FSCurrencyVisor(param1:String, param2:String = "")
      {
         super();
         this.mCurrencyType = param1;
         this.mCraftCurrencyCardSku = param2;
         this.mCraftCurrencyCardDef = this.mCraftCurrencyCardSku != "" ? CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.mCraftCurrencyCardSku)) : null;
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createCurrencyIcon();
         this.createCurrencyTextfield();
      }
      
      private function createBG() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mBG == null)
         {
            _loc1_ = this.mCraftCurrencyCardDef ? "craft_material_slot" : "shop_top_button";
            this.mBG = new FSImage(Root.assets.getTexture(_loc1_));
            _loc2_ = _loc1_ == "craft_material_slot" ? 47 : int(80.75);
            _loc3_ = _loc1_ == "craft_material_slot" ? int(22.75) : 31;
            Utils.setupImage9Scale(this.mBG,15,13.5,3,2.5,_loc2_,_loc3_);
            this.mBG.alignPivot();
            if(this.mCraftCurrencyCardDef)
            {
               this.mBG.x += this.mBG.width / 2;
               this.mBG.y += this.mBG.height / 2;
            }
            addChild(this.mBG);
         }
      }
      
      private function createCurrencyIcon() : void
      {
         var _loc1_:String = "";
         switch(this.mCurrencyType)
         {
            case ServerConnection.CURRENCY_GOLD:
               _loc1_ = "shop_top_icon_gold";
               break;
            case ServerConnection.CURRENCY_RAID_COINS:
               _loc1_ = "shop_top_icon_raids";
               break;
            case ServerConnection.CURRENCY_QUEST_COINS:
               _loc1_ = "shop_top_icon_quests";
               break;
            case ServerConnection.CURRENCY_AH_TOKENS:
               _loc1_ = "shop_top_icon_tokens";
               break;
            case ServerConnection.CURRENCY_CRAFT_MATERIAL:
               _loc1_ = this.mCraftCurrencyCardDef.getCraftMaterialBG();
         }
         if(this.mCurrencyImage == null)
         {
            this.mCurrencyImage = new FSImage(Root.assets.getTexture(_loc1_));
            this.mCurrencyImage.alignPivot();
            this.mCurrencyImage.x = this.mBG.x + this.mBG.width / 2;
            this.mCurrencyImage.y = this.mBG.y;
            addChild(this.mCurrencyImage);
         }
      }
      
      private function createCurrencyTextfield() : void
      {
         var _loc2_:int = 0;
         if(this.mCurrencyTextfield == null)
         {
            _loc2_ = width * 0.58;
            this.mCurrencyTextfield = new FSTextfield(_loc2_,this.mBG.height * 0.8,"");
            this.mCurrencyTextfield.alignPivot();
            this.mCurrencyTextfield.x = this.mBG.x - this.mCurrencyImage.width / 6.25;
            this.mCurrencyTextfield.y = this.mBG.y;
            addChild(this.mCurrencyTextfield);
         }
         this.refreshCurrencyAmount();
         var _loc1_:String = "";
         switch(this.mCurrencyType)
         {
            case ServerConnection.CURRENCY_GOLD:
               _loc1_ = TextManager.getText("TID_SHOP_CURRENCY_DESC_GOLD");
               break;
            case ServerConnection.CURRENCY_RAID_COINS:
               _loc1_ = TextManager.getText("TID_SHOP_CURRENCY_DESC_RAIDCOINS");
               break;
            case ServerConnection.CURRENCY_QUEST_COINS:
               _loc1_ = TextManager.getText("TID_SHOP_CURRENCY_DESC_QUESTCOINS");
               break;
            case ServerConnection.CURRENCY_AH_TOKENS:
               _loc1_ = TextManager.getText("TID_SHOP_CURRENCY_DESC_TOKENS");
               break;
            case ServerConnection.CURRENCY_CRAFT_MATERIAL:
               _loc1_ = this.mCraftCurrencyCardDef.getName();
         }
         if(_loc1_ != "")
         {
            setTooltipText(_loc1_);
         }
      }
      
      public function refreshCurrencyAmount(param1:Boolean = false) : void
      {
         var _loc2_:UserData = null;
         var _loc3_:Number = NaN;
         if(this.mCurrencyTextfield)
         {
            _loc2_ = Utils.getOwnerUserData();
            if(_loc2_)
            {
               switch(this.mCurrencyType)
               {
                  case ServerConnection.CURRENCY_GOLD:
                     _loc3_ = _loc2_.getGold();
                     break;
                  case ServerConnection.CURRENCY_RAID_COINS:
                     _loc3_ = _loc2_.getRaidCoins();
                     break;
                  case ServerConnection.CURRENCY_QUEST_COINS:
                     _loc3_ = _loc2_.getQuestsCoins();
                     break;
                  case ServerConnection.CURRENCY_AH_TOKENS:
                     _loc3_ = _loc2_.getAuctionTickets();
                     break;
                  case ServerConnection.CURRENCY_CRAFT_MATERIAL:
                     _loc3_ = _loc2_.getCardAmount(this.mCraftCurrencyCardSku);
               }
               if(param1)
               {
                  SpecialFX.createTextfieldAmountTransition(this.mCurrencyTextfield,_loc3_,0.25,true);
               }
               else
               {
                  this.mCurrencyTextfield.text = _loc3_.toString();
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mCurrencyImage)
         {
            this.mCurrencyImage.removeFromParent(true);
            this.mCurrencyImage = null;
         }
         if(this.mCurrencyTextfield)
         {
            this.mCurrencyTextfield.removeFromParent(true);
            this.mCurrencyTextfield = null;
         }
         this.mCraftCurrencyCardDef = null;
         super.dispose();
      }
   }
}

