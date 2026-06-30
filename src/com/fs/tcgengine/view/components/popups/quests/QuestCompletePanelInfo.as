package com.fs.tcgengine.view.components.popups.quests
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.QuestsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.quests.Quest;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.easing.Back;
   import flash.utils.setTimeout;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class QuestCompletePanelInfo extends Component
   {
      
      private const QUEST_COMPLETED_PANEL_BG:String = "quest_completed_panel";
      
      private var mBG:FSImage;
      
      private var mQuest:Quest;
      
      private var mQuestImage:FSImage;
      
      private var mQuestDescriptionTextfield:FSTextfield;
      
      private var mQuestCompleteTextfield:FSTextfield;
      
      public function QuestCompletePanelInfo(param1:Quest)
      {
         super();
         this.mQuest = param1;
         this.createUI();
         if(this.mQuest.isDaily())
         {
            InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_DAILY_QUEST,1,true);
         }
         alignPivot();
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createImageQuest();
         this.createTextComplete();
         this.createTextDescriptionQuest();
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture(this.QUEST_COMPLETED_PANEL_BG));
            this.mBG.touchable = true;
            this.mBG.addEventListener(TouchEvent.TOUCH,this.onBGTouch);
         }
         addChild(this.mBG);
      }
      
      private function createImageQuest() : void
      {
         if(this.mQuestImage == null)
         {
            this.mQuestImage = new FSImage(Root.assets.getTexture(this.mQuest.getDef().getBGImageName()));
            this.mQuestImage.x = this.mBG.x;
            this.mQuestImage.y = this.mBG.y + (this.mBG.height - this.mQuestImage.height) / 2;
            this.mQuestImage.touchable = false;
         }
         addChild(this.mQuestImage);
      }
      
      private function createTextComplete() : void
      {
         var _loc1_:String = null;
         if(this.mQuestCompleteTextfield == null)
         {
            _loc1_ = this.mQuest.isDaily() ? TextManager.getText("TID_DAILY_QUEST_COMPLETED") : TextManager.getText("TID_QUEST_COMPLETED");
            _loc1_ = this.mQuest.getDef().isBattlePassQuest() ? TextManager.getText("TID_BP_QUEST_COMPLETED") : _loc1_;
            this.mQuestCompleteTextfield = new FSTextfield(this.mBG.width * 0.975 - (this.mQuestImage.x + this.mQuestImage.width),this.mBG.height * 0.5,_loc1_);
            this.mQuestCompleteTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mQuestCompleteTextfield.format.verticalAlign = Align.BOTTOM;
            this.mQuestCompleteTextfield.x = this.mQuestImage.x + this.mQuestImage.width;
            this.mQuestCompleteTextfield.y = this.mBG.y + 20 / Main.smScaleFactor;
            this.mQuestCompleteTextfield.touchable = false;
         }
         addChild(this.mQuestCompleteTextfield);
      }
      
      private function createTextDescriptionQuest() : void
      {
         var _loc1_:int = 0;
         if(this.mQuestDescriptionTextfield == null)
         {
            _loc1_ = this.mBG.height * 0.5 - this.mQuestCompleteTextfield.y * 2;
            _loc1_ *= Utils.isMobile() ? 2 : 1;
            this.mQuestDescriptionTextfield = new FSTextfield(this.mQuestCompleteTextfield.width,_loc1_,this.mQuest.getDef().getDesc());
            this.mQuestDescriptionTextfield.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mQuestDescriptionTextfield.format.verticalAlign = Align.TOP;
            this.mQuestDescriptionTextfield.x = this.mQuestCompleteTextfield.x;
            this.mQuestDescriptionTextfield.y = Utils.isMobile() ? this.mQuestCompleteTextfield.y + this.mQuestCompleteTextfield.height * 0.75 : this.mQuestCompleteTextfield.y + this.mQuestCompleteTextfield.height * 0.9;
            this.mQuestDescriptionTextfield.touchable = false;
         }
         addChild(this.mQuestDescriptionTextfield);
      }
      
      private function onBGTouch(param1:TouchEvent) : void
      {
         var _loc2_:FSImage = FSImage(param1.currentTarget);
         var _loc3_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc3_)
         {
            this.onPanelTimeOut();
         }
      }
      
      public function showPanel(param1:int = 0) : void
      {
         var _loc2_:FSCoordinate = new FSCoordinate(x,height * 0.8 + param1 * height);
         SpecialFX.createTransition(this,_loc2_,0.5,0,this.onPanelTransitionOver,null,Back.easeOut);
      }
      
      private function onPanelTransitionOver() : void
      {
         FSResourceMng.addToStage(this,FSResourceMng.LAYER_UI);
         setTimeout(this.onPanelTimeOut,3000);
      }
      
      private function onPanelTimeOut() : void
      {
         var _loc1_:FSCoordinate = new FSCoordinate(x,-height * 0.8);
         SpecialFX.createTransition(this,_loc1_,0.5,0,this.onPanelExitOver,null,Back.easeOut);
      }
      
      private function onPanelExitOver() : void
      {
         removeFromParent(true);
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeEventListener(TouchEvent.TOUCH,this.onBGTouch);
            this.mBG.removeFromParent();
            this.mBG.destroy();
            this.mBG = null;
         }
         if(this.mQuestCompleteTextfield)
         {
            this.mQuestCompleteTextfield.removeFromParent(true);
            this.mQuestCompleteTextfield = null;
         }
         if(this.mQuestDescriptionTextfield)
         {
            this.mQuestDescriptionTextfield.removeFromParent(true);
            this.mQuestDescriptionTextfield = null;
         }
         if(this.mQuestImage)
         {
            this.mQuestImage.removeFromParent(true);
            this.mQuestImage = null;
         }
         this.mQuest = null;
         super.dispose();
      }
   }
}

