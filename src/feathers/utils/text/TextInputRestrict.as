package feathers.utils.text
{
   import flash.utils.Dictionary;
   
   public class TextInputRestrict
   {
      
      protected static const REQUIRES_ESCAPE:Dictionary = new Dictionary();
      
      REQUIRES_ESCAPE[/\[/g] = "\\[";
      REQUIRES_ESCAPE[/\]/g] = "\\]";
      REQUIRES_ESCAPE[/\{/g] = "\\{";
      REQUIRES_ESCAPE[/\}/g] = "\\}";
      REQUIRES_ESCAPE[/\(/g] = "\\(";
      REQUIRES_ESCAPE[/\)/g] = "\\)";
      REQUIRES_ESCAPE[/\|/g] = "\\|";
      REQUIRES_ESCAPE[/\//g] = "\\/";
      REQUIRES_ESCAPE[/\./g] = "\\.";
      REQUIRES_ESCAPE[/\+/g] = "\\+";
      REQUIRES_ESCAPE[/\*/g] = "\\*";
      REQUIRES_ESCAPE[/\?/g] = "\\?";
      REQUIRES_ESCAPE[/\$/g] = "\\$";
      
      protected var _restrictStartsWithExclude:Boolean = false;
      
      protected var _restricts:Vector.<RegExp>;
      
      private var _restrict:String;
      
      public function TextInputRestrict(param1:String = null)
      {
         super();
         this.restrict = param1;
      }
      
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function set restrict(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(this._restrict === param1)
         {
            return;
         }
         this._restrict = param1;
         if(param1)
         {
            if(this._restricts)
            {
               this._restricts.length = 0;
            }
            else
            {
               this._restricts = new Vector.<RegExp>(0);
            }
            if(this._restrict === "")
            {
               this._restricts.push(/^$/);
            }
            else if(this._restrict)
            {
               _loc2_ = 0;
               _loc3_ = param1.indexOf("^") == 0;
               this._restrictStartsWithExclude = _loc3_;
               while(true)
               {
                  _loc4_ = param1.indexOf("^",_loc2_ + 1);
                  while(_loc4_ != -1 && param1.charAt(_loc4_ - 1) === "\\")
                  {
                     _loc4_ = param1.indexOf("^",_loc4_ + 1);
                  }
                  if(_loc4_ < 0)
                  {
                     break;
                  }
                  _loc5_ = param1.substr(_loc2_,_loc4_ - _loc2_);
                  this._restricts.push(this.createRestrictRegExp(_loc5_,_loc3_));
                  _loc2_ = _loc4_;
                  _loc3_ = !_loc3_;
               }
               _loc5_ = param1.substr(_loc2_);
               this._restricts.push(this.createRestrictRegExp(_loc5_,_loc3_));
            }
         }
         else
         {
            this._restricts = null;
         }
      }
      
      public function isCharacterAllowed(param1:int) : Boolean
      {
         var _loc7_:RegExp = null;
         if(!this._restricts)
         {
            return true;
         }
         var _loc2_:String = String.fromCharCode(param1);
         var _loc3_:Boolean = this._restrictStartsWithExclude;
         var _loc4_:Boolean = _loc3_;
         var _loc5_:int = int(this._restricts.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = this._restricts[_loc6_];
            if(_loc3_)
            {
               _loc4_ &&= _loc7_.test(_loc2_);
            }
            else
            {
               _loc4_ ||= _loc7_.test(_loc2_);
            }
            _loc3_ = !_loc3_;
            _loc6_++;
         }
         return _loc4_;
      }
      
      public function filterText(param1:String) : String
      {
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:RegExp = null;
         if(!this._restricts)
         {
            return param1;
         }
         var _loc2_:* = param1.length;
         var _loc3_:int = int(this._restricts.length);
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = param1.charAt(_loc4_);
            _loc7_ = _loc6_ = this._restrictStartsWithExclude;
            _loc8_ = 0;
            while(_loc8_ < _loc3_)
            {
               _loc9_ = this._restricts[_loc8_];
               if(_loc6_)
               {
                  _loc7_ &&= _loc9_.test(_loc5_);
               }
               else
               {
                  _loc7_ ||= _loc9_.test(_loc5_);
               }
               _loc6_ = !_loc6_;
               _loc8_++;
            }
            if(!_loc7_)
            {
               param1 = param1.substr(0,_loc4_) + param1.substr(_loc4_ + 1);
               _loc4_--;
               _loc2_--;
            }
            _loc4_++;
         }
         return param1;
      }
      
      protected function createRestrictRegExp(param1:String, param2:Boolean) : RegExp
      {
         var _loc3_:Object = null;
         var _loc4_:RegExp = null;
         var _loc5_:String = null;
         if(!param2 && param1.indexOf("^") == 0)
         {
            param1 = param1.substr(1);
         }
         param1 = param1.replace(/\\(?=[^\-\^\\])/g,"\\\\");
         for(_loc3_ in REQUIRES_ESCAPE)
         {
            _loc4_ = _loc3_ as RegExp;
            _loc5_ = REQUIRES_ESCAPE[_loc4_] as String;
            param1 = param1.replace(_loc4_,_loc5_);
         }
         return new RegExp("[" + param1 + "]");
      }
   }
}

