package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class TutorialDeckBuilderDef extends Def
   {
      
      private var mArrowDirection:String;
      
      private var mAttachedToComponent:String;
      
      private var mIsClickable:Boolean;
      
      private var mWaitForPopup:Boolean;
      
      private var mNeedsOnline:Boolean;
      
      public function TutorialDeckBuilderDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("arrowDirection" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.arrowDirection);
            this.setArrowDirection(_loc2_);
         }
         if("attachedTo" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.attachedTo);
            this.setAttachedTo(_loc2_);
         }
         if("clickable" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.clickable);
            this.setIsClickable(Utils.stringToBoolean(_loc2_));
         }
         if("waitPopup" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.waitPopup);
            this.mWaitForPopup = Utils.stringToBoolean(_loc2_);
         }
         if("needsOnline" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.needsOnline);
            this.mNeedsOnline = Utils.stringToBoolean(_loc2_);
         }
      }
      
      public function getArrowDirection() : String
      {
         return this.mArrowDirection;
      }
      
      public function setArrowDirection(param1:String) : void
      {
         this.mArrowDirection = param1;
      }
      
      public function getAttachedTo() : String
      {
         return this.mAttachedToComponent;
      }
      
      public function setAttachedTo(param1:String) : void
      {
         this.mAttachedToComponent = param1;
      }
      
      public function setIsClickable(param1:Boolean) : void
      {
         this.mIsClickable = param1;
      }
      
      public function isClickable() : Boolean
      {
         return this.mIsClickable;
      }
      
      public function hasToWaitForPopup() : Boolean
      {
         return this.mWaitForPopup;
      }
      
      public function needsToBeOnline() : Boolean
      {
         return this.mNeedsOnline;
      }
   }
}

