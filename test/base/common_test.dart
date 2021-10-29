// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:tool_base/src/base/common.dart';

import '../src/common.dart';

void main() {
  group('throw ToolExit', () {
    test('throws ToolExit', () {
      expect(() => throw ToolExit('message'), throwsToolExit());
    });

    test('throws ToolExit with exitCode', () {
      expect(() => throw ToolExit('message', exitCode: 42),
          throwsToolExit(exitCode: 42));
    });

    test('throws ToolExit with message', () {
      expect(
          () => throw ToolExit('message'), throwsToolExit(message: 'message'));
    });

    test('throws ToolExit with message and exit code', () {
      expect(() => throw ToolExit('message', exitCode: 42),
          throwsToolExit(exitCode: 42, message: 'message'));
    });
  });
}
