package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.MapDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.map.MapSelectorShortcut;
   import feathers.controls.ScrollBarDisplayMode;
   import feathers.controls.ScrollContainer;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.TiledRowsLayout;
   import feathers.layout.VerticalAlign;
   
   public class PopupMapSelector extends PopupStandard
   {
      
      public static const BG_NAME:String = "daily_popup";
      
      private var mScrollContainer:ScrollContainer;
      
      public function PopupMapSelector(param1:Boolean = true)
      {
         var _loc3_:Boolean = false;
         super(param1);
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(_loc2_)
         {
            _loc3_ = _loc2_.flagsMapSelectorPopupShown();
            if(!_loc3_)
            {
               _loc2_.setMapSelectorPopupShown(true);
               InstanceMng.getUserDataMng().updateFlags();
               if(InstanceMng.getCurrentScreen() is FSMapScreen)
               {
                  FSMapScreen(InstanceMng.getCurrentScreen()).removeNewBanner();
               }
            }
         }
      }
      
      override public function setMainFieldText(param1:String = "") : void
      {
         super.setMainFieldText(param1);
         this.createMapSelectorShortcutsContainer();
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = BG_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         super.createBackground(param1,1850);
      }
      
      private function createMapSelectorShortcutsContainer() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:MapSelectorShortcut = null;
         var _loc4_:MapDef = null;
         var _loc5_:int = 0;
         if(mInfoTextfield == null)
         {
            return;
         }
         _loc1_ = mBox.height / 7;
         if(mInfoTextfield)
         {
            mInfoTextfield.y = _loc1_ / 2;
            mInfoTextfield.height = _loc1_;
         }
         if(this.mScrollContainer == null)
         {
            this.mScrollContainer = new ScrollContainer();
            this.mScrollContainer.width = mBox.width * 0.85;
            this.mScrollContainer.height = mBox.height * 0.94 - (mInfoTextfield.y + _loc1_);
            this.mScrollContainer.layout = this.getContainerLayout();
            this.mScrollContainer.scrollBarDisplayMode = ScrollBarDisplayMode.FIXED;
            this.mScrollContainer.x = (mBox.width - this.mScrollContainer.width) / 2;
            this.mScrollContainer.y = mInfoTextfield.y + mInfoTextfield.height;
            addChild(this.mScrollContainer);
         }
         var _loc3_:Array = DictionaryUtils.sortDictionaryByKey(InstanceMng.getMapsDefMng().getAllDefs());
         if(_loc3_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc4_ = _loc3_[_loc5_].value;
               if(_loc4_)
               {
                  _loc2_ = new MapSelectorShortcut(_loc4_);
                  this.mScrollContainer.addChild(_loc2_);
               }
               _loc5_++;
            }
         }
      }
      
      private function getContainerLayout() : TiledRowsLayout
      {
         var _loc1_:TiledRowsLayout = new TiledRowsLayout();
         _loc1_.horizontalGap = 0;
         _loc1_.padding = 0;
         _loc1_.verticalAlign = VerticalAlign.MIDDLE;
         _loc1_.tileVerticalAlign = VerticalAlign.MIDDLE;
         _loc1_.horizontalAlign = HorizontalAlign.CENTER;
         _loc1_.tileHorizontalAlign = HorizontalAlign.CENTER;
         return _loc1_;
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         super.setupAcceptButton(param1,param2,param3);
         if(mAcceptButton)
         {
            mAcceptButton.visible = false;
         }
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mScrollContainer)
         {
            this.mScrollContainer.removeFromParent(true);
            this.mScrollContainer = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.MAP_SELECTOR_POPUP_NAME);
         super.removeFromStage();
      }
   }
}

