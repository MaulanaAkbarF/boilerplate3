import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constant_values/_setting_value/log_app_values.dart';
import '../../../../core/utilities/functions/logger_func.dart';
import '../../../../core/utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import '../../global_return_widgets/future_state_func.dart';
import '../../global_return_widgets/media_widgets_func.dart';

class AdaptiveChewiePlayer extends StatefulWidget {
  final XFile? file;
  final String? pathVideoFromAsset;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final bool isExpanded;

  const AdaptiveChewiePlayer({
    super.key,
    this.file,
    this.pathVideoFromAsset,
    this.width,
    this.height,
    this.aspectRatio,
    this.isExpanded = false,
  });

  @override
  State<AdaptiveChewiePlayer> createState() => _AdaptiveChewiePlayerState();
}

class _AdaptiveChewiePlayerState extends State<AdaptiveChewiePlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  Future<void>? _initializeVideoFuture;

  @override
  void initState() {
    super.initState();
    if (widget.file != null) {
      _initializeVideoFuture = _initializeVideoPlayer();
    }
  }

  @override
  void didUpdateWidget(AdaptiveChewiePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.file?.path != oldWidget.file?.path) {
      _videoController?.dispose();
      _chewieController?.dispose();
      _initializeVideoFuture = _initializeVideoPlayer();
    }
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      if (widget.file != null) {
        _videoController = VideoPlayerController.file(File(widget.file!.path));
        await _videoController!.initialize();
        if (mounted) {
          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            autoPlay: true,
            looping: true,
            showControls: false,
            showOptions: true,
            aspectRatio: widget.aspectRatio ?? 9 / 18,
            errorBuilder: (context, e) {
              clog('Terjadi masalah ketika loadVideoAssetXFile. errorBuilder: $e');
              addLogApp(level: ListLogAppLevel.severe.level, title: 'Terjadi masalah ketika loadVideoAssetXFile. errorBuilder: $e', logs: '');
              return Center(child: loadDefaultAppLogoSVG(sizeLogo: 100));
            },
          );
        }
      }
    } catch (e, s) {
      clog('Terjadi masalah ketika loadVideoAssetXFile. Error: $e\n$s');
      addLogApp(level: ListLogAppLevel.severe.level, title: 'Terjadi masalah ketika loadVideoAssetXFile: $e', logs: '');
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.file == null) {
      return onEmptyState(context: context, description: 'Tidak ada file video yang diberikan!');
    }

    return FutureBuilder(
      future: _initializeVideoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_chewieController != null) {
            if (widget.isExpanded) {
              return Expanded(child: SizedBox(child: Chewie(controller: _chewieController!)));
            } else {
              return SizedBox(
                child: Chewie(controller: _chewieController!),
              );
            }
          } else {
            if (widget.isExpanded) {
              return Expanded(child: onEmptyState(context: context, description: 'File video tidak tersedia atau rusak!'));
            } else {
              return onEmptyState(context: context, description: 'File video tidak tersedia atau rusak!');
            }
          }
        }
        if (snapshot.hasError) {
          return onFailedState(context: context, description: 'AdaptiveChewiePlayer Error: ${snapshot.error}');
        }
        return onLoadingState(context: context);
      },
    );
  }
}