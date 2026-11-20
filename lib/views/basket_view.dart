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
    final palette = cinemaPaletteFor(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              'Item',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: palette.fontPrimary),
            ),
          ),
          Expanded(
            child: Text(
              'Details',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: palette.fontPrimary),
            ),
          ),
          Text(
            'Price                ',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: palette.fontPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildLineItem(BasketRepository basket, BasketItem item, int index) {
    final palette = cinemaPaletteFor(context);
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
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: palette.brandDark),
            ),
          ),
          Expanded(
            child: Text(
              '${item.quantity} Standard\n ${item.movie.title}, ${item.movie.screeningTime}, Southsea Cinema Room',
              style: TextStyle(color: palette.fontPrimary),
            ),
          ),
          Text(
            '£${(item.quantity * item.movie.ticketPrice).toStringAsFixed(2)}  ',
            style: TextStyle(color: palette.fontPrimary),
          ),
          IconButton(
            key: ValueKey<String>('delete_${item.movie.id}'),
            icon: Icon(Icons.delete_outline, color: palette.fontPrimary),
            style: IconButton.styleFrom(
              backgroundColor: palette.brand,
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
    final palette = cinemaPaletteFor(context);
    final TextStyle style;
    if (emphasise) {
      style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: palette.fontPrimary,
      );
    } else {
      style = TextStyle(color: palette.fontPrimary);
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
    final palette = cinemaPaletteFor(context);

    children.add(Text(
      'MY ORDER',
      style: TextStyle(
        color: palette.fontPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ));
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
    final palette = cinemaPaletteFor(context);
    return Card(
      color: palette.surface,
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
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: palette.brandDark),
                ),
                Text(
                  '£${booking.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: palette.fontPrimary,
                  ),
                ),
              ],
            ),
            Text(
              booking.summary,
              style: TextStyle(color: palette.fontPrimary),
            ),
            Text(
              booking.date,
              style: TextStyle(color: palette.fontPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsSection() {
    final palette = cinemaPaletteFor(context);
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Text(
        _errorMessage,
        style: TextStyle(color: palette.fontPrimary),
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
    final palette = cinemaPaletteFor(context);

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
                Text(
                  'PAST BOOKINGS',
                  style: TextStyle(
                    color: palette.fontPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildBookingsSection(),
              ],
            )));
  }
}
