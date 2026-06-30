package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.BoostsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSMenuButton;
   import com.fs.tcgengine.view.popups.dungeons.PopupDungeonLevelFailed;
   import com.fs.tcgengine.view.popups.levels.PopupPostBoost;
   import com.fs.tcgengine.view.popups.raids.PopupRaidLevelFailed;
   import starling.events.Event;
   
   public class PostBoostButton extends Component implements FSModelUnloadableInterface
   {
      
      private var mButton:FSMenuButton;
      
      private var mBattleStatus:int;
      
      private var mBoostDef:BoostDef;
      
      public function PostBoostButton(param1:int)
      {
         super();
         this.mBattleStatus = param1;
         this.init();
      }
      
      private function init() : void
      {
         this.createButton();
      }
      
      private function createButton() : void
      {
         var _loc1_:String = null;
         if(this.mButton == null)
         {
            switch(this.mBattleStatus)
            {
               case PopupPostBoost.OUT_OF_LIFES:
                  this.mBoostDef = InstanceMng.getBoostsDefMng().getBoostDefByKeyname(BoostsMng.POST_BOOST_ID_HP);
                  break;
               case PopupPostBoost.OUT_OF_TURNS:
                  this.mBoostDef = InstanceMng.getBoostsDefMng().getBoostDefByKeyname(BoostsMng.POST_BOOST_ID_EXTRA_TURNS);
                  break;
               case PopupPostBoost.OUT_OF_LIFES_AND_TURNS:
                  this.mBoostDef = InstanceMng.getBoostsDefMng().getBoostDefByKeyname(BoostsMng.POST_BOOST_ID_EXTRA_HP_TURNS);
            }
            _loc1_ = this.mBoostDef.getBGImageName();
            this.mButton = new FSMenuButton(Constants.KEEP_PLAYING_BUTTON_UP_NAME,TextManager.getText("TID_GEN_LEVEL_KEEP"),this.onButtonTriggered,_loc1_);
            Utils.setupButton9Scale(this.mButton.getButton(),15,17.5,4,2.5,125.75,42);
            this.mButton.updatePositions();
            this.mButton.setFontProperties(FSResourceMng.getFontByType(),FSResourceMng.FONT_STD_TITLE_SIZE);
            addChild(this.mButton);
         }
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         this.mButton.setEnabled(param1);
         this.mButton.visible = param1;
      }
      
      private function onButtonTriggered(param1:Event) : void
      {
         if(Root.smBattleData.isDungeon)
         {
            if(parent is PopupDungeonLevelFailed && PopupDungeonLevelFailed(parent) != null)
            {
               PopupDungeonLevelFailed(parent).onPostBoostButtonClicked(this.mBoostDef);
            }
         }
         else if(Root.smBattleData.isRaid)
         {
            if(parent is PopupRaidLevelFailed && PopupRaidLevelFailed(parent) != null)
            {
               PopupRaidLevelFailed(parent).onPostBoostButtonClicked(this.mBoostDef);
            }
         }
         else if(parent is PopupPostBoost && PopupPostBoost(parent) != null)
         {
            PopupPostBoost(parent).onPostBoostButtonClicked(this.mBoostDef);
         }
      }
      
      public function getBoostDef() : BoostDef
      {
         return this.mBoostDef;
      }
      
      override public function dispose() : void
      {
         if(this.mButton)
         {
            this.mButton.removeFromParent(true);
            this.mButton = null;
         }
         this.mBoostDef = null;
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mButton)
         {
            this.mButton.removeFromParent();
            this.mButton = null;
         }
      }
   }
}

