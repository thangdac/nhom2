import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product_post.dart'; // Đường dẫn tới model productPost
import 'dart:async'; // Thêm import Timer

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<productPost> _products = [];
  List<productPost> _filteredProducts = [];
  bool _isLoading = true;
  String _errorMessage = '';
  Timer? _debounce;

  // Fetch products from API
  Future<void> fetchProducts({String query = ''}) async {
    const String baseUrl = 'http://localhost:5019/api/ProductApi/search?name=';
    try {
      final response = await http.get(Uri.parse(baseUrl + query));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _products = data.map((item) => productPost.fromJson(item)).toList();
          _filteredProducts = _products; // Filtered products updated after fetch
          _isLoading = false;
          _errorMessage = ''; // Reset error message if successful
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load products';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch all products when the screen is first loaded
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // Filter products based on the search query
  void _filterProducts(String query) {
    // Cancel the previous debounce timer if there is one
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Create a new timer for debounce to delay the API call
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        // If the search query is empty, fetch all products again
        fetchProducts();
      } else {
        // If there is a search query, fetch products based on the query
        fetchProducts(query: query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _filterProducts, // Trigger search filter on change
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          productPost product = _filteredProducts[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    product: product,
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
                  // Product Image
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(
                        product.image ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported);
                        },
                      ),
                    ),
                  ),
                  // Product Name
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product.name ?? 'No name',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // Product Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      product.description ?? 'No description',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Product Price
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${product.price} VND',
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
  final productPost product;

  const ProductDetailScreen({super.key, required this.product});

  // Add product to cart
  void addToCart(BuildContext context) async {
    final String userId = "33151CA4-FC24-4BE4-B4D4-B6B1852166EE"; // Change to your userId
    final String apiUrl = 'http://localhost:5019/api/CartApi/user/$userId/product/${product.id}';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'quantity': 1, // Number of products to add to cart
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} added to cart')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add to cart')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name ?? 'Product Details'),
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
                child: Image.network(
                  product.image ?? '',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.8,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 100);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.name ?? 'No name',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description ?? 'No description',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${product.price} VND',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                addToCart(context);
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
