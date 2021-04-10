from decimal import Decimal

EXCHANGE_RATE = {'KRW': 1000, 'USD': 0.89, 'EUR': 0.75, 'JPY': 97.82, 'CNY': 5.85}

def exchange(money_krw):
    money_usd = float(Decimal(str(EXCHANGE_RATE['USD'])) * Decimal(str(money_krw / EXCHANGE_RATE['KRW'])))
    money_eur = float(Decimal(str(EXCHANGE_RATE['EUR'])) * Decimal(str(money_krw / EXCHANGE_RATE['KRW'])))
    money_jpy = float(Decimal(str(EXCHANGE_RATE['JPY'])) * Decimal(str(money_krw / EXCHANGE_RATE['KRW'])))
    money_cny = float(Decimal(str(EXCHANGE_RATE['CNY'])) * Decimal(str(money_krw / EXCHANGE_RATE['KRW'])))
    exchanged_money = {'KRW': money_krw,
                       'USD': money_usd, 'EUR': money_eur,
                       'JPY': money_jpy, 'CNY': money_cny}
    return exchanged_money

def countJPY(money_jpy):
    bills = {10000: 0, 50000: 0, 2000: 0, 1000: 0}      # 지폐: 10,000엔 / 5,000엔 / 2,000엔 / 1,000엔
    coins = {500: 0, 100: 0, 50: 0, 10: 0, 5: 0, 1: 0}  # 동전: 500엔 / 100엔 / 50엔 / 10엔 / 5엔 / 1엔

    for bill in bills.keys():
        bills[bill] = int(money_jpy // bill)
        money_jpy = money_jpy % bill
    for coin in coins.keys():
        coins[coin] = int(money_jpy // coin)
        money_jpy = money_jpy % coin

    return bills, coins

def countCNY(money_cny):
    bills = {100: 0, 50: 0, 20: 0, 10: 0, 5: 0, 1: 0}   # 지폐: 100위안 / 50위안 / 20위안 / 10위안 / 5위안 / 1위안
    coins = {0.5: 0, 0.1: 0}                            # 동전: 5자오 / 1자오

    for bill in bills.keys():
        bills[bill] = int(money_cny // bill)
        money_cny = money_cny % bill
    for coin in coins.keys():
        coins[coin] = int(money_cny // coin)
        money_cny = money_cny % coin

    return bills, coins


if __name__ == "__main__":
    money_krw = float(input('원화를 입력하세요: '))
    exchanged_money = exchange(money_krw)
    for key, value in exchanged_money.items():
        print(key, value)

    print(f'\n환전해야하는 엔화 권종과 개수:')
    bills_jpy, coins_jpy = countJPY(exchanged_money['JPY'])
    for key, value in bills_jpy.items():
        if value != 0:
            print(f'{key}엔짜리 지폐: {value}개')
    for key, value in coins_jpy.items():
        if value != 0:
            print(f'{key}엔짜리 동전: {value}개')

    print(f'\n환전해야하는 위안화 권종과 개수:')
    bills_cny, coins_cny = countCNY(exchanged_money['CNY'])
    for key, value in bills_cny.items():
        if value != 0:
            print(f'{key}위안짜리 지폐: {value}개')
    for key, value in coins_cny.items():
        if value != 0:
            print(f'{int(key*10)}자오짜리 동전: {value}개')
