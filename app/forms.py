from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, BooleanField, SubmitField
from wtforms.validators import DataRequired


class AuthForm(FlaskForm):
    username = StringField('Tell me who you are', validators=[DataRequired()])
    submit = SubmitField('Sign In')
