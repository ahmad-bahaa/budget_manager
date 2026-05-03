import 'dart:io';
import 'package:budget_manager/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // --- BACKUP ---
  Future<void> createBackup(BuildContext context) async {
    try {
      // 1. Get current database path
      final String path = await _dbHelper.dbPath;
      final File dbFile = File(path);

      if (!await dbFile.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No database found to backup!')),
        );
        return;
      }

      // 2. Share the file (User can save to Drive, Email, or Files)
      await Share.shareXFiles(
        [XFile(path)],
        text: 'Budget Manager Backup',
        subject: 'My Budget Backup',
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Backup Failed: $e')));
    }
  }

  // --- RESTORE ---
  Future<bool> restoreBackup(BuildContext context) async {
    try {
      // 1. Pick the file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result == null) return false; // User canceled

      final File sourceFile = File(result.files.single.path!);

      // Basic validation: Check if file is likely a SQLite DB
      // (Real validation is harder, but this prevents picking random JPEGs)
      if (!sourceFile.path.endsWith('.db') &&
          !sourceFile.path.endsWith('.sqlite')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid file format. Please select a .db file.'),
          ),
        );
        return false;
      }

      // 2. Close existing DB connection
      await _dbHelper.close();

      // 3. Overwrite the DB file
      final String dbPath = await _dbHelper.dbPath;
      await sourceFile.copy(dbPath);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Restore successful! Restarting app...')),
      );

      return true; // Return true to signal the UI to reload
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Restore Failed: $e')));
      return false;
    }
  }
}
