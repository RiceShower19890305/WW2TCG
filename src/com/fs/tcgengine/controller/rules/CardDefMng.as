package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.rules.ActionDef;
   import com.fs.tcgengine.model.rules.AttachmentDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import flash.utils.Dictionary;
   
   public class CardDefMng extends DefMng
   {
      
      private var mCardsNeedingQuestToCraft:Vector.<CardDef>;
      
      public function CardDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function readDefs() : void
      {
         var _loc2_:Def = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc1_:int = 0;
         if(mJSONDef != null)
         {
            for(_loc4_ in mJSONDef)
            {
               _loc3_ = mJSONDef[_loc4_];
               _loc2_ = createDef();
               _loc2_.fromJSON(_loc3_);
               addDef(_loc2_);
               if(InstanceMng.getResourcesMng())
               {
                  InstanceMng.getResourcesMng().addCardValue(_loc2_.getSku(),CardDef(_loc2_).getCardValue());
                  InstanceMng.getResourcesMng().addCraftingCardMaterial(CardDef(_loc2_).getCraftSku());
                  InstanceMng.getResourcesMng().addCraftingCardMaterial(CardDef(_loc2_).getFusionSku());
                  InstanceMng.getResourcesMng().addCardEdition(_loc2_.getSku(),CardDef(_loc2_).getGameEditionIndex());
               }
            }
         }
         Root.assets.removeObject(mTag);
         mJSONDef = null;
      }
      
      override public function getDefBySku(param1:String) : Def
      {
         var _loc2_:Def = null;
         if(UnitDef(InstanceMng.getUnitsDefMng().getDefBySku(param1)) != null)
         {
            return UnitDef(InstanceMng.getUnitsDefMng().getDefBySku(param1));
         }
         if(ActionDef(InstanceMng.getActionsDefMng().getDefBySku(param1)) != null)
         {
            return ActionDef(InstanceMng.getActionsDefMng().getDefBySku(param1));
         }
         if(AttachmentDef(InstanceMng.getAttachmentsDefMng().getDefBySku(param1)) != null)
         {
            return AttachmentDef(InstanceMng.getAttachmentsDefMng().getDefBySku(param1));
         }
         if(PowerDef(InstanceMng.getPowerDefMng().getDefBySku(param1)) != null)
         {
            return PowerDef(InstanceMng.getPowerDefMng().getDefBySku(param1));
         }
         return _loc2_;
      }
      
      public function getAllCrafteableCards(param1:int = -1, param2:int = -1) : Dictionary
      {
         var _loc4_:RarityDef = null;
         var _loc3_:Dictionary = InstanceMng.getRaritiesDefMng().getAllDefs();
         var _loc5_:String = "";
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.getIndex() > 1)
            {
               _loc5_ += _loc5_ != "" ? "," + _loc4_.getSku() : _loc4_.getSku();
            }
         }
         return this.getAllCardsDefs(_loc5_,1,null,param1,null,null,true,-1,param2);
      }
      
      public function getAllCardsDefs(param1:String = null, param2:int = -1, param3:String = null, param4:int = -1, param5:String = null, param6:Array = null, param7:Boolean = false, param8:int = -1, param9:int = -1) : Dictionary
      {
         var _loc19_:Def = null;
         var _loc20_:int = 0;
         var _loc21_:String = null;
         var _loc22_:UnitDef = null;
         var _loc23_:AttachmentDef = null;
         var _loc24_:ActionDef = null;
         var _loc25_:PowerDef = null;
         var _loc26_:String = null;
         var _loc27_:int = 0;
         var _loc10_:Dictionary = InstanceMng.getUnitsDefMng().getAllDefs();
         var _loc11_:Dictionary = InstanceMng.getAttachmentsDefMng().getAllDefs();
         var _loc12_:Dictionary = InstanceMng.getActionsDefMng().getAllDefs();
         var _loc13_:Dictionary = InstanceMng.getPowerDefMng().getAllDefs();
         var _loc14_:Array = DictionaryUtils.getKeys(_loc10_);
         var _loc15_:Array = DictionaryUtils.getKeys(_loc11_);
         var _loc16_:Array = DictionaryUtils.getKeys(_loc12_);
         var _loc17_:Array = DictionaryUtils.getKeys(_loc13_);
         var _loc18_:Dictionary = new Dictionary(true);
         var _loc28_:Boolean = false;
         var _loc29_:Boolean = param4 != -1;
         if(param4 == CategoriesDefMng.CATEGORY_UNITS || !_loc29_)
         {
            _loc20_ = 0;
            while(_loc20_ < _loc14_.length)
            {
               _loc21_ = _loc14_[_loc20_];
               _loc22_ = UnitDef(_loc10_[_loc21_]);
               _loc28_ = !this.cardDefPassesFilters(_loc22_,param1,param2,param3,param5,param7,param8,param9);
               if(!_loc28_)
               {
                  if(param6 != null)
                  {
                     if(this.checkSubcategory(_loc22_,param6))
                     {
                        _loc18_[_loc21_] = _loc22_;
                     }
                  }
                  else
                  {
                     _loc18_[_loc21_] = _loc22_;
                  }
               }
               _loc20_++;
            }
         }
         if(param4 == CategoriesDefMng.CATEGORY_ATTACHMENTS || !_loc29_)
         {
            _loc20_ = 0;
            while(_loc20_ < _loc15_.length)
            {
               _loc21_ = _loc15_[_loc20_];
               _loc23_ = AttachmentDef(_loc11_[_loc21_]);
               _loc28_ = !this.cardDefPassesFilters(_loc23_,param1,param2,param3,param5,param7,param8,param9);
               if(!_loc28_)
               {
                  _loc18_[_loc21_] = _loc23_;
               }
               _loc20_++;
            }
         }
         if(param4 == CategoriesDefMng.CATEGORY_ACTIONS || !_loc29_)
         {
            _loc20_ = 0;
            while(_loc20_ < _loc16_.length)
            {
               _loc21_ = _loc16_[_loc20_];
               _loc24_ = ActionDef(_loc12_[_loc21_]);
               _loc28_ = !this.cardDefPassesFilters(_loc24_,param1,param2,param3,param5,param7,param8,param9);
               if(!_loc28_)
               {
                  _loc18_[_loc21_] = _loc24_;
               }
               _loc20_++;
            }
         }
         if(param4 == CategoriesDefMng.CATEGORY_POWERS || !_loc29_)
         {
            _loc20_ = 0;
            while(_loc20_ < _loc17_.length)
            {
               _loc21_ = _loc17_[_loc20_];
               _loc25_ = PowerDef(_loc13_[_loc21_]);
               _loc28_ = !this.cardDefPassesFilters(_loc25_,param1,param2,param3,param5,param7,param8,param9);
               if(!_loc28_)
               {
                  _loc18_[_loc21_] = _loc25_;
               }
               _loc20_++;
            }
         }
         return _loc18_;
      }
      
      public function checkSubcategory(param1:CardDef, param2:Array) : Boolean
      {
         return Utils.isAnySubcategorySkuAllowed(param1.getSubCategorySku(),param2);
      }
      
      public function isAnyCardCrafteable() : Boolean
      {
         var _loc1_:int = 0;
         var _loc3_:CardDef = null;
         var _loc2_:Boolean = false;
         var _loc4_:Dictionary = this.getAllCrafteableCards();
         FSDebug.debugTrace("Analizing " + DictionaryUtils.getDictionaryLength(_loc4_) + " cards");
         for each(_loc3_ in _loc4_)
         {
            if(_loc3_)
            {
               if(DictionaryUtils.isCardAvailableToCraft(_loc3_))
               {
                  Root.smCraftsAvailable = true;
                  return true;
               }
            }
         }
         Root.smCraftsAvailable = false;
         return _loc2_;
      }
      
      public function getFirstNeededCraftMaterialAmount(param1:CardDef) : int
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Dictionary = null;
         var _loc2_:int = 0;
         if(param1)
         {
            _loc3_ = param1.getSku();
            _loc5_ = param1.getCategoryIndex();
            _loc6_ = param1.getDeckFamilyID();
            _loc7_ = this.getAllCrafteableCards(_loc5_,_loc6_);
            FSDebug.debugTrace("Analizing " + DictionaryUtils.getDictionaryLength(_loc7_) + " cards");
            for each(param1 in _loc7_)
            {
               if(param1)
               {
                  if(param1.getCraftSku() == _loc3_)
                  {
                     return param1.getCraftAmountCards();
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public function cardDefPassesFilters(param1:CardDef, param2:String = null, param3:int = -1, param4:String = null, param5:String = null, param6:Boolean = false, param7:int = -1, param8:int = -1) : Boolean
      {
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc15_:Array = null;
         var _loc9_:Boolean = true;
         var _loc14_:int = 0;
         var _loc16_:Boolean = false;
         if(param1 != null)
         {
            if(param2 != null)
            {
               _loc10_ = param1.getCardRarity();
               _loc15_ = param2 ? param2.split(",") : null;
               if(_loc15_)
               {
                  _loc14_ = 0;
                  while(_loc14_ < _loc15_.length)
                  {
                     if(_loc10_ == _loc15_[_loc14_])
                     {
                        _loc16_ = true;
                        break;
                     }
                     _loc14_++;
                  }
                  if(!_loc16_ && _loc15_ != null)
                  {
                     _loc9_ = false;
                  }
               }
            }
            if(param4 != null)
            {
               _loc12_ = param1.getFactionSku();
               if(_loc12_ != param4)
               {
                  _loc9_ = false;
               }
            }
            if(param5 != null)
            {
               _loc13_ = param1.getEditionSku();
               if(_loc13_ != param5)
               {
                  _loc9_ = false;
               }
            }
            if(param3 != -1)
            {
               _loc11_ = param1.getTier();
               if(_loc11_ != 0 && _loc11_ != param3)
               {
                  _loc9_ = false;
               }
            }
            if(param6)
            {
               if(!param1.isCrafteable())
               {
                  _loc9_ = false;
               }
            }
            if(param7 != -1)
            {
               if(param1.getEnhanceLevel() != 0 && param1.getEnhanceLevel() != param7)
               {
                  _loc9_ = false;
               }
            }
            if(param8 != -1)
            {
               if(param1.getDeckFamilyID() != 0 && param1.getDeckFamilyID() != param8)
               {
                  _loc9_ = false;
               }
            }
         }
         return _loc9_;
      }
      
      public function getCardTypeByCardDef(param1:CardDef) : int
      {
         var _loc2_:int = -1;
         if(param1 is UnitDef)
         {
            return FSCard.TYPE_UNIT;
         }
         if(param1 is AttachmentDef)
         {
            return FSCard.TYPE_ATTACHMENT;
         }
         if(param1 is ActionDef)
         {
            return FSCard.TYPE_ACTION;
         }
         if(param1 is PowerDef)
         {
            return FSCard.TYPE_POWER;
         }
         return _loc2_;
      }
      
      public function getAllCardsMaterials() : Vector.<CardDef>
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<CardDef> = null;
         var _loc3_:CardDef = null;
         var _loc4_:Dictionary = this.getAllCardsDefs();
         for each(_loc3_ in _loc4_)
         {
            if(Boolean(_loc3_) && _loc3_.isCraftMaterial())
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Vector.<CardDef>();
               }
               _loc2_.push(_loc3_);
            }
         }
         _loc2_.sort(DictionaryUtils.sortByDefSku);
         return _loc2_;
      }
      
      public function getCardValue(param1:String) : int
      {
         return InstanceMng.getResourcesMng() ? InstanceMng.getResourcesMng().getCardValue(param1) : 0;
      }
      
      public function getCardEdition(param1:String) : int
      {
         return InstanceMng.getResourcesMng() ? InstanceMng.getResourcesMng().getCardEdition(param1) : 0;
      }
      
      public function getAllCardsNeedingQuestToCraft() : Vector.<CardDef>
      {
         var _loc2_:CardDef = null;
         if(this.mCardsNeedingQuestToCraft != null)
         {
            return this.mCardsNeedingQuestToCraft;
         }
         this.mCardsNeedingQuestToCraft = new Vector.<CardDef>();
         var _loc1_:Dictionary = this.getAllCardsDefs();
         for each(_loc2_ in _loc1_)
         {
            if(Boolean(_loc2_) && _loc2_.needsQuestToCraft())
            {
               if(this.mCardsNeedingQuestToCraft == null)
               {
                  this.mCardsNeedingQuestToCraft = new Vector.<CardDef>();
               }
               this.mCardsNeedingQuestToCraft.push(_loc2_);
            }
         }
         return this.mCardsNeedingQuestToCraft;
      }
   }
}

