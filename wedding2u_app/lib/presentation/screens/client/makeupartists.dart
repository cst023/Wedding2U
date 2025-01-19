import 'package:flutter/material.dart';
import 'package:wedding2u_app/application/vendor_page_controller.dart';
import 'package:wedding2u_app/presentation/screens/client/vendor_portfolio.dart';

class MakeupArtistsPage extends StatefulWidget {
  const MakeupArtistsPage({super.key});

  @override
  _MakeupArtistsPageState createState() => _MakeupArtistsPageState();
}

class _MakeupArtistsPageState extends State<MakeupArtistsPage> {
  final VendorPageController _vendorController = VendorPageController();
  bool _isLoading = true;
  List<Map<String, dynamic>> _vendors = [];

  @override
  void initState() {
    super.initState();
    _fetchMakeupArtists();
  }

  Future<void> _fetchMakeupArtists() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final makeupArtists =
          await _vendorController.getVendorsByRole('Makeup Artist');
      setState(() {
        _vendors = makeupArtists;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching makeup artists: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Makeup Artist',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold, // Makes the text bold
          ),
        ),
        backgroundColor: const Color(0xFFf7706d),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _vendors.isEmpty
              ? const Center(child: Text('No makeup artists found.'))
              : ListView.builder(
                  itemCount: _vendors.length,
                  itemBuilder: (context, index) {
                    final vendor = _vendors[index];
                    return VendorCard(
                      name: vendor['name'],
                      role: vendor['role'],
                      location: vendor['location'],
                      imageUrl: vendor['imageUrl'],
                      onTap: () {
                        print(
                            'Navigating to Vendor Portfolio: ${vendor['name']}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VendorPortfolioPage(
                                vendorId:
                                    vendor['id']), // Navigate without arguments
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

class VendorCard extends StatelessWidget {
  final String name;
  final String role;
  final String location;
  final String imageUrl;
  final VoidCallback onTap;

  const VendorCard({
    super.key,
    required this.name,
    required this.role,
    required this.location,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white, // Set the card background color to white
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Network Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child:
                          CircularProgressIndicator(), // Placeholder during loading
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/vendor_images/placeholder_makeup_artist.jpg', // Fallback image if network fails
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Location: $location',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
