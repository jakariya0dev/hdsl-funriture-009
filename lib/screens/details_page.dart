import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, required this.productDetails}) : super(key: key);

  final Map productDetails;

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int quantity = 1;
  late TextEditingController quantityController;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    quantityController = TextEditingController(text: quantity.toString());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                    onPressed: () {
                      isSelected = true;
                      addToWishlist();
                      showMessage(msg: "Successfully added to wishlist");
                      setState(() {});
                    },
                    icon: Icon(
                        isSelected ? Icons.favorite : Icons.favorite_border))
              ]),
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Image.network(
                  widget.productDetails['image'],
                  height: 200,
                  width: 200,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 20, bottom: 10),
                  decoration: const BoxDecoration(
                      color: Color(0xffF4F4BA),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.productDetails['title'],
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                shape: StadiumBorder()),
                            onPressed: null,
                            child: Text('★ ${widget.productDetails['rating']}'),
                          )
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                              'Catagory: ${widget.productDetails['catagory']}')),
                      Expanded(
                        child: Text(
                          widget.productDetails['description'],
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Quantity: '),
                          MaterialButton(
                            color: const Color(0xff0B0B45),
                            shape: const StadiumBorder(),
                            onPressed: () {
                              if (quantity > 1) quantity--;
                              setState(() {});
                            },
                            child: const Text(
                              '-',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            width: 50,
                            child: TextField(
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                quantity = int.parse(value);
                                setState(() {});
                              },
                              controller: quantityController,
                              decoration: InputDecoration(
                                  isDense: true, border: OutlineInputBorder()),
                            ),
                          ),
                          MaterialButton(
                            color: const Color(0xff0B0B45),
                            shape: const StadiumBorder(),
                            onPressed: () {
                              quantity++;
                              setState(() {});
                              print(quantity);
                            },
                            child: const Text(
                              '+',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "৳ ${int.parse(widget.productDetails['price']) * quantity}",
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          MaterialButton(
                            shape: const StadiumBorder(),
                            onPressed: () {
                              addToCart();
                              showMessage(msg: "Succesefully added to cart");
                            },
                            child: const Text(
                              'Buy Now',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: const Color(0xff0B0B45),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addToCart() {
    // int price = int.parse(widget.productDetails['price'] * quantity);
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore.collection('users-cart').add({
      'catagory': widget.productDetails['catagory'],
      'description': widget.productDetails['description'],
      'image': widget.productDetails['image'],
      'price': widget.productDetails['price'],
      'rating': widget.productDetails['rating'],
      'title': widget.productDetails['title'],
      'quantity': quantityController.text
    });
  }

  void addToWishlist() {
    // int price = int.parse(widget.productDetails['price'] * quantity);
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore.collection('whish-list').add({
      'catagory': widget.productDetails['catagory'],
      'description': widget.productDetails['description'],
      'image': widget.productDetails['image'],
      'price': widget.productDetails['price'],
      'rating': widget.productDetails['rating'],
      'title': widget.productDetails['title'],
      'quantity': quantityController.text
    });
  }

  showMessage({required String msg}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(msg),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('ok'))
            ],
          );
        });
  }
}
