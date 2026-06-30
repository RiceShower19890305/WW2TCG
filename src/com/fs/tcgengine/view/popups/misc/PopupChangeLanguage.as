package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.utils.Filters;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.TiledRowsLayout;
   import feathers.layout.VerticalAlign;
   import flash.utils.Dictionary;
   import starling.events.Event;
   
   public class PopupChangeLanguage extends PopupStandard
   {
      
      protected var mFactionFilterButtonsContainer:ScrollContainer;
      
      private var mEnglishButton:FSButton;
      
      private var mSpanishButton:FSButton;
      
      private var mFrenchButton:FSButton;
      
      private var mGermanButton:FSButton;
      
      private var mRussianButton:FSButton;
      
      private var mChineseButton:FSButton;
      
      private var mJapaneseButton:FSButton;
      
      public function PopupChangeLanguage(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.createFactionFilterButtonsContainer();
         this.createFactionFilterButtons();
         this.mFactionFilterButtonsContainer.validate();
         this.mFactionFilterButtonsContainer.x = (mBox.width - this.mFactionFilterButtonsContainer.width) / 2;
      }
      
      override public function setMainFieldText(param1:String = "") : void
      {
         createFields();
         super.setMainFieldText(param1);
      }
      
      protected function createFactionFilterButtons() : void
      {
         var _loc1_:FactionDef = null;
         var _loc2_:int = 0;
         var _loc3_:String = InstanceMng.getUserDataMng().getOwnerUserData().getLanguageLocale();
         var _loc4_:Dictionary = Config.getConfig().getLanguagesSupported();
         if(_loc4_)
         {
            if(_loc4_["EN"])
            {
               this.mEnglishButton = this.createFactionButton("EN","english_icon");
            }
            if(_loc4_["ES"])
            {
               this.mSpanishButton = this.createFactionButton("ES","spanish_icon");
            }
            if(_loc4_["DE"])
            {
               this.mGermanButton = this.createFactionButton("DE","german_icon");
            }
            if(_loc4_["FR"])
            {
               this.mFrenchButton = this.createFactionButton("FR","french_icon");
            }
            if(_loc4_["RU"])
            {
               this.mRussianButton = this.createFactionButton("RU","russian_icon");
            }
            if(_loc4_["ZH"])
            {
               this.mChineseButton = this.createFactionButton("ZH","chinese_icon");
            }
            if(_loc4_["JA"])
            {
               this.mJapaneseButton = this.createFactionButton("JA","japanese_icon");
            }
            switch(_loc3_)
            {
               case "EN":
                  if(this.mEnglishButton)
                  {
                     this.mEnglishButton.filter = Filters.requestFilter(Constants.FILTER_GLOW_GREEN);
                  }
                  break;
               case "ES":
                  if(this.mSpanishButton)
                  {
                     this.mSpanishButton.filter = Filters.requestFilter(Constants.FILTER_GLOW_GREEN);
                  }
                  break;
               case "DE":
                  if(this.mGermanButton)
                  {
                     this.mGermanButton.filter = Filters.requestFilter(Constants.FILTER_GLOW_GREEN);
                  }
                  break;
               case "FR":
                  if(this.mFrenchButton)
                  {
                     this.mFrenchButton.filter = Filters.requestFilter(Constants.FILTER_GLOW_GREEN);
                  }
                  break;
               case "RU":
                  if(this.mRussianButton)
                  {
                     this.mRussianButton.filter = Filters.requestFilter(Constants.FILTER_GLOW_GREEN);
                  }
                  break;
               case "ZH":
                  if(this.mChineseButton)
                  {
                     this.mChineseButton.filter = Filters.requestFilter(Constants.FILTER_GLOW_GREEN);
                  }
                  break;
               case "JA":
                  if(this.mJapaneseButton)
                  {
                     this.mJapaneseButton.filter = Filters.requestFilter(Constants.FILTER_GLOW_GREEN);
                  }
                  break;
               default:
                  if(this.mEnglishButton)
                  {
                     this.mEnglishButton.filter = Filters.requestFilter(Constants.FILTER_GLOW_GREEN);
                  }
            }
         }
      }
      
      private function createFactionButton(param1:String, param2:String) : FSButton
      {
         var _loc3_:FSButton = null;
         if(_loc3_ == null)
         {
            _loc3_ = new FSButton(Root.assets.getTexture(param2));
            _loc3_.name = param1.toUpperCase();
            this.mFactionFilterButtonsContainer.addChild(_loc3_);
            _loc3_.addEventListener(Event.TRIGGERED,this.onFactionTriggered);
         }
         return _loc3_;
      }
      
      protected function createFactionFilterButtonsContainer() : void
      {
         var _loc1_:TiledRowsLayout = null;
         if(this.mFactionFilterButtonsContainer == null)
         {
            this.mFactionFilterButtonsContainer = new ScrollContainer();
            _loc1_ = new TiledRowsLayout();
            _loc1_.verticalAlign = VerticalAlign.MIDDLE;
            _loc1_.horizontalAlign = HorizontalAlign.CENTER;
            _loc1_.tileHorizontalAlign = HorizontalAlign.CENTER;
            _loc1_.tileVerticalAlign = VerticalAlign.MIDDLE;
            _loc1_.gap = 7.5;
            this.mFactionFilterButtonsContainer.layout = _loc1_;
            this.mFactionFilterButtonsContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.mFactionFilterButtonsContainer.verticalScrollPolicy = ScrollPolicy.OFF;
            this.mFactionFilterButtonsContainer.height = mBox.height * 0.4;
            this.mFactionFilterButtonsContainer.x = mBox.width * 0.12;
            this.mFactionFilterButtonsContainer.y = height / 2;
            addChild(this.mFactionFilterButtonsContainer);
         }
      }
      
      protected function onFactionTriggered(param1:Event) : void
      {
         var _loc4_:int = 0;
         var _loc2_:FSButton = FSButton(param1.currentTarget);
         var _loc3_:String = _loc2_.name;
         if(_loc3_ != "" || _loc3_ != null)
         {
            if(_loc2_.name == _loc3_ && _loc2_.filter == null)
            {
               _loc2_.filter = Filters.requestFilter(Constants.FILTER_GLOW_GREEN);
            }
            _loc4_ = 0;
            while(_loc4_ < this.mFactionFilterButtonsContainer.numChildren)
            {
               _loc2_ = FSButton(this.mFactionFilterButtonsContainer.getChildAt(_loc4_));
               if(_loc2_)
               {
                  if(_loc2_.name != _loc3_)
                  {
                     if(_loc2_.filter)
                     {
                        _loc2_.filter.dispose();
                     }
                     _loc2_.filter = null;
                  }
               }
               _loc4_++;
            }
         }
         InstanceMng.getUserDataMng().getOwnerUserData().setLanguageLocale(_loc3_);
         InstanceMng.getUserDataMng().updateLanguageLocale();
         closePopup();
         Utils.setLogText(TextManager.getText("TID_SETTINGS_CHANGE_RESTART"));
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mEnglishButton)
         {
            this.mEnglishButton.removeFromParent(true);
            this.mEnglishButton = null;
         }
         if(this.mSpanishButton)
         {
            this.mSpanishButton.removeFromParent(true);
            this.mSpanishButton = null;
         }
         if(this.mGermanButton)
         {
            this.mGermanButton.removeFromParent(true);
            this.mGermanButton = null;
         }
         if(this.mFrenchButton)
         {
            this.mFrenchButton.removeFromParent(true);
            this.mFrenchButton = null;
         }
         if(this.mRussianButton)
         {
            this.mRussianButton.removeFromParent(true);
            this.mRussianButton = null;
         }
         if(this.mChineseButton)
         {
            this.mChineseButton.removeFromParent(true);
            this.mChineseButton = null;
         }
         if(this.mJapaneseButton)
         {
            this.mJapaneseButton.removeFromParent(true);
            this.mJapaneseButton = null;
         }
         if(this.mFactionFilterButtonsContainer)
         {
            this.mFactionFilterButtonsContainer.removeFromParent(true);
            this.mFactionFilterButtonsContainer = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.CHANGE_LANGUAGE_POPUP_NAME);
         super.removeFromStage();
      }
   }
}

