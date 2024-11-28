import 'package:flutter/material.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<String> _imageNames = [
    'market_image/anh1.jpg',
    'market_image/anh2.jpg',
    'market_image/anh3.jpeg',
    'market_image/anh4.webp',
    'market_image/anh5.png',
    'market_image/anh6.jpeg',
  ];

  List<String> _productNames = [
    'Dong Ho',
    'Giay Da',
    'Mu',
    'Mat Kinh',
    'Ao 2 Day',
    'Vay',
  ];

  List<String> _productDescriptions = [
    'A stylish watch for every occasion.',
    'Premium leather shoes for formal wear.',
    'Trendy hats for sunny days.',
    'High-quality sunglasses for UV protection.',
    'Elegant camisole for casual wear.',
    'Chic dress for a perfect evening.',
  ];

  List<int> _filteredIndexes = [];

  @override
  void initState() {
    super.initState();
    _filteredIndexes = List.generate(_productNames.length, (index) => index);
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredIndexes =
            List.generate(_productNames.length, (index) => index);
      } else {
        _filteredIndexes = _productNames
            .asMap()
            .entries
            .where((entry) =>
            entry.value.toLowerCase().contains(query.toLowerCase()))
            .map((entry) => entry.key)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _filterProducts,
          decoration: InputDecoration(
            hintText: 'Search products...',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(8.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blue,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: _filteredIndexes.length,
        itemBuilder: (context, index) {
          int actualIndex = _filteredIndexes[index];
          String imageName = _imageNames[actualIndex];
          String productName = _productNames[actualIndex];
          String productDescription = _productDescriptions[actualIndex];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    imageName: imageName,
                    productName: productName,
                    productDescription: productDescription,
                    price: '\$${(actualIndex + 1) * 10}',
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.asset(
                        imageName,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      productDescription,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '\$${(actualIndex + 1) * 10}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final String imageName;
  final String productName;
  final String productDescription;
  final String price;

  const ProductDetailScreen({
    super.key,
    required this.imageName,
    required this.productName,
    required this.productDescription,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imageName,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              productName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              productDescription,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              price,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
