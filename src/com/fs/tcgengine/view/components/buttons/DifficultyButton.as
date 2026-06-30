package com.fs.tcgengine.view.components.buttons
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.resources.FSResourceMng;
   import starling.events.TouchEvent;
   
   public class DifficultyButton extends FSToggleButton
   {
      
      private var mText:String;
      
      private var mLock:Boolean;
      
      public function DifficultyButton(param1:String, param2:String, param3:String = "")
      {
         super(param1,param2);
         if(param3 != "")
         {
            mButton.text = param3;
            mButton.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            mButton.y -= mButton.height * 0.1;
         }
      }
      
      override protected function setButtonPos() : void
      {
         mButton.x += mUpTexture.width / 2;
         mButton.y += mUpTexture.height / 2;
      }
      
      public function isPressed() : Boolean
      {
         return !mToggled;
      }
      
      public function setPressed(param1:Boolean) : void
      {
         mToggled = !param1;
         updateState();
      }
      
      override protected function onTouch(param1:TouchEvent) : void
      {
      }
      
      public function setLockTexture(param1:String) : void
      {
         if(param1 != null && param1 != "")
         {
            mButton.upState = Root.assets.getTexture(param1);
            mButton.downState = Root.assets.getTexture(param1);
            this.mLock = true;
         }
      }
      
      public function isLock() : Boolean
      {
         return this.mLock;
      }
   }
}

