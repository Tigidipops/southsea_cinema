import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = cinemaPaletteFor(context);
    return Drawer(
      backgroundColor: palette.background,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: palette.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      appTitle,
                      style: TextStyle(
                        color: palette.fontPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: palette.brand),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const DrawerTile(title: 'Home', route: '/'),
            const DrawerTile(title: 'Movie Listing', route: '/listing'),
            const DrawerTile(title: 'My Basket', route: '/basket'),
            const DrawerTile(title: 'My Settings', route: '/settings'),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String title;
  final String? route;

  const DrawerTile({super.key, required this.title, this.route});

  @override
  Widget build(BuildContext context) {
    final palette = cinemaPaletteFor(context);
    return ListTile(
      title: Text(title, style: TextStyle(color: palette.fontPrimary)),
      onTap: () {
        Navigator.pop(context);
        if (route != null) {
          Navigator.pushNamed(context, route!);
        }
      },
    );
  }
}

class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({super.key, required this.layout});
  final Widget layout;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final textSizeMultiplier = width / largeScreenMinWidth;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < largeScreenMinWidth) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(textSizeMultiplier),
              ),
              child: layout);
        } else {
          return layout;
        }
      },
    );
  }
}
