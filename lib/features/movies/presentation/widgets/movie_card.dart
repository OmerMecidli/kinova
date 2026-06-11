import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/movie.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final String? heroTag; // BURA DƏYİŞDİ: parametr əlavə edildi

  const MovieCard({super.key, required this.movie, this.heroTag});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; 

  @override
  Widget build(BuildContext context) {
    super.build(context); 

    final imageUrl = widget.movie.posterPath != null 
        ? '${ApiConstants.imageBaseUrl}${widget.movie.posterPath}' 
        : null;
        
    // BURA DƏYİŞDİ: Unikal tag yaradırıq
    final uniqueTag = widget.heroTag ?? widget.movie.id.toString();

    return GestureDetector(
      onTap: () {
        // BURA DƏYİŞDİ: Həm filmi, həm də tag-i detallar səhifəsinə Map kimi göndəririk
        context.push('/details', extra: {'movie': widget.movie, 'heroTag': uniqueTag});
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: AppColors.surface,
          child: imageUrl != null
              // BURA DƏYİŞDİ: unikal tag istifadə edirik
              ? Hero(
                  tag: uniqueTag,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 300, 
                    fadeInDuration: const Duration(milliseconds: 300),
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image, 
                      color: AppColors.textSecondary, 
                      size: 50,
                    ),
                  ),
                )
              : const Center(
                  child: Text('Şəkil yoxdur', style: TextStyle(color: AppColors.textSecondary)),
                ),
        ),
      ),
    );
  }
}