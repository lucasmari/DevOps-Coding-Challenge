#!/bin/bash

# Export db env
export FLASK_SQLALCHEMY_DATABASE_URI=sqlite:///items.db

# Create virtual environment
python -m venv .venv
. .venv/bin/activate

# Install packages
pip install -r requirements.txt

# Test
python -m pytest
