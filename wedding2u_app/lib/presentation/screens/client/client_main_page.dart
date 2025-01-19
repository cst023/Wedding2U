import 'package:flutter/material.dart';
import 'package:wedding2u_app/application/main_page_search_controller.dart';
import 'package:wedding2u_app/presentation/screens/client/vendor_portfolio.dart';
import 'package:wedding2u_app/presentation/screens/client/venue_details.dart';

class ClientMainPage extends StatefulWidget {
  const ClientMainPage({super.key});

  @override
  _ClientMainPageState createState() => _ClientMainPageState();
}

class _ClientMainPageState extends State<ClientMainPage> {
  final MainPageSearchController _searchController = MainPageSearchController();
  final TextEditingController _searchBarController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  void _onSearchChanged(String value) async {
    setState(() {
      _isSearching = true;
      _searchQuery = value;
    });

    if (value.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    final results = await _searchController.search(value);
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Add the background color here
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Section
                  _buildBanner(userData['name']),
                  const SizedBox(height: 20),

                  // Search Bar and Profile Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: _buildSearchBarWithProfile(context),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Scrollable Cards Section
                        _buildHorizontalCardsSection(context),
                        const SizedBox(height: 20),

                        // Manage My Wedding Section
                        _buildSectionHeader('Manage My Wedding'),
                        const SizedBox(height: 20),
                        _buildManageWeddingCard(context),
                        const SizedBox(height: 20),

                        // Customer Reviews Section
                        _buildSectionHeader('Customer Reviews'),
                        const SizedBox(height: 20),
                        _buildHorizontalReviewCardsSection(context),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_searchQuery.isNotEmpty)
              Positioned(
                top: 160, // Position below the banner and search bar
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildSearchResultsOverlay(),
              ),
          ],
        ),
      ),
    );
  }

// Banner Widget
  Widget _buildBanner(String name) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFf7706d),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(66, 255, 0, 0), // Shadow color
            offset: Offset(0, 4), // X and Y offset
            blurRadius: 10, // Spread of the shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, $name!',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4.0),
                const Text(
                  "Let's prepare for your wedding!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/images/weddingrings.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  // Search Bar and Profile Section
  Widget _buildSearchBarWithProfile(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchBarController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchBarController.clear();
                        setState(() {
                          _searchQuery = '';
                          _searchResults = [];
                        });
                      },
                    )
                  : null,
              hintText: 'Search for venues or vendors',
              filled: true, // Enables the background color
              fillColor: Colors.white, // Sets the background color to white
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'ClientProfilePage');
          },
          child: CircleAvatar(
            radius: 32.0,
            backgroundImage:
                const AssetImage('assets/images/profile_avatar.jpg'),
            backgroundColor: Colors.grey[200],
          ),
        ),
      ],
    );
  }

  // Search Results Overlay
  Widget _buildSearchResultsOverlay() {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.4, // Set height to 60% of screen height
      color: const Color.fromARGB(255, 255, 255, 255),
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final result = _searchResults[index];
          return ListTile(
            leading:
                Icon(result['type'] == 'Venue' ? Icons.place : Icons.person),
            title: Text(result['name']),
            subtitle: Text(result['type']),
            onTap: () {
              if (result['type'] == 'Venue') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VenueDetails(venueId: result['id']),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VendorPortfolioPage(vendorId: result['id']),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  // Horizontal Cards Section
  Widget _buildHorizontalCardsSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryCard(
            imagePath: 'assets/images/location.png',
            onTap: () => Navigator.pushNamed(context, 'VenueCatalog'),
            label: 'Venue',
          ),
          const SizedBox(width: 16),
          _buildCategoryCard(
            imagePath: 'assets/images/post.png',
            onTap: () => Navigator.pushNamed(context, 'WeddingPosts'),
            label: 'Post',
          ),
          const SizedBox(width: 16),
          _buildCategoryCard(
            imagePath: 'assets/images/vendor.png',
            onTap: () => Navigator.pushNamed(context, 'VendorCatalog'),
            label: 'Vendor',
          ),
        ],
      ),
    );
  }

// Reusable Category Card Widget
  Widget _buildCategoryCard({
    required String imagePath,
    required VoidCallback onTap,
    required String label, // Label for text below the image
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180, // Control width of the card
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center, // Align everything in the center
              children: [
                // Circle frame behind the image (no clipping)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // White background for the circle
                    shape: BoxShape.circle, // Circle shape
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ], // Subtle shadow for a clean look
                  ),
                  width: 120, // Fixed width for the circle
                  height: 120, // Fixed height for the circle
                ),
                // Image in front of the circle (without clipping)
                Positioned(
                  top: 13,
                  left: 4, // Adjust this value to move the image down
                  child: Container(
                    width: 120, // Adjust width as needed
                    height: 90, // Adjust height as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Image will be in front of the circle, not clipped
                    ),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain, // Ensure the whole image is visible
                      width: 100, // Smaller size so the image fits nicely
                      height: 100, // Smaller size to fit inside the circle
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8), // Space between image and text
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.w600, // Minimalist style with medium weight
                color: Colors.black, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Manage My Wedding Section Card
  Widget _buildManageWeddingCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'ManageWedding');
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: const DecorationImage(
            image: AssetImage('assets/images/wedding_dais.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // Horizontal Review Cards Section
  Widget _buildHorizontalReviewCardsSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildReviewCard('assets/post_images/javier1.jpg', context),
          const SizedBox(width: 20),
          _buildReviewCard('assets/post_images/azeleen1.jpg', context),
        ],
      ),
    );
  }

// Reusable Review Card Widget
  Widget _buildReviewCard(String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'WeddingPosts');
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(111, 0, 0, 0),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              10), // Matches the container's border radius
          child: Image.asset(
            imagePath,
            width: 180,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
