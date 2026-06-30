package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.DungeonsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import flash.ui.Mouse;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   
   public class FSDungeonSlotDifficultyInfo extends Component implements FSModelUnloadableInterface
   {
      
      protected var mBG:FSImage;
      
      private var mTextfield:FSTextfield;
      
      protected var mGoldCost:FSButton;
      
      private var mParentDungeonSlotInfo:FSDungeonSlotInfo;
      
      private var mDifficultyIndex:int;
      
      private var mIsSelected:Boolean;
      
      public function FSDungeonSlotDifficultyInfo(param1:FSDungeonSlotInfo, param2:int)
      {
         super();
         this.mParentDungeonSlotInfo = param1;
         this.mDifficultyIndex = param2;
         this.init();
      }
      
      private function init() : void
      {
         this.createBG();
         this.createGoldButton();
         this.createText();
         this.addEventListeners();
      }
      
      public function isPlayable() : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc1_:Boolean = false;
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(_loc2_)
         {
            _loc3_ = Config.getConfig().getUnlockMediumDifficulty();
            _loc4_ = _loc2_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY);
            _loc5_ = _loc4_ >= _loc3_;
            switch(this.mDifficultyIndex)
            {
               case 0:
                  _loc1_ = true;
                  break;
               case 1:
                  _loc1_ = _loc5_;
                  break;
               case 2:
               case 3:
                  _loc1_ = _loc5_;
            }
         }
         return _loc1_;
      }
      
      private function addEventListeners() : void
      {
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(!Root.assets.isLoading)
            {
               if(this.isPlayable())
               {
                  if(InstanceMng.getCurrentScreen() is FSDungeonsScreen)
                  {
                     FSDungeonsScreen(InstanceMng.getCurrentScreen()).onDifficultySelected(this.mDifficultyIndex);
                     this.mParentDungeonSlotInfo.onDifficultySelected(this.mDifficultyIndex);
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_UNLOCK_DIFF"),true);
                  Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_LEVEL_DIFF_2_LOCKED"),[Config.getConfig().getUnlockMediumDifficulty() - 1]));
               }
            }
         }
         _loc2_ = param1.getTouch(this,TouchPhase.HOVER);
         alpha = _loc2_ ? 0.8 : 1;
         if(Utils.isBrowser() || Utils.isDesktop())
         {
            Mouse.cursor = _loc2_ ? "hand" : "auto";
         }
      }
      
      public function setSelected(param1:Boolean) : void
      {
         if(this.mIsSelected != param1)
         {
            this.mIsSelected = param1;
            this.manageBG();
         }
      }
      
      private function manageBG() : void
      {
         var _loc1_:Texture = null;
         if(this.mBG)
         {
            _loc1_ = this.mIsSelected ? Root.assets.getTexture("dungeon_diff_button_selected") : Root.assets.getTexture("dungeon_diff_button");
            this.mBG.texture = _loc1_;
         }
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            if(this.mParentDungeonSlotInfo != null)
            {
               this.mBG = new FSImage(Root.assets.getTexture("dungeon_diff_button"));
               this.mBG.color = this.isPlayable() ? 16777215 : 16711680;
               addChild(this.mBG);
            }
         }
      }
      
      private function createGoldButton() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this.mGoldCost == null)
         {
            _loc1_ = this.mParentDungeonSlotInfo.getDungeonDef().getGoldCostByDifficultyIndex(this.mDifficultyIndex).toString();
            if(_loc1_ != null && _loc1_ != "")
            {
               _loc1_ = _loc1_ == "0" ? TextManager.getText("TID_GEN_FREE") : _loc1_;
               _loc1_ = this.isPlayable() ? _loc1_ : "";
            }
            _loc2_ = this.isPlayable() ? "dungeon_small_gold" : "dungeon_diff_locked";
            this.mGoldCost = new FSButton(Root.assets.getTexture(_loc2_),_loc1_);
            this.mGoldCost.fontColor = 16777215;
            this.mGoldCost.fontName = FSResourceMng.getFontByType();
            this.mGoldCost.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mGoldCost.enableScaleOnMouseOver(false);
            this.mGoldCost.x = this.mGoldCost.width / 2;
            this.mGoldCost.y = this.mBG.height / 2;
            addChild(this.mGoldCost);
         }
      }
      
      private function createText() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mTextfield == null) && Boolean(this.mBG) && Boolean(this.mGoldCost))
         {
            switch(this.mDifficultyIndex)
            {
               case DungeonsMng.DUNGEON_DIFFICULTY_EASY:
                  _loc1_ = TextManager.getText("TID_DUNGEON_DIFFICULTY_01");
                  break;
               case DungeonsMng.DUNGEON_DIFFICULTY_MEDIUM:
                  _loc1_ = TextManager.getText("TID_DUNGEON_DIFFICULTY_02");
                  break;
               case DungeonsMng.DUNGEON_DIFFICULTY_HARD:
                  _loc1_ = TextManager.getText("TID_DUNGEON_DIFFICULTY_03");
                  break;
               case DungeonsMng.DUNGEON_DIFFICULTY_EXPERT:
                  _loc1_ = TextManager.getText("TID_DUNGEON_DIFFICULTY_04_diff");
            }
            this.mTextfield = new FSTextfield(this.mBG.width - this.mGoldCost.width,this.mBG.height,_loc1_);
            this.mTextfield.x = this.mGoldCost.x + this.mGoldCost.width / 2;
            this.mTextfield.y = 0;
            addChild(this.mTextfield);
         }
      }
      
      public function getDifficultyIndex() : int
      {
         return this.mDifficultyIndex;
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         if(this.mGoldCost)
         {
            this.mGoldCost.removeFromParent(true);
            this.mGoldCost = null;
         }
         this.mParentDungeonSlotInfo = null;
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG.destroy();
            this.mBG = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent();
            this.mTextfield = null;
         }
         if(this.mGoldCost)
         {
            this.mGoldCost.removeFromParent();
            this.mGoldCost.destroy();
            this.mGoldCost = null;
         }
         this.mParentDungeonSlotInfo = null;
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
      }
   }
}

