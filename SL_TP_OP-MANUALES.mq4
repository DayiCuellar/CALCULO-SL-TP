//+------------------------------------------------------------------+
//|                                            SL_TP_OP-MANUALES.mq4 |
//|                                                        @RobaPips |
//|                https://www.facebook.com/robapips?mibextid=ZbWKwL |
//+------------------------------------------------------------------+
#property copyright "@RobaPips"
#property link      "https://www.facebook.com/robapips?mibextid=ZbWKwL"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                     INCLUDES
//+------------------------------------------------------------------+
#include <Robapips\Chivos.mqh>
#include <Robapips\Objetos.mqh>
#include <Robapips\Operaciones.mqh>
#include <Robapips\Velas.mqh>
#include <Robapips\DEFINES.mqh>
//+------------------------------------------------------------------+
//|               VARIABLES GLOBALES
//+------------------------------------------------------------------+
//---OBJETOS GRAFICOS
string rect_fondo = "rect_fondo",
       edit_sl = "edit_sl",
       edit_tp = "edit_tp",
       label_stop = "label_stop",
       label_profit = "label_profit";
//---
color fondo_rect = clrBlue,
      fondo_edits = clrWhite,
      letras_edits = clrBlack,
      letras_label = clrWhite;
//---
uint   x_dist_rect = 220,
       y_dist_rect = 20,
       alto_rect = 80,
       ancho_rect = 150,
       ancho_edits = 50,
       alto_edits = 23,
       X_temp = 0,
       Y_temp = 0,
       pos_X[20],
       pos_Y[20];

//---
uint const separacion = 10;
//---
int X = 0,
    Y = 0,
    tamanho_letras_label = 10;

//--- FUNCIONAMIENTO DEL ASESOR EXPERTO
double stopp_loss = 0,
       takke_profit = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//---
   Crear_Panel();
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---
   Borrar_Objetos_Panel();
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   Poner_SL(stopp_loss);
   Poner_TP(takke_profit);
//+------------------------------------------------------------------+
//|                  VALORES EN PANTALLA
//+------------------------------------------------------------------+
   Comment(
      "stopp_loss   ", stopp_loss, "\n",
      "takke_profit  ",  takke_profit, "\n",
      "  "
   );
}// FIN DEL ONTICK
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                   EVENTOS
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long & lparam,
                  const double & dparam,
                  const string & sparam)
{
   switch((ENUM_CHART_EVENT)id)
   {
   case CHARTEVENT_MOUSE_MOVE:
      if(sparam == (string)1) //State of the left mouse button
      {
         X = (int)ObjectGetInteger(0, rect_fondo, OBJPROP_XDISTANCE);
         Y = (int)ObjectGetInteger(0, rect_fondo, OBJPROP_YDISTANCE);
         Mover_Objetos(X, Y);
      }
      break;
   case CHARTEVENT_OBJECT_ENDEDIT: // COGER LOS VALORES DE LOS EDITS
      if(sparam == edit_sl)
      {
         string temp_sl = ObjectGetString(0, edit_sl, OBJPROP_TEXT);
         stopp_loss = StringToDouble(temp_sl);
         stopp_loss = NormalizeDouble(stopp_loss, 2);
      }
      //---
      if(sparam == edit_tp)
      {
         string temp_tp = ObjectGetString(0, edit_tp, OBJPROP_TEXT);
         takke_profit = StringToDouble(temp_tp);
         takke_profit = NormalizeDouble(takke_profit, 2);
      }
   }
}
//+------------------------------------------------------------------+
//|                           FUNCIONES
//+------------------------------------------------------------------+
//--- CREAR PANEL
void Crear_Panel ()
{
//--- RECTANGULO DE FONDO
   Crear_Label_Rectangular(rect_fondo, x_dist_rect, y_dist_rect, alto_rect, ancho_rect, CORNER_RIGHT_UPPER, fondo_rect, false, BORDER_RAISED, 0, 3);
   ObjectSetInteger(0, rect_fondo, OBJPROP_SELECTABLE, true);
//--- LABEL STOP LOSS
   Crear_Label(label_stop, x_dist_rect - separacion, y_dist_rect + separacion, CORNER_RIGHT_UPPER, letras_label, "PIPS_SL");
   ObjectSetInteger(0, label_stop, OBJPROP_SELECTABLE, false);
   X_temp = (uint) ObjectGetInteger(0, label_stop, OBJPROP_XDISTANCE);
   Y_temp = (uint) ObjectGetInteger(0, label_stop, OBJPROP_YDISTANCE);
   pos_X[0] = ( MathMax(x_dist_rect, X_temp) - MathMin(x_dist_rect, X_temp));
   pos_Y[0] = ( MathMax(y_dist_rect, Y_temp) - MathMin(y_dist_rect, Y_temp));
//--- LABEL TAKE PROFIT
   Crear_Label(label_profit, label_stop, 0, 4 * separacion, letras_label, "PIPS_TP");
   ObjectSetInteger(0, label_profit, OBJPROP_SELECTABLE, false);
   X_temp = (uint) ObjectGetInteger(0, label_profit, OBJPROP_XDISTANCE);
   Y_temp = (uint) ObjectGetInteger(0, label_profit, OBJPROP_YDISTANCE);
   pos_X[1] = ( MathMax(x_dist_rect, X_temp) - MathMin(x_dist_rect, X_temp));
   pos_Y[1] = ( MathMax(y_dist_rect, Y_temp) - MathMin(y_dist_rect, Y_temp));
//--- EDIT SL
   Crear_Edit(edit_sl, label_stop, -3 * separacion, 0, alto_edits, ancho_edits, letras_edits, NULL, fondo_edits);
   X_temp = (uint) ObjectGetInteger(0, edit_sl, OBJPROP_XDISTANCE);
   Y_temp = (uint) ObjectGetInteger(0, edit_sl, OBJPROP_YDISTANCE);
   pos_X[2] = ( MathMax(x_dist_rect, X_temp) - MathMin(x_dist_rect, X_temp));
   pos_Y[2] = ( MathMax(y_dist_rect, Y_temp) - MathMin(y_dist_rect, Y_temp));
//--- EDIT TP
   Crear_Edit(edit_tp, edit_sl, 0, 5 + separacion, alto_edits, ancho_edits, letras_edits, NULL, fondo_edits);
   X_temp = (uint) ObjectGetInteger(0, edit_tp, OBJPROP_XDISTANCE);
   Y_temp = (uint) ObjectGetInteger(0, edit_tp, OBJPROP_YDISTANCE);
   pos_X[3] = ( MathMax(x_dist_rect, X_temp) - MathMin(x_dist_rect, X_temp));
   pos_Y[3] = ( MathMax(y_dist_rect, Y_temp) - MathMin(y_dist_rect, Y_temp));
}
//+------------------------------------------------------------------+
//--- MOVER OBJETOS DEL PANEL
void Mover_Objetos(uint _X, uint _Y)
{
   ObjectSetInteger(0, label_stop, OBJPROP_XDISTANCE, _X - pos_X[0]);
   ObjectSetInteger(0, label_stop, OBJPROP_YDISTANCE, _Y + pos_Y[0]);
   ObjectSetInteger(0, label_profit, OBJPROP_XDISTANCE, _X - pos_X[1]);
   ObjectSetInteger(0, label_profit, OBJPROP_YDISTANCE, _Y + pos_Y[1]);
   ObjectSetInteger(0, edit_sl, OBJPROP_XDISTANCE, _X - pos_X[2]);
   ObjectSetInteger(0, edit_sl, OBJPROP_YDISTANCE, _Y + pos_Y[2]);
   ObjectSetInteger(0, edit_tp, OBJPROP_XDISTANCE, _X - pos_X[3]);
   ObjectSetInteger(0, edit_tp, OBJPROP_YDISTANCE, _Y + pos_Y[3]);
}
//+------------------------------------------------------------------+
//--- ELIMINAR OBJETOS DEL PANEL
void Borrar_Objetos_Panel()
{
   Borrar_Objeto(label_stop);
   Borrar_Objeto(label_profit);
   Borrar_Objeto(edit_sl);
   Borrar_Objeto(edit_tp);
}
//+------------------------------------------------------------------+
void Poner_TP (double _pips_tp)
{
   int total = OrdersTotal();
   for(int i = total - 1; i >= 0; i--)
   {
      bool p = OrderSelect(i, SELECT_BY_POS);
      if(_pips_tp != 0 && OrderTakeProfit() == 0)
      {
         if(OrderType() == OP_BUY)
         {
            double tempp_tp = OrderOpenPrice() + (_pips_tp * 10 * Point);
            bool k = OrderModify(OrderTicket(), 0, OrderStopLoss(), tempp_tp, 0);
         }
         else if(OrderType() == OP_SELL )
         {
            double tempp_tp = OrderOpenPrice() - (_pips_tp * 10 * Point);
            bool k = OrderModify(OrderTicket(), 0, OrderStopLoss(), tempp_tp, 0);
         }
      }
   }
}
//+------------------------------------------------------------------+
void Poner_SL (double _pips_sl)
{
   int total = OrdersTotal();
   for(int i = total - 1; i >= 0; i--)
   {
      bool p = OrderSelect(i, SELECT_BY_POS);
      //---
      if(_pips_sl != 0 && OrderStopLoss() == 0)
      {
         if(OrderType() == OP_BUY)
         {
            double tempp_sl = OrderOpenPrice() - (_pips_sl * 10 * Point);
            bool k = OrderModify(OrderTicket(), 0, tempp_sl, OrderTakeProfit(), 0);
         }
         else if(OrderType() == OP_SELL)
         {
            double tempp_sl = OrderOpenPrice() + (_pips_sl * 10 * Point);
            bool k = OrderModify(OrderTicket(), 0, tempp_sl, OrderTakeProfit(), 0);
         }
      }
   }
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
