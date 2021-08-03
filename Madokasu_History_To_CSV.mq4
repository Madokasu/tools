#property strict

// 注文構造体
struct ORDER
{
   ORDER():openTime(0.0), closeTime(0.0), lots(0.0), profit(0.0) // メンバの初期化
   {
   }
   datetime openTime;   // オープン時刻
   datetime closeTime;  // クローズ時刻
   double lots;         // ロット数
   double profit;       // 損益
   string symbol;       // シンボル（通貨ペア）名
   string buyOrSell;    // 売買種別（Buy/Sell）
};

// ORDER 構造体同士の交換
void Swap(ORDER &a, ORDER &b)
{
   ORDER c = a;
   a = b;
   b = c;
}

// ORDER 構造体の配列をオープン時刻の昇順に並べ替える
// バブルソート！
void Sort(ORDER &a[])
{
   for(int i=0 ; i < ArraySize(a) - 1 ; i++)
   {
      for(int j = ArraySize(a) - 1 ; j > i ; j--)
      {
          if(a[j].openTime < a[j - 1].openTime) // ソート条件を変えたいときはここを変更
          {
             Swap(a[j], a[j - 1]);
          }
      }
   }
}
 
// MT4 スクリプトのエントリーポイント
void OnStart()
{
   // この日時以降の取引履歴のみ出力
   const MqlDateTime dt = { 2020, 1, 1, 0, 0, 0 };
   const datetime StartTime = StructToTime(dt);

   // 取引履歴の総数
   const int n = OrdersHistoryTotal();
   
   // OREDE 構造体の配列を宣言し要素を確保
   ORDER orders[];   
   ArrayResize(orders, n);
   
   // 取引履歴の数だけループ
   for (int i = 0 ; i < n ; i++)
   {
      // 取引履歴の中から i 番目の注文を選択
      OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
      
      // 約定済みの注文だけデータを取得
      if (OrderType() == OP_BUY || OrderType() == OP_SELL)
      {
         orders[i].openTime = OrderOpenTime();
         orders[i].closeTime = OrderCloseTime();
         orders[i].lots = OrderLots();
         orders[i].profit = OrderProfit();
         orders[i].symbol = OrderSymbol();    
         orders[i].buyOrSell = (OrderType() == OP_BUY) ? "Buy" : "Sell";
      } 
   }
   
   // 並べ替え
   Sort(orders);
   
   // ファイルを開く
   int file = FileOpen("OrderHistory.csv", FILE_CSV | FILE_ANSI | FILE_WRITE, ',');
   
   // ヘッダの出力
   FileWrite(file, "OpenTime", "CloseTime", "Lots", "Profit", "Symbol", "Buy/Sell");
   
   // 取引履歴の数だけループ
   for (int i  = 0 ; i < n ; i++)
   {
      // 指定日時以降にオープンした注文だけファイルに出力
      if (orders[i].openTime >= StartTime)
      {
         FileWrite(
            file, orders[i].openTime, orders[i].closeTime, 
            orders[i].lots,orders[i].profit,
            orders[i].symbol, orders[i].buyOrSell);
      }
   }
   
   // ファイルを閉じる
   FileClose(file);
   
   // 出力完了をお知らせ
   Alert("奇跡もCSV出力もあるんだよ!!");
}
