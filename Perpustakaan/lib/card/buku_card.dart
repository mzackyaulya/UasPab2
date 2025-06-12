import 'package:flutter/material.dart';
import 'package:perpustakaan/models/buku.dart';

class BukuCard extends StatelessWidget {
  final Buku buku;
  final VoidCallback onTapDetail;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BukuCard({
    Key? key,
    required this.buku,
    required this.onTapDetail,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapDetail,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Gambar Buku
            Positioned.fill(
              child: buku.foto.isNotEmpty
                  ? Image.network(
                buku.foto,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
              )
                  : const Center(child: Icon(Icons.book, size: 60, color: Colors.grey)),
            ),

            // Judul di bagian bawah
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                color: Colors.black.withOpacity(0.6),
                child: Text(
                  buku.judul,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
