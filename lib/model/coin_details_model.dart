class CoinDetailsModel {
  String? id;
  String? symbol;
  String? name;
  String? image;
  double? currentPrice;
  double? priceChangePercentage24h;

  CoinDetailsModel(
      {this.id,
      this.symbol,
      this.name,
      this.image,
      this.currentPrice,
      this.priceChangePercentage24h});

  CoinDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    symbol = json['symbol'];
    name = json['name'];
    image = json['image'];
    currentPrice = json['current_price'].toDouble();
    priceChangePercentage24h = json['price_change_percentage_24h'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['symbol'] = this.symbol;
  //   data['name'] = this.name;
  //   data['image'] = this.image;
  //   data['current_price'] = this.currentPrice;
  //   data['price_change_percentage_24h'] = this.priceChangePercentage24h;
  //   return data;
  // }
}