import oracledb
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

class Database:
    def __init__(self):
        self.user = os.getenv('DB_USER')
        self.password = os.getenv('DB_PASSWORD')
        self.host = os.getenv('DB_HOST')
        self.port = os.getenv('DB_PORT')
        self.service = os.getenv('DB_SERVICE')
        self.connection = None
        
    def get_connection(self):
        """Create and return database connection"""
        try:
            # Thick mode for better compatibility
            oracledb.init_oracle_client()
            
            # Create DSN
            dsn = f"{self.host}:{self.port}/{self.service}"
            
            # Connect
            self.connection = oracledb.connect(
                user=self.user,
                password=self.password,
                dsn=dsn
            )
            
            print("✓ Database connection successful!")
            return self.connection
            
        except oracledb.DatabaseError as e:
            error, = e.args
            print(f"✗ Database connection failed: {error.message}")
            return None
        except Exception as e:
            print(f"✗ Error: {str(e)}")
            return None
    
    def close_connection(self):
        """Close database connection"""
        if self.connection:
            self.connection.close()
            print("✓ Database connection closed")
    
    def test_connection(self):
        """Test database connection"""
        try:
            conn = self.get_connection()
            if conn:
                cursor = conn.cursor()
                cursor.execute("SELECT 'Connection OK' FROM DUAL")
                result = cursor.fetchone()
                cursor.close()
                print(f"✓ Test query result: {result[0]}")
                self.close_connection()
                return True
            return False
        except Exception as e:
            print(f"✗ Connection test failed: {str(e)}")
            return False

# Test when run directly
if __name__ == "__main__":
    print("Testing database connection...")
    db = Database()
    if db.test_connection():
        print("\n✅ DATABASE CONNECTION SUCCESSFUL!\n")
    else:
        print("\n❌ DATABASE CONNECTION FAILED!\n")