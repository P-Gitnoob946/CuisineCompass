# CuisineCompass 🍽️

A simple and clean Flask web application connected to Oracle Database for managing cuisine and food-related data.

## ✨ Features

- Built using Flask framework
- Oracle Database (XE) integration
- Environment-based configuration using `.env`
- Easy setup for local development

## 🛠️ Tech Stack

- **Backend**: Python + Flask
- **Database**: Oracle Database XE
- **Environment Management**: python-dotenv

## 🚀 Quick Setup

### 1. Clone the Repository
```bash
git clone https://github.com/P-Gitnoob946/CuisineCompass.git
cd CuisineCompass
```

### 2. Create Virtual Environment
```bash
python -m venv venv
venv\Scripts\activate     # Windows
```

### 3. Install Dependencies
```bash
pip install -r requirements.txt
```

### 4. Setup Environment Variables
```bash
copy .env.example .env    # Windows
# or
cp .env.example .env      # macOS / Linux
```

Edit the `.env` file with your Oracle database credentials.

### 5. Run the Application
```bash
python app.py
```

Open your browser and go to: **http://127.0.0.1:5000**

## 📁 Project Structure

```
CuisineCompass/
├── app.py
├── .env.example
├── .env                 # ← Never commit this file
├── .gitignore
├── requirements.txt
└── README.md
```

## 🔒 Security Note

- `.env` file is ignored and never pushed to GitHub
- Always use a strong, random `FLASK_SECRET_KEY`
- Never commit real database credentials

## 🤝 Contributing

Contributions are welcome!  
Feel free to fork the repo, make improvements, and submit a Pull Request.

---

Made with ❤️ for learning Flask + Oracle Database
```

**Just copy the entire block above** (from `# CuisineCompass` till the end) and paste it into your `README.md` file.

Done! Let me know if you want any small changes.
