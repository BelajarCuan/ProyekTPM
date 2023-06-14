import 'package:crypto/Model/coinModel.dart';
import 'package:crypto/View/Components/item.dart';
import 'package:crypto/View/Components/item2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double saldo =0 ;
  String selectedCurrency = 'Dollar';

  void konversi() {
    setState(() {
      switch (selectedCurrency) {
        case 'Rupiah':
        // Konversi saldo ke Rupiah
          saldo = 15000 * 7662.5;
          break;
        case 'Dollar':
        // Konversi saldo ke Dollar
          saldo = 7662.5;
          break;
        case 'Euro':
        // Konversi saldo ke Euro
          saldo = 0.93 * 7662.5;
          break;
        case 'Ringgit':
        // Konversi saldo ke Ringgit
          saldo = 4.60 *7662.5;
          break;
      }
    });
  }

  @override
  void initState() {

    getCoinMarket();
    super.initState();
    konversi();



  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 253, 225, 112),
                Color(0xfffb0000),
              ]),
        ),
        child: ListView(

          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: myHeight * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: myWidth * 0.02, vertical: myHeight * 0.005),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      'Main portfolio',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Text(
                    'Top 10 coins',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Exprimental',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(

                    children: [
                      Text(
                        '\$${saldo.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 35),
                      ),
                      DropdownButton<String>(
                        value: selectedCurrency,
                        onChanged: (String? newValue) {

                          setState(() {
                            selectedCurrency = newValue!;
                            konversi();

                          });
                        },
                        items: <String>['Rupiah', 'Dollar', 'Euro', 'Ringgit']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),

                  Container(
                    padding: EdgeInsets.all(myWidth * 0.02),
                    height: myHeight * 0.05,
                    width: myWidth * 0.1,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.5)),
                    child: Image.asset(
                      'assets/icons/5.1.png',
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
              child: Row(
                children: [
                  Text(
                    '+162% all time',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: myHeight * 0.02,
            ),
            Container(
              height: myHeight * 0.7,
              width: myWidth,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        color: Colors.grey.shade300,
                        spreadRadius: 3,
                        offset: Offset(0, 3))
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  )),
              child: Column(
                children: [
                  SizedBox(
                    height: myHeight * 0.03,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: myWidth * 0.08),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Assets',
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(Icons.add)
                      ],
                    ),
                  ),

                  Container(

                    height: myHeight * 0.36,
                    width: myWidth * 2.2,
                    child: isRefreshing == true
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Color(0xffFBC700),
                            ),
                          )
                        : coinMarket == null || coinMarket!.length == 0
                            ? Padding(
                                padding: EdgeInsets.all(myHeight * 0.06),
                                child: Center(
                                  child: Text(
                                    'Jangan keseringan.',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: 5,
                                shrinkWrap: true,

                                itemBuilder: (context, index) {
                                  return Item(
                                    item: coinMarket![index],
                                  );
                                },
                              ),
                  ),
                  SizedBox(
                    height: myHeight * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: myWidth * 0.05),
                    child: Row(
                      children: [
                        Text(
                          'Recommend to Buy',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: myHeight * 0.01,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: myWidth * 0.03),
                      child: isRefreshing == true
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Color(0xffFBC700),
                              ),
                            )
                          : coinMarket == null || coinMarket!.length == 0
                              ? Padding(
                                  padding: EdgeInsets.all(myHeight * 0.06),
                                  child: Center(
                                    child: Text(
                                      'Attention this Api is free, so you cannot send multiple requests per second, please wait and try again later.',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: coinMarket!.length,
                                  itemBuilder: (context, index) {
                                    return Item2(
                                      item: coinMarket![index],
                                    );
                                  },
                                ),
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isRefreshing = true;

  List? coinMarket = [];
  var coinMarketList;
  Future<List<CoinModel>?> getCoinMarket() async {
    const url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';

    setState(() {
      isRefreshing = true;
    });
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    setState(() {
      isRefreshing = false;
    });
    if (response.statusCode == 200) {
      var x = response.body;
      coinMarketList = coinModelFromJson(x);
      setState(() {
        coinMarket = coinMarketList;
      });
    } else {
      print(response.statusCode);
    }
  }
}
