#!/usr/bin/env python3
import os
import sys
import logging
sys.path.append(os.path.join(os.path.dirname(__file__), "/database"))

from partition_manager import PartitionManager

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/var/log/crowd_management/partition_creation.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

def main():
    try:
        manager = PartitionManager()
        success = manager.create_next_month_partition()
        
        if success:
            logger.info("Successfully created next month's partition")
            sys.exit(0)
        else:
            logger.error("Failed to create partition")
            sys.exit(1)
    except Exception as e:
        logger.error(f"Error in partition creation script: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    main()
    
#_________________________  
'''
- # View your crontab entries
    crontab -l
    option 1
-Add this line to the file:
    1 0 1 * * /var/www/html/crowd_management/Back/database/crowd_management_database/create_partition.py
    Save the file
    Exit nano
'''