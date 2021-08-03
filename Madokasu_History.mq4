//+------------------------------------------------------------------+
//|                                                 Madokasu_History |
//|                                 https://madokasu-fx.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "@nobclarinet"
#property link      "https://madokasu-fx.blogspot.com"
extern bool   DealMarkers    = True;
extern bool   DepoStats      = True;
extern bool   ShowLive       = True;
extern string MagicFilter    = "";
extern color  clAccName      = Silver;
extern color  clInfData      = Gray;
extern int    FontSize       = 8;
extern int    DigitsLength   = 9;
extern int    PercentLength  = 5;
extern color  clLineProfit   = Lime;
extern color  clLineLoss     = Red;
extern color  clMarkerBuy    = Lime;
extern color  clMarkerSell   = Red;
extern color  clMarkerClose  = Silver;
int      X,Y;
int      i;
int      inf_count;
string   inf_name[10];
string   inf_data[10];
int      maxLengthN, maxLengthD;
string   accName;
#property indicator_chart_window
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   X = 10;
   Y = 35;
   inf_count  = 8;
   maxLengthN = 13;
   maxLengthD = 18+(DigitsLength-6);
   for(i=0; i<=inf_count-1; i++)
     {
      inf_name[i]="";
      inf_data[i]="";
     }
      inf_name[0] = "Account №: ";
      inf_name[1] = "Deposit: ";
      inf_name[2] = "Balance: ";
      inf_name[3] = "Profit: ";
      inf_name[4] = "Withdraw: ";
      inf_name[5] = "Margin: ";
      inf_name[6] = "Equity-Balance: ";
      inf_name[7] = "Equity: ";
   if(MagicFilter != "")
      MagicFilter = "," + MagicFilter + ",";
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   DeleteIndObjects();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   if(DepoStats)
     {
      string accName     = AccountName();
      string accNumber   = AccountNumber();
      string accCurrency = AccountCurrency();
      double accBalance  = AccountBalance();
      double accMargin   = AccountMargin();
      double accEquity   = AccountEquity();
      double accDepo     = Depo();
      double accProfit   = Profit();
      double accWidch    = Widch();
      int md = ((maxLengthN + maxLengthD - StringLen(accName))/2) + StringLen(accName);
      while(StringLen(accName) < md)
         accName = accName + " ";
      string sign="";
      if(accBalance>accDepo)
         sign = "+";
      if(ObjectFind("AccountName")<0)
         ObjectCreate("AccountName", OBJ_LABEL, 0, 0, 0);
      ObjectSet("AccountName", OBJPROP_CORNER, 1);
      ObjectSetText("AccountName", accName, FontSize, "Lucida Console", clAccName);
      ObjectSet("AccountName", OBJPROP_XDISTANCE, X);
      ObjectSet("AccountName", OBJPROP_YDISTANCE, Y - 15);
     }
   if(DealMarkers || ShowLive)
     {
      datetime ot, ct;
      double   op, cp, tp, sl;
      int      i,  ty, k, iMagicNum;
      if(DealMarkers)
        {
         k=OrdersHistoryTotal();
         for(i=0; i<k; i++)
           {
            if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
              {
               if(MagicFilter != "")
                 {
                  iMagicNum = OrderMagicNumber();
                  iMagicNum = StringFind(MagicFilter, "," + iMagicNum + ",");
                 }
               else
                  iMagicNum = 1;
               ty=OrderType();
               if(OrderSymbol()==Symbol() && ty<2 && iMagicNum != -1)
                 {
                  ot=OrderOpenTime();
                  op=OrderOpenPrice();
                  ct=OrderCloseTime();
                  cp=OrderClosePrice();
                  SetObj(OrderTicket(), ty, ot, op, ct, cp);
                 }
              }
           }
        }
      if(ShowLive)
        {
         k=OrdersTotal();
         for(i=0; i<k; i++)
           {
            if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
              {
               if(MagicFilter != "")
                 {
                  iMagicNum = OrderMagicNumber();
                  iMagicNum = StringFind(MagicFilter, "," + iMagicNum + ",");
                 }
               else
                  iMagicNum = 1;
               ty=OrderType();
               if(OrderSymbol()==Symbol() && ty<2 && iMagicNum != -1)
                 {
                  ot=OrderOpenTime();
                  op=OrderOpenPrice();
                  tp=OrderTakeProfit();
                  sl=OrderStopLoss();
                  SetObj(OrderTicket(), ty, ot, op, 0, 0, tp, sl);
                 }
              }
           }
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string RAlignD(string s="")
  {
   while(StringLen(s) < DigitsLength)
      s = StringConcatenate(" ", s);
   return(s);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string RAlignP(string s="")
  {
   while(StringLen(s) < PercentLength+3)
      s = StringConcatenate(" ", s);
   return(s);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Depo()
  {
   int y=0;
   double d=0;
   for(y=0; y<OrdersHistoryTotal(); y++)
     {
      OrderSelect(y,SELECT_BY_POS,MODE_HISTORY);
      if(OrderType()==6 && OrderProfit()>0)
         d+=OrderProfit();
     }
   return(d);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Widch()
  {
   int y=0;
   double w=0;
   for(y=0; y<OrdersHistoryTotal(); y++)
     {
      OrderSelect(y,SELECT_BY_POS,MODE_HISTORY);
      if(OrderType()==6 && OrderProfit()<0)
         w+=OrderProfit();
     }
   return(w);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Profit()
  {
   int y=0;
   double p=0;
   for(y=0; y<OrdersHistoryTotal(); y++)
     {
      OrderSelect(y,SELECT_BY_POS,MODE_HISTORY);
      if(OrderType()<2)
         p+=OrderProfit()+OrderSwap()+OrderCommission();
     }
   return(p);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetObj(int or, int ty, datetime ot, double op, datetime ct=0, double cp=0, double tp=0, double sl=0)
  {
   datetime tc = TimeCurrent()-(240*Period());
   datetime tf = TimeCurrent()+(600*Period());
   if(ct!=0)
     {
      string no="Deal";
      if(ObjectFind(no+or)<0)
         ObjectCreate(no+or, OBJ_TREND, 0, 0, 0, 0, 0);
      ObjectSet(no+or, OBJPROP_STYLE, STYLE_DOT);
      ObjectSet(no+or, OBJPROP_TIME1, ot);
      ObjectSet(no+or, OBJPROP_PRICE1, op);
      ObjectSet(no+or, OBJPROP_TIME2, ct);
      ObjectSet(no+or, OBJPROP_PRICE2, cp);
      if(ty==OP_BUY)
        {
         if(op<cp)
            ObjectSet(no+or, OBJPROP_COLOR, clLineProfit);
         if(op>cp)
            ObjectSet(no+or, OBJPROP_COLOR, clLineLoss);
        }
      if(ty==OP_SELL)
        {
         if(op>cp)
            ObjectSet(no+or, OBJPROP_COLOR, clLineProfit);
         if(op<cp)
            ObjectSet(no+or, OBJPROP_COLOR, clLineLoss);
        }
      ObjectSet(no+or, OBJPROP_RAY, False);
      if(ObjectFind("ADealTP"+or)!=-1)
         ObjectDelete("ADealTP"+or);
      if(ObjectFind("ADealTP-l-"+or)!=-1)
         ObjectDelete("ADealTP-l-"+or);
      if(ObjectFind("ADealSL"+or)!=-1)
         ObjectDelete("ADealSL"+or);
      if(ObjectFind("ADealSL-l-"+or)!=-1)
         ObjectDelete("ADealSL-l-"+or);
     }
   no="ADealOp";
   if(ObjectFind(no+or)<0)
      ObjectCreate(no+or, OBJ_ARROW, 0, 0,0);
   ObjectSet(no+or, OBJPROP_TIME1, ot);
   if(ty==OP_BUY)
     {
      ObjectSet(no+or, OBJPROP_PRICE1, op);
      ObjectSet(no+or, OBJPROP_COLOR, clMarkerBuy);
      ObjectSet(no+or, OBJPROP_ARROWCODE, SYMBOL_LEFTPRICE);
     }
   if(ty==OP_SELL)
     {
      ObjectSet(no+or, OBJPROP_PRICE1, op);
      ObjectSet(no+or, OBJPROP_COLOR, clMarkerSell);
      ObjectSet(no+or, OBJPROP_ARROWCODE, SYMBOL_LEFTPRICE);
     }
   if(cp!=0)
     {
      no="ADealCl";
      if(ObjectFind(no+or)<0)
         ObjectCreate(no+or, OBJ_ARROW, 0, 0,0);
      ObjectSet(no+or, OBJPROP_TIME1, ct);
      ObjectSet(no+or, OBJPROP_PRICE1, cp);
      ObjectSet(no+or, OBJPROP_COLOR, clMarkerClose);
      ObjectSet(no+or, OBJPROP_ARROWCODE, SYMBOL_RIGHTPRICE);
     }
   if(tp!=0)
     {
      no="ADealTP";
      if(ObjectFind(no+or)<0)
         ObjectCreate(no+or, OBJ_ARROW, 0, 0,0);
      ObjectSet(no+or, OBJPROP_TIME1, tf);
      ObjectSet(no+or, OBJPROP_PRICE1, tp);
      ObjectSet(no+or, OBJPROP_COLOR, clLineProfit);
      ObjectSet(no+or, OBJPROP_ARROWCODE, SYMBOL_RIGHTPRICE);
      if(ObjectFind(no+"-l-"+or)<0)
         ObjectCreate(no+"-l-"+or, OBJ_TREND, 0, 0, 0, 0, 0);
      ObjectSet(no+"-l-"+or, OBJPROP_RAY, False);
      ObjectSet(no+"-l-"+or, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(no+"-l-"+or, OBJPROP_TIME1, tc);
      ObjectSet(no+"-l-"+or, OBJPROP_PRICE1, tp);
      ObjectSet(no+"-l-"+or, OBJPROP_TIME2, tf+60*Period());
      ObjectSet(no+"-l-"+or, OBJPROP_PRICE2, tp);
      ObjectSet(no+"-l-"+or, OBJPROP_COLOR, clLineProfit);
     }
   if(sl!=0)
     {
      no="ADealSL";
      if(ObjectFind(no+or)<0)
         ObjectCreate(no+or, OBJ_ARROW, 0, 0,0);
      ObjectSet(no+or, OBJPROP_TIME1, tf);
      ObjectSet(no+or, OBJPROP_PRICE1, sl);
      ObjectSet(no+or, OBJPROP_COLOR, clLineLoss);
      ObjectSet(no+or, OBJPROP_ARROWCODE, SYMBOL_RIGHTPRICE);
      if(ObjectFind(no+"-l-"+or)<0)
         ObjectCreate(no+"-l-"+or, OBJ_TREND, 0, 0, 0, 0, 0);
      ObjectSet(no+"-l-"+or, OBJPROP_RAY, False);
      ObjectSet(no+"-l-"+or, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(no+"-l-"+or, OBJPROP_TIME1, tc);
      ObjectSet(no+"-l-"+or, OBJPROP_PRICE1, sl);
      ObjectSet(no+"-l-"+or, OBJPROP_TIME2, tf+60*Period());
      ObjectSet(no+"-l-"+or, OBJPROP_PRICE2, sl);
      ObjectSet(no+"-l-"+or, OBJPROP_COLOR, clLineLoss);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteIndObjects()
  {
   int ot, iMagicNum;
   ObjectDelete("AccountName");
   for(i=0; i<=inf_count-1; i++)
      ObjectDelete(inf_name[i]);
   if(DealMarkers)
     {
      int i,  ty, k=OrdersHistoryTotal();
      for(i=0; i<k; i++)
        {
         if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
           {
            ty=OrderType();
            ot=OrderTicket();
            if(OrderSymbol()==Symbol() && ty<2)
              {
               ObjectDelete("ADealOp"+ot);
               ObjectDelete("ADealCl"+ot);
               ObjectDelete("Deal"+ot);
              }
           }
        }
     }
   if(ShowLive)
     {
      if(OrdersTotal()>0)
        {
         k=OrdersTotal();
         for(i=0; i<k; i++)
           {
            if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
              {
               if(MagicFilter != "")
                 {
                  iMagicNum = OrderMagicNumber();
                  iMagicNum = StringFind(MagicFilter, "," + iMagicNum + ",");
                 }
               else
                  iMagicNum = 1;
               ty=OrderType();
               ot=OrderTicket();
               if(OrderSymbol()==Symbol() && ty<2 && iMagicNum != -1)
                 {
                  ObjectDelete("ADealOp"+ot);
                  ObjectDelete("ADealTP"+ot);
                  ObjectDelete("ADealTP-l-"+ot);
                  ObjectDelete("ADealSL"+ot);
                  ObjectDelete("ADealSL-l-"+ot);
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
