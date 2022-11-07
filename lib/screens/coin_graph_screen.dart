import 'package:cryptocurrency_app/model/coin_details_model.dart';
import 'package:cryptocurrency_app/model/price_and_time_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoinGraphScreen extends StatefulWidget {
  final CoinDetailsModel coinDetailsModel;
  const CoinGraphScreen({
    Key? key,
    required this.coinDetailsModel,
  }) : super(key: key);

  @override
  State<CoinGraphScreen> createState() => _CoinGraphScreenState();
}

class _CoinGraphScreenState extends State<CoinGraphScreen> {
  bool isLoading = true;
  bool isFirstTime = true;

  List<FlSpot> flSpotList = [];

  double minX = 0.0, maxX = 0.0, minY = 0.0, maxY = 0.0;

  @override
  void initState() {
    super.initState();
    getChartDetails("1");
  }

  void getChartDetails(String day) async {
    if (isFirstTime) {
      isFirstTime = false;
    } else {
      setState(() {
        isLoading = true;
      });
    }

    String apiUrl =
        "https://api.coingecko.com/api/v3/coins/${widget.coinDetailsModel.id}/market_chart?vs_currency=inr&days=${day}";

    Uri uri = Uri.parse(apiUrl);

    final response = await http.get(uri);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> result = json.decode(response.body);

      List rawList = result["prices"];

      List<List> chartData = rawList.map((e) => e as List).toList();

      List<PriceAndTime> priceAndTimeList = chartData
          .map(
            (e) => PriceAndTime(time: e[0] as int, price: e[1] as double),
          )
          .toList();

      flSpotList = [];

      for (var element in priceAndTimeList) {
        flSpotList.add(
          FlSpot(
            element.time!.toDouble(),
            element.price!.toDouble(),
          ),
        );
      }

      minX = priceAndTimeList.first.time!.toDouble();
      maxX = priceAndTimeList.last.time!.toDouble();

      priceAndTimeList.sort((a, b) => a.price!.compareTo(b.price!));

      minY = priceAndTimeList.first.price!;
      maxY = priceAndTimeList.last.price!;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          widget.coinDetailsModel.name.toString(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: "${widget.coinDetailsModel.name} Price\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  "Rs.${widget.coinDetailsModel.currentPrice}\n",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "${widget.coinDetailsModel.priceChangePercentage24h}%\n",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            TextSpan(
                              text: "$maxY",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                  ),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: LineChart(
                      LineChartData(
                          minX: minX,
                          minY: minY,
                          maxX: maxX,
                          maxY: maxY,
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(show: false),
                          gridData: FlGridData(
                            getDrawingVerticalLine: (value) {
                              return FlLine(strokeWidth: 0);
                            },
                            getDrawingHorizontalLine: (value) {
                              return FlLine(strokeWidth: 0);
                            },
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: flSpotList,
                              dotData: FlDotData(show: false),

                              // spots: [
                              //   // FlSpot(1, 5),
                              //   // FlSpot(5, 5.2),
                              //   // FlSpot(6, 3.5),
                              //   // FlSpot(5.2, 9.2),
                              //   // FlSpot(1.23, 18.6),
                              //   // FlSpot(6.8, 15.7),
                              //   // FlSpot(9.5, 10),
                              //   // FlSpot(8.2, 1),
                              // ],
                            )
                          ]),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          getChartDetails("1");
                        },
                        child: Text("1 day"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          getChartDetails("15");
                        },
                        child: Text("15 days"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          getChartDetails("30");
                        },
                        child: Text("30 days"),
                      ),
                    ],
                  ))
                ],
              ),
            ),
    );
  }
}
