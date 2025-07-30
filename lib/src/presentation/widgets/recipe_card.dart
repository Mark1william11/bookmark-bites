import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.onTap,
    required this.heroTag,
  });

  final String imageUrl;
  final String name;
  final VoidCallback onTap;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    // THE FIX: The .animate() call on the Hero widget has been completely removed.
    return Hero(
      tag: heroTag,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                memCacheWidth: 500,
                memCacheHeight: 500,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image_outlined, size: 40, color: Colors.white70)),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.7)],
                    stops: const [0.5, 0.7, 1.0],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [const Shadow(blurRadius: 8.0, color: Colors.black, offset: Offset(0, 0))],
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}