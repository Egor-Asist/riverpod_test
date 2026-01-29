enum CurrencyCode {
  usd('USD'),
  eur('EUR'),
  rub('RUB'),
  gbp('GBP');


  const CurrencyCode(this.code);

  final String code;


  static List<CurrencyCode> get all => CurrencyCode.values;

  static CurrencyCode fromString(String code) {
    return CurrencyCode.values.firstWhere(
      (e) => e.code == code,
      orElse: () => CurrencyCode.usd,
    );
  }
}
