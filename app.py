from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy

# Create a Flask application
app = Flask(__name__)
app.config.from_object('default_settings')
app.config.from_envvar('APP_SETTINGS')

# Configure SQLite database
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Define Item model


class Item(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    dosage = db.Column(db.String(50), nullable=False)

# Route for listing items


@app.route('/')
def index():
    medications = Item.query.all()
    return render_template('index.html', medications=medications)

# Route for adding new item


@app.route('/add', methods=['POST'])
def add_item():
    name = request.form['name']
    dosage = request.form['dosage']
    if name and dosage:
        new_item = Item(name=name, dosage=dosage)
        db.session.add(new_item)
        db.session.commit()
    return redirect(url_for('index'))


# Create the database tables
with app.app_context():
    db.create_all()

if __name__ == '__main__':
    app.run()
