import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/models/booking.dart';
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
  List<Booking> _bookings = [];
  bool _loading = true;
  String _errorMessage = '';
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

  Widget _buildLineItem(BasketRepository basket, BasketItem item, int index) {
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
            key: ValueKey<String>('delete_${item.movie.id}'),
            icon: const Icon(Icons.delete_outline, color: cinemaFontWhite),
            style: IconButton.styleFrom(
              backgroundColor: cinemaBrand,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            onPressed: () {
              setState(() {
                basket.removeItem(index);
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

  Widget _buildBasketList(BasketRepository basket, List<BasketItem> items) {
    final List<Widget> children = [];

    children.add(const Text('MY ORDER', style: cinemaHeaderStyle));
    children.add(const SizedBox(height: 16));
    children.add(_buildHeader());
    children.add(const SizedBox(height: 8));

    for (int index = 0; index < items.length; index++) {
      final BasketItem item = items[index];
      children.add(_buildLineItem(basket, item, index));
    }
    children.add(const SizedBox(height: 24));
    children.add(
      _buildTotalRow(
        'Items subtotal',
        '£${basket.getSubtotal().toStringAsFixed(2)}',
      ),
    );
    children.add(
      _buildTotalRow(
        'Service charge',
        '£${basket.getServiceCharge().toStringAsFixed(2)}',
      ),
    );
    children.add(
      _buildTotalRow(
        'Total Due',
        '£${basket.getTotalDue().toStringAsFixed(2)}',
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
              _checkout(basket, items);
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
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _checkout(
      BasketRepository basketRepo, List<BasketItem> items) async {
    final String summary = _buildSummary(items);
    final double total = basketRepo.getTotalDue();
    final String date = _formatDate(DateTime.now());

    try {
      final CinemaDatabase database = CinemaDatabase.instance;
      final int bookingNumber = await database.getNextBookingNumber();
      final Booking record = Booking(
        bookingNumber: bookingNumber,
        summary: summary,
        total: total,
        date: date,
      );

      await database.insertBooking(record);
      basketRepo.clear();
      if (!mounted) {
        return;
      }
      setState(() {
        _confirmationMessage = 'Booking #$bookingNumber saved';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _confirmationMessage = 'Could not save your booking: $error';
      });
    }
  }

  String _buildSummary(List<BasketItem> items) {
    final List<String> parts = [];
    for (final BasketItem item in items) {
      parts.add('${item.quantity} x ${item.movie.title}');
    }
    return parts.join(', ');
  }

  String _formatDate(DateTime now) {
    final String day = now.day.toString().padLeft(2, '0');
    final String month = now.month.toString().padLeft(2, '0');
    final String year = now.year.toString();
    final String hour = now.hour.toString().padLeft(2, '0');
    final String minute = now.minute.toString().padLeft(2, '0');
    return '$day/$month/${now.year} $hour:$minute';
  }

  Future<void> _loadBookings() async {
    try {
      final List<Booking> bookings =
          await CinemaDatabase.instance.getAllBookings();
      if (!mounted) {
        return;
      }
      setState(() {
        _bookings = bookings;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'could not load bookings: $error';
        _loading = false;
      });
    }
  }

  Widget _buildBookingLine(Booking booking) {
    return Card(
      color: cinemaSurface,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking #${booking.bookingNumber}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: cinemaBrandDark),
                ),
                Text(
                  '£${booking.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: cinemaFontWhite,
                  ),
                ),
              ],
            ),
            Text(
              booking.summary,
              style: const TextStyle(color: cinemaFontWhite),
            ),
            Text(
              booking.date,
              style: const TextStyle(color: cinemaFontWhite),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsSection() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Text(
        _errorMessage,
        style: const TextStyle(color: cinemaFontWhite),
      );
    }

    if (_bookings.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          'No bookings yet',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final List<Widget> children = [];

    for (final Booking booking in _bookings) {
      children.add(_buildBookingLine(booking));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                content,
                const SizedBox(height: 32),
                const Text('PAST BOOKINGS', style: cinemaHeaderStyle),
                const SizedBox(height: 16),
                _buildBookingsSection(),
              ],
            )));
  }
}
