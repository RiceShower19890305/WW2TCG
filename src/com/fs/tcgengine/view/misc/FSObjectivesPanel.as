package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TargetMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.VerticalLayout;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   
   public class FSObjectivesPanel extends Component
   {
      
      private var mObjectivesCatalog:Dictionary;
      
      protected var mScrollContainer:ScrollContainer;
      
      public function FSObjectivesPanel()
      {
         super();
      }
      
      public function setObjectivesText(param1:int, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:FSObjectiveTick = null;
         if(this.mObjectivesCatalog == null)
         {
            this.mObjectivesCatalog = new Dictionary(true);
         }
         if(param2 != null)
         {
            _loc3_ = param2.sku;
            _loc4_ = param1.toString() + "-" + _loc3_;
            _loc5_ = Boolean(param2) && param2.hasOwnProperty("text") ? param2.text : "";
            _loc5_ = Config.getConfig().gameObjectivesShowText() ? _loc5_ : "";
            if(this.mObjectivesCatalog[_loc4_] == null)
            {
               _loc7_ = new FSObjectiveTick(_loc5_,false,false,false,true,param1,param2);
               if(_loc5_ != null && _loc5_ != "" && _loc5_.length > 0)
               {
                  _loc7_.touchable = true;
                  _loc7_.setTooltipText(_loc5_);
               }
               _loc7_.changeLabelFontName(FSResourceMng.getFontByType());
               if(param1 != TargetMng.MAIN_SUBOBJECTIVE)
               {
                  _loc7_.setAmountRequested(param2.amountRequired);
                  _loc7_.setCurrentAmount(0);
               }
               this.mObjectivesCatalog[_loc4_] = _loc7_;
               this.addToScrollContainer(_loc7_);
            }
            else if(param1 == TargetMng.MAIN_SUBOBJECTIVE && _loc5_ != null)
            {
               FSObjectiveTick(this.mObjectivesCatalog[_loc4_]).setText(_loc5_);
               if(_loc5_ != null && _loc5_ != "" && _loc5_.length > 0)
               {
                  FSObjectiveTick(this.mObjectivesCatalog[_loc4_]).touchable = true;
                  FSObjectiveTick(this.mObjectivesCatalog[_loc4_]).setTooltipText(_loc5_);
               }
            }
            _loc6_ = InstanceMng.getTargetMng().getSubObjectiveCurrentAmount(param1,_loc3_);
            if(param1 != TargetMng.MAIN_SUBOBJECTIVE)
            {
               FSObjectiveTick(this.mObjectivesCatalog[_loc4_]).setCurrentAmount(_loc6_);
            }
            else
            {
               FSObjectiveTick(this.mObjectivesCatalog[_loc4_]).setChecked(_loc6_ == 1);
            }
         }
         if(this.mScrollContainer != null)
         {
            addChild(this.mScrollContainer);
         }
      }
      
      protected function addToScrollContainer(param1:FSObjectiveTick) : void
      {
         var _loc2_:int = 0;
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            if(this.mScrollContainer == null)
            {
               this.mScrollContainer = new ScrollContainer();
               this.mScrollContainer.touchable = false;
               if(Config.getConfig().gameObjectivesSmall())
               {
                  _loc2_ = Utils.isAndroidOrDesktop() ? int(FSBattleScreen(InstanceMng.getCurrentScreen()).getAttackButton().width * 1.35) : int(Starling.current.stage.stageWidth * 0.29);
               }
               else
               {
                  _loc2_ = FSBattleScreen(InstanceMng.getCurrentScreen()).getDeckAreaWidth();
               }
               this.mScrollContainer.width = _loc2_;
               this.mScrollContainer.height = FSBattleScreen(InstanceMng.getCurrentScreen()).getDeckAreaHeight();
               this.mScrollContainer.y = 0;
               if(!Config.getConfig().battleHasSimpleUI())
               {
                  this.mScrollContainer.layout = this.getLayout();
               }
               this.mScrollContainer.horizontalScrollPolicy = ScrollPolicy.OFF;
               this.mScrollContainer.verticalScrollPolicy = ScrollPolicy.OFF;
               addChild(this.mScrollContainer);
            }
            this.mScrollContainer.addChild(param1);
         }
      }
      
      protected function getLayout() : VerticalLayout
      {
         return new VerticalLayout();
      }
      
      override public function dispose() : void
      {
         var _loc1_:FSObjectiveTick = null;
         if(this.mObjectivesCatalog)
         {
            for each(_loc1_ in this.mObjectivesCatalog)
            {
               _loc1_.removeFromParent(true);
            }
            DictionaryUtils.clearDictionary(this.mObjectivesCatalog);
            this.mObjectivesCatalog = null;
         }
         if(this.mScrollContainer)
         {
            this.mScrollContainer.removeFromParent(true);
            this.mScrollContainer = null;
         }
         super.dispose();
      }
   }
}

