import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

const primaryColor = Color(0xff2784FF);
const containerBg = Color(0xffEBF3FF);
const dottedLineColor = Color(0xffc9deff);

class DropBox extends StatelessWidget {
  bool _loading;
  VoidCallback handleClickFilePick;
  DropBox(this._loading, this.handleClickFilePick);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(64.0),
        child: Container(
          decoration: BoxDecoration(
            color: containerBg,
            borderRadius: BorderRadius.circular(24),
          ),
          child: DottedBorder(
            color: dottedLineColor,
            dashPattern: const [8, 4],
            strokeWidth: 4,
            borderType: BorderType.RRect,
            radius: const Radius.circular(24),
            child: Padding(
                padding: const EdgeInsets.all(64.0),
                child: SizedBox(
                  width: 520,
                  height: 520,
                  child: _loading
                      ? const Center(
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : ui(handleClickFilePick),
                )),
          ),
        ));
  }
}

Widget ui(VoidCallback handleClickFilePick) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Image.asset(
          "assets/folder_active.png",
          width: 48,
          height: 48,
        ),
      ),
      const Text("열고자하는 PCL파일을 드래그해주세요.",
          style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.bold)),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          "또는",
          style: TextStyle(color: Colors.black45, fontSize: 16),
        ),
      ),
      ElevatedButton(
        onPressed: handleClickFilePick,
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        child: const Text(
          "파일 찾아보기",
        ),
      )
    ],
  );
}
