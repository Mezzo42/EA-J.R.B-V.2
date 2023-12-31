///------J.R.B--------------------------------------------

#include <Trade/Trade.mqh>

///-------------------------------------------------------

input double Lots = 0.1;

///---------------------------------------------------------

input int SLPoints = 300;
input int TPPoints = 300;

///---------------------------------------------------------

input int RSIPerioden   = 50; 
input int SchwelleUnten = 50;
input int SchwelleOben  = 65;

///--------------------------------------------------------

input int EMA           = 200;

///---------------------------------------------------------

input string Kommentar = "";

///----------------------------------------------------------

CTrade trade; 
bool isLongTrade, isShortTrade;
bool   Expert_EveryTick     =false;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

int OnInit(){

   int movingAverageDefinition = iMA(_Symbol,_Period,200,0,MODE_EMA,PRICE_CLOSE);
     
///--------------
     
   ChartSetInteger(0, CHART_COLOR_BACKGROUND, clrWhite);    // Hintergrundfarbe auf Rot ändern
   ChartSetInteger(0, CHART_COLOR_CHART_UP, clrGray);       // Kerzenfarbe UP auf Grün ändern
   ChartSetInteger(0, CHART_COLOR_CHART_DOWN, clrBlack);    // Kerzenfarbe DOWN auf Rot ändern
   ChartSetInteger(0, CHART_COLOR_GRID, clrWhite);          // Gridfarbe auf Weiß ändern
   ChartSetInteger(0, CHART_COLOR_CHART_LINE, clrBlack);    // Graph auf Weiß ändern
 
 
  return(INIT_SUCCEEDED);   
   
}

///-------------------------------------------------------------

void OnDeinit(const int reason){
 
}

///--------------------------------------------------------------

void OnTick() {
   double rsi[];
   int movingAverageDefinition = iMA(_Symbol,_Period,200,0,MODE_EMA,PRICE_CLOSE);
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

///-------------------------------------------------------------

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

///----------------------ENDE--------------------------------