#property version   "1.00"
#property strict

string symbols[] = {
 "USDCHF"
,"GBPUSD"
,"EURUSD"
,"USDJPY"
,"USDCAD"
,"AUDUSD"
,"EURGBP"
,"EURAUD"
,"EURCHF"
,"EURJPY"
,"GBPCHF"
,"CADJPY"
,"GBPJPY"
,"AUDNZD"
,"AUDCAD"
,"AUDCHF"
,"AUDJPY"
,"CHFJPY"
,"EURNZD"
,"EURCAD"
,"CADCHF"
,"NZDJPY"
,"NZDUSD"
,"GOLD"
,"EURCZK"
,"EURDKK"
,"EURZAR"
,"GBPAUD"
,"GBPCAD"
,"GBPDKK"
,"GBPHUF"
,"GBPNOK"
,"GBPNZD"
,"GBPZAR"
,"HKDJPY"
,"NOKJPY"
,"NZDCAD"
,"NZDCHF"
,"SEKJPY"
,"SGDJPY"
,"USDCNY"
,"USDCZK"
,"USDDKK"
,"USDHUF"
,"USDHKD"
,"USDNOK"
,"USDPLN"
,"USDZAR"
,"ZARJPY"
,"SILVER"
,"NIFTY"
,"WTI"
,"ADOBE_SYS"
,"AIG"
,"ALIBABA"
,"ALTABA"
,"AMAZON"
,"AMER_AIRLS"
,"AMEX"
,"APPLE"
,"BAIDU"
,"BANCSAN"
,"BMW"
,"BOEING"
,"BOA"
,"BRBY-LON"
,"BOSS"
,"BRIDGESTONE"
,"CANON"
,"CBS"
,"CISCO"
,"COCA-COLA"
,"DISNEY"
,"COST"
,"HITACHI-TSE"
,"EBAY"
,"FACEBOOK"
,"FANUC"
,"FERRARI"
,"FAST-RET"
,"GOOGLE"
,"GS"
,"HONDA"
,"IBM"
,"LUFTHANSA"
,"INTEL"
,"KOMATSU_NPV"
,"JPM"
,"LVMH"
,"LG"
,"McDonald's"
,"MICRON"
,"MAZDA"
,"MICROSOFT"
,"MIZUHO"
,"MITSUI"
,"Motorola"
,"MURATA_MFG"
,"NESTLE"
,"NETFLIX"
,"NIKE"
,"NISSAN"
,"PAYPAL"
,"NOMURA-TSE"
,"PANASONIC-J"
,"SAMSUNG"
,"PFIZER"
,"SNAPCHAT"
,"SHARP-TSE"
,"SONY"
,"SUZUKI"
,"SPOTIFY"
,"TAKEDA_PHAR"
,"TBCOJAP"
,"TESLA"
,"TokioMarHol"
,"TOKYO_ELECT"
,"TWITTER"
,"TOYOTA"
,"UBI"
,"XIAOMI"
,"YANDEX"
,"BTCMINI"
,"Ethereum"
,"Litecoin"
,"Ripple"
,"TOSHIBA"
,"HOILZ8"
,"ASXZ8"
,"ASXH9"
,"SPZ8"
,"SPH9"
,"SMIZ8"
,"SMIH9"
,"BRENTF9"
,"COCOAH9"
,"COFFEEZ8"
,"COFFEEH9"
,"CORNZ8"
,"COTT2Z8"
,"SUG11H9"
,"NGASZ8"
,"WHEATZ8"
,"COPPZ8"
,"COPPH9"
,"AEXZ8"
,"AEXH9"
,"CACZ8"
,"CACH9"
,"NSDQZ8"
,"NSDQH9"
,"PLATF9"
,"PALLADZ8"
,"PALLADH9"
,"NKZ8"
,"NKH9"
,"SBEANF9"
,"VIXZ8"
,"VIXF9"
,"HOILF9"
,"HOILG9"
,"NGASF9"
,"IBEXZ8"
,"IBEXF9"
,"BRENTG9"
,"BRENTH9"
,"DAXZ8"
,"DAXH9"
,"DOWZ8"
,"DOWH9"
,"EURO50Z8"
,"EURO50H9"
,"FTSEZ8"
,"FTSEH9"
,"HANGX8"
,"HANGZ8"
,"HANGF9"
,"MIBZ8"
,"MIBH9"
,"COTT2H9"
,"CORNH9"
,"WHEATH9"
,"NGASG9"
,"PLATJ9"
,"SBEANH9"
,"VIXG9"
,"HOILH9"
,"NGASH9"
,"IBEXH9"
,"IBEXG9"
,"BRENTJ9"
,"HANGG9"
,"LCATTG9"
,"VIXH9"
,"SUG11K9"
,"BRENTK9"
,"NGASJ9"
,"HOILJ9"
};

//スクリプト開始
void OnStart()
{
   //ログファイル名を作る
   datetime localtime = TimeLocal();
   string filename = "Spread_";
   filename += IntegerToString(TimeYear(localtime)) + IntegerToString(TimeMonth(localtime), 2, '0') + IntegerToString(TimeDay(localtime), 2, 0);
   filename += IntegerToString(TimeHour(localtime), 2, '0') + IntegerToString(TimeMinute(localtime), 2, '0') + IntegerToString(TimeSeconds(localtime), 2, '0');
   filename += ".csv";

   //書き込み用のCSVファイルオープン
   int handle = FileOpen(filename, FILE_WRITE | FILE_CSV, ",");
   
   //ヘッダ
   FileWrite(handle, "item", "spread");
   
   //チャートのサイズ
   int size = ArraySize(Time);
   
   //過去から出力
   for(int i = 0; i<ArraySize(symbols)-1; i++){

      
      //出力
      FileWrite(
         handle,
         symbols[i],
         MarketInfo(symbols[i], MODE_SPREAD)
      );

   }
   
   //ファイルクローズ
   FileClose(handle);
   Print("オワタ");
}
