import 'package:cryptocurrency_app/model/coin_details_model.dart';
import 'package:cryptocurrency_app/screens/coin_graph_screen.dart';
import 'package:cryptocurrency_app/screens/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String url =
      "https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=100&page=1&sparkline=false";
  String name = "";
  String email = "";

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  List<CoinDetailsModel> coinDetailsList = [];
  bool isDataFirstTimeAccess = true;
  late Future<List<CoinDetailsModel>> coinDetailsFuture;

  @override
  void initState() {
    super.initState();
    getUserDetails();
    coinDetailsFuture = getCoinDetails();
  }

  void getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString("name") ?? "";
      email = prefs.getString("email") ?? "";
    });
  }

  Future<List<CoinDetailsModel>> getCoinDetails() async {
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200 || response.statusCode == 201) {
      List coinsData = json.decode(response.body);

      List<CoinDetailsModel> data =
          coinsData.map((e) => CoinDetailsModel.fromJson(e)).toList();
      return data;
    } else {
      return <CoinDetailsModel>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _globalKey.currentState!.openDrawer();
          },
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "CryptoCurrency App",
          style: TextStyle(color: Colors.black),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                name,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              accountEmail: Text(
                email,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              currentAccountPicture: Icon(
                Icons.account_circle_rounded,
                size: 70,
                color: Colors.white,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProfileScreen(),
                  ),
                );
              },
              leading: Icon(Icons.account_box),
              title: Text(
                "Update Profile",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: coinDetailsFuture,
        builder: (context, AsyncSnapshot<List<CoinDetailsModel>> snapshot) {
          if (snapshot.hasData) {
            if (isDataFirstTimeAccess) {
              coinDetailsList = snapshot.data!;
              isDataFirstTimeAccess = false;
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 15,
                  ),
                  child: TextField(
                    onChanged: (query) {
                      List<CoinDetailsModel> searchResults =
                          snapshot.data!.where((element) {
                        String? coinName = element.name;
                        bool isItemFound = coinName!.contains(query);

                        return isItemFound;
                      }).toList();

                      setState(() {
                        coinDetailsList = searchResults;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      hintText: "Search for Coins",
                    ),
                  ),
                ),
                Expanded(
                  child: coinDetailsList.isEmpty
                      ? Center(
                          child: Text("Result not found"),
                        )
                      : ListView.builder(
                          itemCount: coinDetailsList.length,
                          itemBuilder: (context, index) {
                            return coinDetails(coinDetailsList[index]);
                          },
                        ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget coinDetails(CoinDetailsModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoinGraphScreen(
                coinDetailsModel: model,
              ),
            ),
          );
        },
        leading: SizedBox(
            height: 50,
            width: 50,
            child: Image.network(model.image.toString())),
        title: Text(
          "${model.name}\n${model.symbol}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        trailing: RichText(
          textAlign: TextAlign.end,
          text: TextSpan(
              text: "${model.currentPrice}\n",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "${model.priceChangePercentage24h}%",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
