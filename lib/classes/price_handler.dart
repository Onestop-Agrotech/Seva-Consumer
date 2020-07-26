class PriceHandler {
  final int price;

  PriceHandler({this.price});

  // reset price back to original
  // back to 1 kg price
  resetPrice() {
    return this.price;
  }

  // cal for 100 gms
  cal100() {
    int p = resetPrice();
    int y = p ~/ 10;
    return y;
  }

  // cal for 250 gms
  cal250() {
    int p = resetPrice();
    int y = p ~/ 4;
    return y;
  }

  // cal for 500 gms
  cal500() {
    int p = resetPrice();
    int y = p ~/ 2;
    return y;
  }
}
