import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mybiz_app/services/image_upload_service.dart';

class ImageUploadPage extends StatefulWidget {
    const ImageUploadPage({super.key});
    @override
    State<ImageUploadPage> createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
    final _service = ImageUploadService();
    final _picker = ImagePicker();
    List<File> _selected = [];
    double _progress = 0;
    bool _loading = false;
    bool _consented = false;

    Future<void> _pickImages() async {
        final granted = await _service.requestGalleryPermission();
        if (!granted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('갤러리 권한이 필요합니다')));
            return;
        }
        final images = await _picker.pickMultiImage();
        if (images.isEmpty) return;
        final files = images.map((x) => File(x.path)).toList();
        setState(() { _selected = files.take(ImageUploadService.maxImageCount).toList(); });
    }

    Future<void> _upload() async {
        if (!_consented) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('약관 동의가 필요합니다')));
            return;
        }
        if (_selected.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('이미지를 선택해주세요')));
            return;
        }
        setState(() { _loading = true; _progress = 0; });
        try {
            final res = await _service.uploadImagesWithProgress(_selected, (p) {
                setState(() { _progress = p; });
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('업로드 완료')));
        } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('업로드 실패')));
        } finally {
            setState(() { _loading = false; });
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text('이미지 업로드', style: GoogleFonts.inter(fontWeight: FontWeight.w600))),
            body: Padding(
                padding: EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                                ElevatedButton(
                                    onPressed: _loading ? null : _pickImages,
                                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00C2FD)),
                                    child: Text('이미지 선택', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700)),
                                ),
                                SizedBox(width: 12),
                                OutlinedButton(onPressed: _loading ? null : _upload, child: Text('업로드')),
                            ]),
                            SizedBox(height: 12),
                            Row(children: [
                                Checkbox(value: _consented, onChanged: (v) => setState(() { _consented = v ?? false; })),
                                Expanded(child: Text('이미지 업로드 약관에 동의합니다', style: GoogleFonts.inter(fontSize: 13, color: Color(0xFF777777))))
                            ]),
                            if (_loading) ...[
                                SizedBox(height: 12),
                                LinearProgressIndicator(value: _progress.clamp(0.0, 1.0)),
                            ]
                        ]),
                    ),
                    SizedBox(height: 12),
                    Expanded(
                        child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
                            itemCount: _selected.length,
                            itemBuilder: (context, index) {
                                final f = _selected[index];
                                return Stack(children: [
                                    Positioned.fill(child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(f, fit: BoxFit.cover))),
                                    Positioned(top: 4, right: 4, child: InkWell(onTap: () { setState(() { _selected.removeAt(index); }); }, child: Container(decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle), padding: EdgeInsets.all(4), child: Icon(Icons.close, size: 16, color: Colors.white))))
                                ]);
                            },
                        ),
                    )
                ]),
            ),
        );
    }
} 