//+------------------------------------------------------------------+
//|                                             SunExpert ver0.1.mq4 |
//|                                                Alexander Strokov |
//|                                    strokovalexander.fx@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Alexander Strokov"
#property link      "strokovalexander.fx@gmail.com"
#property version   "0.1"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

extern string ѕapаметры="ѕараметры тралинга";
extern bool TralEnd=true;
extern int StartTralPoints=10;
extern int SizeTralPoints=7;
extern bool BuyTrall=true;
extern bool SellTrall=true;



double LastBuyPrice;
double LastSellPrice;
int k;
int ReCountBuy;
int ReCountSell;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {

   if((Digits==3)||(Digits==5)) { k=10;}
   if((Digits==4)||(Digits==2)) { k=1;}
 
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {

    
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
 ReCountBuy=0;ReCountSell=0;
   for(int in=0;in<OrdersTotal();in++)
     {      if(OrderSelect(in,SELECT_BY_POS)==true)
        {
         if(OrderSymbol()==Symbol()) 
           {
            if(OrderType()==OP_BUY){ReCountBuy=ReCountBuy+1;}
            if(OrderType()==OP_SELL){ReCountSell=ReCountSell+1;}
           }
        }
     }   
   
if((ReCountBuy>0)&&(TralEnd==true)&&(BuyTrall==True)){
SearchLastBuyPrice();
RefreshRates();
if ((Ask-LastBuyPrice-(StartTralPoints*Point*k))>0)
{

double stp=0;
double Stop=0;
int Ticket=0;
 LastBuyPrice=0;
 for(int ibuySearch2=0;ibuySearch2<OrdersTotal();ibuySearch2++)
     {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это врем€!
      if(OrderSelect(ibuySearch2,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY))
           {
            if(LastBuyPrice==0){LastBuyPrice=OrderOpenPrice();Ticket=OrderTicket();Stop=OrderStopLoss();}
            if(Stop==0){Stop=OrderStopLoss();}
            if(LastBuyPrice>OrderOpenPrice()){LastBuyPrice=OrderOpenPrice();Stop=OrderStopLoss();Ticket=OrderTicket();}
           }
        }
     }
     OrderSelect(Ticket, SELECT_BY_TICKET);
if (Stop==NULL)
{
OrderSelect(Ticket,SELECT_BY_TICKET);
 stp=Ask-SizeTralPoints*Point*k;
OrderModify(Ticket,OrderOpenPrice(),stp,OrderTakeProfit(),0,Purple); Sleep(500);
}     
  else
  { RefreshRates();OrderSelect(Ticket,SELECT_BY_TICKET);
  if (Ask-(SizeTralPoints*Point*k)>Stop){stp=Ask-(SizeTralPoints*Point*k);OrderModify(Ticket,OrderOpenPrice(),stp,OrderTakeProfit(),0,Purple);Sleep(500); 
  
                                        }
  }     
     
}
}
if ((ReCountSell>1)&&(TralEnd==true)&&(SellTrall==True)){
SearchLastSellPrice();
RefreshRates();
if ((LastSellPrice-Bid-(StartTralPoints*Point*k))>0){

double stp=0;
double Stop=0;
int Ticket=0;
 LastSellPrice=0;
 for(int isellSearch2=0;isellSearch2<OrdersTotal();isellSearch2++)
     {
      if(OrderSelect(isellSearch2,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL))
           {
            if(LastSellPrice==0){LastSellPrice=OrderOpenPrice();Ticket=OrderTicket();Stop=OrderStopLoss();}
            if(Stop==0){Stop=OrderStopLoss();}
            if(LastSellPrice<OrderOpenPrice()){LastSellPrice=OrderOpenPrice();Stop=OrderStopLoss();Ticket=OrderTicket();}
           }
        }
     }
     OrderSelect(Ticket, SELECT_BY_TICKET);
if (Stop==NULL)
{
 stp=Bid+SizeTralPoints*Point*k;
OrderModify(Ticket,OrderOpenPrice(),stp,OrderTakeProfit(),0,Orange);
Sleep(500);
}     
  else
  { RefreshRates();OrderSelect(Ticket,SELECT_BY_TICKET);
  if (Bid+(SizeTralPoints*Point*k)<Stop){stp=Bid+(SizeTralPoints*Point*k);OrderModify(Ticket,OrderOpenPrice(),stp,OrderTakeProfit(),0,Orange); Sleep(500);                                        
                                         }         
}
}
}


return(0);}  



double SearchLastBuyPrice()
  {
   LastBuyPrice=0;
   for(int ibuySearch=0;ibuySearch<OrdersTotal();ibuySearch++)
     {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это врем€!
      if(OrderSelect(ibuySearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY))
           {
            if(LastBuyPrice==0){LastBuyPrice=OrderOpenPrice();}
            if(LastBuyPrice>OrderOpenPrice()){LastBuyPrice=OrderOpenPrice();}
           }
        }
     }
   return(LastBuyPrice);
  }
//#ѕоиск последнего ордера на продажу
double SearchLastSellPrice()
  {
   LastSellPrice=0;
   for(int isellSearch=0;isellSearch<OrdersTotal();isellSearch++)
     {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это врем€!
      if(OrderSelect(isellSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL))
           {
            if(LastSellPrice==0){LastSellPrice=OrderOpenPrice();}
            if(LastSellPrice<OrderOpenPrice()){LastSellPrice=OrderOpenPrice();}
           }
        }
     }
   return(LastSellPrice);
  }








  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isNewBar()
  {
   static datetime BarTime;
   bool res=false;

   if(BarTime!=Time[0])
     {
      BarTime=Time[0];
      res=true;
     }
   return(res);
  }
//---- ¬озвращает количество ордеров указанного типа ордеров ----//
int Orders_Total_by_type(int type,int mn,string sym)
  {
   int num_orders=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber()==mn && type==OrderType() && sym==OrderSymbol())
         num_orders++;
     }
   return(num_orders);
  }
//+------------------------------------------------------------------+
