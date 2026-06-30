package com.fs.tcgengine.view.guilds
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.Direction;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.TiledColumnsLayout;
   import feathers.layout.VerticalAlign;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class GuildEmblemBrowser extends Component
   {
      
      private var mScrollContainer:ScrollContainer;
      
      private var mLeftArrowButton:FSButton;
      
      private var mRightArrowButton:FSButton;
      
      private var mEmblemsVector:Vector.<GuildEmblem>;
      
      private var mEmblemsPrefix:String;
      
      private var mEmblemsSelectedSocket:String;
      
      private var mEmblemsUnselectedSocket:String;
      
      private var mEmblemsMaxIndex:int;
      
      private var mSelectedEmblem:GuildEmblem;
      
      private var mOnSelectedFunction:Function;
      
      public function GuildEmblemBrowser(param1:String, param2:String, param3:String, param4:int)
      {
         super();
         this.mEmblemsPrefix = param1;
         this.mEmblemsSelectedSocket = param2;
         this.mEmblemsUnselectedSocket = param3;
         this.mEmblemsMaxIndex = param4;
         this.createUI();
      }
      
      private function createUI() : void
      {
         var _loc1_:int = 0;
         this.generateGuildEmblems();
         if(this.mScrollContainer == null)
         {
            this.mScrollContainer = new ScrollContainer();
            addChild(this.mScrollContainer);
            this.mScrollContainer.layout = this.getContainerLayout();
            this.mScrollContainer.snapToPages = true;
            this.mScrollContainer.verticalScrollPolicy = ScrollPolicy.OFF;
            if(this.mEmblemsVector)
            {
               _loc1_ = 0;
               while(_loc1_ < this.mEmblemsVector.length)
               {
                  this.mScrollContainer.addChild(this.mEmblemsVector[_loc1_]);
                  if(_loc1_ == this.mEmblemsVector.length - 1)
                  {
                     this.setComponentSize(this.mEmblemsVector[_loc1_].width * 4,this.mEmblemsVector[_loc1_].width * 2);
                  }
                  _loc1_++;
               }
            }
         }
         if(this.mLeftArrowButton == null)
         {
            this.mLeftArrowButton = new FSButton(Root.assets.getTexture("scroll_side_icon_left"));
            this.mLeftArrowButton.x = this.mScrollContainer.x - this.mLeftArrowButton.width;
            this.mLeftArrowButton.y = this.mScrollContainer.y + this.mScrollContainer.height / 2;
            this.mLeftArrowButton.addEventListener(Event.TRIGGERED,this.onLeftArrowTriggered);
            addChild(this.mLeftArrowButton);
         }
         if(this.mRightArrowButton == null)
         {
            this.mRightArrowButton = new FSButton(Root.assets.getTexture("scroll_side_icon"));
            this.mRightArrowButton.x = this.mScrollContainer.x + this.mScrollContainer.width + this.mRightArrowButton.width;
            this.mRightArrowButton.y = this.mLeftArrowButton.y;
            this.mRightArrowButton.addEventListener(Event.TRIGGERED,this.onRightArrowTriggered);
            addChild(this.mRightArrowButton);
         }
      }
      
      private function onLeftArrowTriggered(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         if(this.mScrollContainer)
         {
            _loc2_ = this.mScrollContainer.horizontalPageIndex > 0;
            if(_loc2_)
            {
               this.mScrollContainer.scrollToPageIndex(this.mScrollContainer.horizontalPageIndex - 1,0,0.15);
            }
         }
      }
      
      private function onRightArrowTriggered(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         if(this.mScrollContainer)
         {
            _loc2_ = this.mScrollContainer.horizontalPageIndex < this.mScrollContainer.horizontalPageCount;
            if(_loc2_)
            {
               this.mScrollContainer.scrollToPageIndex(this.mScrollContainer.horizontalPageIndex + 1,0,0.15);
            }
         }
      }
      
      private function generateGuildEmblems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:GuildEmblem = null;
         var _loc3_:String = null;
         if(this.mEmblemsVector == null)
         {
            this.mEmblemsVector = new Vector.<GuildEmblem>();
         }
         _loc1_ = 0;
         while(_loc1_ < this.mEmblemsMaxIndex)
         {
            _loc3_ = this.mEmblemsPrefix + Utils.transformValueToString(_loc1_.toString(),2);
            _loc2_ = new GuildEmblem(_loc3_,"",this.mEmblemsUnselectedSocket);
            _loc2_.name = _loc3_;
            _loc2_.addEventListener(TouchEvent.TOUCH,this.onEmblemTouch);
            this.mEmblemsVector.push(_loc2_);
            if(_loc1_ == 1)
            {
               this.onEmblemSelected(_loc2_);
            }
            _loc1_++;
         }
      }
      
      public function selectItemByName(param1:String) : void
      {
         var _loc2_:GuildEmblem = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.mScrollContainer)
         {
            this.mScrollContainer.validate();
            _loc2_ = GuildEmblem(this.mScrollContainer.getChildByName(param1));
            _loc3_ = this.mScrollContainer.getChildIndex(_loc2_);
            _loc4_ = this.mScrollContainer.numChildren / this.mScrollContainer.horizontalPageCount;
            _loc3_ = Math.abs(Math.ceil((_loc3_ + 1) / _loc4_));
            this.mScrollContainer.scrollToPageIndex(_loc3_ - 1,0,0);
            this.mScrollContainer.validate();
            this.onEmblemSelected(_loc2_);
         }
      }
      
      private function onEmblemTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            if(Boolean(this.mScrollContainer) && Boolean(!this.mScrollContainer.isScrolling) && param1.currentTarget != null)
            {
               this.onEmblemSelected(GuildEmblem(param1.currentTarget));
            }
         }
      }
      
      private function getContainerLayout() : TiledColumnsLayout
      {
         var _loc1_:TiledColumnsLayout = new TiledColumnsLayout();
         _loc1_.paging = Direction.HORIZONTAL;
         _loc1_.verticalAlign = VerticalAlign.MIDDLE;
         _loc1_.tileVerticalAlign = VerticalAlign.MIDDLE;
         _loc1_.horizontalAlign = HorizontalAlign.CENTER;
         _loc1_.tileHorizontalAlign = HorizontalAlign.CENTER;
         return _loc1_;
      }
      
      public function setComponentSize(param1:int, param2:int) : void
      {
         if(this.mScrollContainer)
         {
            this.mScrollContainer.setSize(param1,param2);
            if(this.mLeftArrowButton)
            {
               this.mLeftArrowButton.x = this.mScrollContainer.x - this.mLeftArrowButton.width;
               this.mLeftArrowButton.y = this.mScrollContainer.y + this.mScrollContainer.height / 2;
            }
            if(this.mRightArrowButton)
            {
               this.mRightArrowButton.x = this.mScrollContainer.x + this.mScrollContainer.width + this.mRightArrowButton.width;
               this.mRightArrowButton.y = this.mLeftArrowButton.y;
            }
         }
      }
      
      public function onEmblemSelected(param1:GuildEmblem) : void
      {
         if(this.mSelectedEmblem != null)
         {
            this.mSelectedEmblem.changeSocketTexture(Root.assets.getTexture(this.mEmblemsUnselectedSocket));
         }
         this.mSelectedEmblem = param1;
         if(this.mSelectedEmblem != null)
         {
            this.mSelectedEmblem.changeSocketTexture(Root.assets.getTexture(this.mEmblemsSelectedSocket));
         }
         if(this.mOnSelectedFunction != null)
         {
            this.mOnSelectedFunction(this,param1);
         }
      }
      
      public function setOnEmblemSelectedTriggerFunction(param1:Function) : void
      {
         this.mOnSelectedFunction = param1;
      }
      
      public function getSelectedEmblem() : GuildEmblem
      {
         return this.mSelectedEmblem;
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         if(this.mLeftArrowButton)
         {
            this.mLeftArrowButton.removeFromParent(true);
            this.mLeftArrowButton = null;
         }
         if(this.mRightArrowButton)
         {
            this.mRightArrowButton.removeFromParent(true);
            this.mRightArrowButton = null;
         }
         if(this.mEmblemsVector)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mEmblemsVector.length)
            {
               this.mEmblemsVector[_loc1_].removeFromParent();
               _loc1_++;
            }
            Utils.destroyArray(this.mEmblemsVector);
            this.mEmblemsVector = null;
         }
         if(this.mSelectedEmblem)
         {
            this.mSelectedEmblem.removeFromParent(true);
            this.mSelectedEmblem = null;
         }
         this.mOnSelectedFunction = null;
         if(this.mScrollContainer)
         {
            this.mScrollContainer.removeChildren();
            this.mScrollContainer.removeFromParent();
            this.mScrollContainer = null;
         }
         removeChildren(0,-1,true);
         super.dispose();
      }
   }
}

