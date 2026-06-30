package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.rules.TutorialDeckBuilderDef;
   import com.fs.tcgengine.particles.TextParticleWithBG;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.map.MapSubmenu;
   import com.greensock.TweenMax;
   import feathers.controls.supportClasses.LayoutViewPort;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class TutorialDeckBuilderMng
   {
      
      protected var mTutorialDefs:Array;
      
      protected var mTutorialDefsRequested:Boolean;
      
      protected var mCurrentStep:int = -1;
      
      protected var mStartingStep:int = -1;
      
      private var mCurrentAttachedToComponent:DisplayObject;
      
      protected var mCurrentParticle:TextParticleWithBG;
      
      protected var mTutorialDefsAmount:int = -1;
      
      protected var mCurrentTutorialDef:TutorialDeckBuilderDef;
      
      private var mOriginalAttachedToComponentPos:FSCoordinate;
      
      protected var mOriginalAttachedToComponentParent:DisplayObjectContainer;
      
      private var mOriginalAttachedToComponentChildIndex:int = 0;
      
      private var mOriginalAttachedToComponentWasTouchable:Boolean;
      
      private var mDummyShape:Quad;
      
      public function TutorialDeckBuilderMng()
      {
         super();
      }
      
      public function startTutorial(param1:int = 0) : void
      {
         this.lockUI(true);
         this.mCurrentStep = param1;
         this.mStartingStep = 0;
      }
      
      protected function lockUI(param1:Boolean) : void
      {
         InstanceMng.getCurrentScreen().lockUI(true);
      }
      
      public function getTutorialStep() : int
      {
         return this.mCurrentStep;
      }
      
      public function isTutorialON() : Boolean
      {
         return this.mStartingStep > -1 || this.mTutorialDefsAmount == this.mStartingStep - 1;
      }
      
      public function getCurrentTutorialDef() : TutorialDeckBuilderDef
      {
         return this.mCurrentTutorialDef;
      }
      
      public function increaseCurrentStep(param1:String = "") : void
      {
         this.removeCurrentBubble();
         if(this.mStartingStep + 1 == this.mTutorialDefsAmount)
         {
            this.mCurrentStep = -1;
            this.mStartingStep = -1;
            this.mTutorialDefsAmount = 0;
            InstanceMng.getCurrentScreen().removeTranslucentBG();
            this.setTutorialAsFinished();
         }
         else
         {
            ++this.mCurrentStep;
            ++this.mStartingStep;
         }
         FSDebug.debugTrace("CURRENT STEP-> " + this.mCurrentStep);
      }
      
      protected function setTutorialAsFinished() : void
      {
         InstanceMng.getUserDataMng().getOwnerUserData().setDeckBuilderTutorialShown(true);
         InstanceMng.getUserDataMng().updateFlags();
      }
      
      public function removeCurrentBubble() : void
      {
         if(this.mCurrentParticle)
         {
            this.mCurrentParticle.removeFromParent();
            this.mCurrentParticle.destroy();
            this.mCurrentParticle = null;
         }
         if(this.mCurrentAttachedToComponent)
         {
            TweenMax.killTweensOf(this.mCurrentAttachedToComponent);
            this.mCurrentAttachedToComponent.alpha = 1;
            if(this.mOriginalAttachedToComponentPos)
            {
               this.mCurrentAttachedToComponent.x = this.mOriginalAttachedToComponentPos.getX();
               this.mCurrentAttachedToComponent.y = this.mOriginalAttachedToComponentPos.getY();
            }
            if(Boolean(this.mOriginalAttachedToComponentParent) && Boolean(this.mCurrentAttachedToComponent))
            {
               if(this.mOriginalAttachedToComponentChildIndex >= 0 && this.mOriginalAttachedToComponentChildIndex <= this.mOriginalAttachedToComponentParent.numChildren)
               {
                  if(this.mOriginalAttachedToComponentParent is LayoutViewPort)
                  {
                     if(this.mDummyShape)
                     {
                        this.mDummyShape.removeFromParent();
                        this.mDummyShape = null;
                     }
                  }
                  if(this.mOriginalAttachedToComponentChildIndex >= 0)
                  {
                     this.mOriginalAttachedToComponentParent.addChildAt(this.mCurrentAttachedToComponent,this.mOriginalAttachedToComponentChildIndex);
                  }
                  else
                  {
                     this.mOriginalAttachedToComponentParent.addChild(this.mCurrentAttachedToComponent);
                  }
               }
               else
               {
                  if(this.mOriginalAttachedToComponentParent is LayoutViewPort)
                  {
                     if(this.mDummyShape)
                     {
                        this.mDummyShape.removeFromParent();
                     }
                  }
                  this.mOriginalAttachedToComponentParent.addChild(this.mCurrentAttachedToComponent);
               }
            }
            if(this.mCurrentAttachedToComponent)
            {
               this.mCurrentAttachedToComponent.touchable = this.mOriginalAttachedToComponentWasTouchable;
            }
         }
         if(Boolean(InstanceMng.getCurrentScreen()) && Boolean(InstanceMng.getCurrentScreen().getTouchableBG()))
         {
            InstanceMng.getCurrentScreen().addChild(InstanceMng.getCurrentScreen().getTouchableBG());
         }
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         this.manageTutorialSteps();
      }
      
      private function manageTutorialSteps() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TutorialDeckBuilderDef = null;
         var _loc4_:Boolean = false;
         if(!this.mTutorialDefsRequested)
         {
            this.fillTutorialDefsArr();
            this.mTutorialDefsAmount = this.mTutorialDefs ? int(this.mTutorialDefs.length) : 0;
            if(this.mTutorialDefsAmount)
            {
               this.mTutorialDefsRequested = true;
            }
         }
         if(Boolean(this.mTutorialDefs != null && this.mTutorialDefsRequested) && Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen().isFullyLoaded())
         {
            _loc2_ = int(this.mTutorialDefs.length);
            _loc4_ = false;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.mTutorialDefs[_loc1_];
               if(_loc3_ != null)
               {
                  if(_loc3_.getIndex() == this.mCurrentStep)
                  {
                     _loc4_ = _loc3_.needsToBeOnline() && InstanceMng.getServerConnection().isUserLoggedIn() || !_loc3_.needsToBeOnline();
                     if(_loc4_)
                     {
                        this.mCurrentTutorialDef = _loc3_;
                        this.mTutorialDefs.splice(_loc1_,1);
                        if(this.mTutorialDefs.length == 0)
                        {
                           this.mTutorialDefs = null;
                        }
                        this.onTutorialTriggerStepOps(_loc3_,_loc1_);
                     }
                     else
                     {
                        FSDebug.debugTrace("Tutorial step required internet connection and couldn\'t find one.");
                     }
                  }
               }
               _loc1_++;
            }
         }
      }
      
      protected function fillTutorialDefsArr() : void
      {
         this.mTutorialDefs = InstanceMng.getTutorialDeckBuilderDefMng().getTutorialDefsArray();
      }
      
      protected function onTutorialTriggerStepOps(param1:TutorialDeckBuilderDef, param2:int) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:Point = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         if(param1 == null || Boolean(param1) && Boolean(param1.hasToWaitForPopup()))
         {
            return;
         }
         this.createTutorialBubble(param1);
         var _loc3_:String = param1.getArrowDirection();
         var _loc4_:String = param1.getAttachedTo();
         this.mCurrentAttachedToComponent = this.getComponentByName(_loc4_);
         if(this.mCurrentAttachedToComponent)
         {
            _loc5_ = 0;
            this.mOriginalAttachedToComponentWasTouchable = this.mCurrentAttachedToComponent.touchable;
            _loc6_ = param1.getAttachedTo() ? param1.getAttachedTo().indexOf("/") != -1 : false;
            _loc7_ = (_loc6_) && param1.getAttachedTo().indexOf("UI/") != -1;
            if(_loc6_)
            {
               if(InstanceMng.getCurrentScreen() is FSMapScreen)
               {
                  if(FSMapScreen(InstanceMng.getCurrentScreen()).isSubMenuShown())
                  {
                     if(FSMapScreen(InstanceMng.getCurrentScreen()).getSubMenu())
                     {
                        FSMapScreen(InstanceMng.getCurrentScreen()).getSubMenu().refreshPositionInMapTutorial();
                        _loc10_ = FSMapScreen(InstanceMng.getCurrentScreen()).getSubMenu().getComponentPageIndex(this.mCurrentAttachedToComponent as Component);
                        _loc11_ = FSMapScreen(InstanceMng.getCurrentScreen()).getSubMenu().getChildrenAmount();
                        _loc12_ = Math.ceil(_loc11_ / MapSubmenu.MAX_BUTTONS);
                        if(_loc10_ == _loc12_ - 1)
                        {
                           _loc13_ = _loc11_ - _loc12_ * MapSubmenu.MAX_BUTTONS;
                           if(_loc13_ < 0)
                           {
                              _loc5_ = (_loc13_ + 1) * this.mCurrentAttachedToComponent.height;
                           }
                        }
                     }
                  }
               }
               this.mOriginalAttachedToComponentPos = new FSCoordinate(this.mCurrentAttachedToComponent.x,this.mCurrentAttachedToComponent.y);
               this.mOriginalAttachedToComponentParent = this.mCurrentAttachedToComponent.parent;
               this.mOriginalAttachedToComponentChildIndex = this.mCurrentAttachedToComponent.parent.getChildIndex(this.mCurrentAttachedToComponent);
               _loc9_ = new Point(this.mCurrentAttachedToComponent.x,this.mCurrentAttachedToComponent.y + _loc5_);
               _loc9_ = this.mCurrentAttachedToComponent.parent.localToGlobal(_loc9_);
               this.mCurrentAttachedToComponent.x = _loc9_.x;
               this.mCurrentAttachedToComponent.y = _loc9_.y;
            }
            else
            {
               this.mOriginalAttachedToComponentPos = null;
               this.mOriginalAttachedToComponentParent = null;
               this.mOriginalAttachedToComponentChildIndex = 0;
            }
            this.setPositionObjectRelative(_loc3_);
            this.mCurrentParticle.x -= this.mCurrentAttachedToComponent.pivotX != 0 ? this.mCurrentAttachedToComponent.width / 2 : 0;
            this.mCurrentParticle.y -= this.mCurrentAttachedToComponent.pivotY != 0 ? this.mCurrentAttachedToComponent.height / 2 : 0;
            if(this.mCurrentParticle.x - this.mCurrentParticle.width / 2 < 0)
            {
               this.mCurrentParticle.x += this.mCurrentParticle.width / 2 - this.mCurrentParticle.x;
            }
            _loc8_ = Starling.current.stage.stageHeight;
            if(this.mCurrentParticle.y + this.mCurrentParticle.height / 2 > Starling.current.stage.stageHeight)
            {
               this.mCurrentParticle.y += Starling.current.stage.stageHeight - (this.mCurrentParticle.y + this.mCurrentParticle.height / 2);
            }
            if(!InstanceMng.getCurrentScreen().isTransparentBGShown())
            {
               InstanceMng.getCurrentScreen().createTranslucentBG(true);
            }
            TweenMax.killTweensOf(this.mCurrentAttachedToComponent);
            SpecialFX.createYoYoAlphaTransition(this.mCurrentAttachedToComponent,0.4,0.75);
            if(_loc7_)
            {
               if(InstanceMng.getCurrentScreen().getTouchableBG())
               {
                  Starling.current.stage.addChild(InstanceMng.getCurrentScreen().getTouchableBG());
               }
               Starling.current.stage.addChild(this.mCurrentAttachedToComponent);
            }
            else
            {
               InstanceMng.getCurrentScreen().addChild(this.mCurrentAttachedToComponent);
            }
            if(this.mCurrentAttachedToComponent is FSButton)
            {
               FSButton(this.mCurrentAttachedToComponent).setEnabled(true);
            }
            if(this.mOriginalAttachedToComponentParent is LayoutViewPort)
            {
               if(this.mDummyShape == null)
               {
                  this.mDummyShape = new Quad(this.mCurrentAttachedToComponent.width,this.mCurrentAttachedToComponent.height);
               }
               this.mDummyShape.alpha = 0;
               this.mOriginalAttachedToComponentParent.addChildAt(this.mDummyShape,this.mOriginalAttachedToComponentChildIndex);
            }
            Starling.current.stage.addChild(this.mCurrentParticle);
            this.mCurrentAttachedToComponent.touchable = param1.isClickable();
         }
         else if(_loc4_ != null && _loc4_ != "")
         {
            this.increaseCurrentStep();
            if(InstanceMng.getCurrentScreen().getTouchableBG())
            {
               InstanceMng.getCurrentScreen().getTouchableBG().removeFromParent();
            }
         }
         else
         {
            if(!InstanceMng.getCurrentScreen().isTransparentBGShown())
            {
               InstanceMng.getCurrentScreen().createTranslucentBG(true);
            }
            this.setPositionScreenRelative(this.mCurrentParticle,_loc3_);
            Starling.current.stage.addChild(this.mCurrentParticle);
         }
      }
      
      public function getCurrentHighlightedItem() : Component
      {
         return this.mCurrentAttachedToComponent is Component ? Component(this.mCurrentAttachedToComponent) : null;
      }
      
      protected function setPositionScreenRelative(param1:DisplayObject, param2:String) : void
      {
         var _loc3_:Number = Starling.current.stage.stageWidth;
         var _loc4_:Number = Starling.current.stage.stageHeight;
         switch(param2)
         {
            case "up-center":
               param1.x = _loc3_ / 2 - param1.width * 0.5;
               param1.y = _loc4_ * 0.1;
               break;
            case "center-center":
               param1.x = _loc3_ / 2 - param1.width * 0.5;
               param1.y = _loc4_ / 2 - param1.height * 0.5;
               break;
            case "down-center":
               param1.x = _loc3_ / 2;
               param1.y = _loc4_ - param1.height / 2;
               break;
            case "down-right":
               param1.x = _loc3_ - param1.width;
               param1.y = _loc4_ - param1.height;
         }
         if(param1 is PackAnimation)
         {
            param1.x += param1.width / 2;
            param1.y += param1.height / 1.5;
         }
      }
      
      protected function setPositionObjectRelative(param1:String) : void
      {
         switch(param1)
         {
            case "up":
               this.mCurrentParticle.x = this.mCurrentAttachedToComponent.x + this.mCurrentAttachedToComponent.width / 2;
               this.mCurrentParticle.y = this.mCurrentAttachedToComponent.y - this.mCurrentParticle.height / 2;
               break;
            case "down":
               this.mCurrentParticle.x = this.mCurrentAttachedToComponent.x + this.mCurrentAttachedToComponent.width / 2;
               this.mCurrentParticle.y = this.mCurrentAttachedToComponent.y + this.mCurrentAttachedToComponent.height + this.mCurrentParticle.height;
               break;
            case "left":
               this.mCurrentParticle.x = this.mCurrentAttachedToComponent.x - this.mCurrentParticle.width / 2;
               this.mCurrentParticle.y = this.mCurrentAttachedToComponent.y + this.mCurrentAttachedToComponent.height / 2;
               break;
            case "right":
               this.mCurrentParticle.x = this.mCurrentAttachedToComponent.x + this.mCurrentAttachedToComponent.width + this.mCurrentParticle.width / 2;
               this.mCurrentParticle.y = this.mCurrentAttachedToComponent.y + this.mCurrentAttachedToComponent.height / 2;
               break;
            case "down-left":
               this.mCurrentParticle.x = this.mCurrentAttachedToComponent.x - this.mCurrentParticle.width / 2;
               this.mCurrentParticle.y = this.mCurrentAttachedToComponent.y + this.mCurrentAttachedToComponent.height + this.mCurrentParticle.height;
               break;
            case "up-right":
               this.mCurrentParticle.x = this.mCurrentAttachedToComponent.x + this.mCurrentAttachedToComponent.width / 2 + this.mCurrentParticle.width / 2;
               this.mCurrentParticle.y = this.mCurrentAttachedToComponent.y - this.mCurrentParticle.height / 2;
               break;
            case "up-left":
               this.mCurrentParticle.x = this.mCurrentAttachedToComponent.x - this.mCurrentParticle.width * 1.2;
               this.mCurrentParticle.y = this.mCurrentAttachedToComponent.y - this.mCurrentParticle.height / 2;
         }
      }
      
      private function getComponentByName(param1:String) : DisplayObject
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:DisplayObjectContainer = null;
         var _loc6_:String = null;
         if(param1 != "" && param1 != null)
         {
            if(param1.indexOf("/") != -1)
            {
               _loc3_ = param1.split("/");
               if(_loc3_ != null && _loc3_[0] != null && InstanceMng.getCurrentScreen() != null)
               {
                  _loc5_ = _loc3_[0] == "UI" ? DisplayObjectContainer(Starling.current.stage.getChildByName(_loc3_[0])) : DisplayObjectContainer(InstanceMng.getCurrentScreen().getChildByName(_loc3_[0]));
                  _loc6_ = "";
                  _loc4_ = 1;
                  while(_loc4_ < _loc3_.length)
                  {
                     _loc6_ = _loc3_[_loc4_];
                     if(_loc4_ < _loc3_.length - 1)
                     {
                        if(_loc5_)
                        {
                           _loc5_ = DisplayObjectContainer(_loc5_.getChildByName(_loc6_));
                        }
                     }
                     else
                     {
                        _loc2_ = _loc5_ ? _loc5_.getChildByName(_loc6_) : null;
                     }
                     _loc4_++;
                  }
               }
            }
            else
            {
               _loc2_ = InstanceMng.getCurrentScreen().getChildByName(param1);
            }
         }
         return _loc2_;
      }
      
      protected function createTutorialBubble(param1:TutorialDeckBuilderDef) : void
      {
         if(this.mCurrentParticle == null)
         {
            this.mCurrentParticle = new TextParticleWithBG("tutorial_bubble",520);
            this.mCurrentParticle.setBG("tutorial_bubble",Align.CENTER,FSResourceMng.FONT_TYPE_STD_DESC,0,true);
         }
         this.mCurrentParticle.addEventListener(TouchEvent.TOUCH,this.onParticleTouch);
         this.mCurrentParticle.setText(param1.getDesc());
      }
      
      protected function onParticleTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this.mCurrentParticle,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            this.mCurrentParticle.removeEventListener(TouchEvent.TOUCH,this.onParticleTouch);
            if(InstanceMng.getTutorialDeckBuilderMng().isTutorialON())
            {
               if(Boolean(this.mCurrentTutorialDef) && !this.mCurrentTutorialDef.isClickable())
               {
                  this.increaseCurrentStep();
               }
            }
         }
      }
      
      public function unload() : void
      {
         if(this.mTutorialDefs != null)
         {
            this.mTutorialDefs.length = 0;
         }
         if(this.mCurrentParticle)
         {
            this.mCurrentParticle.removeFromParent(true);
         }
         this.mCurrentParticle = null;
         this.mCurrentTutorialDef = null;
         this.mOriginalAttachedToComponentPos = null;
         this.mOriginalAttachedToComponentParent = null;
         if(this.mDummyShape)
         {
            this.mDummyShape.removeFromParent(true);
            this.mDummyShape = null;
         }
         this.mCurrentAttachedToComponent = null;
         this.mTutorialDefs = null;
         this.mTutorialDefsRequested = false;
         this.mCurrentStep = -1;
         this.mStartingStep = -1;
      }
      
      public function checkTutorialFunctionsOnHold() : void
      {
         var _loc1_:TutorialDeckBuilderDef = null;
         if(this.isTutorialON())
         {
            _loc1_ = this.getCurrentTutorialDef();
            if(Boolean(_loc1_) && _loc1_.isClickable())
            {
               this.increaseCurrentStep();
            }
         }
      }
   }
}

