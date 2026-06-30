package com.fs.tcgengine.view.components.buttons
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class FSCheckBox extends Component
   {
      
      protected const CHECKBOX_IMAGE_NAME:String = "checkbox";
      
      protected const CHECKBOX_TICK_IMAGE_NAME:String = "tick_box";
      
      protected var mCheckBoxImage:FSImage;
      
      protected var mCheckBoxTickImage:FSImage;
      
      protected var mToggled:Boolean;
      
      private var mEnabled:Boolean = true;
      
      private var mOnSelectedTriggerFunction:Function;
      
      private var mOnUnselectedTriggerFunction:Function;
      
      public function FSCheckBox()
      {
         super();
         this.mToggled = false;
         this.init();
      }
      
      protected function init() : void
      {
         if(this.mCheckBoxImage == null)
         {
            this.mCheckBoxImage = new FSImage(Root.assets.getTexture(this.CHECKBOX_IMAGE_NAME));
            this.mCheckBoxImage.alignPivot();
            addChild(this.mCheckBoxImage);
         }
         if(this.mCheckBoxTickImage == null)
         {
            this.mCheckBoxTickImage = new FSImage(Root.assets.getTexture(this.CHECKBOX_TICK_IMAGE_NAME));
            this.mCheckBoxTickImage.alignPivot();
            this.mCheckBoxTickImage.x = this.mCheckBoxImage.x;
            this.mCheckBoxTickImage.y = this.mCheckBoxImage.y;
            this.mCheckBoxTickImage.visible = false;
            addChild(this.mCheckBoxTickImage);
         }
         this.addEventListeners();
         this.updateState();
      }
      
      protected function updateState() : void
      {
         this.mCheckBoxTickImage.visible = this.mToggled;
      }
      
      protected function addEventListeners() : void
      {
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         _loc2_ = param1.getTouch(this,TouchPhase.ENDED);
         if(Boolean(_loc2_) && this.mEnabled)
         {
            this.setToggled();
         }
      }
      
      public function isToggled() : Boolean
      {
         return this.mToggled;
      }
      
      public function setToggled(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(!param1 && !param2)
         {
            this.mToggled = !this.mToggled;
         }
         else
         {
            if(param1)
            {
               this.mToggled = true;
            }
            if(param2)
            {
               this.mToggled = false;
            }
         }
         if(this.mToggled)
         {
            if(this.mOnSelectedTriggerFunction != null)
            {
               this.mOnSelectedTriggerFunction();
            }
         }
         else if(this.mOnUnselectedTriggerFunction != null)
         {
            this.mOnUnselectedTriggerFunction();
         }
         this.updateState();
         if(!param1 && !param2)
         {
            Utils.playSound(Constants.SOUND_CLICK,SoundManager.TYPE_SFX);
         }
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         this.mEnabled = param1;
         alpha = this.mEnabled ? 1 : 0.5;
      }
      
      public function setOnToggledFunction(param1:Function) : void
      {
         this.mOnSelectedTriggerFunction = param1;
      }
      
      public function setOnUntoggledFunction(param1:Function) : void
      {
         this.mOnUnselectedTriggerFunction = param1;
      }
      
      override public function dispose() : void
      {
         if(this.mCheckBoxImage)
         {
            this.mCheckBoxImage.removeFromParent(true);
            this.mCheckBoxImage = null;
         }
         if(this.mCheckBoxTickImage)
         {
            this.mCheckBoxTickImage.removeFromParent(true);
            this.mCheckBoxTickImage = null;
         }
         this.mOnSelectedTriggerFunction = null;
         this.mOnUnselectedTriggerFunction = null;
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
   }
}

