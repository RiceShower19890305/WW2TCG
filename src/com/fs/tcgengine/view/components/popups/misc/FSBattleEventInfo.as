package com.fs.tcgengine.view.components.popups.misc
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.BattleEventDef;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   
   public class FSBattleEventInfo extends Component implements FSModelUnloadableInterface
   {
      
      private var mBattleEventDef:BattleEventDef;
      
      private var mEventIcon:FSImage;
      
      private var mEventNameTextfield:FSTextfield;
      
      private var mEventDescTextfield:FSTextfield;
      
      private var mContainerWidth:int;
      
      private var mshowDescInComponent:Boolean;
      
      public function FSBattleEventInfo(param1:BattleEventDef, param2:int, param3:Boolean = false)
      {
         super();
         this.mBattleEventDef = param1;
         this.mContainerWidth = param2;
         this.mshowDescInComponent = param3;
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createEventIcon();
         this.createEventName();
         this.createEventDescription();
         if(!this.mshowDescInComponent)
         {
            setTooltipText(this.mBattleEventDef.getDesc());
         }
      }
      
      private function createEventIcon() : void
      {
         if(Boolean(this.mBattleEventDef) && this.mEventIcon == null)
         {
            this.mEventIcon = new FSImage(Root.assets.getTexture(this.mBattleEventDef.getBGImageName()));
            this.mEventIcon.x = this.mContainerWidth / 6.25;
            addChild(this.mEventIcon);
         }
      }
      
      private function createEventName() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this.mBattleEventDef) && this.mEventNameTextfield == null)
         {
            _loc1_ = this.mContainerWidth * 0.825 - (this.mEventIcon.x + this.mEventIcon.width);
            this.mEventNameTextfield = new FSTextfield(_loc1_,this.mEventIcon.height * 0.75,this.mBattleEventDef.getName());
            this.mEventNameTextfield.touchable = true;
            this.mEventNameTextfield.x = this.mEventIcon.x + this.mEventIcon.width * 1.1;
            this.mEventNameTextfield.y = this.mEventIcon.y + (this.mEventIcon.height - this.mEventNameTextfield.height) / 2;
            addChild(this.mEventNameTextfield);
         }
      }
      
      private function createEventDescription() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(Boolean(this.mshowDescInComponent) && Boolean(this.mBattleEventDef) && this.mEventDescTextfield == null)
         {
            this.mEventDescTextfield = new FSTextfield(this.mEventNameTextfield.width,this.mEventIcon.height * 0.9,this.mBattleEventDef.getDesc());
            this.mEventDescTextfield.x = this.mEventNameTextfield.x;
            this.mEventDescTextfield.y = this.mEventNameTextfield.y + this.mEventNameTextfield.height;
            addChild(this.mEventDescTextfield);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mEventIcon)
         {
            this.mEventIcon.removeFromParent(true);
            this.mEventIcon = null;
         }
         if(this.mEventNameTextfield)
         {
            this.mEventNameTextfield.removeFromParent(true);
            this.mEventNameTextfield = null;
         }
         if(this.mEventDescTextfield)
         {
            this.mEventDescTextfield.removeFromParent(true);
            this.mEventDescTextfield = null;
         }
         this.mBattleEventDef = null;
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mEventIcon)
         {
            this.mEventIcon.removeFromParent();
            this.mEventIcon.destroy();
            this.mEventIcon = null;
         }
         if(this.mEventNameTextfield)
         {
            this.mEventNameTextfield.removeFromParent();
            this.mEventNameTextfield = null;
         }
         if(this.mEventDescTextfield)
         {
            this.mEventDescTextfield.removeFromParent();
            this.mEventDescTextfield = null;
         }
      }
   }
}

