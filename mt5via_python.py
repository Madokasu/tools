import MetaTrader5 as mt5
import pytz
from datetime import datetime, timezone
import pandas as pd

# メタトレーダにログイン
if not mt5.initialize(
    "C:\\path\\to\\installed\\terminal64.exe",
    login=99999999999,
    server="Exness-MT5Trial2",
    password="YourPassword"):
    print("ログイン失敗, error code =", mt5.last_error())
    exit(1)

# とりあえず取引可能な銘柄を5つほどピックアップ
symbols = mt5.symbols_get()
print('Symbols: ', len(symbols))
count=0

for s in symbols:
    count += 1
    print("{}. {}".format(count,s.name))
    if count==5: break

# BTCペアを表示してみる
btc_symbols = mt5.symbols_get("*BTC*")
print('len(*BTC*): ', len(btc_symbols))
for s in btc_symbols:
    print(s.name)

symbol = "BTCUSD"
tf = mt5.TIMEFRAME_M1
date_from = datetime(2022, 1, 21, tzinfo = timezone.utc)
date_to = datetime(2022, 1, 22, tzinfo = timezone.utc)
rates = mt5.copy_rates_range(symbol, tf, date_from, date_to)

count = 0
for i in rates:
    print(i)
    count += 1
    if count > 10: break

point = mt5.symbol_info(symbol).point
price = mt5.symbol_info_tick(symbol).bid
deviation = 20

request = {
    "action": mt5.TRADE_ACTION_DEAL,
    "symbol": symbol,
    "volume": 0.01,
    "type": mt5.ORDER_TYPE_SELL,
    "price": price,
    "sl": price + 10000 * point,
    "tp": price - 10000 * point,
    "deviation": deviation,# 許容スリップページ
    "magic": 191969154,
    "comment": "python script open",
    "type_time": mt5.ORDER_TIME_GTC,
    "type_filling": mt5.ORDER_FILLING_IOC,
}

result = mt5.order_send(request)
if result.retcode != mt5.TRADE_RETCODE_DONE:
    print("2. 失敗理由, retcode={}".format(result.retcode))

result_dict = result._asdict()
for field in result_dict.keys():
    print("   {}={}".format(field, result_dict[field]))

exit
