import 'package:flutter/material.dart';
import 'package:wedding2u_app/application/vendor_portfolio_controller.dart';

class VendorPortfolioPage extends StatefulWidget {
  final String vendorId;

  const VendorPortfolioPage({super.key, required this.vendorId});

  @override
  _VendorPortfolioPageState createState() => _VendorPortfolioPageState();
}

class _VendorPortfolioPageState extends State<VendorPortfolioPage> {
  final VendorPortfolioController _controller = VendorPortfolioController();
  bool _isLoading = true;
  Map<String, dynamic>? _vendorData;
  List<String> _galleryImages = [];

  @override
  void initState() {
    super.initState();
    _fetchVendorPortfolio();
  }

  Future<void> _fetchVendorPortfolio() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final portfolioData =
          await _controller.fetchVendorPortfolio(widget.vendorId);
      setState(() {
        _vendorData = portfolioData['vendorData'];
        _galleryImages = portfolioData['galleryImages'];
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching vendor portfolio: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_vendorData == null) {
      return const Scaffold(
        body: Center(child: Text('Vendor not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '${_vendorData!['name']}\'s Portfolio',
          style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFf7706d),
        elevation: 1,
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/vendor_images/gerry_banner.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(_vendorData!['imageUrl']),
                    backgroundColor: Colors.grey[200],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Center(
              child: Column(
                children: [
                  Text(
                    _vendorData!['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    _vendorData!['role'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '📍 ${_vendorData!['location']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  const SocialMediaIcons(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            // Contact and Book Buttons
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add Contact functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 219, 148, 171),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      'Contact',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Add Book functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 219, 148, 171),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      'Book',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 30, thickness: 1),
            // Vendor Gallery Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Gallery',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _galleryImages.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No images available',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: PageController(viewportFraction: 0.9),
                      itemCount: _galleryImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(_galleryImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 20),
            // Description Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Text(
                _vendorData!['description'] ?? 'No description provided.',
                style: const TextStyle(color: Colors.grey, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Social Media Icons Row
class SocialMediaIcons extends StatelessWidget {
  const SocialMediaIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.camera_alt_outlined, size: 30),
        SizedBox(width: 16),
        Icon(Icons.facebook_outlined, size: 30),
        SizedBox(width: 16),
        Icon(Icons.chat_outlined, size: 30),
        SizedBox(width: 16),
        Icon(Icons.share, size: 30),
      ],
    );
  }
}
