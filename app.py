from flask import Flask, render_template, request, jsonify, session, redirect, url_for
from flask_cors import CORS
from database import Database
import oracledb
import os
from dotenv import load_dotenv
from datetime import datetime
import hashlib

load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv('FLASK_SECRET_KEY')
CORS(app, supports_credentials=True)

db = Database()

def hash_password(password):
    """Hash password using SHA256"""
    return hashlib.sha256(password.encode()).hexdigest()

def get_db_connection():
    """Get database connection"""
    return db.get_connection()

def login_required(f):
    """Decorator to require login"""
    from functools import wraps
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            return jsonify({'success': False, 'message': 'Not logged in'}), 401
        return f(*args, **kwargs)
    return decorated_function

# ============================================
# PAGE ROUTES
# ============================================

@app.route('/')
def index():
    """Home page with map"""
    return render_template('index.html')

@app.route('/restaurant/<int:restaurant_id>')
def restaurant_detail(restaurant_id):
    """Restaurant detail page"""
    return render_template('restaurant_detail.html', restaurant_id=restaurant_id)

@app.route('/profile')
def profile():
    """User profile page"""
    if 'user_id' not in session:
        return redirect(url_for('index'))
    return render_template('profile.html')

@app.route('/analytics')
def analytics():
    """Analytics dashboard"""
    return render_template('analytics.html')

@app.route('/add-restaurant')
def add_restaurant_page():
    """Add restaurant page - ADMINS ONLY"""
    if 'user_id' not in session:
        return redirect(url_for('index'))
    
    # Check if user is admin or moderator
    if session.get('role') not in ['admin', 'moderator']:
        return '''
        <!DOCTYPE html>
        <html>
        <head>
            <title>Access Denied</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>
        <body style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); height: 100vh; display: flex; align-items: center; justify-content: center;">
            <div class="card text-center" style="max-width: 500px; padding: 30px;">
                <h2>🚫 Access Denied</h2>
                <p class="text-muted">Only administrators and moderators can add restaurants.</p>
                <p>Please contact an admin if you want to add a restaurant.</p>
                <a href="/" class="btn btn-primary mt-3">← Back to Home</a>
            </div>
        </body>
        </html>
        '''
    
    return render_template('add_restaurant.html')

# ============================================
# AUTHENTICATION API
# ============================================

@app.route('/api/register', methods=['POST'])
def register():
    """User registration"""
    try:
        data = request.json
        username = data.get('username')
        email = data.get('email')
        password = data.get('password')
        city = data.get('city', 'Manipal')
        
        if not username or not email or not password:
            return jsonify({
                'success': False,
                'message': 'All fields are required'
            }), 400
        
        password_hash = hash_password(password)
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        try:
            cursor.execute("""
                INSERT INTO USERS (user_id, username, email, password_hash, city)
                VALUES (user_seq.NEXTVAL, :username, :email, :password, :city)
            """, {
                'username': username,
                'email': email,
                'password': password_hash,
                'city': city
            })
            conn.commit()
            
            cursor.execute("SELECT user_seq.CURRVAL FROM DUAL")
            user_id = cursor.fetchone()[0]
            
            cursor.close()
            conn.close()
            
            return jsonify({
                'success': True,
                'message': 'Registration successful!',
                'user_id': int(user_id)
            })
            
        except oracledb.IntegrityError:
            conn.rollback()
            cursor.close()
            conn.close()
            return jsonify({
                'success': False,
                'message': 'Username or email already exists'
            }), 400
            
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Registration failed: {str(e)}'
        }), 500

@app.route('/api/login', methods=['POST'])
def login():
    """User login"""
    try:
        data = request.json
        username = data.get('username')
        password = data.get('password')
        
        if not username or not password:
            return jsonify({
                'success': False,
                'message': 'Username and password required'
            }), 400
        
        password_hash = hash_password(password)
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT user_id, username, email, role, city, trust_score
            FROM USERS
            WHERE username = :username AND password_hash = :password
        """, {'username': username, 'password': password_hash})
        
        user = cursor.fetchone()
        cursor.close()
        conn.close()
        
        if user:
            session['user_id'] = user[0]
            session['username'] = user[1]
            session['role'] = user[3]
            
            return jsonify({
                'success': True,
                'message': 'Login successful!',
                'user': {
                    'user_id': user[0],
                    'username': user[1],
                    'email': user[2],
                    'role': user[3],
                    'city': user[4],
                    'trust_score': user[5]
                }
            })
        else:
            return jsonify({
                'success': False,
                'message': 'Invalid username or password'
            }), 401
            
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Login failed: {str(e)}'
        }), 500

@app.route('/api/logout', methods=['POST'])
def logout():
    """User logout"""
    session.clear()
    return jsonify({'success': True, 'message': 'Logged out successfully'})

@app.route('/api/current-user', methods=['GET'])
def get_current_user():
    """Get current logged in user with trust score"""
    if 'user_id' not in session:
        return jsonify({'success': False, 'message': 'Not logged in'}), 401
    
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT user_id, username, email, role, city, trust_score 
            FROM USERS 
            WHERE user_id = :user_id
        """, {'user_id': session['user_id']})
        
        user = cursor.fetchone()
        cursor.close()
        conn.close()
        
        if user:
            return jsonify({
                'success': True,
                'user': {
                    'user_id': user[0],
                    'username': user[1],
                    'email': user[2],
                    'role': user[3],
                    'city': user[4],
                    'trust_score': int(user[5]) if user[5] is not None else 0
                }
            })
        else:
            return jsonify({'success': False, 'message': 'User not found'}), 404
            
    except Exception as e:
        print("Error in current-user:", str(e))
        return jsonify({'success': False, 'message': 'Database error'}), 500

# ============================================
# RESTAURANT API
# ============================================

@app.route('/api/restaurants', methods=['GET'])
def get_restaurants():
    """Get all restaurants"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT 
                r.restaurant_id,
                r.name,
                r.latitude,
                r.longitude,
                r.address,
                r.city,
                r.price_range,
                r.phone,
                r.website,
                r.avg_rating,
                r.total_reviews,
                LISTAGG(c.cuisine_name, ', ') WITHIN GROUP (ORDER BY c.cuisine_name) as cuisines
            FROM RESTAURANTS r
            LEFT JOIN RESTAURANT_CUISINES rc ON r.restaurant_id = rc.restaurant_id
            LEFT JOIN CUISINES c ON rc.cuisine_id = c.cuisine_id
            WHERE r.status = 'active'
            GROUP BY r.restaurant_id, r.name, r.latitude, r.longitude, 
                     r.address, r.city, r.price_range, r.phone, r.website, 
                     r.avg_rating, r.total_reviews
            ORDER BY r.avg_rating DESC
        """)
        
        restaurants = []
        for row in cursor:
            restaurants.append({
                'restaurant_id': row[0],
                'name': row[1],
                'latitude': float(row[2]) if row[2] else 0,
                'longitude': float(row[3]) if row[3] else 0,
                'address': row[4],
                'city': row[5],
                'price_range': row[6] if row[6] else '₹₹',
                'phone': row[7],
                'website': row[8],
                'avg_rating': float(row[9]) if row[9] else 0,
                'total_reviews': int(row[10]) if row[10] else 0,
                'cuisines': row[11] if row[11] else 'Various'
            })
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'restaurants': restaurants,
            'count': len(restaurants)
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

@app.route('/api/restaurants/<int:restaurant_id>', methods=['GET'])
def get_restaurant_details(restaurant_id):
    """Get restaurant details with ratings"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT 
                r.restaurant_id, r.name, r.latitude, r.longitude,
                r.address, r.city, r.price_range, r.phone, r.website,
                r.avg_rating, r.total_reviews,
                LISTAGG(c.cuisine_name, ', ') WITHIN GROUP (ORDER BY c.cuisine_name) as cuisines
            FROM RESTAURANTS r
            LEFT JOIN RESTAURANT_CUISINES rc ON r.restaurant_id = rc.restaurant_id
            LEFT JOIN CUISINES c ON rc.cuisine_id = c.cuisine_id
            WHERE r.restaurant_id = :id
            GROUP BY r.restaurant_id, r.name, r.latitude, r.longitude,
                     r.address, r.city, r.price_range, r.phone, r.website,
                     r.avg_rating, r.total_reviews
        """, {'id': restaurant_id})
        
        row = cursor.fetchone()
        
        if not row:
            cursor.close()
            conn.close()
            return jsonify({'success': False, 'message': 'Restaurant not found'}), 404
        
        restaurant = {
            'restaurant_id': row[0],
            'name': row[1],
            'latitude': float(row[2]),
            'longitude': float(row[3]),
            'address': row[4],
            'city': row[5],
            'price_range': row[6],
            'phone': row[7],
            'website': row[8],
            'avg_rating': float(row[9]) if row[9] else 0,
            'total_reviews': int(row[10]) if row[10] else 0,
            'cuisines': row[11]
        }
        
        cursor.execute("""
            SELECT 
                rt.rating_id, u.username, u.user_id, rt.overall_rating,
                rt.food_rating, rt.service_rating, rt.ambiance_rating,
                rt.value_rating, rt.review_text, rt.visit_date, rt.created_at
            FROM RATINGS rt
            JOIN USERS u ON rt.user_id = u.user_id
            WHERE rt.restaurant_id = :id
            ORDER BY rt.created_at DESC
        """, {'id': restaurant_id})
        
        ratings = []
        for row in cursor:
            ratings.append({
                'rating_id': row[0],
                'username': row[1],
                'user_id': row[2],
                'overall_rating': float(row[3]),
                'food_rating': float(row[4]) if row[4] else None,
                'service_rating': float(row[5]) if row[5] else None,
                'ambiance_rating': float(row[6]) if row[6] else None,
                'value_rating': float(row[7]) if row[7] else None,
                'review_text': row[8],
                'visit_date': row[9].strftime('%Y-%m-%d') if row[9] else None,
                'created_at': row[10].strftime('%Y-%m-%d %H:%M:%S')
            })
        
        restaurant['ratings'] = ratings
        
        if 'user_id' in session:
            try:
                weighted_rating = cursor.callfunc(
                    'get_weighted_rating',
                    float,
                    [restaurant_id, session['user_id']]
                )
                restaurant['weighted_rating'] = round(weighted_rating, 2) if weighted_rating else None
            except:
                restaurant['weighted_rating'] = None
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'restaurant': restaurant
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

@app.route('/api/restaurants/nearby', methods=['GET'])
def get_nearby_restaurants():
    """Find nearby restaurants"""
    try:
        lat = float(request.args.get('lat'))
        lng = float(request.args.get('lng'))
        radius = float(request.args.get('radius', 5))
        cuisine = request.args.get('cuisine')
        min_rating = float(request.args.get('min_rating', 0))
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        result_cursor = conn.cursor()
        
        cursor.callproc('find_nearby_restaurants', [
            lat, lng, radius, cuisine, min_rating, 20, result_cursor
        ])
        
        restaurants = []
        for row in result_cursor:
            restaurants.append({
                'restaurant_id': row[0],
                'name': row[1],
                'latitude': float(row[2]),
                'longitude': float(row[3]),
                'address': row[4],
                'price_range': row[5],
                'avg_rating': float(row[6]),
                'total_reviews': int(row[7]),
                'distance_km': float(row[8])
            })
        
        result_cursor.close()
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'restaurants': restaurants,
            'count': len(restaurants)
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

@app.route('/api/restaurants', methods=['POST'])
@login_required
def add_restaurant():
    """Add new restaurant"""
    try:
        data = request.json
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        restaurant_id_var = cursor.var(oracledb.NUMBER)
        
        cursor.callproc('add_restaurant', [
            data['name'],
            float(data['latitude']),
            float(data['longitude']),
            data['address'],
            data['city'],
            data['price_range'],
            data.get('phone'),
            data.get('website'),
            data.get('cuisine_ids', '1'),
            session['user_id'],
            restaurant_id_var
        ])
        
        conn.commit()
        
        restaurant_id = int(restaurant_id_var.getvalue())
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'message': 'Restaurant added successfully!',
            'restaurant_id': restaurant_id
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

# ============================================
# RATING API
# ============================================

@app.route('/api/ratings', methods=['POST'])
@login_required
def submit_rating():
    """Submit a rating"""
    try:
        data = request.json
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        visit_date = datetime.strptime(data['visit_date'], '%Y-%m-%d') if data.get('visit_date') else datetime.now()
        
        rating_id_var = cursor.var(oracledb.NUMBER)
        
        cursor.callproc('submit_rating', [
            int(data['restaurant_id']),
            session['user_id'],
            float(data['overall_rating']),
            float(data.get('food_rating')) if data.get('food_rating') else None,
            float(data.get('service_rating')) if data.get('service_rating') else None,
            float(data.get('ambiance_rating')) if data.get('ambiance_rating') else None,
            float(data.get('value_rating')) if data.get('value_rating') else None,
            data.get('review_text'),
            visit_date,
            rating_id_var
        ])
        
        conn.commit()
        
        rating_id = int(rating_id_var.getvalue())
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'message': 'Rating submitted successfully!',
            'rating_id': rating_id
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

@app.route('/api/ratings/user', methods=['GET'])
@login_required
def get_user_ratings():
    """Get current user's ratings"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT 
                rt.rating_id, 
                r.restaurant_id, 
                r.name as restaurant_name, 
                rt.overall_rating,
                rt.review_text, 
                rt.visit_date, 
                rt.created_at
            FROM RATINGS rt
            JOIN RESTAURANTS r ON rt.restaurant_id = r.restaurant_id
            WHERE rt.user_id = :user_id
            ORDER BY rt.created_at DESC
        """, {'user_id': session['user_id']})
        
        ratings = []
        for row in cursor:
            ratings.append({
                'rating_id': row[0],
                'restaurant_id': row[1],
                'restaurant_name': row[2],
                'overall_rating': float(row[3]),
                'review_text': row[4],
                'visit_date': row[5].strftime('%d %b %Y') if row[5] else None,
                'created_at': row[6].strftime('%d %b %Y') if row[6] else None
            })
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'ratings': ratings,
            'count': len(ratings)
        })
        
    except Exception as e:
        print("Error in get_user_ratings:", str(e))   # ← Helpful for debugging
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

# ============================================
# CUISINE API
# ============================================

@app.route('/api/cuisines', methods=['GET'])
def get_cuisines():
    """Get all cuisines"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("SELECT cuisine_id, cuisine_name, description FROM CUISINES ORDER BY cuisine_name")
        
        cuisines = []
        for row in cursor:
            cuisines.append({
                'cuisine_id': row[0],
                'cuisine_name': row[1],
                'description': row[2]
            })
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'cuisines': cuisines
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

# ============================================
# FRIEND API
# ============================================

@app.route('/api/friends', methods=['GET'])
@login_required
def get_friends():
    """Get user's friends"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
    SELECT 
        u.user_id, u.username, u.email, u.city, f.status, f.accepted_at
    FROM FRIENDSHIPS f
    JOIN USERS u 
        ON u.user_id = f.user_id_2
    WHERE f.user_id_1 = :uid1
      AND f.status = 'accepted'

    UNION ALL

    SELECT 
        u.user_id, u.username, u.email, u.city, f.status, f.accepted_at
    FROM FRIENDSHIPS f
    JOIN USERS u 
        ON u.user_id = f.user_id_1
    WHERE f.user_id_2 = :uid2
      AND f.status = 'accepted'

    ORDER BY accepted_at DESC
""", {
    'uid1': int(session['user_id']),
    'uid2': int(session['user_id'])
})


        rows=cursor.fetchall()
        print("SESSION USER:", session.get('user_id'))   # 👈 ADD
        print("RAW ROWS FROM DB:", rows)                 # 👈 ADD
        friends = []
        for row in rows:
            friends.append({
                'user_id': row[0],
                'username': row[1],
                'email': row[2],
                'city': row[3],
                'status': row[4],
                'accepted_at': row[5].strftime('%Y-%m-%d %H:%M:%S') if row[5] else None
            })
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'friends': friends,
            'count': len(friends)
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

        
@app.route('/api/me', methods=['GET'])
@login_required
def get_me():
    return jsonify({
        'user_id': session.get('user_id'),
        'username': session.get('username')
    })

@app.route('/api/friends/requests', methods=['GET'])
@login_required
def get_friend_requests():
    """Get pending friend requests"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT 
                f.friendship_id, u.user_id, u.username, f.requested_at
            FROM FRIENDSHIPS f
            JOIN USERS u ON f.user_id_1 = u.user_id
            WHERE f.user_id_2 = :uid AND f.status = 'pending'
            ORDER BY f.requested_at DESC
        """, {'uid': session['user_id']})
        
        incoming = []
        for row in cursor:
            incoming.append({
                'friendship_id': row[0],
                'user_id': row[1],
                'username': row[2],
                'requested_at': row[3].strftime('%Y-%m-%d %H:%M:%S')
            })
        
        cursor.execute("""
            SELECT 
                f.friendship_id, u.user_id, u.username, f.requested_at
            FROM FRIENDSHIPS f
            JOIN USERS u ON f.user_id_2 = u.user_id
            WHERE f.user_id_1 = :uid AND f.status = 'pending'
            ORDER BY f.requested_at DESC
        """, {'uid': session['user_id']})
        
        outgoing = []
        for row in cursor:
            outgoing.append({
                'friendship_id': row[0],
                'user_id': row[1],
                'username': row[2],
                'requested_at': row[3].strftime('%Y-%m-%d %H:%M:%S')
            })
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'incoming': incoming,
            'outgoing': outgoing
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

@app.route('/api/friends/request', methods=['POST'])
@login_required
def send_friend_request():
    """Send friend request"""
    try:
        data = request.json
        to_user_id = int(data.get('to_user_id'))
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        friendship_id_var = cursor.var(oracledb.NUMBER)
        
        cursor.callproc('send_friend_request', [
            session['user_id'],
            to_user_id,
            friendship_id_var
        ])
        
        conn.commit()
        
        friendship_id = int(friendship_id_var.getvalue())
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'message': 'Friend request sent!',
            'friendship_id': friendship_id
        })
        
    except oracledb.DatabaseError as e:
        error, = e.args
        return jsonify({
            'success': False,
            'message': error.message
        }), 400
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

@app.route('/api/friends/accept/<int:friendship_id>', methods=['POST'])
@login_required
def accept_friend_request(friendship_id):
    """Accept friend request"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT user_id_2 FROM FRIENDSHIPS 
            WHERE friendship_id = :fid AND status = 'pending'
        """, {'fid': friendship_id})
        
        row = cursor.fetchone()
        if not row or row[0] != session['user_id']:
            return jsonify({
                'success': False,
                'message': 'Invalid friend request'
            }), 403
        
        cursor.execute("""
            UPDATE FRIENDSHIPS 
            SET status = 'accepted' 
            WHERE friendship_id = :fid
        """, {'fid': friendship_id})
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'message': 'Friend request accepted!'
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

@app.route('/api/friends/recommendations', methods=['GET'])
@login_required
def get_friend_recommendations():
    """Get friend-based restaurant recommendations"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT 
                r.restaurant_id, 
                r.name, 
                r.avg_rating, 
                r.address,
                fr.weight_score, 
                u.username as recommended_by
            FROM FRIEND_RECOMMENDATIONS fr
            JOIN RESTAURANTS r ON fr.restaurant_id = r.restaurant_id
            JOIN USERS u ON fr.friend_id = u.user_id
            WHERE fr.user_id = :user_id
            ORDER BY fr.weight_score DESC, fr.calculated_at DESC
            FETCH FIRST 10 ROWS ONLY
        """, {'user_id': session['user_id']})
        
        recommendations = []
        for row in cursor:
            recommendations.append({
                'restaurant_id': int(row[0]),
                'name': row[1],
                'avg_rating': float(row[2]) if row[2] else 0.0,
                'address': row[3],
                'weight_score': float(row[4]) if row[4] else 0.0,
                'recommended_by': row[5]
            })
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'recommendations': recommendations
        })
        
    except Exception as e:
        print("Error in recommendations:", str(e))   # ← Add this for debugging
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

@app.route('/api/users/search', methods=['GET'])
@login_required
def search_users():
    """Search users by username"""
    try:
        query = request.args.get('q', '').lower()
        
        if len(query) < 2:
            return jsonify({
                'success': False,
                'message': 'Query too short'
            }), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT user_id, username, email, city
            FROM USERS
            WHERE LOWER(username) LIKE :query
            AND user_id != :uid
            FETCH FIRST 10 ROWS ONLY
        """, {'query': f'%{query}%', 'uid': session['user_id']})
        
        users = []
        for row in cursor:
            users.append({
                'user_id': row[0],
                'username': row[1],
                'email': row[2],
                'city': row[3]
            })
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'users': users
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

# ============================================
# ANALYTICS API
# ============================================

@app.route('/api/analytics/trending', methods=['GET'])
def get_trending():
    """Get trending restaurants"""
    try:
        days = int(request.args.get('days', 30))
        city = request.args.get('city')
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        result_cursor = cursor.callfunc(
            'get_trending_restaurants',
            oracledb.CURSOR,
            [days, city]
        )
        
        restaurants = []
        for row in result_cursor:
            restaurants.append({
                'restaurant_id': row[0],
                'name': row[1],
                'city': row[2],
                'avg_rating': float(row[3]) if row[3] else 0,
                'recent_reviews': int(row[4]) if row[4] else 0,
                'recent_avg_rating': float(row[5]) if row[5] else 0,
                'trending_score': float(row[6]) if row[6] else 0
            })
        
        result_cursor.close()
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'trending': restaurants
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

@app.route('/api/analytics/top-cuisine', methods=['GET'])
def get_top_by_cuisine():
    """Get top restaurants by cuisine"""
    try:
        cuisine = request.args.get('cuisine', 'South Indian')
        min_reviews = int(request.args.get('min_reviews', 3))
        limit = int(request.args.get('limit', 5))
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        result_cursor = cursor.callfunc(
            'get_top_rated_by_cuisine',
            oracledb.CURSOR,
            [cuisine, min_reviews, limit]
        )
        
        restaurants = []
        for row in result_cursor:
            restaurants.append({
                'restaurant_id': row[0],
                'name': row[1],
                'address': row[2],
                'city': row[3],
                'price_range': row[4],
                'avg_rating': float(row[5]),
                'total_reviews': int(row[6]),
                'cuisine': row[7],
                'unique_reviewers': int(row[8]),
                'avg_food_rating': float(row[9]) if row[9] else None,
                'avg_service_rating': float(row[10]) if row[10] else None,
                'avg_ambiance_rating': float(row[11]) if row[11] else None,
                'avg_value_rating': float(row[12]) if row[12] else None,
                'highest_rating': float(row[13]) if row[13] else None,
                'lowest_rating': float(row[14]) if row[14] else None
            })
        
        result_cursor.close()
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'restaurants': restaurants
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

@app.route('/api/analytics/stats/<int:restaurant_id>', methods=['GET'])
def get_restaurant_stats(restaurant_id):
    """Get detailed statistics for a restaurant"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        result_cursor = cursor.callfunc(
            'get_restaurant_stats',
            oracledb.CURSOR,
            [restaurant_id]
        )
        
        row = result_cursor.fetchone()
        
        if not row:
            return jsonify({
                'success': False,
                'message': 'Restaurant not found'
            }), 404
        
        stats = {
            'restaurant_id': row[0],
            'name': row[1],
            'address': row[2],
            'price_range': row[3],
            'overall_avg': float(row[4]) if row[4] else 0,
            'total_reviews': int(row[5]) if row[5] else 0,
            'avg_food': float(row[6]) if row[6] else None,
            'avg_service': float(row[7]) if row[7] else None,
            'avg_ambiance': float(row[8]) if row[8] else None,
            'avg_value': float(row[9]) if row[9] else None,
            'five_star_count': int(row[10]) if row[10] else 0,
            'four_star_count': int(row[11]) if row[11] else 0,
            'three_star_count': int(row[12]) if row[12] else 0,
            'two_star_count': int(row[13]) if row[13] else 0,
            'one_star_count': int(row[14]) if row[14] else 0,
            'unique_reviewers': int(row[15]) if row[15] else 0,
            'highest_rating': float(row[16]) if row[16] else None,
            'lowest_rating': float(row[17]) if row[17] else None,
            'reviews_last_30_days': int(row[18]) if row[18] else 0,
            'avg_last_30_days': float(row[19]) if row[19] else None,
            'approved_photos': int(row[20]) if row[20] else 0,
            'friend_recommendations': int(row[21]) if row[21] else 0
        }
        
        result_cursor.close()
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'stats': stats
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

@app.route('/api/analytics/distance', methods=['GET'])
def calculate_distance():
    """Calculate distance between two points"""
    try:
        lat1 = float(request.args.get('lat1'))
        lng1 = float(request.args.get('lng1'))
        lat2 = float(request.args.get('lat2'))
        lng2 = float(request.args.get('lng2'))
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        distance = cursor.callfunc(
            'calculate_distance',
            float,
            [lat1, lng1, lat2, lng2]
        )
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'distance_km': round(distance, 2)
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

# ============================================
# MODERATION API ENDPOINTS
# ============================================

@app.route('/api/moderation/flagged', methods=['GET'])
@login_required
def get_flagged_reviews_api():
    if session.get('role') != 'admin':
        return jsonify({'success': False, 'message': 'Admin access required'}), 403
    
    try:
        status = request.args.get('status', 'pending').lower()
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        result_cursor = cursor.callfunc(
            'get_flagged_reviews',
            oracledb.CURSOR,
            [status]
        )
        
        flagged_reviews = []
        for row in result_cursor:
            flagged_reviews.append({
                'flag_id': int(row[0]),
                'rating_id': int(row[1]),
                'restaurant_id': int(row[2]),
                'restaurant_name': row[3],
                'user_id': int(row[4]),
                'username': row[5],
                'flagged_reason': row[6],
                'review_text': row[7],
                'rating': float(row[8]) if row[8] else 0,
                'status': row[9],
                'flagged_at': row[10].strftime('%Y-%m-%d %H:%M') if row[10] else None,
                'resolved_by': int(row[11]) if row[11] else None,
                'resolved_at': row[12].strftime('%Y-%m-%d %H:%M') if row[12] else None
            })
        
        result_cursor.close()
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'flagged_reviews': flagged_reviews
        })
        
    except Exception as e:
        print("Flagged reviews error:", str(e))
        return jsonify({
            'success': False,
            'message': str(e)
        }), 500


@app.route('/api/moderation/moderate/<int:flag_id>', methods=['POST'])
@login_required
def moderate_review_api(flag_id):
    if session.get('role') != 'admin':
        return jsonify({'success': False, 'message': 'Admin access required'}), 403
    
    try:
        data = request.json
        action = data.get('action', '').lower().strip()
        notes = data.get('notes', '')

        if action == 'approve':
            db_action = 'approved'
        elif action == 'reject':
            db_action = 'rejected'
        else:
            return jsonify({'success': False, 'message': 'Invalid action'}), 400

        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.callproc('moderate_review', [
            flag_id,
            session['user_id'],
            db_action,
            notes
        ])
        
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'message': f'Review {action}d successfully!'
        })
        
    except Exception as e:
        print("Moderation Error:", str(e))
        return jsonify({'success': False, 'message': str(e)}), 500

@app.route('/api/moderation/stats', methods=['GET'])
@login_required
def get_moderation_stats_api():
    """Get moderation statistics - ADMIN ONLY"""
    if session.get('role') != 'admin':
        return jsonify({
            'success': False,
            'message': 'Admin access required'
        }), 403
    
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        result_cursor = cursor.callfunc(
            'get_moderation_stats',
            oracledb.CURSOR
        )
        
        row = result_cursor.fetchone()
        
        stats = {
            'total_flagged': int(row[0]) if row[0] else 0,
            'pending_count': int(row[1]) if row[1] else 0,
            'approved_count': int(row[2]) if row[2] else 0,
            'rejected_count': int(row[3]) if row[3] else 0
        }
        
        result_cursor.close()
        cursor.close()
        conn.close()
        
        return jsonify({
            'success': True,
            'stats': stats
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Error: {str(e)}'
        }), 500

# ============================================
# ERROR HANDLERS
# ============================================

@app.errorhandler(404)
def not_found(error):
    return jsonify({'success': False, 'message': 'Endpoint not found'}), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({'success': False, 'message': 'Internal server error'}), 500

# ============================================
# RUN APPLICATION
# ============================================

if __name__ == '__main__':
    print("="*50)
    print("🚀 STARTING CUISINECOMPASS BACKEND")
    print("="*50)
    
    test_db = Database()
    if test_db.test_connection():
        print("✓ Database connection verified!")
    else:
        print("✗ Database connection failed!")
        print("Please check your .env file settings")
        exit(1)
    
    print("\n🌐 Server starting on http://localhost:5000")
    print("="*50)
    
    app.run(
        host='0.0.0.0',
        port=5000,
        debug=True
    )