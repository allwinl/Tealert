import ccxt
import requests
import time

# Binance API credentials
api_key = 'Hqod6Y5MDAkMmAJbRKOqUUDsYb9HG5aAkE3BMPZxHrm8JdZTgfIJr2RKSkRiOlDM'
api_secret = 'wVI5YTy9Y3dhiU1KoOSc0ysMVsAvaklSHDm40ZqkaHzKGgjlq9zlmi5CSF3n2wGw'

# Telegram credentials
bot_token = '7426543281:AAHu4Qf_KT6sGBaqUJU5ccFKZroHKrVc9R0'
chat_id = '1385370555'

# Initialize Binance client
binance = ccxt.binance({
    'apiKey': api_key,
    'secret': api_secret
})

def get_unrealized_profit():
    # Fetch the balance and positions
    balance = binance.fetch_balance()
    positions = balance['info']['positions']

    unrealized_profit = 0
    for position in positions:
        if float(position['unrealizedProfit']) != 0:
            unrealized_profit += float(position['unrealizedProfit'])
    
    return unrealized_profit

def send_telegram_message(message):
    url = f"https://api.telegram.org/bot{bot_token}/sendMessage"
    params = {"chat_id": chat_id, "text": message}
    requests.get(url, params=params)

def monitor_profit():
    profit_threshold = .01  # Set your profit threshold

    while True:
        unrealized_profit = get_unrealized_profit()
        if unrealized_profit > profit_threshold:
            message = f"Unrealized Profit Alert! Profit: {unrealized_profit} USDT"
            send_telegram_message(message)
        time.sleep(300)  # Check every 5 minutes

if __name__ == "__main__":
    monitor_profit()
