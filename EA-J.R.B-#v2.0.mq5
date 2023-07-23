#include <Trade/Trade.mqh>

///----------------------

input double Lots = 0.1;

input int SLPoints = 300;
input int TPPoints = 300;


input int RSIPerioden   = 50; 
input int SchwelleUnten = 70;
input int SchwelleOben  = 30;

input string Kommentar = "";

///------------------------

CTrade trade; 
bool isLongTrade, isShortTrade;

///------------------------

int OnInit(){
 
  return(INIT_SUCCEEDED);   
   
}

void OnDeinit(const int reason){
 
}

int  iMA(
   string               symbol,            // Symbolname
   ENUM_TIMEFRAMES      period,            // Periode
   int                  ma_period,         // Mittelungsperiode 
   int                  ma_shift,          // horizontale Verschiebung des Indikators 
   ENUM_MA_METHOD       ma_method,         // Glaettungstyp
   ENUM_APPLIED_PRICE   applied_price      // Preistyp oder handle
   );


///------------------------

void OnTick() {
   double rsi[];
   int rsiHandle = iRSI(_Symbol,PERIOD_CURRENT,RSIPerioden,PRICE_CLOSE);  
   CopyBuffer(rsiHandle,0,0,1,rsi);
   if(rsi[0] == 0) return;
      
   if(rsi[0] < SchwelleUnten){
         if(isShortTrade){
            trade.PositionClose(_Symbol);
            isShortTrade = false;
         }
   
   
         if(!isLongTrade) isLongTrade = executeShort(); 
   }
 
   else if(rsi[0] > SchwelleOben){
         if(isLongTrade){
            trade.PositionClose(_Symbol);
            isLongTrade = false;
           }
            
         if(!isShortTrade) isShortTrade = executeLong();
   }
    Comment(rsi[0]);
 }

///------------------------

 bool executeShort(){
 
      double entry = SymbolInfoDouble(_Symbol,SYMBOL_BID);
      double sl = entry + SLPoints + _Point;
      double tp = entry - TPPoints *  _Point;
      bool res;
    
      res = trade.Sell(Lots,_Symbol,entry,sl,tp,Kommentar);
      return res;
 
}
 
bool executeLong(){

      double entry = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      double sl = entry - SLPoints + _Point;
      double tp = entry + TPPoints * _Point;
      bool res;
      
      res = trade.Buy(Lots,_Symbol,entry,sl,tp,Kommentar);
      return res;
}

///--------------------