package com.fs.tcgengine.view.components.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.utils.Utils;
   import feathers.controls.TextInput;
   import feathers.events.FeathersEventType;
   import flash.text.ReturnKeyLabel;
   import starling.events.Event;
   
   public class FSTextInput extends TextInput
   {
      
      public function FSTextInput()
      {
         super();
         if(Utils.isAndroid())
         {
            textEditorProperties.returnKeyLabel = ReturnKeyLabel.GO;
         }
         else
         {
            styleNameList.add("custom-textInput");
         }
         addEventListener(FeathersEventType.ENTER,this.inputEnterHandler);
      }
      
      private function inputEnterHandler(param1:Event) : void
      {
         if(Boolean(InstanceMng.getApplication()) && Boolean(InstanceMng.getApplication().getStage()))
         {
            InstanceMng.getApplication().getStage().focus = null;
            if(Utils.isIOS())
            {
               InstanceMng.getApplication().resizeViewport();
            }
         }
      }
      
      override public function setFocus() : void
      {
         super.setFocus();
      }
      
      override public function dispose() : void
      {
         removeEventListener(FeathersEventType.ENTER,this.inputEnterHandler);
         super.dispose();
      }
   }
}

