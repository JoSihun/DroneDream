EXCHANGE_RATE = {'KRW': 1000, 'USD': 0.89, 'EUR': 0.75, 'JPY': 97.82, 'CNY': 5.85}

def exchange(money_krw):
    money_usd = EXCHANGE_RATE['USD'] * (money_krw / EXCHANGE_RATE['KRW'])
    money_eur = EXCHANGE_RATE['EUR'] * (money_krw / EXCHANGE_RATE['KRW'])
    money_jpy = EXCHANGE_RATE['JPY'] * (money_krw / EXCHANGE_RATE['KRW'])
    money_cny = EXCHANGE_RATE['CNY'] * (money_krw / EXCHANGE_RATE['KRW'])
    exchanged_money = {'KRW': money_krw,
                       'USD': money_usd, 'EUR': money_eur,
                       'JPY': money_jpy, 'CNY': money_cny}
    return exchanged_money













if __name__ == "__main__":
    money_krw = int(input('원화를 입력하세요: '))
    exchanged_money = exchange(money_krw)
    for key, value in exchanged_money.items():
        print(key, value)

