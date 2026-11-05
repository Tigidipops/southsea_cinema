import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

class BasketView extends StatefulWidget {
  const BasketView({super.key});

  @override
  State<BasketView> createState() {
    return _BasketViewState();
  }
}

class _BasketViewState extends State<BasketView> {
  String _confirmationMessage = '';

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              'Item',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: cinemaFontWhite),
            ),
          ),
          Expanded(
            child: Text(
              'Details',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: cinemaFontWhite),
            ),
          ),
          Text(
            'Price                ',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: cinemaFontWhite),
          ),
        ],
      ),
    );
  }

  Widget _buildLineItem(BasketRepository cart, BasketItem item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              item.quantity == 1
                  ? '${item.quantity} Ticket'
                  : '${item.quantity} Tickets',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: cinemaBrandDark),
            ),
          ),
          Expanded(
            child: Text(
              '${item.quantity} Standard\n ${item.movie.title}, ${item.movie.screeningTime}, Southsea Cinema Room',
              style: const TextStyle(color: cinemaFontWhite),
            ),
          ),
          Text(
            '£${(item.quantity * item.movie.ticketPrice).toStringAsFixed(2)}  ',
            style: const TextStyle(color: cinemaFontWhite),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: cinemaFontWhite),
            style: IconButton.styleFrom(
              backgroundColor: cinemaBrand,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            onPressed: () {
              setState(() {
                cart.removeItem(index);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool emphasise = false}) {
    final TextStyle style;
    if (emphasise) {
      style = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    } else {
      style = const TextStyle(color: cinemaFontWhite);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }

  Widget _buildBasketList(BasketRepository cart, List<BasketItem> items) {
    final List<Widget> children = [];

    children.add(const Text('MY ORDER', style: cinemaHeaderStyle));
    children.add(const SizedBox(height: 16));
    children.add(_buildHeader());
    children.add(const SizedBox(height: 8));

    for (int index = 0; index < items.length; index++) {
      final BasketItem item = items[index];
      children.add(_buildLineItem(cart, item, index));
    }
    children.add(const SizedBox(height: 24));
    children.add(
      _buildTotalRow(
        'Items subtotal',
        '£${cart.getSubtotal().toStringAsFixed(2)}',
      ),
    );
    children.add(
      _buildTotalRow(
        'Service charge',
        '£${cart.getServiceCharge().toStringAsFixed(2)}',
      ),
    );
    children.add(
      _buildTotalRow(
        'Total Due',
        '£${cart.getTotalDue().toStringAsFixed(2)}',
        emphasise: true,
      ),
    );
    children.add(const SizedBox(height: 24));
    children.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          PrimaryButton(
            label: 'UPDATE ORDER',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MovieListing(movie: items.last.movie);
                  },
                ),
              );
            },
          ),
          PrimaryButton(
            label: 'BUY TICKETS',
            onPressed: () {
              setState(() {
                cart.clear();
                _confirmationMessage = 'Thanks, your order is on its way';
              });
            },
          ),
        ])));
    if (_confirmationMessage.isNotEmpty) {
      children.add(const SizedBox(height: 12));
      children.add(
        Text(
          _confirmationMessage,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Your basket is empty',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final BasketRepository cart = BasketRepository.instance;
    final List<BasketItem> items = cart.getItems();

    final Widget content;
    if (items.isEmpty) {
      if (_confirmationMessage.isNotEmpty) {
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmptyState(),
            const SizedBox(height: 12),
            Text(
              _confirmationMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      } else {
        content = _buildEmptyState();
      }
    } else {
      content = _buildBasketList(cart, items);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: content,
      ),
    );
  }
}
