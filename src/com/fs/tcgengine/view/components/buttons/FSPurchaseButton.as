package com.fs.tcgengine.view.components.buttons
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Event;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class FSPurchaseButton extends FSSideImageButton
   {
      
      private var mAmount:Number;
      
      private var mCurrency:String;
      
      private var mSuccessFunction:Function;
      
      private var mSuccessParams:Array;
      
      private var mPriceCurrencyIcon:FSImage;
      
      public function FSPurchaseButton(param1:String, param2:Number, param3:Function, param4:Array = null, param5:String = "", param6:String = "center", param7:String = "accept_button_up")
      {
         this.mCurrency = param1;
         this.mAmount = param2;
         this.mSuccessFunction = param3;
         this.mSuccessParams = param4;
         var _loc8_:Texture = Root.assets.getTexture(param7);
         param5 = param5 != "" ? param5 : param2.toString();
         super(_loc8_,param5,param6,downState);
         Utils.handleButton9Scale(this,param7);
         if(getTextfield())
         {
            fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
         }
         this.createCurrencyIcon();
         this.checkEnoughCurrency();
         addEventListener(Event.TRIGGERED,this.onTriggered);
      }
      
      private function onTriggered(param1:Event) : void
      {
         if(this.mCurrency != ServerConnection.CURRENCY_REAL)
         {
            if(this.mSuccessFunction != null)
            {
               if(this.mSuccessParams != null)
               {
                  this.mSuccessFunction.apply(null,this.mSuccessParams);
               }
               else
               {
                  this.mSuccessFunction();
               }
            }
         }
      }
      
      private function checkEnoughCurrency() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:Boolean = false;
         if(this.mCurrency != ServerConnection.CURRENCY_REAL)
         {
            _loc1_ = Utils.getOwnerUserData();
            _loc2_ = _loc1_ ? _loc1_.hasEnoughCurrency(this.mCurrency,this.mAmount) : false;
            fontColor = !_loc2_ ? 16711680 : fontColor;
         }
      }
      
      private function createCurrencyIcon() : void
      {
         var _loc1_:String = null;
         if(this.mCurrency != ServerConnection.CURRENCY_REAL)
         {
            _loc1_ = "";
            switch(this.mCurrency)
            {
               case ServerConnection.CURRENCY_GOLD:
                  _loc1_ = "gold_icon";
                  break;
               case ServerConnection.CURRENCY_QUEST_COINS:
                  _loc1_ = "gem_quest_icon";
                  break;
               case ServerConnection.CURRENCY_RAID_COINS:
                  _loc1_ = "raid_coin_icon";
            }
            if(_loc1_ != "")
            {
               if(this.mPriceCurrencyIcon == null)
               {
                  this.mPriceCurrencyIcon = new FSImage(Root.assets.getTexture(_loc1_));
                  this.mPriceCurrencyIcon.scale = 0.75;
                  addChildToContents(this.mPriceCurrencyIcon);
               }
               else
               {
                  this.mPriceCurrencyIcon.texture = Root.assets.getTexture(_loc1_);
               }
               getTextfield().width = width * 0.85 - this.mPriceCurrencyIcon.width;
               getTextfield().format.horizontalAlign = Align.CENTER;
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.mPriceCurrencyIcon)
         {
            this.mPriceCurrencyIcon.removeFromParent();
            this.mPriceCurrencyIcon.destroy();
            this.mPriceCurrencyIcon = null;
         }
         Utils.destroyArray(this.mSuccessParams);
         this.mSuccessParams = null;
         this.mSuccessFunction = null;
         removeEventListener(Event.TRIGGERED,this.onTriggered);
         super.dispose();
      }
   }
}

