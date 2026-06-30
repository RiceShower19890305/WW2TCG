package com.fs.tcgengine.view.components.map
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.misc.FSImage;
   import feathers.controls.ScrollBarDisplayMode;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.VerticalLayout;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   
   public class MapSubmenu extends Component implements FSModelUnloadableInterface
   {
      
      public static const NOTIFICATION_NAME:String = "map_submenu_notification";
      
      public static const MAX_BUTTONS:int = 5;
      
      private const MENU_OPEN_NAME:String = "map_submenu_open_button";
      
      private const MENU_CLOSE_NAME:String = "map_submenu_close_button";
      
      private const TOP_NAME:String = "map_submenu_frame";
      
      private var mButton:FSButton;
      
      private var mTop:FSImage;
      
      private var mScrollContainer:ScrollContainer;
      
      private var mIsExpanded:Boolean = false;
      
      private var mButtonsVector:Vector.<SubMenuButton>;
      
      private var mQuad1:Quad;
      
      private var mQuad2:Quad;
      
      private var mNotificationIcon:FSImage;
      
      private var mHovered:Boolean;
      
      public function MapSubmenu(param1:Vector.<SubMenuButton>)
      {
         super();
         this.mButtonsVector = param1;
         this.createUI();
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      public function sortButtonsVector(param1:Vector.<SubMenuButton>) : void
      {
         var _loc2_:int = 0;
         if(InstanceMng.getTutorialMapMng() == null || Boolean(InstanceMng.getTutorialMapMng()) && Boolean(!InstanceMng.getTutorialMapMng().isTutorialON()))
         {
            if(this.mScrollContainer)
            {
               this.mScrollContainer.removeChildren();
            }
            this.mButtonsVector = param1;
            if(this.mButtonsVector)
            {
               _loc2_ = 0;
               while(_loc2_ < this.mButtonsVector.length)
               {
                  this.addButtonToScrollContainer(this.mButtonsVector[_loc2_]);
                  _loc2_++;
               }
               if(this.mScrollContainer)
               {
                  addChild(this.mScrollContainer);
               }
            }
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         this.mHovered = param1.getTouch(this,TouchPhase.HOVER) != null;
      }
      
      public function isHovered() : Boolean
      {
         return this.mHovered;
      }
      
      public function isScrolling() : Boolean
      {
         return Boolean(this.mScrollContainer) && this.mScrollContainer.isScrolling;
      }
      
      private function createUI() : void
      {
         this.createButton();
         this.addButtonsToContainer();
         this.addTopImage();
         this.addBG();
         this.setExpanded(false);
      }
      
      private function addBG() : void
      {
         if(this.mQuad1 == null)
         {
            this.mQuad1 = new Quad(this.mTop.width * 0.75,this.mScrollContainer.height + 15,0);
            this.mQuad1.x = this.mScrollContainer.x;
            this.mQuad1.y = this.mScrollContainer.y - 10;
            this.mQuad1.alpha = 1;
            this.mQuad1.setVertexAlpha(0,0.75);
            this.mQuad1.setVertexAlpha(1,0.85);
            this.mQuad1.setVertexAlpha(2,0.85);
            this.mQuad1.setVertexAlpha(3,0.75);
            addChildAt(this.mQuad1,getChildIndex(this.mScrollContainer));
         }
         if(this.mQuad2 == null)
         {
            this.mQuad2 = new Quad(this.mTop.width * 0.25,this.mQuad1.height,0);
            this.mQuad2.x = this.mQuad1.x + this.mQuad1.width;
            this.mQuad2.y = this.mQuad1.y;
            this.mQuad2.alpha = 1;
            this.mQuad2.setVertexAlpha(0,0.75);
            this.mQuad2.setVertexAlpha(1,0);
            this.mQuad2.setVertexAlpha(2,0.75);
            this.mQuad2.setVertexAlpha(3,0);
            addChildAt(this.mQuad2,getChildIndex(this.mScrollContainer));
         }
      }
      
      private function createButton() : void
      {
         if(this.mButton == null)
         {
            this.mButton = new FSButton(Root.assets.getTexture(this.MENU_OPEN_NAME));
            this.mButton.addEventListener(Event.TRIGGERED,this.onTriggered);
            addChild(this.mButton);
         }
         this.refreshButtonTextures();
      }
      
      private function refreshButtonTextures() : void
      {
         var _loc1_:Texture = null;
         if(this.mButton)
         {
            _loc1_ = this.mIsExpanded ? Root.assets.getTexture(this.MENU_CLOSE_NAME) : Root.assets.getTexture(this.MENU_OPEN_NAME);
            this.mButton.upState = _loc1_;
            this.mButton.downState = _loc1_;
            this.mButton.disabledState = _loc1_;
            this.mButton.overState = _loc1_;
         }
      }
      
      private function onTriggered(param1:Event) : void
      {
         this.setExpanded(!this.mIsExpanded);
         if(InstanceMng.getTutorialMapMng().isTutorialON())
         {
            InstanceMng.getTutorialMapMng().increaseCurrentStep();
         }
      }
      
      private function addTopImage() : void
      {
         if(this.mTop == null)
         {
            this.mTop = new FSImage(Root.assets.getTexture(this.TOP_NAME));
            this.mTop.alignPivot();
         }
         this.mTop.x = this.mScrollContainer.x + this.mTop.width / 2;
         this.mTop.y = this.mScrollContainer.y - this.mTop.height / 2;
         this.mTop.touchable = true;
         SpecialFX.createYoYoAlphaTransition(this.mTop,0.5,1);
         addEventListener(TouchEvent.TOUCH,this.onTopImageTouch);
         addChild(this.mTop);
      }
      
      private function onTopImageTouch(param1:TouchEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Touch = param1 ? param1.getTouch(this.mTop,TouchPhase.HOVER) : null;
         if(_loc2_)
         {
            if(this.mScrollContainer)
            {
               this.mScrollContainer.scrollToPageIndex(0,0);
            }
         }
         this.mTop.scale = _loc2_ ? 1.1 : 1;
         _loc2_ = param1 ? param1.getTouch(this.mButton,TouchPhase.HOVER) : null;
         if(_loc2_)
         {
            if(this.mScrollContainer)
            {
               this.mScrollContainer.scrollToPageIndex(0,0.0001);
               _loc3_ = this.mIsExpanded && this.mScrollContainer.verticalPageCount >= 1 ? this.mScrollContainer.verticalPageCount : 0;
               this.mScrollContainer.scrollToPageIndex(0,_loc3_,0.15);
            }
         }
      }
      
      private function addButtonsToContainer() : void
      {
         var _loc1_:int = 0;
         if(this.mButtonsVector)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mButtonsVector.length)
            {
               this.addButtonToScrollContainer(this.mButtonsVector[_loc1_]);
               _loc1_++;
            }
            if(this.mScrollContainer)
            {
               addChild(this.mScrollContainer);
            }
         }
      }
      
      private function addButtonToScrollContainer(param1:SubMenuButton) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:VerticalLayout = null;
         if(this.mScrollContainer == null)
         {
            this.mScrollContainer = new ScrollContainer();
            this.mScrollContainer.name = "scrollContainer";
            _loc2_ = 5;
            _loc3_ = 0;
            _loc4_ = 0;
            if(this.mButtonsVector)
            {
               if(this.mButtonsVector.length > MAX_BUTTONS)
               {
                  _loc3_ = this.mButtonsVector[0].width;
                  _loc4_ = MAX_BUTTONS * this.mButtonsVector[0].height;
               }
               else
               {
                  _loc3_ = this.mButtonsVector[0].width;
                  _loc4_ = this.mButtonsVector.length * (this.mButtonsVector[0].height + (_loc2_ + 3));
               }
            }
            this.mScrollContainer.verticalScrollPolicy = Boolean(this.mButtonsVector) && this.mButtonsVector.length <= MAX_BUTTONS ? ScrollPolicy.OFF : ScrollPolicy.AUTO;
            this.mScrollContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.mScrollContainer.width = _loc3_;
            this.mScrollContainer.height = _loc4_;
            this.mScrollContainer.x = this.mButton.x - this.mButton.width / 2;
            this.mScrollContainer.y = this.mButton.y - this.mButton.height / 2 - _loc4_;
            _loc5_ = new VerticalLayout();
            _loc5_.paddingTop = 10;
            _loc5_.paddingBottom = 10;
            _loc5_.gap = _loc2_;
            this.mScrollContainer.layout = _loc5_;
            this.mScrollContainer.scrollBarDisplayMode = ScrollBarDisplayMode.NONE;
            addChild(this.mScrollContainer);
         }
         param1.x = param1.width / 2;
         param1.y = param1.height / 2;
         this.mScrollContainer.addChild(param1);
      }
      
      public function isExpanded() : Boolean
      {
         return this.mIsExpanded;
      }
      
      public function setExpanded(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(this.mIsExpanded != param1)
         {
            this.mIsExpanded = param1;
         }
         if(Boolean(this.mButtonsVector) && this.mButtonsVector.length > MAX_BUTTONS)
         {
            if(this.mIsExpanded)
            {
               if(!InstanceMng.getTutorialMapMng().isTutorialON())
               {
                  this.mScrollContainer.scrollToPageIndex(0,0.0001);
                  _loc2_ = this.mIsExpanded && this.mScrollContainer.verticalPageCount >= 1 ? this.mScrollContainer.verticalPageCount : 0;
                  this.mScrollContainer.scrollToPageIndex(0,_loc2_,0.15);
               }
            }
            else
            {
               this.mScrollContainer.scrollToPageIndex(0,1);
               this.mScrollContainer.scrollToPageIndex(0,0);
            }
         }
         this.refreshButtonTextures();
         if(this.mScrollContainer)
         {
            this.mScrollContainer.visible = this.mIsExpanded;
         }
         if(this.mTop)
         {
            this.mTop.visible = this.mIsExpanded;
         }
         if(this.mQuad1)
         {
            this.mQuad1.visible = this.mIsExpanded;
         }
         if(this.mQuad2)
         {
            this.mQuad2.visible = this.mIsExpanded;
         }
      }
      
      public function refreshPositionInMapTutorial() : void
      {
         var _loc1_:Component = null;
         var _loc2_:int = 0;
         if(InstanceMng.getTutorialMapMng().isTutorialON())
         {
            _loc1_ = InstanceMng.getTutorialMapMng().getCurrentHighlightedItem();
            if(_loc1_ != null && _loc1_ is SubMenuButton)
            {
               this.mScrollContainer.validate();
               _loc2_ = this.getComponentPageIndex(_loc1_);
               if(_loc2_ != -1)
               {
                  this.mScrollContainer.scrollToPageIndex(0,_loc2_,0);
                  this.mScrollContainer.validate();
               }
            }
         }
      }
      
      public function getComponentPageIndex(param1:Component) : int
      {
         var _loc2_:int = this.mScrollContainer.getChildIndex(param1);
         return Boolean(this.mButtonsVector) && Boolean(this.mButtonsVector.length > MAX_BUTTONS) && _loc2_ < MAX_BUTTONS ? 0 : 1;
      }
      
      public function getChildrenAmount() : int
      {
         return this.mButtonsVector ? int(this.mButtonsVector.length) : 0;
      }
      
      public function getMainButton() : FSButton
      {
         return this.mButton;
      }
      
      public function showNotificationIcon(param1:Boolean) : void
      {
         if(this.mNotificationIcon == null)
         {
            this.mNotificationIcon = new FSImage(Root.assets.getTexture(NOTIFICATION_NAME));
            this.mNotificationIcon.x = this.mButton.x + this.mButton.width / 2 - this.mNotificationIcon.width / 1.5;
            this.mNotificationIcon.y = this.mButton.y - this.mButton.height / 2;
            this.mNotificationIcon.touchable = false;
            addChild(this.mNotificationIcon);
            SpecialFX.createYoYoZoomTransition(this.mNotificationIcon,1.3,1,-1,null,null,false);
         }
         this.mNotificationIcon.visible = param1;
         if(InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            FSMapScreen(InstanceMng.getCurrentScreen()).createSubmenu();
         }
      }
      
      public function getButtonsVector() : Vector.<SubMenuButton>
      {
         return this.mButtonsVector;
      }
      
      public function validateContainer() : void
      {
         if(this.mScrollContainer)
         {
            this.mScrollContainer.validate();
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         if(this.mButton)
         {
            this.mButton.removeFromParent(true);
            this.mButton = null;
         }
         if(this.mTop)
         {
            this.mTop.removeFromParent(true);
            this.mTop = null;
         }
         if(this.mQuad1)
         {
            this.mQuad1.removeFromParent(true);
            this.mQuad1 = null;
         }
         if(this.mQuad2)
         {
            this.mQuad2.removeFromParent(true);
            this.mQuad2 = null;
         }
         if(this.mNotificationIcon)
         {
            this.mNotificationIcon.removeFromParent(true);
            this.mNotificationIcon = null;
         }
         if(this.mScrollContainer)
         {
            this.mScrollContainer.removeChildren();
            this.mScrollContainer.removeFromParent(true);
            this.mScrollContainer = null;
         }
         if(this.mButtonsVector)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mButtonsVector.length)
            {
               this.mButtonsVector[_loc1_].removeFromParent();
               _loc1_++;
            }
            Utils.destroyArray(this.mButtonsVector);
            this.mButtonsVector = null;
         }
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         removeEventListener(TouchEvent.TOUCH,this.onTopImageTouch);
         super.dispose();
      }
      
      public function destroy() : void
      {
         var _loc1_:int = 0;
         if(this.mButton)
         {
            this.mButton.removeFromParent();
            this.mButton.destroy();
            this.mButton = null;
         }
         if(this.mTop)
         {
            this.mTop.removeFromParent();
            this.mTop = null;
         }
         if(this.mQuad1)
         {
            this.mQuad1.removeFromParent();
            this.mQuad1 = null;
         }
         if(this.mQuad2)
         {
            this.mQuad2.removeFromParent();
            this.mQuad2 = null;
         }
         if(this.mNotificationIcon)
         {
            this.mNotificationIcon.removeFromParent();
            this.mNotificationIcon = null;
         }
         if(this.mScrollContainer)
         {
            this.mScrollContainer.removeChildren();
            this.mScrollContainer.removeFromParent();
            this.mScrollContainer = null;
         }
         if(this.mButtonsVector)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mButtonsVector.length)
            {
               this.mButtonsVector[_loc1_].removeFromParent();
               _loc1_++;
            }
            Utils.destroyArray(this.mButtonsVector);
            this.mButtonsVector = null;
         }
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         removeEventListener(TouchEvent.TOUCH,this.onTopImageTouch);
      }
   }
}

