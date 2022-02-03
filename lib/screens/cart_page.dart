import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: items.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your cart has ${items.length} item(s)',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                        child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
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
                                    borderRadius: BorderRadius.circular(16)),
                                margin: const EdgeInsets.all(16),
                                padding: const EdgeInsets.all(4),
                                child: Image.network(items[index]['image']),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Text(
                                      'Quantity: ${items[index]['quantity']}',
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                        MaterialButton(
                                          color: const Color(0xff880061),
                                          shape: const StadiumBorder(),
                                          onPressed: () async {
                                            FirebaseFirestore firestore =
                                                FirebaseFirestore.instance;
                                            await firestore
                                                .collection('users-cart')
                                                .doc(items[index]['id'])
                                                .delete();
                                            items.clear();
                                            getCartData();
                                            setState(() {});

                                            // removeItemFromCart();
                                          },
                                          child: const Text(
                                            'Remove item',
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
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: items.length,
                    ))
                  ],
                ),
        ),
      ),
    );
  }

  getCartData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var cartData = await firestore.collection('users-cart').get();

    for (var doc in cartData.docs) {
      setState(() {
        Map map = {
          'title': doc['title'],
          'catagory': doc['catagory'],
          'image': doc['image'],
          'price': doc['price'],
          'description': doc['description'],
          'rating': doc['rating'],
          'id': doc.id,
          'quantity': doc['quantity']
        };
        items.add(map);
      });
      print(items);
    }
  }

  void removeItemFromCart() {}
}
