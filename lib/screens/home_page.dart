import 'package:flutter/material.dart';
import 'package:hdsl_furniture/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List catagory = ['Top item', 'Almirah', 'Alna', 'Chair', 'Table'];
  List catagory2 = ['top', 'almirah', 'alna', 'chair', 'table'];

  int selectedIndex = 0;
  List items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData('top');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Best Furniture!',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Your Prefect Choice',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search here',
                    suffixIcon: const Icon(Icons.search),
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 40,
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 0,
                        );
                      },
                      itemCount: catagory.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return MaterialButton(
                            shape: const StadiumBorder(),
                            onPressed: () {
                              selectedIndex = index;
                              items.clear();
                              getData(catagory2[selectedIndex]);
                              setState(() {});
                            },
                            minWidth: 100,
                            color: selectedIndex == index ? Colors.black : null,
                            child: Text(
                              catagory[index],
                              style: TextStyle(
                                  color: selectedIndex == index
                                      ? Colors.white
                                      : Colors.black),
                            ));
                      }),
                ),
                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.separated(
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailsPage(
                                            productDetails: items[index])));
                              },
                              child: Container(
                                padding: EdgeInsets.only(right: 8),
                                height: 180,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 130,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      margin: const EdgeInsets.all(16),
                                      padding: const EdgeInsets.all(4),
                                      child:
                                          Image.network(items[index]['image']),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            items[index]['title'],
                                            style: const TextStyle(
                                                fontSize: 20,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              'item: ${items[index]['catagory']}',
                                              style: TextStyle(
                                                  color: Colors.grey.shade900,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          Text(
                                            items[index]['description'],
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 18,
                                                color: Colors.grey.shade900,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '৳ ${items[index]['price']}',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              MaterialButton(
                                                color: const Color(0xff880061),
                                                shape: const StadiumBorder(),
                                                onPressed: () {},
                                                child: const Text(
                                                  'Buy now',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: 5),
                )
              ],
            ),
          ),
        ));
  }

  getData(String keyWord) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var data = await firestore.collection(keyWord).get();

    for (var doc in data.docs) {
      setState(() {
        Map map = {
          'title': doc['title'],
          'catagory': doc['catagory'],
          'image': doc['image'],
          'price': doc['price'],
          'description': doc['description'],
          'rating': doc['rating'],
        };
        items.add(map);
      });
      print(items);
    }
  }
}
