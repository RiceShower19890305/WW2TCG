package com.fs.tcgengine.view.map
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.MapDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import feathers.controls.ScrollContainer;
   import feathers.controls.supportClasses.LayoutViewPort;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class MapSelectorShortcut extends Component
   {
      
      private var mMapIndex:int;
      
      private var mMapDef:MapDef;
      
      private var mBG:FSImage;
      
      private var mNameTextfield:FSTextfield;
      
      private var mLevelsInfoTextfield:FSTextfield;
      
      public function MapSelectorShortcut(param1:MapDef)
      {
         super();
         this.mMapDef = param1;
         this.mMapIndex = this.mMapDef.getIndex();
         this.createUI();
         Utils.alignComponentAndFixPosition(this);
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createName();
         this.createLevelsInfo();
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(Utils.isDesktop() || Utils.isBrowser())
         {
            _loc2_ = param1.getTouch(this,TouchPhase.HOVER);
            scaleX = _loc2_ ? 1.04 : 1;
            scaleY = _loc2_ ? 1.04 : 1;
         }
         if(param1.getTouch(this,TouchPhase.ENDED))
         {
            this.performOnTouchOps();
         }
      }
      
      private function performOnTouchOps() : void
      {
         var onPopupClosed:Function = null;
         var popup:Popup = null;
         onPopupClosed = function():void
         {
            if(InstanceMng.getCurrentScreen() is FSMapScreen)
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).travelToMap(mMapIndex);
            }
         };
         var parentContainer:ScrollContainer = parent is LayoutViewPort && parent.parent != null ? ScrollContainer(parent.parent) : null;
         var isScrolling:Boolean = parentContainer ? parentContainer.isScrolling : false;
         if(isScrolling)
         {
            return;
         }
         if(InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            popup = InstanceMng.getPopupMng().getPopupShown();
            if(popup)
            {
               popup.closePopup(onPopupClosed);
            }
            else
            {
               onPopupClosed();
            }
         }
      }
      
      private function createBG() : void
      {
         var _loc2_:String = null;
         var _loc1_:String = "map_" + Utils.transformValueToString(this.mMapIndex.toString(),2) + "_thumb";
         if(this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture(_loc1_));
            _loc2_ = this.mMapDef.getName();
            if(_loc2_ != "" && _loc2_ != null)
            {
               this.mBG.setTooltipText(_loc2_);
               this.mBG.touchable = true;
            }
            addChild(this.mBG);
         }
      }
      
      private function createName() : void
      {
         if(this.mNameTextfield == null)
         {
            this.mNameTextfield = new FSTextfield(this.mBG.width * 0.9,this.mBG.height / 2,this.mMapIndex.toString());
            this.mNameTextfield.alpha = 0.5;
            this.mNameTextfield.x = (this.mBG.width - this.mNameTextfield.width) / 2;
            this.mNameTextfield.y = this.mBG.height - this.mNameTextfield.height;
            addChild(this.mNameTextfield);
         }
      }
      
      private function createLevelsInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(this.mLevelsInfoTextfield == null)
         {
            _loc1_ = this.mMapDef.getLevelsAmount();
            _loc2_ = 1 + (this.mMapIndex - 1) * _loc1_;
            _loc3_ = _loc2_ + _loc1_;
            _loc4_ = TextManager.replaceParameters(TextManager.getText("TID_GEN_LEVEL_PLURAL",true),[_loc2_ + "-" + _loc3_]);
            this.mLevelsInfoTextfield = new FSTextfield(this.mNameTextfield.width,this.mBG.height / 3.25,_loc4_,16777215,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE);
            this.mLevelsInfoTextfield.x = this.mNameTextfield.x;
            this.mLevelsInfoTextfield.y = this.mNameTextfield.y + this.mNameTextfield.height;
            addChild(this.mLevelsInfoTextfield);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent(true);
            this.mNameTextfield = null;
         }
         if(this.mLevelsInfoTextfield)
         {
            this.mLevelsInfoTextfield.removeFromParent(true);
            this.mLevelsInfoTextfield = null;
         }
         this.mMapDef = null;
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
   }
}

