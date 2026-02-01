#!/usr/bin/env python3
import os
import logging
from datetime import datetime

class LogManager:
    def __init__(self, log_file_path, max_size_mb=10):
        """
        Initialize log manager
        :param log_file_path: Path to the log file
        :param max_size_mb: Maximum size in MB before clearing
        """
        self.log_file_path = log_file_path
        self.max_size_bytes = max_size_mb * 1024 * 1024  # Convert MB to bytes
        
    def check_and_clear_if_needed(self):
        """Check file size and clear if it exceeds the limit"""
        try:
            if os.path.exists(self.log_file_path):
                file_size = os.path.getsize(self.log_file_path)
                
                if file_size > self.max_size_bytes:
                    # Backup the last few lines before clearing (optional)
                    self._backup_recent_logs()
                    
                    # Clear the log file
                    with open(self.log_file_path, 'w') as f:
                        f.write(f"[{datetime.now()}] Log file cleared due to size limit ({file_size} bytes)\n")
                    
                    print(f"Log file cleared. Previous size: {file_size} bytes")
                    return True
                else:
                    print(f"Log file size OK: {file_size} bytes (limit: {self.max_size_bytes} bytes)")
                    return False
            else:
                print(f"Log file {self.log_file_path} doesn't exist")
                return False
                
        except Exception as e:
            print(f"Error checking log file: {e}")
            return False
    
    def _backup_recent_logs(self, lines_to_keep=100):
        """Backup the last N lines before clearing (optional)"""
        try:
            backup_file = f"{self.log_file_path}.backup"
            
            with open(self.log_file_path, 'r') as f:
                all_lines = f.readlines()
            
            # Keep only the last N lines
            recent_lines = all_lines[-lines_to_keep:] if len(all_lines) > lines_to_keep else all_lines
            
            with open(backup_file, 'w') as f:
                f.write(f"[{datetime.now()}] Backup of recent logs before clearing\n")
                f.writelines(recent_lines)
                
            print(f"Backed up {len(recent_lines)} recent log entries to {backup_file}")
            
        except Exception as e:
            print(f"Error creating backup: {e}")

    def get_file_size_mb(self):
        """Get current file size in MB"""
        if os.path.exists(self.log_file_path):
            size_bytes = os.path.getsize(self.log_file_path)
            return size_bytes / (1024 * 1024)
        return 0

# Usage example
if __name__ == "__main__":
    import sys
    
    # Get the directory where this script is located
    script_dir = os.path.dirname(os.path.abspath(__file__))
    LOG_FILE = os.path.join(script_dir, "logs", "errors.log")
    
    MAX_SIZE_MB = 10  # 10 MB limit (adjust as needed)
    
    # Create log manager
    manager = LogManager(LOG_FILE, MAX_SIZE_MB)
    
    # Handle command line arguments
    if len(sys.argv) > 1:
        command = sys.argv[1].lower()
        if command == "info":
            current_size = manager.get_file_size_mb()
            print(f"Log file: {LOG_FILE}")
            print(f"Current size: {current_size:.2f} MB")
            print(f"Size limit: {MAX_SIZE_MB} MB")
            if os.path.exists(LOG_FILE):
                with open(LOG_FILE, 'r') as f:
                    lines = sum(1 for _ in f)
                print(f"Number of lines: {lines}")
        elif command == "force-clear":
            with open(LOG_FILE, 'w') as f:
                f.write(f"[{datetime.now()}] Log file manually cleared\n")
            print("Log file cleared manually")
        else:
            print("Usage: python3 log_manager.py [info|force-clear]")
            print("  No argument: Check and clear if needed")
            print("  info: Show log file information")
            print("  force-clear: Clear log file regardless of size")
    else:
        # Default: Check and clear if needed
        manager.check_and_clear_if_needed()
        
        # Show current size
        current_size = manager.get_file_size_mb()
        print(f"Current log file size: {current_size:.2f} MB")
