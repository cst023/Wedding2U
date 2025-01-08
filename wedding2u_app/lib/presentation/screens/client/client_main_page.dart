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
            imagePath: 'assets/images/venues2_icon.jpg',
            onTap: () => Navigator.pushNamed(context, 'VenueCatalog'),
          ),
          const SizedBox(width: 16),
          _buildCategoryCard(
            imagePath: 'assets/images/posts2_icon.jpg',
            onTap: () => Navigator.pushNamed(context, 'WeddingPosts'),
          ),
          const SizedBox(width: 16),
          _buildCategoryCard(
            imagePath: 'assets/images/vendors2_icon.jpg',
            onTap: () => Navigator.pushNamed(context, 'VendorCatalog'),
          ),
        ],
      ),
    );
  }

  // Reusable Category Card Widget
  Widget _buildCategoryCard(
      {required String imagePath, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          imagePath,
          width: 160,
          height: 160,
          fit: BoxFit.cover,
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
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          imagePath,
          width: 180,
          height: 180,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
